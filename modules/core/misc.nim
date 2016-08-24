# Copyright 2016 Xored Software, Inc.

## Types that didn't fit into other interfaced modules for now

proc ueCast*[T](v: ptr UObject): ptr T {.importcpp: "(Cast<'*0>(@))", nodecl.}

macro invokeSuper*(parentType: typedesc, f: untyped, params: varargs[typed]): stmt =
  if f.kind != nnkIdent:
    error("method identifier expected")
  let sym = genIdent(f)
  var callParams = ""
  for param in params:
    if callParams.len > 0:
      callParams.add(",")
    callParams.add("`" & repr(param) & "`")
  let fName = ($f).capitalize()
  result = quote do:
    {.emit: "`this`->`" & `parentType`.name & "`::" & `fName` & "(" & `callParams` & ");".}

macro invokeSuperWithResult*(resType: typedesc, parentType: typedesc, f: untyped, params: varargs[typed]): expr =
  if f.kind != nnkIdent:
    error("method identifier expected")
  let sym = genIdent(f)
  var callParams = ""
  for param in params:
    if callParams.len > 0:
      callParams.add(",")
    callParams.add("`" & repr(param) & "`")
  let fName = ($f).capitalize()
  result = quote do:
    var `sym`: `resType`
    {.emit: "`" & astToStr(`sym`) & "`" & " = `this`->`" & `parentType`.name & "`::" & `fName` & "(" & `callParams` & ");".}
    `sym`

type
  ERHIFeatureLevel* {.header: "RHIDefinitions.h", importcpp: "ERHIFeatureLevel::Type", size: sizeof(cint), pure.} = enum
    ## The RHI's feature level indicates what level of support can be relied upon.
    ## Note: these are named after graphics API's like ES2 but a feature level can be used with a different API (eg ERHIFeatureLevel::ES2 on D3D11)
    ## As long as the graphics API supports all the features of the feature level (eg no ERHIFeatureLevel::SM5 on OpenGL ES2)
    ES2, ## Feature level defined by the core capabilities of OpenGL ES2.
    ES3_1, ## Feature level defined by the core capabilities of OpenGL ES3.1 & Metal.
    SM4, ## Feature level defined by the capabilities of DX10 Shader Model 4.
    SM5, ## Feature level defined by the capabilities of DX11 Shader Model 5.
    Num

  EShaderPlatform* {.header: "RHIDefinitions.h", importcpp, size: sizeof(cint).} = enum
    SP_PCD3D_SM5 = 0,
    SP_OPENGL_SM4 = 1,
    SP_PS4 = 2,
    SP_OPENGL_PCES2 = 3, ## Used when running in Feature Level ES2 in OpenGL.
    SP_XBOXONE = 4,
    SP_PCD3D_SM4 = 5,
    SP_OPENGL_SM5 = 6,
    SP_PCD3D_ES2 = 7, ## Used when running in Feature Level ES2 in D3D11.
    SP_OPENGL_ES2_ANDROID = 8,
    SP_OPENGL_ES2_WEBGL = 9,
    SP_OPENGL_ES2_IOS = 10,
    SP_METAL = 11,
    SP_OPENGL_SM4_MAC = 12,
    SP_METAL_MRT = 13,
    SP_OPENGL_ES31_EXT = 14,
    SP_PCD3D_ES3_1 = 15, ## Used when running in Feature Level ES3_1 in D3D11.
    SP_OPENGL_PCES3_1 = 16,  ## Used when running in Feature Level ES3_1 in OpenGL.
    SP_METAL_SM5 = 17,
    SP_VULKAN_ES2 = 18,
    SP_METAL_SM4 = 19,
    SP_METAL_MACES3_1 = 20,
    SP_NumPlatforms = 21
const SP_NumBits = 5

type FGuid* {.header: "Misc/Guid.h", importcpp.} = object
  A*: uint32
  B*: uint32
  C*: uint32
  D*: uint32

type FNoncopyable* {.header: "Templates/UnrealTemplate.h", importcpp, inheritable.} = object

