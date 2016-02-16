# Copyright 2016 Xored Software, Inc.

class(FVector_NetQuantize of FVector, header: "Engine/NetSerialization.h"):
  proc makeFVector_NetQuantize(): FVector_NetQuantize {.constructor.}
  proc makeFVector_NetQuantize(inX, inY, inZ: cfloat): FVector_NetQuantize {.constructor.}