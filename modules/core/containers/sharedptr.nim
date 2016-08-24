# Copyright 2016 Xored Software, Inc.

wclass(TSharedRef[T], header: "Templates/SharedPointer.h", bycopy):
  proc getSharedReferenceCount(): int32 {.noSideEffect.}
    ## Returns the number of shared references to this object (including this reference.)
    ## IMPORTANT: Not necessarily fast!  Should only be used for debugging purposes!
    ##
    ## @return  Number of shared references to the object (including this reference.)

  proc IsUnique(): bool {.noSideEffect.}
    ## Returns true if this is the only shared reference to this object.  Note that there may be
    ## outstanding weak references left.
    ## IMPORTANT: Not necessarily fast!  Should only be used for debugging purposes!
    ##
    ## @return  True if there is only one shared reference to the object, and this is it!

  proc get(): var T

wclass(TSharedPtr[T], header: "Templates/SharedPointer.h", bycopy):
  proc initTSharedPtr(): TSharedPtr[T] {.constructor.}
    ## initializes nil ptr

  proc getSharedReferenceCount(): int32 {.noSideEffect.}
    ## Returns the number of shared references to this object (including this reference.)
    ## IMPORTANT: Not necessarily fast!  Should only be used for debugging purposes!
    ##
    ## @return  Number of shared references to the object (including this reference.)

  proc IsUnique(): bool {.noSideEffect.}
    ## Returns true if this is the only shared reference to this object.  Note that there may be
    ## outstanding weak references left.
    ## IMPORTANT: Not necessarily fast!  Should only be used for debugging purposes!
    ##
    ## @return  True if there is only one shared reference to the object, and this is it!

  proc get(): ptr T
  proc isValid(): bool
  proc toSharedRef(): TSharedRef[T]
  proc reset()

converter toPtr*[T](reference: TSharedRef[T]): ptr T {.importcpp: "(& #.Get())", nodecl.}
converter toPtr*[T](sharedPtr: TSharedPtr[T]): ptr T {.importcpp: "#.Get()", nodecl.}

converter toSharedPtr*[T](sharedRef: TSharedRef[T]): TSharedPtr[T] {.importcpp: "(#)", nodecl.}

proc makeShareable*[T](p: ptr T): TSharedPtr[T] {.importc: "MakeShareable", header: "Templates/SharedPointer.h".}

wclass(TSharedFromThis[T], header: "Templates/SharedPointer.h", bycopy):
  proc asShared(): TSharedRef[T]

# TODO