type FDateTime* {.header: "Misc/DateTime.h", importcpp.} = object
type FThreadSafeCounter* {.header: "HAL/ThreadingBase.h", importcpp.} = object
type FPrimitiveSceneProxy* {.header: "PrimitiveSceneProxy.h", importcpp.} = object
type FRenderCommandFence* {.header: "RenderCommandFence.h", importcpp.} = object

type FStaticLightingPrimitiveInfo* {.header: "StaticLighting.h", importcpp.} = object
type FLightingBuildOptions* {.header: "LightingBuildOptions.h", importcpp.} = object
type FEngineShowFlags* {.header: "ShowFlags.h", importcpp.} = object
type FConvexVolume* {.header: "ConvexVolume.h", importcpp.} = object

type
  FNavigableGeometryExport* {.header: "AI/NavigationSystemHelpers.h", importcpp.} = object
  FNavAvoidanceMask* {.header: "AI/Navigation/NavigationAvoidanceTypes.h", importcpp.} = object

type FSceneView* {.header: "SceneView.h", importcpp.} = object

type IBlendableInterface* {.header: "Engine/BlendableInterface.h", importcpp, inheritable.} = object
  ## Derive from this class if you want to be blended by the PostProcess blending e.g. PostprocessVolume
proc overrideBlendableSettings*(this: IBlendableInterface, view: var FSceneView, weight: cfloat) {.
    header: "Engine/BlendableInterface.h", importcpp: "OverrideBlendableSettings", noSideEffect.}
  ## @param `weight` 0..1, excluding 0, 1=fully take the values from this object, crash if outside the valid range.

type UAssetUserData {.header: "Engine/AssetUserData.h", importcpp.} = object of UObject
# proc draw(this: UAssetUserData; pdi: ptr FPrimitiveDrawInterface; view: ptr FSceneView)

proc setSuppressTransitionMessage*(viewport: ptr UGameViewportClient, bSuppress: bool) {.importcpp: "SetSuppressTransitionMessage", nodecl.}

type
  FRenderTarget* {.header: "RHI.h", importcpp.} = object
  FRHICommandListBase* {.header: "RHICommandList.h", importcpp.} = object of FNoncopyable
  FRHICommandList* {.header: "RHICommandList.h", importcpp.} = object of FRHICommandListBase
  FRHICommandListImmediate* {.header: "RHICommandList.h", importcpp.} = object of FRHICommandList

type FBatchedElements* {.header: "BatchedElements.h", importcpp.} = object

type
  HHitProxy* {.header: "HitProxies.h", importcpp.} = object
  FHitProxyId* {.header: "HitProxies.h", importcpp.} = object


wclass(FTexture of FRenderResource, header: "RenderResource.h", notypedef):
  proc getSizeX(): uint32 {.noSideEffect.}
    ## Returns the width of the texture in pixels.

  proc getSizeY(): uint32 {.noSideEffect.}
    ## Returns the height of the texture in pixels.

wclass(FHitProxyConsumer, header: "HitProxies.h", bycopy):
  method addHitProxy(hitProxy: ptr HHitProxy)
    ## Called when a new hit proxy is rendered.  The hit proxy consumer should keep a TRefCountPtr to the HitProxy to prevent it from being
    ## deleted before the rendered hit proxy map.

wclass(UGameViewportClient, header: "Engine/GameViewportClient.h", notypedef):
  proc getViewportSize(viewportSize: var FVector2D)
    ## Retrieve the size of the main viewport.
    ##
    ## @param	out_ViewportSize	[out] will be filled in with the size of the main viewport

wclass(FDebugDisplayInfo, header: "DisplayDebugHelpers.h", bycopy):
  ## Tracks what debug information we have switched on
  proc initFDebugDisplayInfo(inDisplayNames, inToggledCategories: TArray[FName]): FDebugDisplayInfo {.constructor.}

  proc isDisplayOn(displayName: FName): bool {.noSideEffect.}
  proc isCategoryToggledOn(category: FName, bDefaultsToOn: bool): bool {.noSideEffect.}
  proc numDisplayNames(): int32 {.noSideEffect.}

proc loadModulePtr*[T](moduleName: FName): ptr T {.
  importcpp: "FModuleManager::LoadModulePtr<'*0>(@)", header: "Modules/ModuleManager.h".}

# TODO
