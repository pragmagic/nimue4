# Copyright 2016 Xored Software, Inc.

type
  ECanBeCharacterBase* {.header: "Components/PrimitiveComponent.h", importcpp: "ECanBeCharacterBase".} = enum
    ## Determines whether a Character can attempt to step up onto a component when they walk in to it.
    ECB_No,
      ## Character cannot step up onto this Component.
    ECB_Yes,
      ## Character can step up onto this Component.
    ECB_Owner,
      ## Owning actor determines whether character can step up onto this Component (default true unless overridden in code).
      ## @see AActor::CanBeBaseForCharacter()
    ECB_MAX

  EHasCustomNavigableGeometry* {.header: "Components/PrimitiveComponent.h",
                                importcpp: "EHasCustomNavigableGeometry::Type", pure.} = enum
    No,
      ## Primitive doesn't have custom navigation geometry,
      ## if collision is enabled then its convex/trimesh collision will be used for generating the navmesh
    Yes,
      ## If primitive would normally affect navmesh,
      ## DoCustomNavigableGeometryExport() should be called to export this primitive's navigable geometry
    EvenIfNotCollidable,
      ## DoCustomNavigableGeometryExport() should be called even if the mesh is non-collidable and wouldn't normally affect the navmesh
    DontExport
      ## Don't export navigable geometry even if primitive is relevant for navigation (can still add modifiers)

  FSpriteCategoryInfo* {.header: "Components/PrimitiveComponent.h", importcpp.} = object
    ## Information about the sprite category
    category* {.importcpp: "Category".}: FName
      ## Sprite category that the component belongs to
    displayName* {.importcpp: "DisplayName".}: FText
      ## Localized name of the sprite category
    description* {.importcpp: "Description".}: FText
      ## Localized description of the sprite category

  FStreamingTexturePrimitiveInfo* {.header: "Components/PrimitiveComponent.h", importcpp.} = object
    ## Information about a streaming texture that a primitive uses for rendering.
    texture* {.importcpp: "Texture".}: ptr UTexture
    bounds* {.importcpp: "Bounds".}: FSphere
    texelFactor* {.importcpp: "TexelFactor".}: cfloat

wclass(FOverlapInfo, header: "Components/SceneComponent.h", bycopy):
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

## Delegate for notification of blocking collision against a specific component.
## NormalImpulse will be filled in for physics-simulating bodies, but will be zero for swept-component blocking collisions.
declareBuiltinDelegate(FComponentHitSignature, dkDynamicMulticast, "Components/PrimitiveComponent.h",
                       otherActor: ptr AActor, otherComp: ptr UPrimitiveComponent, normalImpulse: FVector, hit: FHitResult)

## Delegate for notification of start of overlap with a specific component
declareBuiltinDelegate(FComponentBeginOverlapSignature, dkDynamicMulticast, "Components/PrimitiveComponent.h",
                       otherActor: ptr AActor, otherComp: ptr UPrimitiveComponent, otherBodyIndex: int32, bFromSweep: bool, sweepResult: FHitResult)

## Delegate for notification of end of overlap with a specific component
declareBuiltinDelegate(FComponentEndOverlapSignature, dkDynamicMulticast, "Components/PrimitiveComponent.h",
                       otherActor: ptr AActor, otherComp: ptr UPrimitiveComponent, otherBodyIndex: int32)

## Delegate for notification when a wake event is fired by physics
declareBuiltinDelegate(FComponentWakeSignature, dkDynamicMulticast, "Components/PrimitiveComponent.h",
                       boneName: FName)
## Delegate for notification when a sleep event is fired by physics
declareBuiltinDelegate(FComponentSleepSignature, dkDynamicMulticast, "Components/PrimitiveComponent.h",
                       boneName: FName)

declareBuiltinDelegate(FComponentBeginCursorOverSignature, dkDynamicMulticast, "Components/PrimitiveComponent.h",
                       touchedComponent: ptr UPrimitiveComponent)
declareBuiltinDelegate(FComponentEndCursorOverSignature, dkDynamicMulticast, "Components/PrimitiveComponent.h",
                       touchedComponent: ptr UPrimitiveComponent)
declareBuiltinDelegate(FComponentOnClickedSignature, dkDynamicMulticast, "Components/PrimitiveComponent.h",
                       touchedComponent: ptr UPrimitiveComponent)
declareBuiltinDelegate(FComponentOnReleasedSignature, dkDynamicMulticast, "Components/PrimitiveComponent.h",
                       touchedComponent: ptr UPrimitiveComponent)

declareBuiltinDelegate(FComponentOnInputTouchBeginSignature, dkDynamicMulticast, "Components/PrimitiveComponent.h",
                       fingerIndex: ETouchIndex, touchedComponent: ptr UPrimitiveComponent)
declareBuiltinDelegate(FComponentOnInputTouchEndSignature, dkDynamicMulticast, "Components/PrimitiveComponent.h",
                       fingerIndex: ETouchIndex, touchedComponent: ptr UPrimitiveComponent)
declareBuiltinDelegate(FComponentBeginTouchOverSignature, dkDynamicMulticast, "Components/PrimitiveComponent.h",
                       fingerIndex: ETouchIndex, touchedComponent: ptr UPrimitiveComponent)
declareBuiltinDelegate(FComponentEndTouchOverSignature, dkDynamicMulticast, "Components/PrimitiveComponent.h",
                       fingerIndex: ETouchIndex, touchedComponent: ptr UPrimitiveComponent)

#if WITH_EDITOR
declareBuiltinDelegate(FSelectionOverride, dkSimpleRetVal, "Components/PrimitiveComponent.h",
                       bool, comp: ptr UPrimitiveComponent)
#endif

wclass(UPrimitiveComponent of USceneComponent, header: "Components/PrimitiveComponent.h", notypedef):
  ## PrimitiveComponents are SceneComponents that contain or generate some sort of geometry, generally to be rendered or used as collision data.
  ## There are several subclasses for the various types of geometry, but the most common by far are the ShapeComponents (Capsule, Sphere, Box), StaticMeshComponent, and SkeletalMeshComponent.
  ## ShapeComponents generate geometry that is used for collision detection but are not rendered, while StaticMeshComponents and SkeletalMeshComponents contain pre-built geometry that is rendered, but can also be used for collision detection.

# public:

  var minDrawDistance: cfloat
    ## The minimum distance at which the primitive should be rendered,
    ## measured in world space units from the center of the primitive's bounding sphere to the camera position.
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=LOD)

  var LDMaxDrawDistance: cfloat
    ## Max draw distance exposed to LDs. The real max draw distance is the min (disregarding 0) of this and volumes affecting this object.
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=LOD, meta=(DisplayName="Desired Max Draw Distance") )

  var cachedMaxDrawDistance: cfloat
    ## The distance to cull this primitive at.
    ## A CachedMaxDrawDistance of 0 indicates that the primitive should not be culled by distance.
    ##
    ## UPROPERTY(Category=LOD, AdvancedDisplay, VisibleAnywhere, BlueprintReadOnly, meta=(DisplayName="Current Max Draw Distance") )

  var depthPriorityGroup: ESceneDepthPriorityGroup
    ## The scene depth priority group to draw the primitive in.
    ## UPROPERTY()

  var viewOwnerDepthPriorityGroup: ESceneDepthPriorityGroup
    ## The scene depth priority group to draw the primitive in, if it's being viewed by its owner.
    ## UPROPERTY()

  var bAlwaysCreatePhysicsState: bool
    ## Indicates if we'd like to create physics state all the time (for collision and simulation).
    ## If you set this to false, it still will create physics state if collision or simulation activated.
    ## This can help performance if you'd like to avoid overhead of creating physics state when triggers
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Collision)

  var bGenerateOverlapEvents: bool
    ## If true, this component will generate overlap events when it is overlapping other components (eg Begin Overlap).
    ## Both components (this and the other) must have this enabled for overlap events to occur.
    ##
    ## @see [Overlap Events](https://docs.unrealengine.com/latest/INT/Engine/Physics/Collision/index.html#overlapandgenerateoverlapevents)
    ## @see UpdateOverlaps(), BeginComponentOverlap(), EndComponentOverlap()
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Collision)

  var bMultiBodyOverlap: bool
    ## If true, this component will generate individual overlaps for each overlapping physics body if it is a multi-body component. When false, this component will
    ## generate only one overlap, regardless of how many physics bodies it has and how many of them are overlapping another component/body. This flag has no
    ## influence on single body components.
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadWrite, Category=Collision)

  var bCheckAsyncSceneOnMove: bool
    ## If true, this component will look for collisions on both physic scenes during movement.
    ## Only required if the asynchronous physics scene is enabled and has geometry in it, and you wish to test for collisions with objects in that scene.
    ## @see MoveComponent()
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadWrite, Category=Collision)

  var bTraceComplexOnMove: bool
    ## If true, component sweeps with this component should trace against complex collision during movement (for example, each triangle of a mesh).
    ## If false, collision will be resolved against simple collision bounds instead.
    ## @see MoveComponent()
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadWrite, Category=Collision)

  var bReturnMaterialOnMove: bool
    ## If true, component sweeps will return the material in their hit result.
    ## @see MoveComponent(), FHitResult
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadWrite, Category=Collision)

  var bUseViewOwnerDepthPriorityGroup: bool
    ## True if the primitive should be rendered using ViewOwnerDepthPriorityGroup if viewed by its owner.
    ## UPROPERTY()

  var bAllowCullDistanceVolume: bool
    ## Whether to accept cull distance volumes to modify cached cull distance.
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=LOD)

  var bHasMotionBlurVelocityMeshes: bool
    ## true if the primitive has motion blur velocity meshes
    ## UPROPERTY()

  var bRenderInMainPass: bool
    ## If true, this component will be rendered in the main pass (z prepass, basepass, transparency)
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category = Rendering)

  var bReceivesDecals: bool
    ## Whether the primitive receives decals.
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Rendering)

  var bOwnerNoSee: bool
    ## If this is True, this component won't be visible when the view actor is the component's owner, directly or indirectly.
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category = Rendering)

  var bOnlyOwnerSee: bool
    ## If this is True, this component will only be visible when the view actor is the component's owner, directly or indirectly.
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category = Rendering)

  var bTreatAsBackgroundForOcclusion: bool
    ## Treat this primitive as part of the background for occlusion purposes. This can be used as an optimization to reduce the cost of rendering skyboxes, large ground planes that are part of the vista, etc.
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Rendering)

  var bUseAsOccluder: bool
    ## Whether to render the primitive in the depth only pass.
    ## This should generally be true for all objects, and let the renderer make decisions about whether to render objects in the depth only pass.
    ## @todo - if any rendering features rely on a complete depth only pass, this variable needs to go away.
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Rendering)

  var bSelectable: bool
    ## If this is True, this component can be selected in the editor.
    ## UPROPERTY()

  var bForceMipStreaming: bool
    ## If true, forces mips for textures used by this component to be resident when this component's level is loaded.
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=TextureStreaming)

  var bHasPerInstanceHitProxies: bool
    ## If true a hit-proxy will be generated for each instance of instanced static meshes
    ## UPROPERTY()

