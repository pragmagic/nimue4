# Copyright 2016 Xored Software, Inc.

type FGuid {.header: "Misc/Guid.h", importcpp.} = object
  A: uint32
  B: uint32
  C: uint32
  D: uint32

type FDateTime {.header: "Misc/DateTime.h", importcpp.} = object

proc ueLog*(s: wstring) {.importcpp: "UE_LOG(LogTemp, Log, @)", nodecl, varargs.}

proc ueLog*(s: static[string]) {.inline.} =
  uelog(TEXT(s))

proc ueCast*[T](v: ptr UObject): ptr T {.importcpp: "Cast<'*0>(@)", nodecl.}

# TODO