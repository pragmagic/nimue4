# Copyright 2016 Xored Software, Inc.

type LogLevel {.pure.} = enum
  Fatal,
    ## Always prints s fatal error to console (and log file) and crashes (even if logging is disabled)
  Error,
    ## Prints an error to console (and log file).
    ## Commandlets and the editor collect and report errors. Error messages result in commandlet failure.
  Warning,
    ## Prints a warning to console (and log file).
    ## Commandlets and the editor collect and report warnings. Warnings can be treated as an error.
  Display,
    ## Prints a message to console (and log file)
  Log,
    ## Prints a message to a log file (does not print to console)
  Verbose,
    ## Prints a verbose message to a log file (if Verbose logging is enabled for the given category,
    ## usually used for detailed logging)
  VeryVerbose
    ## Prints a verbose message to a log file (if VeryVerbose logging is enabled,
    ## usually used for detailed logging that would otherwise spam output)

proc rawUEFatal*(s: wstring) {.importcpp: "UE_LOG(LogTemp, Fatal, @)", nodecl, varargs.}
proc rawUEError*(s: wstring) {.importcpp: "UE_LOG(LogTemp, Error, @)", nodecl, varargs.}
proc rawUEWarning*(s: wstring) {.importcpp: "UE_LOG(LogTemp, Warning, @)", nodecl, varargs.}
proc rawUEDisplay*(s: wstring) {.importcpp: "UE_LOG(LogTemp, Display, @)", nodecl, varargs.}
proc rawUELog*(s: wstring) {.importcpp: "UE_LOG(LogTemp, Log, @)", nodecl, varargs.}
proc rawUEVerbose*(s: wstring) {.importcpp: "UE_LOG(LogTemp, Verbose, @)", nodecl, varargs.}
proc rawUEVeryVerbose*(s: wstring) {.importcpp: "UE_LOG(LogTemp, VeryVerbose, @)", nodecl, varargs.}

proc expandUeLog(level: LogLevel, format: NimNode, callSite: NimNode, args: NimNode): NimNode =
  result = callSite
  result[0] = case level:
    of LogLevel.Fatal: newIdentNode("rawUEFatal")
    of LogLevel.Error: newIdentNode("rawUEError")
    of LogLevel.Warning: newIdentNode("rawUEWarning")
    of LogLevel.Display: newIdentNode("rawUEDisplay")
    of LogLevel.Log: newIdentNode("rawUELog")
    of LogLevel.Verbose: newIdentNode("rawUEVerbose")
    of LogLevel.VeryVerbose: newIdentNode("rawUEVeryVerbose")

  result[1] = newCall("TEXT", result[1])

  for i in 0 .. <args.len:
    if args[i].getType.typeKind == ntyString or
       args[i].getType.typeKind == ntyCString:
      result[i + 2] = newCall("toWideString", result[i + 2])

macro ueFatal*(formatString: string{lit}, args: varargs[expr]): expr =
  result = expandUeLog(LogLevel.Fatal, formatString, callsite(), args)

macro ueError*(formatString: string{lit}, args: varargs[expr]): expr =
  result = expandUeLog(LogLevel.Error, formatString, callsite(), args)

macro ueWarning*(formatString: string{lit}, args: varargs[expr]): expr =
  result = expandUeLog(LogLevel.Warning, formatString, callsite(), args)

macro ueDisplay*(formatString: string{lit}, args: varargs[expr]): expr =
  result = expandUeLog(LogLevel.Display, formatString, callsite(), args)

macro ueLog*(formatString: string{lit}, args: varargs[expr]): expr =
  result = expandUeLog(LogLevel.Log, formatString, callsite(), args)

macro ueVerbose*(formatString: string{lit}, args: varargs[expr]): expr =
  result = expandUeLog(LogLevel.Verbose, formatString, callsite(), args)

macro ueVeryVerbose*(formatString: string{lit}, args: varargs[expr]): expr =
  result = expandUeLog(LogLevel.VeryVerbose, formatString, callsite(), args)

proc ueLog*[T](t: T) {.inline.} =
  rawUELog(TEXT("%s"), toWideString($t))
