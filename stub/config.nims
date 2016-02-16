import strutils, ospaths

mode = ScriptMode.Verbose

##### Edit these constants
const ue4LibDir = "/Path/To/nim-ue4/"
const engineDir = "/Users/Shared/UnrealEngine/4.10/"
#####

const uebuildLocation = ue4LibDir / "tools" / "uebuild" / "uebuild"

proc paramOrNil(i: Natural): string =
  if i < paramCount():
    result = paramStr(i)

let targetParam= paramOrNil(1)
let modeParam= paramOrNil(2)
let platformParam = paramOrNil(3)

let target = if targetParam != nil: "-t \"" & targetParam & '\"' else: ""
let platform = if platformParam != nil: "-p \"" & platformParam & '\"' else: ""
let mode = if modeParam != nil: "-m \"" & modeParam & '\"' else: ""

exec "nim c -d:release --opt:speed \"$#.nim\"" % uebuildLocation

task build, "build specified target for specified platform":
  withDir ue4LibDir:
    exec "$# -e \"$#\" -d \"$#\" $# $# $# build" %
      [uebuildLocation, engineDir, thisDir(), target, mode, platform]

task clean, "clean Nim and Unreal generated files":
  withDir ue4LibDir:
    exec "$# -e \"$#\" -d \"$#\" $# $# $# clean" %
      [uebuildLocation, engineDir, thisDir(), target, mode, platform]
