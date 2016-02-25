# Copyright 2016 Xored Software, Inc.

type FGuid* {.header: "Misc/Guid.h", importcpp.} = object
  A*: uint32
  B*: uint32
  C*: uint32
  D*: uint32

type FDateTime* {.header: "Misc/DateTime.h", importcpp.} = object

proc ueLog*(s: wstring) {.importcpp: "UE_LOG(LogTemp, Log, @)", nodecl, varargs.}

template ueLog*(s: static[string]) =
  uelog(TEXT(s))

proc ueCast*[T](v: ptr UObject): ptr T {.importcpp: "(Cast<'*0>(@))", nodecl.}
proc ueNew*[T](): ptr T {.importcpp: "(NewObject<'*0>())", nodecl.}

type FSceneView* {.header: "SceneView.h", importcpp.} = object

type IBlendableInterface* {.header: "Engine/BlendableInterface.h", importcpp, inheritable.} = object
  ## Derive from this class if you want to be blended by the PostProcess blending e.g. PostprocessVolume
proc overrideBlendableSettings*(this: IBlendableInterface, view: var FSceneView, weight: cfloat) {.
    header: "Engine/BlendableInterface.h", importcpp: "OverrideBlendableSettings", noSideEffect.}
  ## @param `weight` 0..1, excluding 0, 1=fully take the values from this object, crash if outside the valid range.

type UAssetUserData {.header: "Engine/AssetUserData.h", importcpp.} = object of UObject
# proc draw(this: UAssetUserData; pdi: ptr FPrimitiveDrawInterface; view: ptr FSceneView)

# TODO
