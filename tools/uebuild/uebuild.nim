# Copyright 2016 Xored Software, Inc.

import parseopt, pegs, ropes, strutils, os, times, sets, osproc

type
  OptType = enum
    otCommand
    otProjectDir
    otTarget
    otMode
    otPlatform
    otEngineLocation

  CommandType = enum
    ctRecompile
    ctDeploy
    ctPreCook
    ctClean
    ctCompileNim

const usage = slurp("usage.txt")

const nimModuleDirName = ".nimgen"

const beginTypeMarker = "/*BEGIN_UNREAL_TYPE*/"
const endTypeMarker = "/*END_UNREAL_TYPE*/"
const exportMarker = "/*EXPORT_MACRO_PLACEHOLDER*/"

const cppModuleFileTemplate = """
  #include "$1.h"
  class $1GameModule: public FDefaultGameModuleImpl {
  };
"""

const nimModuleFileTemplate = """
  #include "$1.h"

  void NimMain(void);

#if WITH_EDITOR
  struct NimInitializer {
    NimInitializer() {
      UE_LOG(LogTemp, Log, TEXT("Invoking NimMain()..."));
      NimMain();
    }
  };
  static NimInitializer nimInitializer;
#endif

  class $1GameModule: public FDefaultGameModuleImpl {
#if !WITH_EDITOR
    bool bIsInitialized;
    public:
    $1GameModule() : bIsInitialized(false) {
    }

    virtual void StartupModule() override {
      if (!bIsInitialized) {
        UE_LOG(LogTemp, Log, TEXT("Invoking NimMain()..."));
        NimMain();
        bIsInitialized = true;
      }
    }
#endif
  };
"""

const primaryModuleAppendix = """
  IMPLEMENT_PRIMARY_GAME_MODULE($1GameModule, $1, "$1");
"""

const moduleAppendix = """
  IMPLEMENT_GAME_MODULE($1GameModule, $1);
"""

const moduleHeaderTemplate = """
  #pragma once
  #include "Engine.h"

  #if PLATFORM_WINDOWS
  #include "Windows/AllowWindowsPlatformTypes.h"
  #endif
"""

template withDir(dir: string; body: untyped): untyped =
  ## Taken from nimscript implementation
  var curDir = getCurrentDir()
  try:
    setCurrentDir(dir)
    body
  finally:
    setCurrentDir(curDir)

proc exec(command: string) =
  echo "[exec] " & command
  let retCode = execCmd(command)
  if retCode != 0:
    quit(-1)

proc nimOSToUEPlatform(os: string): string {.noSideEffect.} =
  result = case os
    of "macosx": "Mac"
    of "windows": "Win64" # Win32 is not supported for editor builds
    of "linux": "Linux"
    else: nil

  if result == nil:
    raise newException(OSError, "Unsupported OS: " & os)

proc uePlatformToNimOSCPU(platform: string, cpu: string = nil): tuple[os, cpu: string] {.noSideEffect.} =
  # UE Platforms:
  # Win32, Win64, WinRT, WinRT_ARM, UWP,
  # Mac, XboxOne, PS4, IOS, Android, HTML5, Linux,
  # AllDesktop, TVOS

  result.os = case platform.toLowerAscii():
    of "win32", "win64", "winrt", "winrt_arm", "uwp", "html5": "windows"
    of "mac", "ios", "tvos": "macosx"
    of "linux", "android": "linux"
    else: "standalone"

  if cpu != nil:
    result.cpu = cpu
  else:
    result.cpu = case platform.toLowerAscii():
      of "win32", "winrt", "uwp", "linux", "alldesktop", "html5": "i386"
      of "win64", "mac", "xboxone", "ps4": "amd64"
      else: "arm"

proc extractByPeg(str: var string, peg: Peg, separator = ""): Rope =
  var matches = newSeq[string](1)
  var (beginPos, endPos) = str.findBounds(peg, matches, 0)
  result = rope("")
  while beginPos != -1:
    let sliceToExtract = beginPos..endPos
    if result.len > 0 and separator.len > 0:
      result.add(separator)
    result = result & str[sliceToExtract]
    str[sliceToExtract] = ""
    (beginPos, endPos) = str.findBounds(peg, matches, beginPos)

