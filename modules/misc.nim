# Copyright 2016 Xored Software, Inc.

## Types that didn't fit into other interfaced modules for now

type ERHIFeatureLevel* {.header: "RHIDefinitions.h", importcpp: "ERHIFeatureLevel::Type", size: sizeof(cint), pure.} = enum
    ## The RHI's feature level indicates what level of support can be relied upon.
    ## Note: these are named after graphics API's like ES2 but a feature level can be used with a different API (eg ERHIFeatureLevel::ES2 on D3D11)
    ## As long as the graphics API supports all the features of the feature level (eg no ERHIFeatureLevel::SM5 on OpenGL ES2)
    ES2, ## Feature level defined by the core capabilities of OpenGL ES2.
    ES3_1, ## Feature level defined by the core capabilities of OpenGL ES3.1 & Metal.
    SM4, ## Feature level defined by the capabilities of DX10 Shader Model 4.
    SM5, ## Feature level defined by the capabilities of DX11 Shader Model 5.
    Num

type FGuid* {.header: "Misc/Guid.h", importcpp.} = object
  A*: uint32
  B*: uint32
  C*: uint32
  D*: uint32

type FDateTime* {.header: "Misc/DateTime.h", importcpp.} = object
type FThreadSafeCounter* {.header: "HAL/ThreadingBase.h", importcpp.} = object
type FPrimitiveSceneProxy* {.header: "PrimitiveSceneProxy.h", importcpp.} = object
type FRenderCommandFence* {.header: "RenderCommandFence.h", importcpp.} = object

type FStaticLightingPrimitiveInfo* {.header: "StaticLighting.h", importcpp.} = object
type FLightingBuildOptions* {.header: "LightingBuildOptions.h", importcpp.} = object
type FEngineShowFlags* {.header: "ShowFlags.h", importcpp.} = object
type FConvexVolume* {.header: "ConvexVolume.h", importcpp.} = object

type FNavigableGeometryExport* {.header: "AI/NavigationSystemHelpers.h", importcpp.} = object

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
