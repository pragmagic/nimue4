# Copyright 2016 Xored Software, Inc.

wclass(TOptional[T], header: "Misc/Optional.h", bycopy):
  ## When we have an optional value isSet() returns true, and getValue() is meaningful.
  ## Otherwise getValue() is not meaningful.
  proc initTOptional(val: T): TOptional[T] {.constructor.}
  proc isSet(): bool {.noSideEffect.}
  proc getValue(): T {.noSideEffect.}
  proc `==`(other: TOptional[T]): bool {.noSideEffect.}
  proc reset()