# Lighting flags

  var castShadow: bool
    ## Controls whether the primitive component should cast a shadow or not.
    ##
    ## This flag is ignored (no shadows will be generated) if all materials on this component have an Unlit shading model.
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Lighting)

  var bAffectDynamicIndirectLighting: bool
    ## Controls whether the primitive should inject light into the Light Propagation Volume.  This flag is only used if CastShadow is true. *
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Lighting, AdvancedDisplay, meta=(EditCondition="CastShadow"))

  var bAffectDistanceFieldLighting: bool
    ## Controls whether the primitive should affect dynamic distance field lighting methods.  This flag is only used if CastShadow is true. *
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Lighting, AdvancedDisplay, meta=(EditCondition="CastShadow"))

  var bCastDynamicShadow: bool
    ## Controls whether the primitive should cast shadows in the case of non precomputed shadowing.  This flag is only used if CastShadow is true. *
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Lighting, AdvancedDisplay, meta=(EditCondition="CastShadow", DisplayName = "Dynamic Shadow"))

  var bCastStaticShadow: bool
    ## Whether the object should cast a static shadow from shadow casting lights.  This flag is only used if CastShadow is true.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Lighting, AdvancedDisplay, meta=(EditCondition="CastShadow", DisplayName = "Static Shadow"))

  var bCastVolumetricTranslucentShadow: bool
    ## Whether the object should cast a volumetric translucent shadow.
    ## Volumetric translucent shadows are useful for primitives with smoothly changing opacity like particles representing a volume,
    ## But have artifacts when used on highly opaque surfaces.
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Lighting, meta=(EditCondition="CastShadow", DisplayName = "Volumetric Translucent Shadow"))

  var bSelfShadowOnly: bool
    ## When enabled, the component will only cast a shadow on itself and not other components in the world.  This is especially useful for first person weapons, and forces bCastInsetShadow to be enabled.
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Lighting, meta=(EditCondition="CastShadow"))

  var bCastFarShadow: bool
    ## When enabled, the component will be rendering into the far shadow cascades (only for directional lights).
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Lighting, meta=(EditCondition="CastShadow", DisplayName = "Far Shadow"))

  var bCastInsetShadow: bool
    ## Whether this component should create a per-object shadow that gives higher effective shadow resolution.
    ## Useful for cinematic character shadowing. Assumed to be enabled if bSelfShadowOnly is enabled.
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Lighting, meta=(EditCondition="CastShadow", DisplayName = "Dynamic Inset Shadow"))

  var bCastCinematicShadow: bool
    ## Whether this component should cast shadows from lights that have bCastShadowsFromCinematicObjectsOnly enabled.
    ## This is useful for characters in a cinematic with special cinematic lights, where the cost of shadowmap rendering of the environment is undesired.
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Lighting, meta=(EditCondition="CastShadow"))

  var bCastHiddenShadow: bool
    ## 	If true, the primitive will cast shadows even if bHidden is true.
    ## 	Controls whether the primitive should cast shadows when hidden.
    ## 	This flag is only used if CastShadow is true.
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Lighting, meta=(EditCondition="CastShadow", DisplayName = "Hidden Shadow"))

  var bCastShadowAsTwoSided: bool
    ## Whether this primitive should cast dynamic shadows as if it were a two sided material.
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Lighting, meta=(EditCondition="CastShadow", DisplayName = "Shadow Two Sided"))

  var bLightAsIfStatic: bool
    ## Whether to light this primitive as if it were static, including generating lightmaps.
    ## This only has an effect for component types that can bake lighting, like static mesh components.
    ## This is useful for moving meshes that don't change significantly.
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Lighting)

  var bLightAttachmentsAsGroup: bool
    ## Whether to light this component and any attachments as a group.  This only has effect on the root component of an attachment tree.
    ## When enabled, attached component shadowing settings like bCastInsetShadow, bCastVolumetricTranslucentShadow, etc, will be ignored.
    ## This is useful for improving performance when multiple movable components are attached together.
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Lighting)

  var indirectLightingCacheQuality: EIndirectLightingCacheQuality
    ## Quality of indirect lighting for Movable primitives.  This has a large effect on Indirect Lighting Cache update time.
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Lighting)

  var bHasCachedStaticLighting: bool
    ## UPROPERTY()

  var bStaticLightingBuildEnqueued: bool
    ## If true, asynchronous static build lighting will be enqueued to be applied to this
    ## UPROPERTY(Transient)

  var bIgnoreRadialImpulse: bool
    ## Physics
    ## Will ignore radial impulses applied to this component.
    ## UPROPERTY()

  var bIgnoreRadialForce: bool
    ## Will ignore radial forces applied to this component.
    ## UPROPERTY()

  var alwaysLoadOnClient: bool
    ## General flags.
    ## If this is True, this component must always be loaded on clients, even if Hidden and CollisionEnabled is NoCollision.
    ## UPROPERTY()

  var alwaysLoadOnServer: bool
    ## If this is True, this component must always be loaded on servers, even if Hidden and CollisionEnabled is NoCollision
    ## UPROPERTY()

  var bUseEditorCompositing: bool
    ## Composite the drawing of this component onto the scene after post processing (only applies to editor drawing)
    ## UPROPERTY()

  var bRenderCustomDepth: bool
    ## If true, this component will be rendered in the CustomDepth pass (usually used for outlines)
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Rendering, meta=(DisplayName = "Render CustomDepth Pass"))

  var customDepthStencilValue: int32
    ## Optionally write this 0-255 value to the stencil buffer in CustomDepth pass (Requires project setting or r.CustomDepth == 3)
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Rendering,  meta=(UIMin = "0", UIMax = "255", editcondition = "bRenderCustomDepth", DisplayName = "CustomDepth Stencil Value"))

  var translucencySortPriority: int32
    ## Translucent objects with a lower sort priority draw behind objects with a higher priority.
    ## Translucent objects with the same priority are rendered from back-to-front based on their bounds origin.
    ##
    ## Ignored if the object is not translucent.  The default priority is zero.
    ## Warning: This should never be set to a non-default value unless you know what you are doing, as it will prevent the renderer from sorting correctly.
    ## It is especially problematic on dynamic gameplay effects.
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, AdvancedDisplay, Category=Rendering)

  var visibilityId: int32
    ## Used for precomputed visibility
    ## UPROPERTY()

  var componentId: FPrimitiveComponentId
    ## Used by the renderer, to identify a component across re-registers.

  var lpvBiasMultiplier: cfloat
    ## Multiplier used to scale the Light Propagation Volume light injection bias, to reduce light bleeding.
    ## Set to 0 for no bias, 1 for default or higher for increased biasing (e.g. for
    ## thin geometry such as walls)
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, AdvancedDisplay, Category=Rendering, meta=(UIMin = "0.0", UIMax = "3.0"))

  var bodyInstance: FBodyInstance
    ## Internal physics engine data.
    ## Physics scene information for this component, holds a single rigid body with multiple shapes.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Collision, meta=(ShowOnlyInnerProperties))

  var bCanEverAffectNavigation: bool
    ## Whether this component can potentially influence navigation
    ## UPROPERTY(EditAnywhere, Category=Collision, AdvancedDisplay)

  var bNavigationRelevant: bool
    ## Cached navigation relevancy flag for collision updates