proc extractTypeDefinitions(contents: var string): Rope =
  result = extractByPeg(contents, peg("'$#' @ '$#'" % [beginTypeMarker, endTypeMarker]), "\n")

proc extractIncludes(contents: var string, filename: string): Rope =
  let includePeg = peg("""s <- wsNoEol '#include' ws '"' !'$#.h' [^"]+ '"' wsWithEol
                         comment <- '/*' @ '*/' / '//' .*
                         wsNoEol <- (comment / !\n \s+)*
                         wsWithEol <- (comment / [\9\11\12]+)* \n
                         ws <- (comment / \s+)* """.format(filename))
  result = extractByPeg(contents, includePeg)

proc writeFileIfNotSame(filename, contents: string) =
  if not fileExists(filename) or readFile(filename) != contents:
    writeFile(filename, contents)

proc processFile(file, moduleName: string; outDir: string; nimblePackageName: string) =
  let moduleIncludeString = "#include \"$#.h\"\n" % moduleName
  let exportMacro = moduleName.toUpperAscii() & "_API"
  let outCppDir = outDir / "Private"

  var (_, outName, _) = splitFile(file)
  # When .nimble is present, Nim prefixes .cpp files with Nimble package name.
  # We need to get rid of that, because nimue4 macros rely on .cpp files being named after .nim files
  if nimblePackageName != nil and outName.startsWith(nimblePackageName & "_"):
    outName = outName[nimblePackageName.len+1..^1] # +1 to account for `_`
  let outFile = outCppDir / outName & ".cpp"

  if outFile != file and fileExists(outFile) and
     file.getLastModificationTime() <= outFile.getLastModificationTime():
    # no changes - no need to process
    return

  var contents = readFile(file)
  if outFile == file and contents.contains(moduleIncludeString):
    # file hasn't been regenerated
    return
  echo file.extractFileName() & " was changed - processing..."
  createDir(outCppDir)

  var matches: seq[string] = @[]
  let (intBitsDefBegin, intBitsDefEnd) = contents.findBounds(peg"s <- '#define' \s+ 'NIM_INTBITS' \s+ \d+ \n+", matches, 0)
  assert(intBitsDefBegin != -1)
  let intBitsDef = contents[intBitsDefBegin..intBitsDefEnd]
  if contents.contains(beginTypeMarker):
    let isUHTAffected = contents.contains(peg"s <- ('UCLASS' / 'UINTERFACE' / 'USTRUCT' / 'UENUM')")
    let includes = extractIncludes(contents, outName)
    let typeDefs = extractTypeDefinitions(contents)

    let generatedInclude = if isUHTAffected: "#include \"" & outName & ".generated.h\"\n" else: ""

    var headerFileContents = $("#pragma once\n" & intBitsDef & includes & generatedInclude & typeDefs)
    var outHeaderDir = outCppDir
    if headerFileContents.contains(exportMarker):
      outHeaderDir = outDir / "Public"
      createDir(outHeaderDir)
      headerFileContents = headerFileContents.replace(exportMarker, exportMacro)

    writeFileIfNotSame(outHeaderDir / outName & ".h", headerFileContents)

    let headerIncludeString = "#include \"$#.h\"\n" % outName
    if not contents.contains(headerIncludeString):
      contents.insert(headerIncludeString, intBitsDefEnd + 1)

  contents.insert(moduleIncludeString, intBitsDefEnd + 1)
  writeFile(outFile, contents)

proc makeRelative(filePath: string; dir: string): string =
  assert(dir.isAbsolute())
  let fullPath = expandFilename(filePath)
  let fullDirPath = expandFilename(dir)
  assert(fullPath.startsWith(fullDirPath))

  result = fullPath[fullDirPath.len + 1 .. ^1]

