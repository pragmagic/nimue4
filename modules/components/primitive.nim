# Copyright 2016 Xored Software, Inc.

type
  ECanBeCharacterBase* {.header: "Components/PrimitiveComponent.h", importcpp: "ECanBeCharacterBase".} = enum
    ECB_No,
    ECB_Yes,
    ECB_Owner,
    ECB_MAX

  EHasCustomNavigableGeometry* {.header: "Components/PrimitiveComponent.h",
                                importcpp: "EHasCustomNavigableGeometry::Type", pure.} = enum
    No,
    Yes,
    EvenIfNotCollidable,
    DontExport

class(FStreamingTexturePrimitiveInfo, header: "Components/PrimitiveComponent.h", bycopy):
  # var texture: ptr UTexture
  var bounds: FSphere
  var textelFactor: cfloat

class(FSpriteCategoryInfo, header: "Components/PrimitiveComponent.h", bycopy):
  var category: FName
  var displayName: FText
  var description: FText

class(UPrimitiveComponent of USceneComponent, header: "Components/PrimitiveComponent.h", notypedef):
  ## PrimitiveComponents are SceneComponents that contain or generate some sort of geometry, generally to be rendered or used as collision data.
  ## There are several subclasses for the various types of geometry, but the most common by far are the ShapeComponents (Capsule, Sphere, Box), StaticMeshComponent, and SkeletalMeshComponent.
  ## ShapeComponents generate geometry that is used for collision detection but are not rendered, while StaticMeshComponents and SkeletalMeshComponents contain pre-built geometry that is rendered, but can also be used for collision detection.
  var minDrawDistance: cfloat
  var ldMaxDrawDistance: cfloat
  var cachedMaxDrawDistance: cfloat

# TODO

class(FOverlapInfo, header: "Components/SceneComponent.h", bycopy):
  ## Overlap info consisting of the primitive and the body that is overlapping

  proc makeFOverlapInfo(): FOverlapInfo {.constructor.}

  proc makeFOverlapInfo(inSweepResult: var FHitResult): FOverlapInfo {.noSideEffect, constructor.}

  proc makeFOverlapInfo(inComponent: ptr UPrimitiveComponent, inBodyIndex: int32 = INDEX_NONE);

  proc getBodyIndex(): int32 {.noSideEffect.}

  proc `==`(other: FOverlapInfo): bool {.noSideEffect.}
    ## This function completely ignores SweepResult information.
    ## It seems that places that use this function do not care, but it still seems risky

  var bFromSweep: bool

  var overlapInfo: FHitResult
    ## Information for both sweep and overlap queries. Different parts are valid depending on bFromSweep.
    ## If bFromSweep is true then FHitResult is completely valid just like a regular sweep result.
    ## If bFromSweep is false only FHitResult::Component, FHitResult::Actor, FHitResult::Item are valid as this is really just an FOverlapResult