# protected:

  proc updateNavigationData()

  proc areAllCollideableDescendantsRelative(bAllowCachedValue: bool = true): bool {.
      noSideEffect.}
    ## Returns true if all descendant components that we can possibly overlap with use relative location and rotation.

  var bCachedAllCollideableDescendantsRelative: bool
    ## Result of last call to AreAllCollideableDescendantsRelative().

  var lastCheckedAllCollideableDescendantsTime: cfloat
    ## Last time we checked AreAllCollideableDescendantsRelative(), so we can throttle those tests since it rarely changes once false.

  var bHasCustomNavigableGeometry: EHasCustomNavigableGeometry
    ## If true then DoCustomNavigableGeometryExport will be called to collect navigable geometry of this component.
    ## UPROPERTY()

  var nextComponentId: FThreadSafeCounter
    ## Next id to be used by a component.

# public:

  var boundsScale: cfloat
    ## Scales the bounds of the object.
    ## This is useful when using World Position Offset to animate the vertices of the object outside of its bounds.
    ## Warning: Increasing the bounds of an object will reduce performance and shadow quality!
    ## Currently only used by StaticMeshComponent and SkeletalMeshComponent.
    ##
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, Category=Rendering, meta=(UIMin = "1", UIMax = "10.0"))

  var lastSubmitTime: cfloat
    ## Last time the component was submitted for rendering (called FScene::AddPrimitive).
    ## UPROPERTY(transient)

  var lastRenderTime: cfloat
    ## The value of WorldSettings->TimeSeconds for the frame when this component was last rendered.  This is written
    ## from the render thread, which is up to a frame behind the game thread, so you should allow this time to
    ## be at least a frame behind the game thread's world time before you consider the actor non-visible.
    ##
    ## UPROPERTY(transient)

  var canCharacterStepUpOn: ECanBeCharacterBase
    ## Determine whether a Character can step up onto this component.
    ## This controls whether they can try to step up on it when they bump in to it, not whether they can walk on it after landing on it.
    ## @see FWalkableSlopeOverride
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Collision)

  var moveIgnoreActors: TArray[TWeakObjectPtr[AActor]]
    ## Set of actors to ignore during component sweeps in MoveComponent().
    ## All components owned by these actors will be ignored when this component moves or updates overlaps.
    ## Components on the other Actor may also need to be told to do the same when they move.
    ## Does not affect movement of this component when simulating physics.
    ## @see IgnoreActorWhenMoving()

  proc ignoreActorWhenMoving(actor: ptr AActor; bShouldIgnore: bool)
    ## Tells this component whether to ignore collision with all components of a specific Actor when this component is moved.
    ## Components on the other Actor may also need to be told to do the same when they move.
    ## Does not affect movement of this component when simulating physics.
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Collision", meta=(Keywords="Move MoveIgnore"))

  proc copyArrayOfMoveIgnoreActors(): TArray[ptr AActor]
    ## Returns the list of actors we currently ignore when moving.
    ##
    ## UFUNCTION(BlueprintCallable, meta=(DisplayName="GetMoveIgnoreActors"), Category = "Collision")

  proc getMoveIgnoreActors(): var TArray[TWeakObjectPtr[AActor]]
    ## Returns the list of actors (as WeakObjectPtr) we currently ignore when moving.

  proc clearMoveIgnoreActors()
    ## Clear the list of actors we ignore when moving.
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Collision")

#if WITH_EDITOR
  var selectionOverrideDelegate: FSelectionOverride
    ## Override delegate used for checking the selection state of a component
#endif

# protected:
  var overlappingComponents: TArray[FOverlapInfo]
    ## Set of components that this component is currently overlapping.

# public:

  proc beginComponentOverlap(otherOverlap: FOverlapInfo; bDoNotifies: bool)
    ## Begin tracking an overlap interaction with the component specified.
    ## @param OtherComp - The component of the other actor that this component is now overlapping
    ## @param bDoNotifies - True to dispatch appropriate begin/end overlap notifications when these events occur.
    ## @see [Overlap
    ## Events](https://docs.unrealengine.com/latest/INT/Engine/Physics/Collision/index.html#overlapandgenerateoverlapevents)

  proc endComponentOverlap(otherOverlap: FOverlapInfo; bDoNotifies: bool = true;
                          bNoNotifySelf: bool = false)
    ## Finish tracking an overlap interaction that is no longer occurring between this component and the component specified.
    ## @param OtherComp - The component of the other actor to stop overlapping
    ## @param bDoNotifies - True to dispatch appropriate begin/end overlap notifications when these events occur.
    ## @param bNoNotifySelf	- True to skip end overlap notifications to this component's.  Does not affect notifications to OtherComp's actor.
    ## @see [Overlap Events](https://docs.unrealengine.com/latest/INT/Engine/Physics/Collision/index.html#overlapandgenerateoverlapevents)

  proc isOverlappingComponent(otherComp: ptr UPrimitiveComponent): bool {.noSideEffect.}
    ## Check whether this component is overlapping another component.
    ## @param OtherComp Component to test this component against.
    ## @return Whether this component is overlapping another component.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Collision", meta=(UnsafeDuringActorConstruction="true"))

  proc isOverlappingComponent(overlap: FOverlapInfo): bool {.noSideEffect.}
    ## Check whether this component has the specified overlap.

  proc isOverlappingActor(other: ptr AActor): bool {.noSideEffect.}
    ## Check whether this component is overlapping any component of the given Actor.
    ## @param Other Actor to test this component against.
    ## @return Whether this component is overlapping any component of the given Actor.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Collision", meta=(UnsafeDuringActorConstruction="true"))

  proc getOverlapsWithActor(actor: ptr AActor; outOverlaps: var TArray[FOverlapInfo]): bool {.
      noSideEffect.}
    ## Appends list of overlaps with components owned by the given actor to the 'OutOverlaps' array.
    ## Returns true if any overlaps were added.

  proc getOverlappingActors(overlappingActors: var TArray[ptr AActor];
                          classFilter: ptr UClass = nil) {.noSideEffect.}
    ## Returns a list of actors that this component is overlapping.
    ## @param OverlappingActors		[out] Returned list of overlapping actors
    ## @param ClassFilter			[optional] If set, only returns actors of this class or subclasses
    ##
    ## UFUNCTION(BlueprintCallable, Category="Collision", meta=(UnsafeDuringActorConstruction="true"))

  proc getOverlappingComponents(inOverlappingComponents: var TArray[
      ptr UPrimitiveComponent]) {.noSideEffect.}
    ## Returns list of components this component is overlapping.
    ## UFUNCTION(BlueprintCallable, Category="Collision", meta=(UnsafeDuringActorConstruction="true"))

  proc getOverlapInfos(): var TArray[FOverlapInfo] {.noSideEffect.}
    ## Returns list of components this component is overlapping.
    ## UFUNCTION(BlueprintCallable, Category="Collision")

  proc updateOverlaps(newPendingOverlaps: ptr TArray[FOverlapInfo] = nil;
                    bDoNotifies: bool = true;
                    overlapsAtEndLocation: ptr TArray[FOverlapInfo] = nil)
    ## Queries world and updates overlap tracking state for this component.
    ## @param NewPendingOverlaps		An ordered list of components that the MovedComponent overlapped during its movement (eg. generated during a sweep). Only used to add potentially new overlaps.
    ## 									Might not be overlapping them now.
    ## @param bDoNotifies				True to dispatch being/end overlap notifications when these events occur.
    ## @param OverlapsAtEndLocation		If non-null, the given list of overlaps will be used as the overlaps for this component at the current location, rather than checking for them with a scene query.
    ## 									Generally this should only be used if this component is the RootComponent of the owning actor and overlaps with other descendant components have been verified.

  proc updatePhysicsVolume(bTriggerNotifiers: bool)
    ## Update current physics volume for this component, if bShouldUpdatePhysicsVolume is true. Overridden to use the overlaps to find the physics volume.

  proc componentOverlapMulti(outOverlaps: var TArray[FOverlapResult];
                            inWorld: ptr UWorld; pos: FVector; rot: FQuat;
                            testChannel: ECollisionChannel;
                            params: FComponentQueryParams; objectQueryParams: FCollisionObjectQueryParams = defaultObjectQueryParam): bool {.
      noSideEffect.}
    ## Test the collision of the supplied component at the supplied location/rotation, and determine the set of components that it overlaps.
    ## @note This overload taking rotation as a FQuat is slightly faster than the version using FRotator.
    ## @note This simply calls the virtual ComponentOverlapMultiImpl() which can be overridden to implement custom behavior.
    ## @param  OutOverlaps     Array of overlaps found between this component in specified pose and the world
    ## @param  World			World to use for overlap test
    ## @param  Pos             Location of component's geometry for the test against the world
    ## @param  Rot             Rotation of component's geometry for the test against the world
    ## @param  TestChannel		The 'channel' that this ray is in, used to determine which components to hit
    ## @param	ObjectQueryParams	List of object types it's looking for. When this enters, we do object query with component shape
    ## @return true if OutOverlaps contains any blocking results
  proc componentOverlapMulti(outOverlaps: var TArray[FOverlapResult];
                            inWorld: ptr UWorld; pos: FVector; rot: FRotator;
                            testChannel: ECollisionChannel;
                            params: FComponentQueryParams; objectQueryParams: FCollisionObjectQueryParams = defaultObjectQueryParam): bool {.
      noSideEffect.}