proc createModuleFilesIfNeeded(targetDir, moduleName: string; isNimModule, isPrimaryModule: bool) =
  let moduleFile = targetDir / "Private" / moduleName & ".cpp"
  let moduleHeaderFile = targetDir / "Public" / moduleName & ".h"

  createDir(moduleFile.parentDir())
  createDir(moduleHeaderFile.parentDir())

  let moduleFileTemplate = if isNimModule: nimModuleFileTemplate else: cppModuleFileTemplate
  let appendixTemplate = if isPrimaryModule: primaryModuleAppendix else: moduleAppendix
  let cppTemplate = moduleFileTemplate & appendixTemplate

  writeFileIfNotSame(moduleFile, cppTemplate.format(moduleName))
  writeFileIfNotSame(moduleHeaderFile, moduleHeaderTemplate.format(moduleName))

proc runUnrealBuildTool(engineDir: string; command: CommandType;
                        target, platform, mode, uprojectFile: string;
                        extraOptions: string = "") =
  let commandStr = case command:
  of ctRecompile: "-editorrecompile"
  of ctDeploy: "-deploy"
  of ctClean: "-clean"
  of ctPreCook: "-editorrecompile"
  of ctCompileNim: nil

  let ubtPlatform = if command == ctPreCook: nimOSToUEPlatform(hostOS) else: platform

  var buildTool: string
  let ubtPath = (engineDir / "Engine" / "Binaries" / "DotNET" / "UnrealBuildTool.exe")
  case hostOS
    of "macosx":
      let runMono = '"' & (engineDir / "Engine" / "Build" / "BatchFiles" / "Mac" / "RunMono.sh") & '"'
      buildTool = runMono & " \"" & ubtPath & '"'
    of "windows":
      buildTool = ubtPath
    else:
      raise newException(OSError, "Building is not supported for your platform.")

  withDir engineDir:
    exec buildTool & " $# $# $# $# -project=\"$#\" -rocket -disableunity $#" %
      [target, ubtPlatform, mode, commandStr, uprojectFile, extraOptions]

proc cleanModules(projectDir: string) =
  for moduleDir in walkDir(projectDir / "Source"):
    if moduleDir.kind != pcDir:
      continue
    removeDir(moduleDir.path / nimModuleDirName)

proc getNimOutDir(projectDir: string): string =
  result = projectDir / "Intermediate" / "Nim"

proc getNimcacheDir(projectDir: string; moduleName: string): string =
  result = getNimOutDir(projectDir) / "nimcache" / moduleName

proc createNimCfg(outDir: string; moduleDir, nimcacheDir, rootFile: string;
                  isEditorBuild: bool; platform, os, cpu: string) =
  var contents = ""
  if existsFile(moduleDir / "nim.cfg"):
    contents = readFile(moduleDir / "nim.cfg")
    if not contents.endsWith("\n"):
      contents.add("\n")
  contents.add("-c\n")
  contents.add("--define:CPP\n") # for nimsuggest
  contents.add("--noMain\n")
  contents.add("--experimental\n")
  if hostOS == "windows" and platform != "android":
    contents.add("cc=vcc\n")
  contents.add("--define:noSignalHandler\n")
  contents.add("--define:useRealtimeGC\n")
  if os != nil:
    contents.add("--os:" & os & "\n")
  if cpu != nil:
    contents.add("--cpu:" & cpu & "\n")
  if platform == "android" or platform == "ios":
    contents.add("--noCppExceptions\n")
    contents.add("--define:dontWrapNimExceptions\n")
  if platform == "ios":
    contents.add("--define:ios\n")
  if platform == "android":
    contents.add("--define:android\n")
    contents.add("--define:android4\n")
  if platform == "ios" or platform == "android" or platform == "mac":
    contents.add("--dynlibOverride:ssl\n")
    contents.add("--dynlibOverride:crypto\n")
  if isEditorBuild:
    contents.add("--define:editor\n")
  contents.add("--path:\"" & moduleDir.replace("\\", "/") & "\"\n")
  contents.add("--path:\"" & getCurrentDir().replace("\\", "/") & "\"\n")
  contents.add("--nimcache:\"" & nimcacheDir.replace("\\", "/") & "\"\n")
  writeFile(outDir / "nim.cfg", contents)

proc copyNimFilesAddingImports(dir: string, rootFileContent: var Rope) =
  for file in walkDirRec(getAppDir() / "nimfiles", {pcFile}):
    let filename = extractFilename(file)
    copyFile(file, dir / filename)
    rootFileContent.addf("import \"$#\"\n", [rope(filename)])

