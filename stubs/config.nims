import strutils, ospaths

mode = ScriptMode.Verbose

proc getEnvOrRaise(envKey: string): string =
  if existsEnv(envKey):
    result = getEnv(envKey)
  else:
    raise newException(OSError, "Mandatory environment variable is not set: " & envKey)

proc paramString(): string =
  result = ""
  for i in 1 .. <paramCount():
    result &= " " & paramStr(i)

proc getThisDir(): string =
  (when defined(windows): thisDir().capitalize() else: thisDir())

let nimUE4LibDir = getEnvOrRaise("NIMUE_HOME")
let engineDir = getEnvOrRaise("UE4_HOME")

const uebuildPath = nimUE4LibDir / "tools" / "uebuild" / "uebuild"

exec "nim c -d:release --opt:speed \"$#.nim\"" % uebuildPath

task build, "rebuild editor for the current platform in Development mode":
  withDir nimUE4LibDir:
    exec "$# -e \"$#\" -d \"$#\" recompile $#" %
      [uebuildPath, engineDir, getThisDir(), paramString()]

task deploy, "hot deployment":
  withDir nimUE4LibDir:
    exec "$# -e \"$#\" -d \"$#\" deploy $#" %
      [uebuildPath, engineDir, getThisDir(), paramString()]

task clean, "clean Nim and Unreal generated files":
  withDir nimUE4LibDir:
    exec "$# -e \"$#\" -d \"$#\" clean $#" %
      [uebuildPath, engineDir, getThisDir(), paramString()]