# protected:

  proc componentOverlapMultiImpl(outOverlaps: var TArray[FOverlapResult];
                                inWorld: ptr UWorld; pos: FVector; rot: FQuat;
                                testChannel: ECollisionChannel;
                                params: FComponentQueryParams; objectQueryParams: FCollisionObjectQueryParams = defaultObjectQueryParam): bool {.
      noSideEffect.}
    ## Override this method for custom behavior.

# public:

  var onComponentHit: FComponentHitSignature
    ## 	Event called when a component hits (or is hit by) something solid. This could happen due to things like Character movement, using Set Location with 'sweep' enabled, or physics simulation.
    ## 	For events when objects overlap (e.g. walking into a trigger) see the 'Overlap' event.
    ##
    ## 	@note For collisions during physics simulation to generate hit events, 'Simulation Generates Hit Events' must be enabled for this component.
    ## 	@note When receiving a hit from another object's movement, the directions of 'Hit.Normal' and 'Hit.ImpactNormal'
    ## 	will be adjusted to indicate force from the other object against this object.
    ##
    ## UPROPERTY(BlueprintAssignable, Category="Collision")

  var onComponentBeginOverlap: FComponentBeginOverlapSignature
    ## 	Event called when something starts to overlaps this component, for example a player walking into a trigger.
    ## 	For events when objects have a blocking collision, for example a player hitting a wall, see 'Hit' events.
    ##
    ## 	@note Both this component and the other one must have bGenerateOverlapEvents set to true to generate overlap events.
    ## 	@note When receiving an overlap from another object's movement, the directions of 'Hit.Normal' and 'Hit.ImpactNormal'
    ## 	will be adjusted to indicate force from the other object against this object.
    ##
    ## UPROPERTY(BlueprintAssignable, Category="Collision")

  var onComponentEndOverlap: FComponentEndOverlapSignature
    ## 	Event called when something stops overlapping this component
    ## 	@note Both this component and the other one must have bGenerateOverlapEvents set to true to generate overlap events.
    ##
    ## UPROPERTY(BlueprintAssignable, Category="Collision")

  var onComponentWake: FComponentWakeSignature
    ## 	Event called when the underlying physics objects is woken up
    ##
    ## UPROPERTY(BlueprintAssignable, Category="Collision")

  var onComponentSleep: FComponentSleepSignature
    ## 	Event called when the underlying physics objects is put to sleep
    ##
    ## UPROPERTY(BlueprintAssignable, Category = "Collision")

  var onBeginCursorOver: FComponentBeginCursorOverSignature
    ## Event called when the mouse cursor is moved over this component and mouse over events are enabled in the player controller
    ## UPROPERTY(BlueprintAssignable, Category="Input|Mouse Input")

  var onEndCursorOver: FComponentEndCursorOverSignature
    ## Event called when the mouse cursor is moved off this component and mouse over events are enabled in the player controller
    ## UPROPERTY(BlueprintAssignable, Category="Input|Mouse Input")

  var onClicked: FComponentOnClickedSignature
    ## Event called when the left mouse button is clicked while the mouse is over this component and click events are enabled in the player controller
    ## UPROPERTY(BlueprintAssignable, Category="Input|Mouse Input")

  var onReleased: FComponentOnReleasedSignature
    ## Event called when the left mouse button is released while the mouse is over this component click events are enabled in the player controller
    ## UPROPERTY(BlueprintAssignable, Category="Input|Mouse Input")

  var onInputTouchBegin: FComponentOnInputTouchBeginSignature
    ## Event called when a touch input is received over this component when touch events are enabled in the player controller
    ## UPROPERTY(BlueprintAssignable, Category="Input|Touch Input")

  var onInputTouchEnd: FComponentOnInputTouchEndSignature
    ## Event called when a touch input is released over this component when touch events are enabled in the player controller
    ## UPROPERTY(BlueprintAssignable, Category="Input|Touch Input")

  var onInputTouchEnter: FComponentBeginTouchOverSignature
    ## Event called when a finger is moved over this component when touch over events are enabled in the player controller
    ## UPROPERTY(BlueprintAssignable, Category="Input|Touch Input")

  var onInputTouchLeave: FComponentEndTouchOverSignature
    ## Event called when a finger is moved off this component when touch over events are enabled in the player controller
    ## UPROPERTY(BlueprintAssignable, Category="Input|Touch Input")

  proc getMaterial(elementIndex: int32): ptr UMaterialInterface {.noSideEffect.}
    ## Returns the material used by the element at the specified index
    ## @param ElementIndex - The element to access the material of.
    ## @return the material used by the indexed element of this mesh.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Material")

  proc setMaterial(elementIndex: int32; material: ptr UMaterialInterface)
    ## Changes the material applied to an element of the mesh.
    ## @param ElementIndex - The element to access the material of.
    ## @return the material used by the indexed element of this mesh.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Material")

  proc createDynamicMaterialInstance(elementIndex: int32;
                                     sourceMaterial: ptr UMaterialInterface = nil): ptr UMaterialInstanceDynamic
    ## Creates a Dynamic Material Instance for the specified element index, optionally from the supplied material.
    ## @param ElementIndex - The index of the skin to replace the material for.  If invalid, the material is unchanged and NULL is returned.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Material")

  proc getWalkableSlopeOverride(): var FWalkableSlopeOverride {.noSideEffect.}
    ## Returns the slope override struct for this component.
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc setWalkableSlopeOverride(newOverride: FWalkableSlopeOverride)
    ## Sets a new slope override for this component instance.
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc setSimulatePhysics(bSimulate: bool)
    ## 	Sets whether or not a single body should use physics simulation, or should be 'fixed' (kinematic).
    ##
    ## 	@param	bSimulate	New simulation state for single body
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc canEditSimulatePhysics(): bool
    ## Determines whether or not the simulate physics setting can be edited interactively on this component

  proc setConstraintMode(constraintMode: EDOFMode)
    ## Sets the constraint mode of the component.
    ## @param ConstraintMode	The type of constraint to use.
    ##
    ## UFUNCTION(BlueprintCallable, meta = (DisplayName = "Set Constraint Mode", Keywords = "set locked axis constraint physics"), Category = Physics)

  proc addImpulse(impulse: FVector; boneName: FName = NAME_None; bVelChange: bool = false)
    ## 	Add an impulse to a single rigid body. Good for one time instant burst.
    ##
    ## 	@param	Impulse		Magnitude and direction of impulse to apply.
    ## 	@param	BoneName	If a SkeletalMeshComponent, name of body to apply impulse to. 'None' indicates root body.
    ## 	@param	bVelChange	If true, the Strength is taken as a change in velocity instead of an impulse (ie. mass will have no affect).
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc addAngularImpulse(impulse: FVector; boneName: FName = NAME_None;
                        bVelChange: bool = false)
    ## 	Add an angular impulse to a single rigid body. Good for one time instant burst.
    ##
    ## 	@param	AngularImpulse	Magnitude and direction of impulse to apply. Direction is axis of rotation.
    ## 	@param	BoneName	If a SkeletalMeshComponent, name of body to apply angular impulse to. 'None' indicates root body.
    ## 	@param	bVelChange	If true, the Strength is taken as a change in angular velocity instead of an impulse (ie. mass will have no affect).
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Physics")

  proc addImpulseAtLocation(impulse: FVector; location: FVector;
                          boneName: FName = NAME_None)
    ## 	Add an impulse to a single rigid body at a specific location.
    ##
    ## 	@param	Impulse		Magnitude and direction of impulse to apply.
    ## 	@param	Location	Point in world space to apply impulse at.
    ## 	@param	BoneName	If a SkeletalMeshComponent, name of bone to apply impulse to. 'None' indicates root body.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc addRadialImpulse(origin: FVector; radius: cfloat; strength: cfloat;
                      falloff: ERadialImpulseFalloff; bVelChange: bool = false)
    ## Add an impulse to all rigid bodies in this component, radiating out from the specified position.
    ##
    ## @param Origin		Point of origin for the radial impulse blast, in world space
    ## @param Radius		Size of radial impulse. Beyond this distance from Origin, there will be no affect.
    ## @param Strength		Maximum strength of impulse applied to body.
    ## @param Falloff		Allows you to control the strength of the impulse as a function of distance from Origin.
    ## @param bVelChange	If true, the Strength is taken as a change in velocity instead of an impulse (ie. mass will have no affect).
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc addForce(force: FVector; boneName: FName = NAME_None; bAccelChange: bool = false)
    ## 	Add a force to a single rigid body.
    ## This is like a 'thruster'. Good for adding a burst over some (non zero) time. Should be called every frame for the duration of the force.
    ##
    ## 	@param	Force		 Force vector to apply. Magnitude indicates strength of force.
    ## 	@param	BoneName	 If a SkeletalMeshComponent, name of body to apply force to. 'None' indicates root body.
    ## @param  bAccelChange If true, Force is taken as a change in acceleration instead of a physical force (i.e. mass will have no affect).
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc addForceAtLocation(force: FVector; location: FVector;
                        boneName: FName = NAME_None)
    ## 	Add a force to a single rigid body at a particular location.
    ## This is like a 'thruster'. Good for adding a burst over some (non zero) time. Should be called every frame for the duration of the force.
    ##
    ## 	@param Force		Force vector to apply. Magnitude indicates strength of force.
    ## 	@param Location		Location to apply force, in world space.
    ## 	@param BoneName		If a SkeletalMeshComponent, name of body to apply force to. 'None' indicates root body.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc addRadialForce(origin: FVector; radius: cfloat; strength: cfloat;
                    falloff: ERadialImpulseFalloff; bAccelChange: bool = false)
    ## 	Add a force to all bodies in this component, originating from the supplied world-space location.
    ##
    ## 	@param Origin		Origin of force in world space.
    ## 	@param Radius		Radius within which to apply the force.
    ## 	@param Strength		Strength of force to apply.
    ## @param Falloff		Allows you to control the strength of the force as a function of distance from Origin.
    ## @param bAccelChange If true, Strength is taken as a change in acceleration instead of a physical force (i.e. mass will have no affect).
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc addTorque(torque: FVector; boneName: FName = NAME_None; bAccelChange: bool = false)
    ## 	Add a torque to a single rigid body.
    ## 	@param Torque		Torque to apply. Direction is axis of rotation and magnitude is strength of torque.
    ## 	@param BoneName		If a SkeletalMeshComponent, name of body to apply torque to. 'None' indicates root body.
    ## @param bAccelChange If true, Torque is taken as a change in angular acceleration instead of a physical torque (i.e. mass will have no affect).
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc setPhysicsLinearVelocity(newVel: FVector; bAddToCurrent: bool = false;
                              boneName: FName = NAME_None)
    ## 	Set the linear velocity of a single body.
    ## 	This should be used cautiously - it may be better to use AddForce or AddImpulse.
    ##
    ## 	@param NewVel			New linear velocity to apply to physics.
    ## 	@param bAddToCurrent	If true, NewVel is added to the existing velocity of the body.
    ## 	@param BoneName			If a SkeletalMeshComponent, name of body to modify velocity of. 'None' indicates root body.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc getPhysicsLinearVelocity(boneName: FName = NAME_None): FVector
    ## 	Get the linear velocity of a single body.
    ## 	@param BoneName			If a SkeletalMeshComponent, name of body to get velocity of. 'None' indicates root body.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc getPhysicsLinearVelocityAtPoint(point: FVector; boneName: FName = NAME_None): FVector
    ## 	Get the linear velocity of a point on a single body.
    ## 	@param Point			Point is specified in world space.
    ## 	@param BoneName			If a SkeletalMeshComponent, name of body to get velocity of. 'None' indicates root body.
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Physics")

  proc setAllPhysicsLinearVelocity(newVel: FVector; bAddToCurrent: bool = false)
    ## 	Set the linear velocity of all bodies in this component.
    ##
    ## 	@param NewVel			New linear velocity to apply to physics.
    ## 	@param bAddToCurrent	If true, NewVel is added to the existing velocity of the body.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc setPhysicsAngularVelocity(newAngVel: FVector; bAddToCurrent: bool = false;
                                boneName: FName = NAME_None)
    ## 	Set the angular velocity of a single body.
    ## 	This should be used cautiously - it may be better to use AddTorque or AddImpulse.
    ##
    ## 	@param NewAngVel		New angular velocity to apply to body, in degrees per second.
    ## 	@param bAddToCurrent	If true, NewAngVel is added to the existing angular velocity of the body.
    ## 	@param BoneName			If a SkeletalMeshComponent, name of body to modify angular velocity of. 'None' indicates root body.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc setPhysicsMaxAngularVelocity(newMaxAngVel: cfloat;
                                  bAddToCurrent: bool = false;
                                  boneName: FName = NAME_None)
    ## 	Set the maximum angular velocity of a single body.
    ##
    ## 	@param NewMaxAngVel		New maximum angular velocity to apply to body, in degrees per second.
    ## 	@param bAddToCurrent	If true, NewMaxAngVel is added to the existing maximum angular velocity of the body.
    ## 	@param BoneName			If a SkeletalMeshComponent, name of body to modify maximum angular velocity of. 'None' indicates root body.
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Physics")

  proc getPhysicsAngularVelocity(boneName: FName = NAME_None): FVector
    ## 	Get the angular velocity of a single body, in degrees per second.
    ## 	@param BoneName			If a SkeletalMeshComponent, name of body to get velocity of. 'None' indicates root body.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc getCenterOfMass(boneName: FName = NAME_None): FVector
    ## 	Get the center of mass of a single body. In the case of a welded body this will return the center of mass of the entire welded body (including its parent and children)
    ## Objects that are not simulated return (0,0,0) as they do not have COM
    ## 	@param BoneName			If a SkeletalMeshComponent, name of body to get center of mass of. 'None' indicates root body.
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Physics")

  proc setCenterOfMass(centerOfMassOffset: FVector; boneName: FName = NAME_None)
    ## 	Set the center of mass of a single body. This will offset the physx-calculated center of mass.
    ## 	Note that in the case where multiple bodies are attached together, the center of mass will be set for the entire group.
    ## 	@param CenterOfMassOffset		User specified offset for the center of mass of this object, from the calculated location.
    ## 	@param BoneName			If a SkeletalMeshComponent, name of body to set center of mass of. 'None' indicates root body.
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Physics")

  proc wakeRigidBody(boneName: FName = NAME_None)
    ## 	'Wake' physics simulation for a single body.
    ## 	@param	BoneName	If a SkeletalMeshComponent, name of body to wake. 'None' indicates root body.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc putRigidBodyToSleep(boneName: FName = NAME_None)
    ## 	Force a single body back to sleep.
    ## 	@param	BoneName	If a SkeletalMeshComponent, name of body to put to sleep. 'None' indicates root body.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc setNotifyRigidBodyCollision(bNewNotifyRigidBodyCollision: bool)
    ## Changes the value of bNotifyRigidBodyCollision
    ## @param bNewNotifyRigidBodyCollision - The value to assign to bNotifyRigidBodyCollision
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc setOwnerNoSee(bNewOwnerNoSee: bool)
    ## Changes the value of bOwnerNoSee.
    ## UFUNCTION(BlueprintCallable, Category="Rendering")

  proc setOnlyOwnerSee(bNewOnlyOwnerSee: bool)
    ## Changes the value of bOnlyOwnerSee.
    ## UFUNCTION(BlueprintCallable, Category="Rendering")

  proc setCastShadow(newCastShadow: bool)
    ## Changes the value of CastShadow.
    ## UFUNCTION(BlueprintCallable, Category="Rendering")

  proc setTranslucentSortPriority(newTranslucentSortPriority: int32)
    ## Changes the value of TranslucentSortPriority.
    ## UFUNCTION(BlueprintCallable, Category="Rendering")

  proc setCollisionEnabled(newType: ECollisionEnabled)
    ## Controls what kind of collision is enabled for this body
    ## UFUNCTION(BlueprintCallable, Category="Collision")

  proc setCollisionProfileName(inCollisionProfileName: FName)
    ## Set Collision Profile Name
    ## This function is called by constructors when they set ProfileName
    ## This will change current CollisionProfileName to be this, and overwrite Collision Setting
    ##
    ## @param InCollisionProfileName : New Profile Name
    ##
    ## UFUNCTION(BlueprintCallable, Category="Collision")

  proc getCollisionProfileName(): FName
    ## Get the collision profile name
    ## UFUNCTION(BlueprintCallable, Category="Collision")

  proc setCollisionObjectType(channel: ECollisionChannel)
    ## 	Changes the collision channel that this object uses when it moves
    ## 	@param      Channel     The new channel for this component to use
    ##
    ## UFUNCTION(BlueprintCallable, Category="Collision")

  proc k2_LineTraceComponent(traceStart: FVector; traceEnd: FVector;
                            bTraceComplex: bool; bShowTrace: bool;
                            hitLocation: var FVector; hitNormal: var FVector;
                            boneName: var FName): bool
    ## Perform a line trace against a single component
    ## UFUNCTION(BlueprintCallable, Category="Collision", meta=(DisplayName = "Line Trace Component", bTraceComplex="true"))

  proc setRenderCustomDepth(bValue: bool)
    ## Sets the bRenderCustomDepth property and marks the render state dirty.
    ## UFUNCTION(BlueprintCallable, Category="Rendering")

  proc setCustomDepthStencilValue(value: int32)
    ## Sets the CustomDepth stencil value (0 - 255) and marks the render state dirty.
    ## UFUNCTION(BlueprintCallable, Category = "Rendering", meta=(UIMin = "0", UIMax = "255"))

  proc setRenderInMainPass(bValue: bool)
    ## Sets bRenderInMainPass property and marks the render state dirty.
    ## UFUNCTION(BlueprintCallable, Category = "Rendering")