proc buildNim(projectDir, projectName, os, cpu, uePlatform: string, isEditorBuild: bool) =
  let sourceDir = projectDir / "Source"
  let nimOutDir = getNimOutDir(projectDir)

  # TODO: properly handle deleted files

  for sourceDirFile in walkDir(sourceDir):
    if sourceDirFile.kind != pcDir:
      continue
    let moduleDir = sourceDirFile.path
    let moduleName = moduleDir.extractFilename()
    if not existsFile(moduleDir / moduleName & ".Build.cs"):
      # not UE4 module
      continue
    let nimcacheDir = getNimcacheDir(projectDir, moduleName)

    let targetDir = moduleDir / nimModuleDirName

    var expectedFilenames = initSet[string]()

    var rootFileContent = rope("")
    var nimbleFile: string = nil
    var nimsFile = moduleDir / "config.nims"
    if not existsFile(moduleDir / "config.nims"):
      nimsFile = nil
    for file in walkDirRec(moduleDir):
      if file.endsWith(".nim") and not file.endsWith(".inc.nim"):
        if file.extractFilename().cmpIgnoreCase(moduleName & ".nim") == 0:
          echo ".nim filename mustn't be equal to module name: " & file.extractFileName()
          quit(-1)
        let importArg = makeRelative(file, moduleDir).replace("\\", "/")
        rootFileContent = rootFileContent & "import \"" & importArg & "\"\n"
        expectedFilenames.incl(file.changeFileExt("h").extractFilename())
      if file.endsWith(".nimble") and sameFile(file.parentDir(), moduleDir):
        nimbleFile = file

    let isPrimaryModule = (moduleName == projectName)
    let isNimModule = (rootFileContent.len != 0)

    rootFileContent.add("GC_disable()\n")

    createModuleFilesIfNeeded(targetDir, moduleName, isNimModule, isPrimaryModule)
    expectedFilenames.incl(moduleName & ".h")

    if isNimModule:
      let rootFile = nimOutDir / moduleName & "Root.nim"
      createDir(nimOutDir)
      copyNimFilesAddingImports(nimOutDir, rootFileContent)
      writeFileIfNotSame(rootFile, $rootFileContent)

      var nimblePackageName: string = nil
      if nimbleFile != nil:
        copyFile(nimbleFile, nimOutDir / extractFilename(nimbleFile))
        nimblePackageName = splitFile(nimbleFile).name

      if nimsFile != nil:
        copyFile(nimsFile, nimOutDir / extractFilename(nimsFile))

      let platform = uePlatform.toLowerAscii()
      createNimCfg(nimOutDir, moduleDir, nimcacheDir, rootFile, isEditorBuild, platform, os, cpu)

      if nimbleFile == nil:
        exec "nim cpp \"" & rootFile & '"'
      else:
        withDir nimOutDir:
          exec "nimble -y cpp \"" & rootFile & '"'

      for file in walkDirRec(nimcacheDir, {pcFile}):
        if file.endsWith(".h") and not expectedFilenames.contains(extractFilename(file)):
          let cppFile = file.changeFileExt("cpp")
          let cppFilename = cppFile.extractFilename()
          removeFile file
          removeFile cppFile
          removeFile targetDir / file.extractFilename()
          removeFile targetDir / "Public" / file.extractFilename()
          removeFile targetDir / "Private" / file.extractFilename()
          removeFile targetDir / cppFilename
          removeFile targetDir / "Private" / cppFilename
        elif file.endsWith(".cpp"):
          processFile(file, moduleName, targetDir, nimblePackageName)

