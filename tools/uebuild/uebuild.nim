# Copyright 2016 Xored Software, Inc.

import parseopt2, pegs, ropes, strutils, os, times, sets, osproc

type
  OptType = enum
    otTask
    otProjectDir
    otTarget
    otMode
    otPlatform
    otEngineLocation

  TaskType = enum
    ttRecompile
    ttDeploy
    ttPreCook
    ttClean
    ttCompileNim

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

  extern "C" {void NimMain(void);}

#if WITH_EDITOR
  struct NimInitializer {
    NimInitializer() {
      NimMain();
    }
  };
  static NimInitializer nimInitializer;
#endif

  class $1GameModule: public FDefaultGameModuleImpl {
#if !WITH_EDITOR
    virtual void StartupModule() override {
      NimMain();
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
    of "windows": "Win" & $(sizeof(int) * 8)
    of "linux": "Linux"
    else: nil

  if result == nil:
    raise newException(OSError, "Unsupported OS: " & os)

proc uePlatformToNimOSCPU(platform: string): tuple[os, cpu: string] {.noSideEffect.} =
  # UE Platforms:
  # Win32, Win64, WinRT, WinRT_ARM, UWP,
  # Mac, XboxOne, PS4, IOS, Android, HTML5, Linux,
  # AllDesktop, TVOS

  result.os = case platform.toLower():
    of "win32", "win64", "winrt", "winrt_arm", "uwp", "html5": "windows"
    of "mac", "ios", "tvos": "macosx"
    of "linux", "android": "linux"
    else: "standalone"

  result.cpu = case platform.toLower():
    of "win32", "winrt", "uwp", "linux", "alldesktop", "html5": "i386"
    of "win64", "mac", "xboxone", "ps4": "amd64"
    else: "arm"

proc extractByPeg(str: var string, peg: Peg): Rope =
  var matches = newSeq[string](1)
  var (beginPos, endPos) = str.findBounds(peg, matches, 0)
  result = rope("")
  while beginPos != -1:
    let sliceToExtract = beginPos..endPos
    result = result & str[sliceToExtract]
    str[sliceToExtract] = ""
    (beginPos, endPos) = str.findBounds(peg, matches, beginPos)

proc extractTypeDefinitions(contents: var string): Rope =
  result = extractByPeg(contents, peg("'$#' @ '$#'" % [beginTypeMarker, endTypeMarker]))

proc extractIncludes(contents: var string, filename: string): Rope =
  let includePeg = peg("""s <- wsNoEol '#include' ws '"' !'$#.h' [^"]+ '"' wsWithEol
                         comment <- '/*' @ '*/' / '//' .*
                         wsNoEol <- (comment / !\n \s+)*
                         wsWithEol <- (comment / [\9\11\12]+)* \n
                         ws <- (comment / \s+)* """.format(filename))
  result = extractByPeg(contents, includePeg)

proc replaceInFile(filename: string; sub, to: string) =
  var contents = readFile(filename)
  writeFile(filename, contents.replace(sub, to))

proc writeFileIfNotSame(filename, contents: string) =
  if not fileExists(filename) or readFile(filename) != contents:
    writeFile(filename, contents)

proc processFile(file, moduleName: string; outDir: string) =
  let moduleIncludeString = "#include \"$#.h\"\n" % moduleName
  let exportMacro = moduleName.toUpper() & "_API"
  let outCppDir = outDir / "Private"
  let outFile = outCppDir / extractFilename(file)

  if outFile != file and fileExists(outFile) and file.getLastModificationTime() < outFile.getLastModificationTime():
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
    let (_, filename, _) = splitFile(file)

    let isUHTAffected = contents.contains(peg"s <- ('UCLASS' / 'UINTERFACE' / 'USTRUCT' / 'UENUM')")
    let includes = extractIncludes(contents, filename)
    let typeDefs = extractTypeDefinitions(contents)

    let generatedInclude = if isUHTAffected: "#include \"" & filename & ".generated.h\"\n" else: ""

    var headerFileContents = $("#pragma once\n" & intBitsDef & includes & generatedInclude & typeDefs)
    var outHeaderDir = outCppDir
    if headerFileContents.contains(exportMarker):
      outHeaderDir = outDir / "Public"
      createDir(outHeaderDir)
      headerFileContents = headerFileContents.replace(exportMarker, exportMacro)

    writeFile(outHeaderDir / outFile.extractFilename().changeFileExt("h"), headerFileContents)

    let headerIncludeString = "#include \"$#.h\"\n" % filename
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

proc runUnrealBuildTool(engineDir: string; task: TaskType;
                        target, platform, mode, uprojectFile: string;
                        extraOptions: string = "") =
  let taskStr = case task:
  of ttRecompile: "-editorrecompile"
  of ttDeploy: "-deploy"
  of ttClean: "-clean"
  of ttPreCook: "-editorrecompile"
  of ttCompileNim: nil

  let ubtPlatform = if task == ttPreCook: nimOSToUEPlatform(hostOS) else: platform

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
      [target, ubtPlatform, mode, taskStr, uprojectFile, extraOptions]

proc cleanModules(projectDir: string) =
  for moduleDir in walkDir(projectDir / "Source"):
    if moduleDir.kind != pcDir:
      continue
    removeDir (moduleDir.path / nimModuleDirName)

proc getNimOutDir(projectDir: string): string =
  result = projectDir / "Intermediate" / "Nim"

proc getNimcacheDir(projectDir: string; moduleName: string): string =
  result = getNimOutDir(projectDir) / "nimcache" / moduleName

proc createNimCfg(outDir: string, moduleDir: string) =
  var contents = "--define:CPP\n"
  if hostOS == "windows":
    contents.add("cc=vcc\n")
  contents.add("--define:noSignalHandler\n")
  contents.add("--path:\"" & moduleDir.replace("\\", "/") & "\"\n")
  contents.add("--path:\"" & getCurrentDir().replace("\\", "/") & "\"\n")
  contents.add("--define:useRealtimeGC")
  contents.add("--experimental\n")
  writeFile(outDir / "nim.cfg", contents)

proc copyNimFilesAddingImports(dir: string, rootFileContent: var Rope) =
  for file in walkDirRec(getAppDir() / "nimfiles", {pcFile}):
    let filename = extractFilename(file)
    copyFile(file, dir / filename)
    rootFileContent.addf("import \"$#\"\n", [rope(filename)])

proc buildNim(projectDir, projectName, os, cpu, uePlatform: string) =
  let sourceDir = projectDir / "Source"
  let nimOutDir = getNimOutDir(projectDir)

  # TODO: properly handle deleted files

  for sourceDirFile in walkDir(sourceDir):
    if sourceDirFile.kind != pcDir:
      continue
    let moduleDir = sourceDirFile.path
    let moduleName = moduleDir.extractFilename()
    let nimcacheDir = getNimcacheDir(projectDir, moduleName)

    let targetDir = moduleDir / nimModuleDirName

    var expectedFilenames = initSet[string]()

    var rootFileContent = rope("")
    for file in walkDirRec(moduleDir):
      if file.endsWith(".nim") and not file.endsWith(".inc.nim"):
        if file.extractFilename().cmpIgnoreCase(moduleName & ".nim") == 0:
          echo ".nim filename mustn't be equal to module name: " & file.extractFileName()
          quit(-1)
        let importArg = makeRelative(file, moduleDir).replace("\\", "/")
        rootFileContent = rootFileContent & "import \"" & importArg & "\"\n"
        expectedFilenames.incl(file.changeFileExt("h").extractFilename())

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
      createNimCfg(nimOutDir, moduleDir)

      # TODO: use -d:release --deadCodeElim:on for release builds
      var osCpuFlags = ""
      if os != nil:
        osCpuFlags.add("--os:" & os)
      if cpu != nil:
        osCpuFlags.add(" --cpu:" & cpu)
      let platform = uePlatform.toLower()
      let exceptionFlags = if platform == "android" or platform == "ios": "--noCppExceptions -d:dontWrapNimExceptions"
                           else: ""
      exec "nim cpp -c --noMain " & exceptionFlags &
           " --experimental " & osCpuFlags &
           " -p:\"" & getCurrentDir() & "\" -p:\"" & moduleDir & "\" --nimcache:\"" & nimcacheDir &
           "\" \"" & rootFile & '"'
      # export NimMain procedure so that it can be used from module initialization code
      replaceInFile(nimcacheDir / rootFile.extractFilename().changeFileExt(".cpp"),
                    "N_CDECL(void, NimMain)",
                    "NIM_EXTERNC N_CDECL(void, NimMain)")

    for file in walkDirRec(nimcacheDir, {pcFile}):
      if file.endsWith(".h") and not expectedFilenames.contains(extractFilename(file)):
        let cppFile = file.changeFileExt("cpp")
        let filename = file.extractFilename()
        let cppFilename = cppFile.extractFilename()
        removeFile file
        removeFile cppFile
        removeFile targetDir / file.extractFilename()
        removeFile targetDir / "Public" / file.extractFilename()
        removeFile targetDir / "Private" / file.extractFilename()
        removeFile targetDir / cppFilename
        removeFile targetDir / "Private" / cppFilename
      elif file.endsWith(".cpp"):
        processFile(file, moduleName, targetDir)

proc build(task: TaskType, engineDir, projectDir, projectName, target, mode, platform, extraOptions: string) =
  var os, cpu: string = nil
  if task != ttPreCook:
    (os, cpu) = uePlatformToNimOSCPU(platform)

  buildNim(projectDir, projectName, os, cpu, platform)
  runUnrealBuildTool(engineDir, task, target, platform, mode, projectDir / projectName & ".uproject", extraOptions)

  if task == ttPreCook:
    # When precooking, we have to compile editor for the current platform first,
    # and then regenerate the .cpp files for the project target platform
    # Thankfully, this is only needed in CI builds, so local development cycle is undisturbed
    removeDir (projectDir / ".nimcache")
    cleanModules(projectDir)

    (os, cpu) = uePlatformToNimOSCPU(platform)
    buildNim(projectDir, projectName, os, cpu, platform)

proc clean(engineDir, projectDir, projectName, target, mode, platform, extraOptions: string) =
  let nimOutDir = getNimOutDir(projectDir)
  removeDir nimOutDir

  runUnrealBuildTool(engineDir, ttClean, target, platform, mode, projectDir / projectName & ".uproject", extraOptions)

  cleanModules(projectDir)

proc compileNim(engineDir, projectDir, projectName, target, mode, platform, extraOptions: string) =
  let (os, cpu) = uePlatformToNimOSCPU(platform)
  buildNim(projectDir, projectName, os, cpu, platform)

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
  var extraOptions = ""
  var projectDir: string = nil
  var task = ttRecompile
  var engineDir: string = nil
  var expectedOptType = otTask

  var p = initOptParser()
  while true:
    next(p)
    if p.kind == cmdEnd: break
    let (kind, key, val) = (p.kind, p.key, p.val)
    case kind:
      of cmdArgument:
        case expectedOptType:
        of otTask:
          case key:
          of "deploy": task = ttDeploy
          of "precook": task = ttPreCook
          of "clean": task = ttClean
          of "recompile": task = ttRecompile
          of "compilenim": task = ttCompileNim
          else: raise newException(ValueError, "Unknown task: " & key)
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
        expectedOptType = otTask
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
  case task:
    of ttPreCook, ttDeploy, ttRecompile: build(task, engineDir, projectDir, projectName, target, mode, platform, extraOptions)
    of ttClean: clean(engineDir, projectDir, projectName, target, mode, platform, extraOptions)
    of ttCompileNim: compileNim(engineDir, projectDir, projectName, target, mode, platform, extraOptions)