# public:

  var currentTag: int32

  var sceneProxy: ptr FPrimitiveSceneProxy
    ## The primitive's scene info.

  var detachFence: FRenderCommandFence
    ## A fence to track when the primitive is detached from the scene in the rendering thread.

  var attachmentCounter: FThreadSafeCounter
    ## Incremented by the main thread before being attached to the scene, decremented
    ## by the rendering thread after removal. This counter exists to assert that
    ## operations are safe in order to help avoid race conditions.
    ##
    ##          *** Runtime logic should NEVER rely on this value. ***
    ##
    ## The only safe assertions to make are:
    ##
    ##    AttachmentCounter == 0: The primitive is not exposed to the rendering
    ##                            thread, it is safe to modify shared members.
    ##                            This assertion is valid ONLY from the main thread.
    ##
    ##    AttachmentCounter >= 1: The primitive IS exposed to the rendering
    ##                            thread and therefore shared members must not
    ##                            be modified. This assertion may be made from
    ##                            any thread. Note that it is valid and expected
    ##                            for AttachmentCounter to be larger than 1, e.g.
    ##                            during reattachment.

# Scene data
# public:

  proc setLODParentPrimitive(inLODParentPrimitive: ptr UPrimitiveComponent)
  proc getLODParentPrimitive(): ptr UPrimitiveComponent

