# Copyright 2016 Xored Software, Inc.

type
  FSetElementId {.importcpp: "FSetElementId".} = object
  TSetIterator {.importcpp: "TSet<'0>::TIterator".} [T] = object
  TSetConstIterator {.importcpp: "TSet<'0>::TConstIterator".} [T] = object
  TAnySetIterator[T] = TSetIterator[T] or TSetConstIterator[T]

wclass(TSet[T], header: "Containers/Set.h", bycopy):
  ## A set with an optional KeyFuncs parameters for customizing how the elements are compared and searched. E.g.
  ## You can specify a mapping from elements to keys if you want to find elements by specifying a subset of the element type.
  ## It uses a TSparseArray of the elements, and also links the elements into a hash with a number of
  ## buckets proportional to the number of elements. Addition, removal, and finding are O(1).

  proc len(): int32 {.noSideEffect, cppname: "Num".}
    ## The number of elements.

  proc contains(key: T): bool {.noSideEffect.}

  proc incl(key: T) {.cppname: "Add".}

  proc toArray(): TArray[T] {.cppname: "Array".}

  proc findId(key: T): FSetElementId {.noSideEffect.}
  proc remove(id: FSetElementId)

  proc clear() {.cppname: "Empty".}

  proc union(s: TSet[T]): TSet[T]
  proc intersection(s: TSet[T]): TSet[T] {.cppname: "Intersect".}
  proc difference(s: TSet[T]): TSet[T]
  proc createConstIterator(): TSetConstIterator[T]

proc excl*[T](s: var TSet[T], val: T) {.inline.} =
  let id = s.findId(val)
  if id != nil:
    s.remove(id)

proc `+`*[T](s1, s2: TSet[T]): TSet[T] {.inline.} =
  ## Alias for `union(s1, s2) <#union>`_.
  result = union(s1, s2)

proc `*`*[T](s1, s2: TSet[T]): TSet[T] {.inline.} =
  ## Alias for `intersection(s1, s2) <#intersection>`_.
  result = intersection(s1, s2)

proc `-`*[T](s1, s2: TSet[T]): TSet[T] {.inline.} =
  ## Alias for `difference(s1, s2) <#difference>`_.
  result = difference(s1, s2)

proc isValid[T](it: TAnySetIterator[T]): bool {.noSideEffect, importcpp: "((bool)(#))", header: "Containers/Set.h".}
proc next[T](it: var TAnySetIterator[T]) {.importcpp: "(++#)", header: "Containers/Set.h".}
proc value[T](it: TSetIterator[T]): var T {.noSideEffect, importcpp: "(*#)", header: "Containers/Set.h".}
proc value[T](it: TSetConstIterator[T]): T {.noSideEffect, importcpp: "(*#)", header: "Containers/Set.h".}

proc makeSet*[T](): TSet[T] {.importcpp: "TSet", constructor, header: "Containers/Set.h".}

iterator items*[T](s: TSet[T]): T =
  var it = s.createConstIterator()
  while it.isValid():
    yield it.value
    it.next

proc `$`*[T](st: TSet[T]): string =
  let comma = rope(", ")
  var isFirst = true
  var r = rope("[")
  for item in st.items():
    if not isFirst:
      r.add(comma)
    else:
      isFirst = false
    r.add($item)
  r.add("]")
  result = $r

# TODO: might have to manually implement many procs here
# so that they work properly with Nim (non-C++) types
