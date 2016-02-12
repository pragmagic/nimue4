# Copyright 2016 Xored Software, Inc.

class(TEnumAsByte[T: enum], header: "Container/EnumAsByte.h"):
  proc makeTEnumAsByte(e: T): TEnumAsByte[T] {.constructor.}
  proc value(): T {.noSideEffect.}

converter toEnumValue*[T](container: TEnumAsByte[T]): T =
  result = container.value()

converter fromEnumValue*[T: enum](t: T): TEnumAsByte[T] =
  result = makeTEnumAsByte(t)