#if WITH_EDITOR:
  proc getNumUncachedStaticLightingInteractions(): int32 {.noSideEffect.}
  ## recursive function
  ## This function is used to create hierarchical LOD for the level. You can decide to opt out if you don't want.
  proc shouldGenerateAutoLOD(): bool {.noSideEffect.}
#endf

  proc shouldRenderSelected(): bool {.noSideEffect.}
    ## @return true if the owner is selected and this component is selectable

  proc isComponentIndividuallySelected(): bool {.noSideEffect.}
    ## Component is directly selected in the editor separate from its parent actor

  proc hasStaticLighting(): bool {.noSideEffect.}
    ## @return True if a primitive's parameters as well as its position is static during gameplay, and can thus use static lighting.
  proc hasValidSettingsForStaticLighting(): bool {.noSideEffect.}

  proc usesOnlyUnlitMaterials(): bool {.noSideEffect.}
    ## @return true if only unlit materials are used for rendering, false otherwise.

  proc getLightMapResolution(width: var int32; height: var int32): bool {.noSideEffect.}
    ## Returns the lightmap resolution used for this primitive instance in the case of it supporting texture light/ shadow maps.
    ## 0 if not supported or no static shadowing.
    ##
    ## @param	Width	[out]	Width of light/shadow map
    ## @param	Height	[out]	Height of light/shadow map
    ## @return	bool			true if LightMap values are padded, false if not

  proc getStaticLightMapResolution(): int32 {.noSideEffect.}
    ## 	Returns the static lightmap resolution used for this primitive.
    ## 	0 if not supported or no static shadowing.
    ##
    ## @return	int32		The StaticLightmapResolution for the component

  proc getLightAndShadowMapMemoryUsage(lightMapMemoryUsage: var int32;
                                      shadowMapMemoryUsage: var int32) {.noSideEffect.}
    ## Returns the light and shadow map memory for this primitive in its out variables.
    ##
    ## Shadow map memory usage is per light whereof lightmap data is independent of number of lights, assuming at least one.
    ##
    ## @param [out] LightMapMemoryUsage		Memory usage in bytes for light map (either texel or vertex) data
    ## @param [out]	ShadowMapMemoryUsage	Memory usage in bytes for shadow map (either texel or vertex) data

#if WITH_EDITOR:
  proc getStaticLightingInfo(outPrimitiveInfo: var FStaticLightingPrimitiveInfo;
                            inRelevantLights: TArray[ptr ULightComponent];
                            options: FLightingBuildOptions)
    ## Requests the information about the component that the static lighting system needs.
    ## @param OutPrimitiveInfo - Upon return, contains the component's static lighting information.
    ## @param InRelevantLights - The lights relevant to the primitive.
    ## @param InOptions - The options for the static lighting build.
#endif

  proc getStaticLightingType(): ELightMapInteractionType {.noSideEffect.}
    ## 	Requests whether the component will use texture, vertex or no lightmaps.
    ##
    ## 	@return	ELightMapInteractionType		The type of lightmap interaction the component will use.

  proc getStreamingTextureInfo(outStreamingTextures: var TArray[
      FStreamingTexturePrimitiveInfo]) {.noSideEffect.}
    ## Enumerates the streaming textures used by the primitive.
    ## @param OutStreamingTextures - Upon return, contains a list of the streaming textures used by the primitive.

  proc getStreamingTextureInfoWithNULLRemoval(
      outStreamingTextures: var TArray[FStreamingTexturePrimitiveInfo]) {.
      noSideEffect.}
    ## Call GetStreamingTextureInfo and remove the elements with a NULL texture
    ## @param OutStreamingTextures - Upon return, contains a list of the non-null streaming textures used by the primitive.

  proc getStaticDepthPriorityGroup(): uint8 {.noSideEffect.}
    ## Determines the DPG the primitive's primary elements are drawn in.
    ## Even if the primitive's elements are drawn in multiple DPGs, a primary DPG is needed for occlusion culling and shadow projection.
    ## @return The DPG the primitive's primary elements will be drawn in.

  proc getUsedMaterials(outMaterials: var TArray[ptr UMaterialInterface]) {.
      noSideEffect.}
    ## Retrieves the materials used in this component
    ##
    ## @param OutMaterials	The list of used materials.

  proc getUsedTextures(outTextures: var TArray[ptr UTexture]; qualityLevel: EMaterialQualityLevel)
    ## Returns the material textures used to render this primitive for the given platform.
    ## Internally calls GetUsedMaterials() and GetUsedTextures() for each material.
    ##
    ## @param OutTextures	[out] The list of used textures.

  var postPhysicsComponentTick: FPrimitiveComponentPostPhysicsTickFunction
    ## Tick function for physics ticking
    ## UPROPERTY()

  proc setPostPhysicsComponentTickEnabled(bEnable: bool)
    ## Controls if we get a post physics tick or not. If set during ticking, will take effect next frame

  proc isPostPhysicsComponentTickEnabled(): bool {.noSideEffect.}
    ## Returns whether we have the post physics tick enabled

  proc postPhysicsTick(thisTickFunction: var FPrimitiveComponentPostPhysicsTickFunction)
    ## Tick function called after physics (sync scene) has finished simulation

  proc getBodySetup(): ptr UBodySetup
    ## Return the BodySetup to use for this PrimitiveComponent (single body case)

  proc syncComponentToRBPhysics()
    ## Move this component to match the physics rigid body pose. Note, a warning will be generated if you call this function on a component that is attached to something

  proc getRenderMatrix(): FMatrix {.noSideEffect.}
    ## 	Returns the matrix that should be used to render this component.
    ## 	Allows component class to perform graphical distortion to the component not supported by an FTransform

  proc getNumMaterials(): int32 {.noSideEffect.}
    ## @return number of material elements in this primitive
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Material")

  proc getBodyInstance(boneName: FName = NAME_None; bGetWelded: bool = true): ptr FBodyInstance {.
      noSideEffect.}
    ## Get a BodyInstance from this component. The supplied name is used in the SkeletalMeshComponent case. A name of NAME_None in the skeletal case gives the root body instance.
    ##
    ## returns BodyInstance of the component.
    ##
    ## @param BoneName				Used to get body associated with specific bone. NAME_None automatically gets the root most body
    ## @param bGetWelded				If the component has been welded to another component and bGetWelded is true we return the single welded BodyInstance that is used in the simulation
    ##
    ## @return		Returns the BodyInstance based on various states (does component have multiple bodies? Is the body welded to another body?)

  proc getDistanceToCollision(point: FVector; closestPointOnCollision: var FVector): cfloat {.
      noSideEffect.}
    ## returns Distance to closest Body Instance surface.
    ##
    ## @param Point				World 3D vector
    ## @param OutPointOnBody	Point on the surface of collision closest to Point
    ##
    ## @return		Success if returns > 0.f, if returns 0.f, it is either not convex or inside of the point
    ## 				If returns < 0.f, this primitive does not have collsion

  proc getClosestPointOnCollision(point: FVector; outPointOnBody: var FVector;
                                boneName: FName = NAME_None): cfloat {.noSideEffect.}
    ## Returns the distance and closest point to the collision surface.
    ## Component must have simple collision to be queried for closest point.
    ##
    ## @param Point				World 3D vector
    ## @param OutPointOnBody		Point on the surface of collision closest to Point
    ## @param BoneName			If a SkeletalMeshComponent, name of body to set center of mass of. 'None' indicates root body.
    ##
    ## @return		Success if returns > 0.f, if returns 0.f, it is either not convex or inside of the point
    ## 				If returns < 0.f, this primitive does not have collsion
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Collision")

  proc createSceneProxy(): ptr FPrimitiveSceneProxy
    ## Creates a proxy to represent the primitive to the scene manager in the rendering thread.
    ## @return The proxy object.

  proc shouldRecreateProxyOnUpdateTransform(): bool {.noSideEffect.}
    ## Determines whether the proxy for this primitive type needs to be recreated whenever the primitive moves.
    ## @return true to recreate the proxy when UpdateTransform is called.

  proc isZeroExtent(): bool {.noSideEffect.}
    ## This isn't bound extent, but for shape component to utilize extent is 0.
    ## For normal primitive, this is 0, for ShapeComponent, this will have valid information

  proc receiveComponentDamage(damageAmount: cfloat; damageEvent: FDamageEvent;
                            eventInstigator: ptr AController;
                            damageCauser: ptr AActor)
    ## Event called when a component is 'damaged', allowing for component class specific behaviour

  proc weldTo(inParent: ptr USceneComponent; inSocketName: FName = NAME_None)
    ## Welds this component to another scene component, optionally at a named socket. Component is automatically attached if not already
    ## Welding allows the child physics object to become physically connected to its parent. This is useful for creating compound rigid bodies with correct mass distribution.
    ## @param InParent the component to be physically attached to
    ## @param InSocketName optional socket to attach component to

  proc weldToImplementation(inParent: ptr USceneComponent;
                          parentSocketName: FName = NAME_None;
                          bWeldSimulatedChild: bool = true): bool
    ## Does the actual work for welding.
    ## @return true if did a true weld of shapes, meaning body initialization is not needed

  proc unWeldFromParent()
    ## UnWelds this component from its parent component. Attachment is maintained (DetachFromParent automatically unwelds)

  proc unWeldChildren()
    ## Unwelds the children of this component. Attachment is maintained

  proc getWeldedBodies(outWeldedBodies: var TArray[ptr FBodyInstance];
                      outLabels: var TArray[FName])
    ## 	Adds the bodies that are currently welded to the OutWeldedBodies array