proc build(command: CommandType, engineDir, projectDir, projectName, target, mode, platform, cpuOverride, extraOptions: string) =
  echo "Building with command $#, target \"$#\", mode \"$#\", platform \"$#\"" % [$command, target, mode, platform]
  var os, cpu: string = nil
  if command != ctPreCook:
    (os, cpu) = uePlatformToNimOSCPU(platform, cpuOverride)
  var actualMode = if command != ctPreCook: mode
                   else: "Development"
  var actualPlatform = if command != ctPreCook: platform
                       else: nimOSToUEPlatform(hostOS)
  if command == ctPreCook and hostOS == "windows":
    cpu = "amd64" # editor builds do not support Win32

  buildNim(projectDir, projectName, os, cpu, actualPlatform, isEditorBuild = (command == ctPreCook or target.endsWith("Editor")))
  runUnrealBuildTool(engineDir, command, target, actualPlatform, actualMode, projectDir / projectName & ".uproject", extraOptions)

  if command == ctPreCook:
    # When precooking, we have to compile editor for the current platform first,
    # and then regenerate the .cpp files for the project target platform
    # Thankfully, this is only needed in CI builds, so local development cycle is undisturbed
    removeDir(getNimOutDir(projectDir) / "nimcache")
    cleanModules(projectDir)

    (os, cpu) = uePlatformToNimOSCPU(platform, cpuOverride)
    buildNim(projectDir, projectName, os, cpu, platform, isEditorBuild = false)

proc clean(engineDir, projectDir, projectName, target, mode, platform, extraOptions: string) =
  let nimOutDir = getNimOutDir(projectDir)
  removeDir nimOutDir

  runUnrealBuildTool(engineDir, ctClean, target, platform, mode, projectDir / projectName & ".uproject", extraOptions)

  cleanModules(projectDir)

proc compileNim(engineDir, projectDir, projectName, target, mode, platform, cpuOverride, extraOptions: string) =
  let (os, cpu) = uePlatformToNimOSCPU(platform, cpuOverride)
  buildNim(projectDir, projectName, os, cpu, platform, isEditorBuild = target.endsWith("Editor"))

proc detectProjectName(projectDir: string): string =
  for file in walkDir(projectDir):
    if file.kind != pcFile: continue
    if file.path.endsWith(".uproject"):
      let (_, name, _) = splitFile(file.path)
      return name

  raise newException(OSError, ".uproject file must be located in the same folder with the build script")

when isMainModule:
  var mode = "Development"
  var target: string = nil
  var platform = nimOSToUEPlatform(hostOS)
  var cpu: string = nil
  var extraOptions = ""
  var projectDir: string = nil
  var command = ctRecompile
  var engineDir: string = nil
  var expectedOptType = otCommand

  var p = initOptParser()
  while true:
    next(p)
    if p.kind == cmdEnd: break
    let (kind, key, val) = (p.kind, p.key, p.val)
    case kind:
      of cmdArgument:
        case expectedOptType:
        of otCommand:
          case key:
          of "deploy": command = ctDeploy
          of "precook": command = ctPreCook
          of "clean": command = ctClean
          of "recompile": command = ctRecompile
          of "compilenim": command = ctCompileNim
          else: raise newException(ValueError, "Unknown command: " & key)
          extraOptions = cmdLineRest(p)
          break
        of otProjectDir:
          projectDir = key
        of otTarget:
          target = key
        of otMode:
          mode = key
        of otPlatform:
          platform = key
        of otEngineLocation:
          engineDir = key
        expectedOptType = otCommand
      of cmdShortOption:
        case key:
          of "d": expectedOptType = otProjectDir
          of "p": expectedOptType = otPlatform
          of "t": expectedOptType = otTarget
          of "m": expectedOptType = otMode
          of "e": expectedOptType = otEngineLocation
          else:
            raise newException(KeyError, "Unknown option: -" & key)
      of cmdLongOption:
        case key:
          of "projectDir":
            projectDir = val
          of "platform":
            platform = val
          of "cpu":
            cpu = val
          of "target":
            target = val
          of "mode":
            mode = val
          of "engineDir":
            engineDir = val
          else:
            raise newException(KeyError, "Unknown option: --" & key)
      else: discard

  if projectDir == nil or engineDir == nil:
    echo usage
    quit(-1)

  let projectName = detectProjectName(projectDir)
  if target == nil:
    target = projectName & "Editor"
  case command:
    of ctPreCook, ctDeploy, ctRecompile: build(command, engineDir, projectDir, projectName, target, mode, platform, cpu, extraOptions)
    of ctClean: clean(engineDir, projectDir, projectName, target, mode, platform, extraOptions)
    of ctCompileNim: compileNim(engineDir, projectDir, projectName, target, mode, platform, cpu, extraOptions)
