# Copyright 2016 Xored Software, Inc.

wclass(TWeakObjectPtr[T], header: "UObject/WeakObjectPtrTemplates.h", bycopy):
  proc isValid(bEvenIfPendingKill, bThreadsafeTest: bool  = false): bool {.noSideEffect.}
    ## Test if this points to a live UObject
    ## @param bEvenIfPendingKill, if this is true, pendingkill objects are considered valid
    ## @param bThreadsafeTest, if true then function will just give you information whether referenced
    ##							UObject is gone forever (@return false) or if it is still there (@return true, no object flags checked).
    ## @return true if Get() would return a valid non-null pointer

  proc isStale(bIncludingIfPendingKill, bThreadsafeTest: bool = false): bool {.noSideEffect.}
    ## Slightly different than !IsValid(), returns true if this used to point to a UObject, but doesn't any more and has not been assigned or reset in the mean time.
    ## @param bIncludingIfPendingKill, if this is true, pendingkill objects are considered stale
    ## @param bThreadsafeTest, set it to true when testing outside of Game Thread. Results in false if WeakObjPtr point to an existing object (no flags checked)
    ## @return true if this used to point at a real object but no longer does.

  proc get(): ptr T
  proc reset()

proc set*[T](weakPtr: var TWeakObjectPtr[T], p: ptr T) {.importcpp: "(# = #)", nodecl.}

converter toWeakPtr*[T](p: ptr T): TWeakObjectPtr[T] {.importcpp: "(#)", nodecl.}
converter toPtr*[T](p: TWeakObjectPtr[T]): ptr T {.importcpp: "(#.Get())", nodecl.}

wclass(TAutoWeakObjectPtr[T], header: "UObject/WeakObjectPtrTemplates.h", bycopy):
  proc initTAutoWeakObjectPtr(): TAutoWeakObjectPtr[T] {.constructor.}
  proc initTAutoWeakObjectPtr(p: ptr T): TAutoWeakObjectPtr[T] {.constructor.}
  proc initTAutoWeakObjectPtr(weakPtr: TWeakObjectPtr[T]): TAutoWeakObjectPtr[T] {.constructor.}
  proc get(): ptr T

converter toPtr*[T](p: TAutoWeakObjectPtr[T]): ptr T {.importcpp: "(#)", nodecl.}

wclass(TWeakPtr[T], header: "Templates/SharedPointer.h", bycopy):
  ## TWeakPtr is a non-intrusive reference-counted weak object pointer.  This weak pointer will be
  ## conditionally thread-safe when the optional Mode template argument is set to ThreadSafe.

  proc initTWeakPtr(): TWeakPtr[T] {.constructor.}

  proc initTWeakPtr[OtherT](inSharedRef: TSharedRef[OtherT]): TWeakPtr[T]
    ## Constructs a weak pointer from a shared reference
    ##
    ## @param  InSharedRef  The shared reference to create a weak pointer from

  proc initTWeakPtr[OtherT](inSharedPtr: TSharedPtr[OtherT]): TWeakPtr[T]
    ## Constructs a weak pointer from a shared pointer
    ##
    ## @param  InSharedPtr  The shared pointer to create a weak pointer from

  proc initTWeakPtr[OtherT](inWeakPtr: TWeakPtr[OtherT]): TWeakPtr[T]
    ## Constructs a weak pointer from a weak pointer of another type.
    ## This constructor is intended to allow derived-to-base conversions.
    ##
    ## @param  InWeakPtr  The weak pointer to create a weak pointer from

  proc initTWeakPtr(inWeakPtr: TWeakPtr[T]): TWeakPtr[T]

  proc pin(): TSharedPtr[T] {.noSideEffect.}
    ## Converts this weak pointer to a shared pointer that you can use to access the object (if it
    ## hasn't expired yet.)  Remember, if there are no more shared references to the object, the
    ## returned shared pointer will not be valid.  You should always check to make sure the returned
    ## pointer is valid before trying to dereference the shared pointer!
    ##
    ## @return  Shared pointer for this object (will only be valid if still referenced!)

  proc isValid(): bool {.noSideEffect.}
    ## Checks to see if this weak pointer actually has a valid reference to an object
    ##
    ## @return  True if the weak pointer is valid and a pin operator would have succeeded

  proc reset()
    ## Resets this weak pointer, removing a weak reference to the object.  If there are no other shared
    ## or weak references to the object, then the tracking object will be destroyed.

  proc hasSameObject(inOtherPtr: pointer): bool
    ## Returns true if the object this weak pointer points to is the same as the specified object pointer.

converter toWeakPtr*[T](p: TSharedRef[T]): TWeakPtr[T] {.importcpp: "(#)", nodecl.}
converter toWeakPtr*[T](p: TSharedPtr[T]): TWeakPtr[T] {.importcpp: "(#)", nodecl.}