#if WITH_EDITOR:
  proc componentIsTouchingSelectionBox(inSelBBox: FBox;
                                      showFlags: FEngineShowFlags;
                                      bConsiderOnlyBSP: bool;
                                      bMustEncompassEntireComponent: bool): bool {.
      noSideEffect.}
    ## Determines whether the supplied bounding box intersects with the component.
    ## Used by the editor in orthographic viewports.
    ##
    ## @param	InSelBBox						Bounding box to test against
    ## @param	ShowFlags						Engine ShowFlags for the viewport
    ## @param	bConsiderOnlyBSP				If only BSP geometry should be tested
    ## @param	bMustEncompassEntireComponent	Whether the component bounding box must lay wholly within the supplied bounding box
    ##
    ## @return	true if the supplied bounding box is determined to intersect the component (partially or wholly)
  proc componentIsTouchingSelectionFrustum(inFrustum: FConvexVolume;
      showFlags: FEngineShowFlags; bConsiderOnlyBSP: bool;
      bMustEncompassEntireComponent: bool): bool {.noSideEffect.}
    ## Determines whether the supplied frustum intersects with the component.
    ## Used by the editor in perspective viewports.
    ##
    ## @param	InFrustum						Frustum to test against
    ## @param	ShowFlags						Engine ShowFlags for the viewport
    ## @param	bConsiderOnlyBSP				If only BSP geometry should be tested
    ## @param	bMustEncompassEntireComponent	Whether the component bounding box must lay wholly within the supplied bounding box
    ##
    ## @return	true if the supplied bounding box is determined to intersect the component (partially or wholly)
#endif

# protected
  proc updatePhysicsToRBChannels()
    ## Internal function that updates physics objects to match the component collision settings.

  proc sendPhysicsTransform(teleport: ETeleportType)
    ## Called to send a transform update for this component to the physics engine

  proc ensurePhysicsStateCreated()
    ## Ensure physics state created

# public:

  proc dispatchBlockingHit(outOwner: var AActor; blockingHit: FHitResult)
    ## Dispatch notifications for the given HitResult.
    ##
    ## @param Owner: AActor that owns this component
    ## @param BlockingHit: FHitResult that generated the blocking hit.

  proc dispatchWakeEvents(wakeEvent: int32; boneName: FName)
    ## Dispatch notification for wake events and propagate to any welded bodies

  proc initSweepCollisionParams(outParams: var FCollisionQueryParams;
                              outResponseParam: var FCollisionResponseParams) {.
      noSideEffect.}
    ## Set collision params on OutParams (such as CollisionResponse, bTraceAsyncScene) to match the settings on this PrimitiveComponent.

  proc getCollisionShape(inflation: cfloat = 0.0): FCollisionShape {.noSideEffect.}
    ## Return a CollisionShape that most closely matches this primitive.

  proc areSymmetricRotations(a: FQuat; b: FQuat; scale3D: FVector): bool {.noSideEffect.}
    ## Returns true if the given transforms result in the same bounds, due to rotational symmetry.
    ## For example, this is true for a sphere with uniform scale undergoing any rotation.
    ## This is NOT intended to detect every case where this is true, only the common cases to aid optimizations.

  proc pushSelectionToProxy()
    ## Pushes new selection state to the render thread primitive proxy

  proc pushHoveredToProxy(bInHovered: bool)
    ## Pushes new hover state to the render thread primitive proxy
    ## @param bInHovered - true if the proxy should display as if hovered

  proc pushEditorVisibilityToProxy(inVisibility: uint64)
    ## Sends editor visibility updates to the render thread

  proc getEmissiveBoost(elementIndex: int32): cfloat {.noSideEffect.}
    ## Gets the emissive boost for the primitive component.

  proc getDiffuseBoost(elementIndex: int32): cfloat {.noSideEffect.}
    ## Gets the diffuse boost for the primitive component.

  proc getShadowIndirectOnly(): bool {.noSideEffect.}

#if WITH_EDITOR:
  proc getHiddenEditorViews(): uint64 {.noSideEffect.}
    ## Returns mask that represents in which views this primitive is hidden
#endif

  proc setAllPhysicsAngularVelocity(newAngVel: FVector; bAddToCurrent: bool = false)
    ## 	Set the angular velocity of all bodies in this component.
    ##
    ## 	@param NewAngVel		New angular velocity to apply to physics, in degrees per second.
    ## 	@param bAddToCurrent	If true, NewAngVel is added to the existing angular velocity of all bodies.

  proc setAllPhysicsPosition(newPos: FVector)
    ## 	Set the position of all bodies in this component.
    ## 	If a SkeletalMeshComponent, the root body will be placed at the desired position, and the same delta is applied to all other bodies.
    ##
    ## 	@param	NewPos		New position for the body

  proc setAllPhysicsRotation(newRot: FRotator)
    ## 	Set the rotation of all bodies in this component.
    ## 	If a SkeletalMeshComponent, the root body will be changed to the desired orientation, and the same delta is applied to all other bodies.
    ##
    ## 	@param NewRot	New orienatation for the body

  proc wakeAllRigidBodies()
    ## 	Ensure simulation is running for all bodies in this component.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc setEnableGravity(bGravityEnabled: bool)
    ## Enables/disables whether this component is affected by gravity. This applies only to components with bSimulatePhysics set to true.
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc isGravityEnabled(): bool {.noSideEffect.}
    ## Returns whether this component is affected by gravity. Returns always false if the component is not simulated.
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc setLinearDamping(inDamping: cfloat)
    ## Sets the linear damping of this component.
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc getLinearDamping(): cfloat {.noSideEffect.}
    ## Returns the linear damping of this component.
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc setAngularDamping(inDamping: cfloat)
    ## Sets the angular damping of this component.
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc getAngularDamping(): cfloat {.noSideEffect.}
    ## Returns the angular damping of this component.
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc setMassScale(boneName: FName = NAME_None; inMassScale: cfloat = 1.0)
    ## Change the mass scale used to calculate the mass of a single physics body
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc getMassScale(boneName: FName = NAME_None): cfloat {.noSideEffect.}
    ## Returns the mass scale used to calculate the mass of a single physics body
    ## UFUNCTION(BlueprintCallable, Category = "Physics")

  proc setAllMassScale(inMassScale: cfloat = 1.0)
    ## Change the mass scale used fo all bodies in this component
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc setMassOverrideInKg(boneName: FName = NAME_None; massInKg: cfloat = 1.0;
                          bOverrideMass: bool = true)
    ## 	Override the mass (in Kg) of a single physics body.
    ## 	Note that in the case where multiple bodies are attached together, the override mass will be set for the entire group.
    ## 	Set the Override Mass to false if you want to reset the body's mass to the auto-calculated physx mass.
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Physics")

  proc getMass(): cfloat {.noSideEffect.}
    ## Returns the mass of this component in kg.
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc getInertiaTensor(boneName: FName = NAME_None): FVector {.noSideEffect.}
    ## Returns the inertia tensor of this component in kg cm^2. The inertia tensor is in local component space.
    ## UFUNCTION(BlueprintCallable, Category = "Physics", meta =(Keywords = "physics moment of inertia tensor MOI"))

  proc scaleByMomentOfInertia(inputVector: FVector; boneName: FName = NAME_None): FVector {.
      noSideEffect.}
    ## Scales the given vector by the world space moment of inertia. Useful for computing the torque needed to rotate an object.
    ## UFUNCTION(BlueprintCallable, Category = "Physics", meta = (Keywords = "physics moment of inertia tensor MOI"))

  proc calculateMass(boneName: FName = NAME_None): cfloat
    ## Returns the calculated mass in kg. This is not 100% exactly the mass physx will calculate, but it is very close ( difference < 0.1kg ).

  proc putAllRigidBodiesToSleep()
    ## 	Force all bodies in this component to sleep.

  proc rigidBodyIsAwake(boneName: FName = NAME_None): bool
    ## 	Returns if a single body is currently awake and simulating.
    ## 	@param	BoneName	If a SkeletalMeshComponent, name of body to return wakeful state from. 'None' indicates root body.

  proc isAnyRigidBodyAwake(): bool
    ## 	Returns if any body in this component is currently awake and simulating.

  proc setCollisionResponseToChannel(channel: ECollisionChannel;
                                    newResponse: ECollisionResponse)
    ## 	Changes a member of the ResponseToChannels container for this PrimitiveComponent.
    ##
    ## @param       Channel      The channel to change the response of
    ## @param       NewResponse  What the new response should be to the supplied Channel
    ##
    ## UFUNCTION(BlueprintCallable, Category="Collision")

  proc setCollisionResponseToAllChannels(newResponse: ECollisionResponse)
    ## 	Changes all ResponseToChannels container for this PrimitiveComponent. to be NewResponse
    ##
    ## @param       NewResponse  What the new response should be to the supplied Channel
    ##
    ## UFUNCTION(BlueprintCallable, Category="Collision")

  proc setCollisionResponseToChannels(newReponses: FCollisionResponseContainer)
    ## 	Changes the whole ResponseToChannels container for this PrimitiveComponent.
    ##
    ## @param       NewResponses  New set of responses for this component

