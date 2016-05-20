# Copyright 2016 Xored Software, Inc.

wclass(TEnumAsByte[T: enum], header: "Containers/EnumAsByte.h", bycopy):
  proc value(): T {.noSideEffect.}

proc initTEnumAsByte*[T: enum](e: T): TEnumAsByte[T] {.importcpp: "TEnumAsByte<'1>(@)", nodecl, constructor.}

converter toEnumValue*[T](container: TEnumAsByte[T]): T =
  result = container.value()

converter fromEnumValue*[T: enum](t: T): TEnumAsByte[T] =
  result = initTEnumAsByte(t)