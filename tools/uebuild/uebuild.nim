# Copyright 2016 Xored Software, Inc.

import parseopt2, pegs, ropes, strutils, os, times, sets, osproc

type OptType = enum
  otTask
  otProjectDir
  otTarget
  otMode
  otPlatform
  otEngineLocation

type TaskType = enum
  ttBuild
  ttClean

const usage = slurp("usage.txt")

const beginTypeMarker = "/*BEGIN_UNREAL_TYPE*/"
const endTypeMarker = "/*END_UNREAL_TYPE*/"
const exportMarker = "/*EXPORT_MACRO_PLACEHOLDER*/"

template withDir(dir: string; body: untyped): untyped =
  ## Taken from nimscript implementation
  var curDir = getCurrentDir()
  try:
    setCurrentDir(dir)
    body
  finally:
    setCurrentDir(curDir)

proc exec(command: string) =
  let retCode = execCmd(command)
  if retCode != 0:
    quit(-1)

proc extractByPeg(str: var string, peg: Peg): Rope =
  var matches: seq[string] = @[]
  var (beginPos, endPos) = str.findBounds(peg, matches, 0)
  result = rope("")
  while beginPos != -1:
    let sliceToExtract = beginPos..endPos
    # echo "Match found at: " & $(beginPos, endPos)
    result = result & str[sliceToExtract]
    str[sliceToExtract] = ""
    (beginPos, endPos) = str.findBounds(peg, matches, beginPos)

proc extractTypeDefinitions(contents: var string): Rope =
  result = extractByPeg(contents, peg("'$#' @ '$#'" % [beginTypeMarker, endTypeMarker]))

proc extractIncludes(contents: var string, filename: string): Rope =
  let includePeg = peg("""s <- wsNoEol '#include' ws '"' !'$#.h' {[^"]+} '"' ws
                         comment <- '/*' @ '*/' / '//' .*
                         wsNoEol <- (comment / !\n \s+)*
                         ws <- (comment / \s+)* """.format(filename))
  result = extractByPeg(contents, includePeg)

proc processFile(file, moduleName, outDir: string) =
  # echo "Processing " & file & "..."
  let moduleIncludeString = "#include \"$#.h\"\n" % moduleName
  let exportMacro = moduleName.toUpper() & "_API"
  if not file.endsWith(".cpp"):
    raise newException(ValueError, ".cpp file expected")
  let outCppDir = outDir / "Private"
  let outFile = outCppDir / extractFilename(file)
  let (_, filename, _) = splitFile(file)

  if outFile != file and fileExists(outFile) and file.getLastModificationTime() < outFile.getLastModificationTime():
    # no changes - no need to process
    return

  var contents = readFile(file)
  if outFile == file and contents.contains(moduleIncludeString):
    # file hasn't been regenerated
    return
  echo file.extractFileName() & " has changed - processing..."
  createDir(outCppDir)

  var matches: seq[string] = @[]
  let (intBitsDefBegin, intBitsDefEnd) = contents.findBounds(peg"s <- '#define' \s+ 'NIM_INTBITS' \s+ \d+ \n+", matches, 0)
  assert(intBitsDefBegin != -1)
  let intBitsDef = contents[intBitsDefBegin..intBitsDefEnd]
  if contents.contains(beginTypeMarker):
    let typeDefs = extractTypeDefinitions(contents)
    let includes = extractIncludes(contents, filename)

    var headerFileContents = $("#pragma once\n" & intBitsDef & includes & "#include \"" & filename & ".generated.h\"\n" & typeDefs)
    var outHeaderDir = outCppDir
    if headerFileContents.contains(exportMarker):
      outHeaderDir = outDir / "Public"
      createDir(outHeaderDir)
      headerFileContents = headerFileContents.replace(exportMarker, exportMacro)

    writeFile(outHeaderDir / outFile.extractFilename().changeFileExt("h"), headerFileContents)
  contents.insert(moduleIncludeString, intBitsDefEnd + 1)
  writeFile(outFile, contents)

proc runUnrealBuildScript(engineDir: string; task: TaskType; target, platform, mode, uprojectFile: string) =
  let taskStr = case task:
  of ttBuild: ""
  of ttClean: "clean"

  var unrealBuildScript: string
  case hostOS
    of "macosx":
      unrealBuildScript = engineDir / "Engine" / "Build" / "BatchFiles" / "Mac" / "RocketBuild.sh"
    else:
      raise newException(OSError, "Building is not supported for your platform. Consider submitting a pull request.")

  withDir engineDir:
    exec unrealBuildScript & " $# $# $# $# \"$#\"" % [taskStr, target, platform, mode, uprojectFile]

proc build(engineDir, projectDir, projectName, target, mode, platform: string) =
  let sourceDir = projectDir / "Source"

  for sourceDirFile in walkDir(sourceDir):
    if sourceDirFile.kind != pcDir:
      continue
    let moduleDir = sourceDirFile.path
    let moduleName = moduleDir.extractFilename()
    let isMainModule = (moduleName == projectName)
    let nimcacheDir = projectDir / ".nimcache" / moduleName

    let targetDir = moduleDir / "nimgen"
    var expectedFilenames = initSet[string]()
    for file in walkDirRec(moduleDir):
      if file.endsWith(".nim"):
        # TODO: use -d:release --opt:speed for release builds
        exec "nim cpp -c --noMain --experimental -p:\"" & getCurrentDir() & "\" --nimcache:" & nimcacheDir &
          " --os:" & platform & " " & file
        expectedFilenames.incl(file.changeFileExt("h").extractFilename())

    for file in walkDirRec(nimcacheDir, {pcFile}):
      if file.endsWith(".h") and not expectedFilenames.contains(extractFilename(file)):
        let cppFile = file.changeFileExt("cpp")
        removeFile file
        removeFile cppFile
        removeFile targetDir / file.extractFilename()
        removeFile targetDir / "Public" / file.extractFilename()
        removeFile targetDir / "Private" / file.extractFilename()
        removeFile targetDir / cppFile.extractFilename()
        removeFile targetDir / "Private" / cppFile.extractFilename()
      elif file.endsWith(".cpp"):
        processFile(file, moduleName, targetDir)

  runUnrealBuildScript(engineDir, ttBuild, target, platform, mode, projectDir / projectName & ".uproject")

proc clean(engineDir, projectDir, projectName, target, mode, platform: string) =
  removeDir (projectDir / ".nimcache")

  runUnrealBuildScript(engineDir, ttClean, target, platform, mode, projectDir / projectName & ".uproject")

  for moduleDir in walkDir(projectDir / "Source"):
    if moduleDir.kind != pcDir:
      continue
    removeDir (moduleDir.path / "nimgen")

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
  var platform = hostOS
  var projectDir: string = nil
  var task = ttBuild
  var engineDir: string = nil
  var expectedOptType = otTask
  for kind, key, val in getopt():
    case kind:
      of cmdArgument:
        case expectedOptType:
        of otTask:
          case key:
          of "build": task = ttBuild
          of "clean": task = ttClean
          else: raise newException(ValueError, "Unknown task: " & key)
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
    of ttBuild: build(engineDir, projectDir, projectName, target, mode, platform)
    of ttClean: clean(engineDir, projectDir, projectName, target, mode, platform)