# public:

  proc conditionalApplyRigidBodyState(updatedState: var FRigidBodyState;
                                      errorCorrection: FRigidBodyErrorCorrection;
                                      outDeltaPos: var FVector;
                                      boneName: FName = NAME_None): bool
    ## Applies RigidBodyState only if it needs to be updated
    ## NeedsUpdate flag will be removed from UpdatedState after all velocity corrections are finished

  proc getRigidBodyState(outState: var FRigidBodyState; boneName: FName = NAME_None): bool
    ## 	Get the state of the rigid body responsible for this Actor's physics, and fill in the supplied FRigidBodyState struct based on it.
    ##
    ## 	@return	true if we successfully found a physics-engine body and update the state structure from it.

  proc setPhysMaterialOverride(newPhysMaterial: ptr UPhysicalMaterial)
    ## 	Changes the current PhysMaterialOverride for this component.
    ## 	Note that if physics is already running on this component, this will _not_ alter its mass/inertia etc,
    ## 	it will only change its surface properties like friction.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Physics", meta=(DisplayName="Set PhysicalMaterial Override"))

  proc shouldComponentAddToScene(): bool {.noSideEffect.}
    ## Looking at various values of the component, determines if this
    ## component should be added to the scene
    ## @return true if the component is visible and should be added to the scene, false otherwise

  proc setCullDistance(newCullDistance: cfloat)
    ## Changes the value of CullDistance.
    ## @param NewCullDistance - The value to assign to CullDistance.
    ##
    ## UFUNCTION(BlueprintCallable, Category="LOD", meta=(DisplayName="Set Max Draw Distance"))

  proc setCachedMaxDrawDistance(newCachedMaxDrawDistance: cfloat)
    ## Utility to cache the max draw distance based on cull distance volumes or the desired max draw distance

  proc setDepthPriorityGroup(newDepthPriorityGroup: ESceneDepthPriorityGroup)
    ## Changes the value of DepthPriorityGroup.
    ## @param NewDepthPriorityGroup - The value to assign to DepthPriorityGroup.

  proc setViewOwnerDepthPriorityGroup(bNewUseViewOwnerDepthPriorityGroup: bool;
      newViewOwnerDepthPriorityGroup: ESceneDepthPriorityGroup)
    ## Changes the value of bUseViewOwnerDepthPriorityGroup and ViewOwnerDepthPriorityGroup.
    ## @param bNewUseViewOwnerDepthPriorityGroup - The value to assign to bUseViewOwnerDepthPriorityGroup.
    ## @param NewViewOwnerDepthPriorityGroup - The value to assign to ViewOwnerDepthPriorityGroup.

  proc lineTraceComponent(outHit: var FHitResult; start: FVector; `end`: FVector;
                        params: FCollisionQueryParams): bool
    ## Trace a ray against just this component.
    ## @param  OutHit          Information about hit against this component, if true is returned
    ## @param  Start           Start location of the ray
    ## @param  End             End location of the ray
    ## @param  Params          Additional parameters used for the trace
    ## @return true if a hit is found

  proc sweepComponent(outHit: var FHitResult; start: FVector; `end`: FVector;
                    collisionShape: FCollisionShape; bTraceComplex: bool = false): bool
    ## Trace a box against just this component.
    ## @param  OutHit          Information about hit against this component, if true is returned
    ## @param  Start           Start location of the box
    ## @param  End             End location of the box
    ## @param  BoxHalfExtent 	Half Extent of the box
    ## 	@param	bTraceComplex	Whether or not to trace complex
    ## @return true if a hit is found

  proc componentOverlapComponent(primComp: ptr UPrimitiveComponent; pos: FVector;
                                rot: FQuat; params: FCollisionQueryParams): bool
    ## Test the collision of the supplied component at the supplied location/rotation, and determine if it overlaps this component
    ## @note This overload taking rotation as a FQuat is slightly faster than the version using FRotator.
    ## @note This simply calls the virtual ComponentOverlapComponentImpl() which can be overridden to implement custom behavior.
    ## @param  PrimComp        Component to use geometry from to test against this component. Transform of this component is ignored.
    ## @param  Pos             Location to place PrimComp geometry at
    ## @param  Rot             Rotation to place PrimComp geometry at
    ## @param	Params			Parameter for trace. TraceTag is only used.
    ## @return true if PrimComp overlaps this component at the specified location/rotation
  proc componentOverlapComponent(primComp: ptr UPrimitiveComponent; pos: FVector;
                                rot: FRotator; params: FCollisionQueryParams): bool
# protected:

  proc componentOverlapComponentImpl(primComp: ptr UPrimitiveComponent; pos: FVector;
                                    rot: FQuat; params: FCollisionQueryParams): bool
    ## Override this method for custom behavior.

# public:

  proc overlapComponent(pos: FVector; rot: FQuat; collisionShape: FCollisionShape): bool
    ## Test the collision of the supplied Sphere at the supplied location, and determine if it overlaps this component
    ##
    ## @param  Pos             Location to place PrimComp geometry at
    ## 	@param	Rot				Rotation of PrimComp geometry
    ## @param  CollisionShape 	Shape of collision of PrimComp geometry
    ## @return true if PrimComp overlaps this component at the specified location/rotation

  proc computePenetration(outMTD: var FMTDResult; collisionShape: FCollisionShape;
                        pos: FVector; rot: FQuat): bool
    ## Computes the minimum translation direction (MTD) when an overlap exists between the component and the given shape.
    ## @param OutMTD			Outputs the MTD to move CollisionShape out of penetration
    ## @param CollisionShape	Shape information for the geometry testing against
    ## @param Pos				Location of collision shape
    ## @param Rot				Rotation of collision shape
    ## @return true if the computation succeeded - assumes that there is an overlap at the specified position/rotation

  proc canCharacterStepUp(pawn: ptr APawn): bool {.noSideEffect.}
    ## Return true if the given Pawn can step up onto this component.
    ## This controls whether they can try to step up on it when they bump in to it, not whether they can walk on it after landing on it.
    ## @param Pawn the Pawn that wants to step onto this component.
    ## @see CanCharacterStepUpOn
    ##
    ## UFUNCTION(BlueprintCallable, Category=Collision)

  proc canEverAffectNavigation(): bool {.noSideEffect.}
    ## Can this component potentially influence navigation

  proc setCanEverAffectNavigation(bRelevant: bool)
    ## set value of bCanEverAffectNavigation flag and update navigation octree if needed

# protected:
  proc handleCanEverAffectNavigationChange()
    ## Makes sure navigation system has up to date information regarding component's navigation relevancy and if it can affect navigation at all

# public:

  proc hasCustomNavigableGeometry(): EHasCustomNavigableGeometry {.noSideEffect.}
  proc setCustomNavigableGeometry(inType: EHasCustomNavigableGeometry)

  proc doCustomNavigableGeometryExport(geomExport: var FNavigableGeometryExport): bool {.
      noSideEffect.}
    ## Collects custom navigable geometry of component.
    ## @return true if regular navigable geometry exporting should be run as well
  proc dispatchMouseOverEvents(currentComponent: ptr UPrimitiveComponent;
                              newComponent: ptr UPrimitiveComponent)
  proc dispatchTouchOverEvents(fingerIndex: ETouchIndex;
                              currentComponent: ptr UPrimitiveComponent;
                              newComponent: ptr UPrimitiveComponent)
  proc dispatchOnClicked()
  proc dispatchOnReleased()
  proc dispatchOnInputTouchBegin(key: ETouchIndex)
  proc dispatchOnInputTouchEnd(key: ETouchIndex)