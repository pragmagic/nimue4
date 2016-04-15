# Copyright 2016 Xored Software, Inc.

class(TArray[T], header: "Containers/Array.h", bycopy):
  proc capacity(): uint32 {.noSideEffect, cppname: "Max".}
    ## number of items that can fit in the array without memory reallocation
  proc slack(): int32 {.noSideEffect, cppname: "GetSlack".}
    ## `capacity` - `len`
  proc len(): int32 {.noSideEffect, cppname: "Num".}
    ## number of items in the array
  proc add(item: T) {.cppname: "Push".}

  proc pop(): T

  proc `[]`(i: Natural): T {.noSideEffect.}
  proc `[]=`(i: Natural, val: T)

  proc find(item: T): int32 {.noSideEffect.}

  proc rfind(item: T): int32 {.noSideEffect, cppname: "FindLast".}

  proc `==`(other: TArray[T]): bool {.noSideEffect.}
  proc `!=`(other: TArray[T]): bool {.noSideEffect.}

  proc insert(other: TArray[T], i: Natural): int32 {.discardable.}
  proc insert(item: T, i: Natural): int32 {.discardable.}

  proc delete(i: Natural, count: Natural = 1) {.cppname: "RemoveAt".}
  proc del(i: Natural, count: Natural = 1) {.cppname: "RemoveAtSwap".}

  proc clear() {.cppname: "Empty".}

  proc setLen(newLen: Natural) {.cppname: "SetNum".}

  proc append[OtherT](other: TArray[OtherT])
  proc append(arrPtr: ptr T, count: Natural)

  proc remove(item: T): int32 {.discardable.}
    ## Removes all items equal to the specified item, preserving order.
    ## Optimized for series of matches and non-matches.
    ## Returns the number of items removed

  proc removeFirst(item: T): int32 {.discardable.}
    ## Removes the first item equal to the specified item, preserving order.
    ## Returns the number of items removed

  proc removeFirstSwap(item: T): int32 {.discardable.}
    ## Removes the first item equal to the specified item, not preserving order, but more efficiently
    ## Returns the number of items removed

  proc removeSwap(item: T): int32 {.discardable.}
    ## Removes all items equal to the specified item, not preserving order
    ## Returns the number of items removed

  proc swap(i1: Natural, i2: Natural)

  proc sort()

  proc reserve(capacity: Natural)

  proc getData(): ptr T

proc initArrayInternal[T](arr: var TArray[T], val: T, size: int32) {.importcpp: "#.Init(@)", nodecl.}

proc initArray*[T](): TArray[T] {.importcpp: "'0(@)", constructor, nodecl.}

proc initArray*[T](initCapacity: Natural): TArray[T] =
  result = initArray[T]()
  result.reserve(initCapacity)

proc initArray*[T](val: T, size: Natural): TArray[T] =
  initArrayInternal[T](result, val, int32(size))

iterator items*[T](arr: TArray[T]): T =
  for i in 0 .. <arr.len:
    yield arr[i]

proc `$`*[T](arr: TArray[T]): string =
  let comma = rope(", ")
  var isFirst = true
  var r = rope("[")
  for item in arr.items():
    if not isFirst:
      r.add(comma)
    else:
      isFirst = false
    r.add($item)
  r.add("]")
  result = $r

# TODO: might have to manually implement many procs here
# so that they work properly with Nim (non-C++) types

# TODO: TIndirectArray, TTransArray
