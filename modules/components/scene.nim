# Copyright 2016 Xored Software, Inc.

const compHeader = "Components/SceneComponent.h"

class(FOverlapInfo, header: compHeader):
  var bFromSweep: bool
  var overlapInfo: FHitResult

  proc getBodyIndex(): int32 {.noSideEffect.}
  proc `==`(other: FOverlapInfo): bool {.noSideEffect.}

# type
#   EDetailMode* {.header: compHeader, importcpp: }
type
  USceneComponent {.header: compHeader, importcpp: "USceneComponent", inheritable.} = object of UActorComponent

# TODO