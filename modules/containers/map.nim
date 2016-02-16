# Copyright 2016 Xored Software, Inc.

class(TPair[K, V], header: "Containers/Map.h", bycopy):
  var key: K
  var value: V

  proc `==`(other: TPair[K, V]): bool {.noSideEffect.}
  proc `!=`(other: TPair[K, V]): bool {.noSideEffect.}

class(TMap[K, V], header: "Containers/Map.h", bycopy):
  proc append(other: TMap[K, V])

  proc `[]`(key: K): var V {.noSideEffect.}
  proc `[]=`(key: K, value: V)
  proc getOrDefault(key: K, default: V) {.noSideEffect.}

  proc equals(other: TMap[K, V]): bool {.noSideEffect, cppname: "OrderIndependentCompareEqual".}
    ## Order-independent comparison

  proc reset()
    ## Remove all elements from the map, leaving the current capacity

  proc clear(nextExpectedSize: Natural = 0) {.cppname: "Empty".}
    ## Remove all elements from the map, setting new capacity

  proc reserve(capacity: Natural)
    ## Reserve memory enough to hold the specified number of elements in the map

  proc len(): int32 {.noSideEffect, cppname: "Num".}
    ## Current number of items in the ma

  proc del(key: K): int32 {.discardable, cppname: "Remove".}
    ## Removes value associated with the key in the map, if any. Returns the number of items removed

  proc contains(key: K): bool {.noSideEffect.}

type
  TMapIterator {.importcpp: "TBaseMap<'0, '1>::TIterator".} [K, V] = object

proc key[K, V](it: TMapIterator[K, V]): K {.noSideEffect, importcpp: "#.Key(@)", nodecl.}
proc value[K, V](it: TMapIterator[K, V]): V {.noSideEffect, importcpp: "#.Value(@)", nodecl.}
proc pair[K, V](it: TMapIterator[K, V]): TPair[K, V] {.noSideEffect, importcpp: "*#", nodecl.}
proc isValid[K, V](it: TMapIterator[K, V]): bool {.noSideEffect, importcpp: "#", nodecl.}
proc next[K, V](it: var TMapIterator[K, V]) {.importcpp: "#++", nodecl.}

proc makeIterator[K, V](map: TMap[K, V]): TMapIterator[K, V] {.importcpp:"#.CreateIterator(@)", nodecl.}

proc keysInternal[K, V](map: TMap[K, V], outArr: var TArray[K]) {.importcpp:"#.GetKeys(@)", nodecl.}
proc keys*[K, V](map: TMap[K, V]): TArray[K] =
  result = makeArray(map.len)
  keysInternal(map, result)

iterator keys*[K, V](map: TMap[K, V]): K =
  var it = map.makeIterator()
  while it.isValid:
    yield it.key()
    it.next()

iterator pairs*[K, V](map: TMap[K, V]): TPair[K, V] =
  var it = map.makeIterator()
  while it.isValid:
    yield it.pair()
    it.next()

iterator values*[K, V](map: TMap[K, V]): V =
  var it = map.makeIterator()
  while it.isValid:
    yield it.value()
    it.next()

# TODO: mpairs, mvalues?

proc makeMap*[K, V](): TMap[K, V] {.importcpp: "TMap", constructor, nodecl.}
proc makeMap*[K, V](initialCapacity: Natural): TMap[K, V] =
  result = makeMap()
  result.reserve(initialCapacity)

# TODO: TMultiMap, FScriptMap
