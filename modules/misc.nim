# Copyright 2016 Xored Software, Inc.

type FGuid {.header: "Misc/Guid.h", importcpp.} = object
  A: uint32
  B: uint32
  C: uint32
  D: uint32

type FDateTime {.header: "Misc/DateTime.h", importcpp.} = object

# TODO