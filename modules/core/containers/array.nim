# Copyright 2016 Xored Software, Inc.

wclass(TArray[T], header: "Containers/Array.h", bycopy):
  proc capacity(): uint32 {.noSideEffect, cppname: "Max".}
    ## number of items that can fit in the array without memory reallocation
  proc slack(): int32 {.noSideEffect, cppname: "GetSlack".}
    ## `capacity` - `len`
  proc len(): int32 {.noSideEffect, cppname: "Num".}
    ## number of items in the array
  proc add(item: T) {.cppname: "Push".}
  proc add[OtherT](other: TArray[OtherT]) {.cppname: "Append".}
  proc add(arrPtr: ptr T, count: Natural) {.cppname: "Append".}

  proc pop(): T

  proc `[]`(i: Natural): var T {.noSideEffect.}
  proc `[]=`(i: Natural, val: T)

  proc find(item: T): int32 {.noSideEffect.}

  proc rfind(item: T): int32 {.noSideEffect, cppname: "FindLast".}

  proc `==`(other: TArray[T]): bool {.noSideEffect.}
  proc `!=`(other: TArray[T]): bool {.noSideEffect.}

  proc insert(other: TArray[T], i: Natural): int32 {.discardable.}
  proc insert(item: T, i: Natural): int32 {.discardable.}

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

  proc isValidIndex(i: Natural): bool {.noSideEffect.}
    ## Tests if index is valid, i.e. greater than zero and less than number of
    ## elements in array.

  proc fill(val: T, times: Natural) {.cppname: "Init".}
    ## Sets the size of the array, filling it with the given element.

proc deleteInternal[T](arr: var TArray[T], i: Natural, count: Natural = 1) {.importcpp: "RemoveAt", header: "Containers/Array.h".}
proc delInternal[T](arr: var TArray[T], i: Natural, count: Natural = 1) {.importcpp: "RemoveAtSwap", header: "Containers/Array.h".}

proc delete*[T](arr: var TArray[T], i: Natural) {.inline.} =
  arr.deleteInternal(i)

proc delete*[T](arr: var TArray[T], first, last: Natural) {.inline.} =
  arr.deleteInternal(first, last - first + 1)

proc del*[T](arr: var TArray[T], i: Natural) {.importcpp: "RemoveAtSwap", header: "Containers/Array.h".}

proc del*[T](arr: var TArray[T], first, last: Natural) {.inline.} =
  arr.delInternal(first, last - first + 1)

proc initArrayInternal[T](arr: var TArray[T], val: T, size: int32) {.importcpp: "#.Init(@)", nodecl.}

type
  TArrayIterator {.importcpp: "TArray<'0>::TIterator".} [T] = object
  TArrayConstIterator {.importcpp: "TArray<'0>::TConstIterator".} [T] = object
  TAnyArrayIterator[T] = TArrayIterator[T] or TArrayConstIterator[T]

proc isValid[T](it: TAnyArrayIterator[T]): bool {.noSideEffect, importcpp: "((bool)(#))", header: "Containers/Array.h".}
proc next[T](it: var TAnyArrayIterator[T]) {.importcpp: "(++#)", header: "Containers/Array.h".}

proc value[T](it: TArrayIterator[T]): var T {.noSideEffect, importcpp: "(*#)", header: "Containers/Array.h".}
proc value[T](it: TArrayConstIterator[T]): T {.noSideEffect, importcpp: "(*#)", header: "Containers/Array.h".}

proc initArray*[T](): TArray[T] {.importcpp: "'0(@)", constructor, nodecl.}

proc initArray*[T](initCapacity: Natural): TArray[T] =
  result = initArray[T]()
  result.reserve(initCapacity)

proc initArray*[T](val: T, size: Natural): TArray[T] =
  initArrayInternal[T](result, val, int32(size))

iterator items*[T](arr: TArray[T]): T =
  for i in 0 .. <arr.len:
    yield arr[i]

iterator pairs*[T](arr: TArray[T]): tuple[key: int, val: T] =
  for i in 0 .. <arr.len:
    yield (i.int, arr[i])

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
