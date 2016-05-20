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
