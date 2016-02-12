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

class(FStreamingTexturePrimitiveInfo, header: "Components/PrimitiveComponent.h"):
  # var texture: ptr UTexture
  var bounds: FSphere
  var textelFactor: cfloat

class(FSpriteCategoryInfo, header: "Components/PrimitiveComponent.h"):
  var category: FName
  var displayName: FText
  var description: FText

class(UPrimitiveComponent of USceneComponent, header: "Components/PrimitiveComponent.h"):
  ## PrimitiveComponents are SceneComponents that contain or generate some sort of geometry, generally to be rendered or used as collision data.
  ## There are several subclasses for the various types of geometry, but the most common by far are the ShapeComponents (Capsule, Sphere, Box), StaticMeshComponent, and SkeletalMeshComponent.
  ## ShapeComponents generate geometry that is used for collision detection but are not rendered, while StaticMeshComponents and SkeletalMeshComponents contain pre-built geometry that is rendered, but can also be used for collision detection.
  var minDrawDistance: cfloat
  var ldMaxDrawDistance: cfloat
  var cachedMaxDrawDistance: cfloat

# TODO
