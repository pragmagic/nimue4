# Copyright 2016 Xored Software, Inc.

type
  EDetailMode* {.size: sizeof(cint), header: "Components/SceneComponent.h", importcpp.} = enum
    ## Detail mode for scene component rendering.
    DM_Low,
    DM_Medium,
    DM_High,
    DM_MAX

  ERelativeTransformSpace* {.size: sizeof(cint), header: "Components/SceneComponent.h", importcpp.} = enum
    ## The space for the transform
    RTS_World,
      ## World space transform.
    RTS_Actor,
      ## Actor space transform.
    RTS_Component
      ## Component space transform.

  EMoveComponentFlags* {.size: sizeof(cint), header: "Components/SceneComponent.h", importcpp.} = enum
    ## MoveComponent options.
    MOVECOMP_NoFlags = 0x0000,  ## No flags
    MOVECOMP_IgnoreBases = 0x0001,  ## Ignore collisions with things the Actor is based on
    MOVECOMP_SkipPhysicsMove = 0x0002,
      ## When moving this component, do not move the physics representation.
      ## Used internally to avoid looping updates when syncing with physics.
    MOVECOMP_NeverIgnoreBlockingOverlaps= 0x0004,
      ## Never ignore initial blocking overlaps during movement, which are usually ignored when moving out of an object.
      ## MOVECOMP_IgnoreBases is still respected.

  EScopedUpdate* {.header: "Components/SceneComponent.h", importcpp: "EScopedUpdate::Type", pure, size: sizeof(cint).} = enum
    ## Enum that controls the scoping behavior of FScopedMovementUpdate.
    ## Note that EScopedUpdate::ImmediateUpdates is not allowed within outer scopes that defer updates,
    ## and any attempt to do so will change the new inner scope to use deferred updates instead.
    ImmediateUpdates,
    DeferredUpdates

  EHasMovedTransformOption* {.header: "Components/SceneComponent.h", importcpp: "EHasMovedTransformOption", size: sizeof(cint).} = enum
    eTestTransform,
    eIgnoreTransform

wclass(FScopedMovementUpdate, header: "Components/SceneComponent.h", bycopy):
  proc getOuterDeferredScope(): ptr FScopedMovementUpdate {.noSideEffect.}
    ## Get the scope containing this scope. A scope only has an outer scope if they both defer updates.

  proc isDeferringUpdates(): bool {.noSideEffect.}
    ## Return true if deferring updates, false if updates are applied immediately.

  proc revertMove()
    ## Revert movement to the initial location of the Component at the start of the scoped update. Also clears pending overlaps and sets bHasMoved to false.

  proc hasMoved(checkTransform: EHasMovedTransformOption): bool {.noSideEffect.}
    ## Returns whether movement has occurred at all during this scope, optionally checking if the transform is different (since changing scale does not go through a move). RevertMove() sets this back to false.

  proc isTransformDirty(): bool {.noSideEffect.}
    ## Returns true if the Component's transform differs from that at the start of the scoped update.

  proc hasPendingOverlaps(): bool {.noSideEffect.}
    ## Returns true if there are pending overlaps queued in this scope.

  proc getPendingOverlaps(): TArray[FOverlapInfo]  {.noSideEffect.}
    ## Returns the pending overlaps within this scope.

  proc getPendingBlockingHits(): TArray[FHitResult] {.noSideEffect.}
    ## Returns the list of pending blocking hits, which will be used for notifications once the move is committed.

# These methods are intended only to be used by SceneComponent and derived classes.

  proc appendOverlapsAfterMove(NewPendingOverlaps: TArray[FOverlapInfo]; bSweep: bool; bIncludesOverlapsAtEnd: bool)
    ## Add overlaps to the queued overlaps array. This is intended for use only by SceneComponent and its derived classes whenever movement is performed.

  proc keepCurrentOverlapsAfterRotation(bSweep: bool)
    ## Keep current pending overlaps after a move but make note that there was movement (just a symmetric rotation).

  proc appendBlockingHitAfterMove(hit: FHitResult)
    ## Add blocking hit that will get processed once the move is committed. This is intended for use only by SceneComponent and its derived classes.

  proc invalidateCurrentOverlaps()
    ## Clear overlap state at current location, we don't know what it is.

  proc forceOverlapUpdate()
    ## Force full overlap update once this scope finishes.


const compHeader = "Components/SceneComponent.h"

proc `|`(arg1: EMoveComponentFlags, arg2: EMoveComponentFlags): EMoveComponentFlags {.header: compHeader, importcpp: "#|#", noSideEffect.}
proc `&`(arg1: EMoveComponentFlags, arg2: EMoveComponentFlags): EMoveComponentFlags {.header: compHeader, importcpp: "#&#", noSideEffect.}
proc `|=`(arg1: var EMoveComponentFlags, arg2: EMoveComponentFlags) {.header: compHeader, importcpp: "#|=#".}
proc `&=`(arg1: var EMoveComponentFlags, arg2: EMoveComponentFlags) {.header: compHeader, importcpp: "#&=#".}

declareBuiltinDelegate(FPhysicsVolumeChanged, dkDynamicMulticast, "Components/SceneComponent.h", newVolume: ptr APhysicsVolume)

wclass(USceneComponent of UActorComponent, header: "Components/SceneComponent.h", notypedef):
  ## A SceneComponent has a transform and supports attachment, but has no rendering or collision capabilities.
  ## Useful as a 'dummy' component in the hierarchy to offset others.
  ## @see [Scene Components](https://docs.unrealengine.com/latest/INT/Programming/UnrealArchitecture/Actors/Components/index.html#scenecomponents)

# public:

  proc getDefaultSceneRootVariableName(): FName
    ## The name to use for the default scene root variable

  # proc getLifetimeReplicatedProps(outLifetimeProps: var TArray[FLifetimeProperty]) {.
  #     noSideEffect.}

  var attachParent: ptr USceneComponent
    ## What we are currently attached to. If valid, RelativeLocation etc. are used relative to this object
    ## UPROPERTY(Replicated)

  var attachChildren: TArray[ptr USceneComponent]
    ## List of child SceneComponents that are attached to us.
    ## UPROPERTY(Replicated, transient)

  var attachSocketName: FName
    ## Optional socket name on AttachParent that we are attached to.
    ## UPROPERTY(Replicated)

  var bRequiresCustomLocation: bool
    ## if true, will call GetCustomLocation instead or returning the location part of ComponentToWorld
    ## UPROPERTY()

  var bAbsoluteLocation: bool
    ## If RelativeLocation should be considered relative to the world, rather than the parent
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadWrite, ReplicatedUsing=OnRep_Transform, Category=Transform)

  var bAbsoluteRotation: bool
    ## If RelativeRotation should be considered relative to the world, rather than the parent
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadWrite, ReplicatedUsing=OnRep_Transform, Category=Transform)

  var bAbsoluteScale: bool
    ## If RelativeScale3D should be considered relative to the world, rather than the parent
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadWrite, ReplicatedUsing=OnRep_Transform, Category=Transform)

  var bVisible: bool
    ## Whether to completely draw the primitive; if false, the primitive is not drawn, does not cast a shadow.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, ReplicatedUsing=OnRep_Visibility,  Category = Rendering)

  var bHiddenInGame: bool
    ## Whether to hide the primitive in game, if the primitive is Visible.
    ## UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category=Rendering)

  var bShouldUpdatePhysicsVolume: bool
    ## Whether or not the cached PhysicsVolume this component overlaps should be updated when the component is moved.
    ## @see GetPhysicsVolume()
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, AdvancedDisplay, Category=Physics)

  var bBoundsChangeTriggersStreamingDataRebuild: bool
    ## If true, a change in the bounds of the component will call trigger a streaming data rebuild
    ## UPROPERTY()

  var bUseAttachParentBound: bool
    ## If true, this component uses its parents bounds when attached.
    ##  This can be a significant optimization with many components attached together.
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, AdvancedDisplay, Category=Rendering)

  var bWorldToComponentUpdated: bool
    ## protected:
    ## UPROPERTY(Transient)

  var bDisableDetachmentUpdateOverlaps: bool
    ## Transient flag that temporarily disables UpdateOverlaps within DetachFromParent().

# public:

  var bounds: FBoxSphereBounds
    ## Current bounds of the component

  var componentToWorld: FTransform
    ## Current transform of the component, relative to the world

  var relativeLocation: FVector
    ## Location of the component relative to its parent
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, ReplicatedUsing=OnRep_Transform, Category = Transform)

  var relativeRotation: FRotator
    ## Rotation of the component relative to its parent
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, ReplicatedUsing=OnRep_Transform, Category=Transform)

  var relativeScale3D: FVector
    ## 	Non-uniform scaling of the component relative to its parent.
    ## 	Note that scaling is always applied in local space (no shearing etc)
    ##
    ## UPROPERTY(BlueprintReadOnly, ReplicatedUsing=OnRep_Transform, interp, Category=Transform)

  var mobility: EComponentMobility
    ## How often this component is allowed to move, used to make various optimizations. Only safe to set in constructor, use SetMobility() during runtime.
    ## UPROPERTY(Category = Mobility, EditAnywhere, BlueprintReadOnly)

  var detailMode: EDetailMode
    ## If detail mode is >= system detail mode, primitive won't be rendered.
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=LOD)

  var componentVelocity: FVector
    ## Velocity of the component.
    ## @see GetComponentVelocity()
    ##
    ## UPROPERTY()


  proc K2_SetRelativeLocation(newLocation: FVector; bSweep: bool;
                            sweepHitResult: var FHitResult; bTeleport: bool)
  proc setRelativeLocation(newLocation: FVector; bSweep: bool = false;
                          outSweepHitResult: ptr FHitResult = nil;
                          teleport: ETeleportType = ETeleportType.None)
    ## Set the location of the component relative to its parent
    ## @param NewLocation		New location of the component relative to its parent.
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ## 							Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ## 							If CCD is on and not teleporting, this will affect objects along the entire sweep volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="SetRelativeLocation"))

  proc k2_SetRelativeRotation(newRotation: FRotator; bSweep: bool;
                            sweepHitResult: var FHitResult; bTeleport: bool)
    ## Set the rotation of the component relative to its parent
    ## @param NewRotation		New rotation of the component relative to its parent
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination (currently not supported for rotation).
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="SetRelativeRotation", AdvancedDisplay="bSweep,SweepHitResult,bTeleport"))
  proc setRelativeRotation(newRotation: FRotator; bSweep: bool = false;
                          outSweepHitResult: ptr FHitResult = nil;
                          teleport: ETeleportType = ETeleportType.None)
  proc setRelativeRotation(newRotation: FQuat; bSweep: bool = false;
                          outSweepHitResult: ptr FHitResult = nil;
                          teleport: ETeleportType = ETeleportType.None)

  proc k2_SetRelativeTransform(newTransform: FTransform; bSweep: bool;
                              sweepHitResult: var FHitResult; bTeleport: bool)
  proc setRelativeTransform(newTransform: FTransform; bSweep: bool = false;
                          outSweepHitResult: ptr FHitResult = nil;
                          teleport: ETeleportType = ETeleportType.None)
    ## Set the transform of the component relative to its parent
    ## @param NewTransform		New transform of the component relative to its parent.
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination (currently not supported for rotation).
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="SetRelativeTransform"))

  proc getRelativeTransform(): FTransform {.noSideEffect.}
    ## Returns the transform of the component relative to its parent
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  proc resetRelativeTransform()
    ## Reset the transform of the component relative to its parent. Sets relative location to zero, relative rotation to no rotation, and Scale to 1.
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  method setRelativeScale3D(newScale3D: FVector)
    ## Set the non-uniform scale of the component relative to its parent
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  proc k2_AddRelativeLocation(deltaLocation: FVector; bSweep: bool;
                            sweepHitResult: var FHitResult; bTeleport: bool)
  proc addRelativeLocation(deltaLocation: FVector; bSweep: bool = false;
                           outSweepHitResult: ptr FHitResult = nil;
                           teleport: ETeleportType = ETeleportType.None)
    ## Adds a delta to the translation of the component relative to its parent
    ## @param DeltaLocation		Change in location of the component relative to its parent
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ## 							Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ## 							If CCD is on and not teleporting, this will affect objects along the entire sweep volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="AddRelativeLocation"))

  proc k2_AddRelativeRotation(deltaRotation: FRotator; bSweep: bool;
                            sweepHitResult: var FHitResult; bTeleport: bool)
  proc addRelativeRotation(deltaRotation: FRotator; bSweep: bool = false;
                           outSweepHitResult: ptr FHitResult = nil;
                           teleport: ETeleportType = ETeleportType.None)
    ## Adds a delta the rotation of the component relative to its parent
    ## @param DeltaRotation		Change in rotation of the component relative to is parent.
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination (currently not supported for rotation).
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="AddRelativeRotation", AdvancedDisplay="bSweep,SweepHitResult,bTeleport"))
  proc addRelativeRotation(deltaRotation: FQuat; bSweep: bool = false;
                           outSweepHitResult: ptr FHitResult = nil;
                           teleport: ETeleportType = ETeleportType.None)

  proc k2_AddLocalOffset(deltaLocation: FVector; bSweep: bool;
                         sweepHitResult: var FHitResult; bTeleport: bool)
  proc addLocalOffset(deltaLocation: FVector; bSweep: bool = false;
                      outSweepHitResult: ptr FHitResult = nil;
                      teleport: ETeleportType = ETeleportType.None)
    ## Adds a delta to the location of the component in its local reference frame
    ## @param DeltaLocation		Change in location of the component in its local reference frame.
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ## 							Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ## 							If CCD is on and not teleporting, this will affect objects along the entire sweep volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="AddLocalOffset", Keywords="location position"))

  proc k2_AddLocalRotation(deltaRotation: FRotator; bSweep: bool;
                          sweepHitResult: var FHitResult; bTeleport: bool)
  proc addLocalRotation(deltaRotation: FRotator; bSweep: bool = false;
                        outSweepHitResult: ptr FHitResult = nil;
                        teleport: ETeleportType = ETeleportType.None)
    ## Adds a delta to the rotation of the component in its local reference frame
    ## @param DeltaRotation		Change in rotation of the component in its local reference frame.
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination (currently not supported for rotation).
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="AddLocalRotation", AdvancedDisplay="bSweep,SweepHitResult,bTeleport"))
  proc addLocalRotation(deltaRotation: FQuat; bSweep: bool = false;
                        outSweepHitResult: ptr FHitResult = nil;
                        teleport: ETeleportType = ETeleportType.None)

  proc k2_AddLocalTransform(deltaTransform: FTransform; bSweep: bool;
                          sweepHitResult: var FHitResult; bTeleport: bool)
  proc addLocalTransform(deltaTransform: FTransform; bSweep: bool = false;
                         outSweepHitResult: ptr FHitResult = nil;
                         teleport: ETeleportType = ETeleportType.None)
    ## Adds a delta to the transform of the component in its local reference frame. Scale is unchanged.
    ## @param DeltaTransform	Change in transform of the component in its local reference frame. Scale is unchanged.
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ## 							Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ## 							If CCD is on and not teleporting, this will affect objects along the entire sweep volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="AddLocalTransform"))

  proc k2_SetWorldLocation(newLocation: FVector; bSweep: bool;
                           sweepHitResult: var FHitResult; bTeleport: bool)
  proc setWorldLocation(newLocation: FVector; bSweep: bool = false;
                        outSweepHitResult: ptr FHitResult = nil;
                        teleport: ETeleportType = ETeleportType.None)
    ## Put this component at the specified location in world space. Updates relative location to achieve the final world location.
    ## @param NewLocation		New location in world space for the component.
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ## 							Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ## 							If CCD is on and not teleporting, this will affect objects along the entire sweep volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="SetWorldLocation"))

  proc k2_SetWorldRotation(newRotation: FRotator; bSweep: bool;
                           sweepHitResult: var FHitResult; bTeleport: bool)
  proc setWorldRotation(newRotation: FRotator; bSweep: bool = false;
                        outSweepHitResult: ptr FHitResult = nil;
                        teleport: ETeleportType = ETeleportType.None)
  proc setWorldRotation(newRotation: FQuat; bSweep: bool = false;
                        outSweepHitResult: ptr FHitResult = nil;
                        teleport: ETeleportType = ETeleportType.None)

  proc setWorldScale3D(newScale: FVector)
    ## Set the relative scale of the component to put it at the supplied scale in world space.
    ## @param NewScale		New scale in world space for this component.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  proc k2_SetWorldTransform(newTransform: FTransform; bSweep: bool;
                          sweepHitResult: var FHitResult; bTeleport: bool)
  proc setWorldTransform(newTransform: FTransform; bSweep: bool = false;
                        outSweepHitResult: ptr FHitResult = nil;
                        teleport: ETeleportType = ETeleportType.None)
    ## Set the transform of the component in world space.
    ## @param NewTransform		New transform in world space for the component.
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ## 							Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ## 							If CCD is on and not teleporting, this will affect objects along the entire sweep volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="SetWorldTransform"))

  proc k2_AddWorldOffset(deltaLocation: FVector; bSweep: bool;
                        sweepHitResult: var FHitResult; bTeleport: bool)
  proc addWorldOffset(deltaLocation: FVector; bSweep: bool = false;
                    outSweepHitResult: ptr FHitResult = nil;
                    teleport: ETeleportType = ETeleportType.None)
    ## Adds a delta to the location of the component in world space.
    ## @param DeltaLocation		Change in location in world space for the component.
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ## 							Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ## 							If CCD is on and not teleporting, this will affect objects along the entire sweep volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="AddWorldOffset", Keywords="location position"))

  proc k2_AddWorldRotation(deltaRotation: FRotator; bSweep: bool;
                          sweepHitResult: var FHitResult; bTeleport: bool)
  proc addWorldRotation(deltaRotation: FRotator; bSweep: bool = false;
                      outSweepHitResult: ptr FHitResult = nil;
                      teleport: ETeleportType = ETeleportType.None)
    ## Adds a delta to the rotation of the component in world space.
    ## @param DeltaRotation		Change in rotation in world space for the component.
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination (currently not supported for rotation).
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ## 							If CCD is on and not teleporting, this will affect objects along the entire sweep volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="AddWorldRotation", AdvancedDisplay="bSweep,SweepHitResult,bTeleport"))
  proc addWorldRotation(deltaRotation: FQuat; bSweep: bool = false;
                      outSweepHitResult: ptr FHitResult = nil;
                      teleport: ETeleportType = ETeleportType.None)

  proc k2_AddWorldTransform(deltaTransform: FTransform; bSweep: bool;
                          sweepHitResult: var FHitResult; bTeleport: bool)
  proc addWorldTransform(deltaTransform: FTransform; bSweep: bool = false;
                        outSweepHitResult: ptr FHitResult = nil;
                        teleport: ETeleportType = ETeleportType.None)
    ## Adds a delta to the transform of the component in world space. Scale is unchanged.
    ## @param DeltaTransform	Change in transform in world space for the component. Scale is unchanged.
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ## 							Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ## 							If CCD is on and not teleporting, this will affect objects along the entire sweep volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="AddWorldTransform"))

  proc k2_GetComponentLocation(): FVector {.noSideEffect.}
    ## Return location of the component, in world space
    ## UFUNCTION(BlueprintCallable, meta=(DisplayName = "GetWorldLocation"), Category="Utilities|Transformation")

  proc k2_GetComponentRotation(): FRotator {.noSideEffect.}
    ## Returns rotation of the component, in world space.
    ## UFUNCTION(BlueprintCallable, meta=(DisplayName = "GetWorldRotation"), Category="Utilities|Transformation")

  proc k2_GetComponentScale(): FVector {.noSideEffect.}
    ## Returns scale of the component, in world space.
    ## UFUNCTION(BlueprintCallable, meta=(DisplayName = "GetWorldScale"), Category="Utilities|Transformation")

  proc k2_GetComponentToWorld(): FTransform {.noSideEffect.}
    ## Get the current component-to-world transform for this component
    ## UFUNCTION(BlueprintCallable, meta=(DisplayName = "GetWorldTransform"), Category="Utilities|Transformation")

  proc getForwardVector(): FVector {.noSideEffect.}
    ## Get the forward (X) unit direction vector from this component, in world space.
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  proc getUpVector(): FVector {.noSideEffect.}
    ## Get the up (Z) unit direction vector from this component, in world space.
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  proc getRightVector(): FVector {.noSideEffect.}
    ## Get the right (Y) unit direction vector from this component, in world space.
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  method isSimulatingPhysics(boneName: FName = NAME_None): bool {.noSideEffect.}
    ## Returns whether the specified body is currently using physics simulation
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  method isAnySimulatingPhysics(): bool {.noSideEffect.}
    ## Returns whether the specified body is currently using physics simulation
    ## UFUNCTION(BlueprintCallable, Category="Physics")

  proc getAttachParent(): ptr USceneComponent {.noSideEffect.}
    ## Get a pointer to the USceneComponent we are attached to
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  proc getParentComponents(parents: var TArray[ptr USceneComponent]) {.noSideEffect.}
    ## Gets all parent components up to and including the root component
    ## UFUNCTION(BlueprintCallable, Category="Components")

  proc getNumChildrenComponents(): int32 {.noSideEffect.}
    ## Gets the number of attached children components
    ## UFUNCTION(BlueprintCallable, Category="Components")

  proc getChildComponent(childIndex: int32): ptr USceneComponent {.noSideEffect.}
    ## Gets the attached child component at the specified location
    ## UFUNCTION(BlueprintCallable, Category="Components")

  proc getChildrenComponents(bIncludeAllDescendants: bool;
                            children: var TArray[ptr USceneComponent]) {.noSideEffect.}
    ## Gets all the attached child components
    ## @param bIncludeAllDescendants Whether to include all descendants in the list of children (i.e. grandchildren, great grandchildren, etc.)
    ## @param Children The list of attached child components
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components")

  proc attachTo(inParent: ptr USceneComponent; inSocketName: FName = NAME_None;
              attachType: EAttachLocation = EAttachLocation.KeepRelativeOffset;
              bWeldSimulatedBodies: bool = false) {.deprecated.}
    ## Attach this component to another scene component, optionally at a named socket. It is valid to call this on components whether or not they have been Registered.
    ## @param bMaintainWorldTransform	If true, update the relative location/rotation of the component to keep its world position the same

  proc attachToComponent(inParent: ptr USceneComponent, attachmentRules: FAttachmentTransformRules, inSocketName: FName = NAME_None): bool {.discardable.}

  proc setupAttachment(inParent: ptr USceneComponent, inSocketName: FName = NAME_None)
    ## Initializes desired Attach Parent and SocketName to be attached to when the component is registered.
    ## Generally intended to be called from its Owning Actor's constructor and should be preferred over AttachToComponent when
    ## a component is not registered.
    ## @param  InParent				Parent to attach to.
    ## @param  InSocketName			Optional socket to attach to on the parent.

  proc k2_AttachTo(inParent: ptr USceneComponent; inSocketName: FName = NAME_None;
                  attachType: EAttachLocation = EAttachLocation.KeepRelativeOffset;
                  bWeldSimulatedBodies: bool = true)
    ##  Attach this component to another scene component, optionally at a named socket. It is valid to call this on components whether or not they have been Registered.
    ##  @param bMaintainWorldTransform	If true, update the relative location/rotation of the component to keep its world position the same
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Utilities|Transformation", meta = (DisplayName = "AttachTo", AttachType = "KeepRelativeOffset"))

  method detachFromParent(bMaintainWorldPosition: bool = false; bCallModify: bool = true)
    ## 	Detach this component from whatever it is attached to. Automatically unwelds components that are welded together (See WeldTo)
    ##   @param bMaintainWorldTransform	If true, update the relative location/rotation of the component to keep its world position the same *
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  proc getAllSocketNames(): TArray[FName] {.noSideEffect.}
    ## Gets the names of all the sockets on the component.
    ## @return Get the names of all the sockets on the component.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(Keywords="Bone"))

  method getSocketTransform(inSocketName: FName;
                        transformSpace: ERelativeTransformSpace = RTS_World): FTransform {.
      noSideEffect.}
    ## Get world-space socket transform.
    ## @param InSocketName Name of the socket or the bone to get the transform
    ## @return Socket transform in world space if socket if found. Otherwise it will return component's transform in world space.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(Keywords="Bone"))

  method getSocketLocation(inSocketName: FName): FVector {.noSideEffect.}
    ## Get world-space socket or bone location.
    ## @param InSocketName Name of the socket or the bone to get the transform
    ## @return Socket transform in world space if socket if found. Otherwise it will return component's transform in world space.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(Keywords="Bone"))

  method getSocketRotation(inSocketName: FName): FRotator {.noSideEffect.}
    ## Get world-space socket or bone  FRotator rotation.
    ## @param InSocketName Name of the socket or the bone to get the transform
    ## @return Socket transform in world space if socket if found. Otherwise it will return component's transform in world space.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(Keywords="Bone"))

  method doesSocketExist(inSocketName: FName): bool {.noSideEffect.}
    ## return true if socket with the given name exists
    ## @param InSocketName Name of the socket or the bone to get the transform
    ## @return true if the socket with the given name exists. Otherwise, return false
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(Keywords="Bone"))

  method hasAnySockets(): bool {.noSideEffect.}
    ## Returns true if this component has any sockets

  method querySupportedSockets(outSockets: var TArray[FComponentSocketDescription]) {.
      noSideEffect.}
    ## Get a list of sockets this component contains

  method getComponentVelocity(): FVector {.noSideEffect.}
    ## Get velocity of the component: either ComponentVelocity, or the velocity of the physics body if simulating physics.
    ## @return Velocity of the component
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  method isVisible(): bool {.noSideEffect.}
    ## Is this component visible or not in game
    ## @return true if visible
    ##
    ## UFUNCTION(BlueprintCallable, Category="Rendering")

  method setVisibility(bNewVisibility: bool; bPropagateToChildren: bool = false)
    ## Set visibility of the component, if during game use this to turn on/off
    ##
    ## UFUNCTION(BlueprintCallable, Category="Rendering")

  proc toggleVisibility(bPropagateToChildren: bool = false)
    ## Toggle visibility of the component
    ##
    ## UFUNCTION(BlueprintCallable, Category="Rendering")

  method setHiddenInGame(newHidden: bool; bPropagateToChildren: bool = false)
    ## Changes the value of HiddenGame.
    ## @param NewHidden	- The value to assign to HiddenGame.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Development")
# public:

  var physicsVolumeChangedDelegate: FPhysicsVolumeChanged
    ## Delegate that will be called when PhysicsVolume has been changed *
    ## UPROPERTY(BlueprintAssignable, Category=PhysicsVolume, meta=(DisplayName="Physics Volume Changed"))

# protected:

  proc internalSetWorldLocationAndRotation(newLocation: FVector; newQuat: FQuat;
                                          bNoPhysics: bool = false;
                                          teleport: ETeleportType = ETeleportType.None): bool
    ## Internal helper, for use from MoveComponent().  Special codepath since the normal setters call MoveComponent.
    ## @return: true if location or rotation was changed.

  method onUpdateTransform(bSkipPhysicsMove: bool; teleport: ETeleportType = ETeleportType.None)

  proc checkStaticMobilityAndWarn(actionText: FText): bool {.noSideEffect.}
    ## Check if mobility is set to non-static. If it's static we trigger a PIE warning and return true

# public:

  method updateOverlaps(pendingOverlaps: ptr TArray[FOverlapInfo] = nil;
                    bDoNotifies: bool = true;
                    overlapsAtEndLocation: ptr TArray[FOverlapInfo] = nil)
    ## Queries world and updates overlap tracking state for this component

  proc moveComponent(delta: FVector; newRotation: FQuat; bSweep: bool;
                    hit: ptr FHitResult = nil;
                    moveFlags: EMoveComponentFlags = MOVECOMP_NoFlags;
                    teleport: ETeleportType = ETeleportType.None): bool
    ## Tries to move the component by a movement vector (Delta) and sets rotation to NewRotation.
    ## Assumes that the component's current location is valid and that the component does fit in its current Location.
    ## Dispatches blocking hit notifications (if bSweep is true), and calls UpdateOverlaps() after movement to update overlap state.
    ##
    ## @note This simply calls the virtual MoveComponentImpl() which can be overridden to implement custom behavior.
    ## @note The overload taking rotation as an FQuat is slightly faster than the version using FRotator (which will be converted to an FQuat)..
    ## @param Delta			The desired location change in world space.
    ## @param NewRotation	The new desired rotation in world space.
    ## @param bSweep		Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ## 						Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param Teleport		Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 						If TeleportPhysics, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 						If None, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ## 						If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ## @param Hit			Optional output describing the blocking hit that stopped the move, if any.
    ## @param MoveFlags		Flags controlling behavior of the move. @see EMoveComponentFlags
    ## @param Teleport      Determines whether to teleport the physics body or not. Teleporting will maintain constant velocity and avoid collisions along the path
    ## @return				True if some movement occurred, false if no movement occurred.
  proc moveComponent(delta: FVector; newRotation: FRotator; bSweep: bool;
                    hit: ptr FHitResult = nil;
                    moveFlags: EMoveComponentFlags = MOVECOMP_NoFlags;
                    teleport: ETeleportType = ETeleportType.None): bool

# protected:

  method moveComponentImpl(delta: FVector; newRotation: FQuat; bSweep: bool;
                        hit: ptr FHitResult = nil;
                        moveFlags: EMoveComponentFlags = MOVECOMP_NoFlags;
                        teleport: ETeleportType = ETeleportType.None): bool
  ## Override this method for custom behavior.

# public:

  proc isDeferringMovementUpdates(): bool {.noSideEffect.}
    ## Returns true if movement is currently within the scope of an FScopedMovementUpdate.

  proc getCurrentScopedMovement(): ptr FScopedMovementUpdate {.noSideEffect.}
    ## Returns the current scoped movement update, or NULL if there is none. @see FScopedMovementUpdate

#if WITH_EDITORONLY_DATA:
# protected:
  var spriteComponent: ptr UBillboardComponent
    ## Editor only component used to display the sprite so as to be able to see the location of the Audio Component
# public:
  var bVisualizeComponent: bool
    ## UPROPERTY()
#endif

# public:

  method onAttachmentChanged()
    ## Called when AttachParent changes, to allow the scene to update its attachment state.

  proc getComponentLocation(): FVector {.noSideEffect.}
    ## Return location of the component, in world space

  method getCustomLocation(): FVector {.noSideEffect.}
    ## Internal routine. Only called if bRequiresCustomLocation is true, Return location of the component, in world space

  proc getComponentRotation(): FRotator {.noSideEffect.}
    ## Return rotation of the component, in world space

  proc getComponentQuat(): FQuat {.noSideEffect.}
    ## Return rotation quaternion of the component, in world space

  proc getComponentScale(): FVector {.noSideEffect.}
    ## Return scale of the component, in world space

  proc getComponentTransform(): FTransform {.noSideEffect.}
    ## Get the current component-to-world transform for this component

  proc updateChildTransforms(bSkipPhysicsMove: bool = false;
                            teleport: ETeleportType = ETeleportType.None)
    ## Update transforms of any components attached to this one.

  method calcBounds(localToWorld: FTransform): FBoxSphereBounds {.noSideEffect.}
    ## Calculate the bounds of the component. Default behavior is a bounding box/sphere of zero size.

  method calcBoundingCylinder(cylinderRadius: var cfloat; cylinderHalfHeight: var cfloat) {.
      noSideEffect.}
    ## Calculate the axis-aligned bounding cylinder of the component (radius in X-Y, half-height along Z axis).
    ## Default behavior is just a cylinder around the box of the cached BoxSphereBounds.

  method updateBounds()
    ## Update the Bounds of the component.

  method shouldCollideWhenPlacing(): bool {.noSideEffect.}
    ## If true, bounds should be used when placing component/actor in level. Does not affect spawning.

  method updatePhysicsVolume(bTriggerNotifiers: bool)
    ## Updates the PhysicsVolume of this SceneComponent, if bShouldUpdatePhysicsVolume is true.
    ##
    ## @param bTriggerNotifiers		if true, send zone/volume change events

  proc setPhysicsVolume(newVolume: ptr APhysicsVolume; bTriggerNotifiers: bool)
    ## Replace current PhysicsVolume to input NewVolume
    ##
    ## @param NewVolume				NewVolume to replace
    ## @param bTriggerNotifiers		if true, send zone/volume change events

  proc getPhysicsVolume(): ptr APhysicsVolume {.noSideEffect.}
    ## Get the PhysicsVolume overlapping this component.
    ##
    ## UFUNCTION(BlueprintCallable, Category=PhysicsVolume)

  method getCollisionResponseToChannels(): var FCollisionResponseContainer {.
      noSideEffect.}
    ## Return const reference to CollsionResponseContainer

  method isVisibleInEditor(): bool {.noSideEffect.}
    ## Return true if visible in editor

  proc shouldRender(): bool {.noSideEffect.}
    ## Return true if it should render

  proc canEverRender(): bool {.noSideEffect.}
    ## Return true if it can ever render

  proc shouldComponentAddToScene(): bool {.noSideEffect.}
    ## Looking at various values of the component, determines if this
    ## component should be added to the scene
    ## @return true if the component is visible and should be added to the scene, false otherwise
#if WITH_EDITOR:
  method postEditComponentMove(bFinished: bool)
    ## Called when this component is moved in the editor
  method canEditChange(property: ptr UProperty): bool {.noSideEffect.}
  method getNumUncachedStaticLightingInteractions(): int32 {.noSideEffect.}
  method preFeatureLevelChange(pendingFeatureLevel: ERHIFeatureLevel)
#endif

# protected:

  method calcNewComponentToWorld(newRelativeTransform: FTransform;
                              parent: ptr USceneComponent = nil;
                              socketName: FName = NAME_None): FTransform {.noSideEffect.}
    ## Calculate the new ComponentToWorld transform for this component.
    ## Parent is optional and can be used for computing ComponentToWorld based on arbitrary USceneComponent.
    ## If Parent is not passed in or is NULL then we use the component's existing AttachParent and AttachSocket

# public:

  proc k2_SetRelativeLocationAndRotation(newLocation: FVector; newRotation: FRotator;
                                        bSweep: bool;
                                        sweepHitResult: var FHitResult;
                                        bTeleport: bool)
  proc setRelativeLocationAndRotation(newLocation: FVector; newRotation: FRotator;
                                    bSweep: bool = false;
                                    outSweepHitResult: ptr FHitResult = nil;
                                    teleport: ETeleportType = ETeleportType.None)
    ## Set the location and rotation of the component relative to its parent
    ## @param NewLocation		New location of the component relative to its parent.
    ## @param NewRotation		New rotation of the component relative to its parent.
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ## 							Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ## 							If CCD is on and not teleporting, this will affect objects along the entire sweep volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="SetRelativeLocationAndRotation"))
  proc setRelativeLocationAndRotation(newLocation: FVector; newRotation: FQuat;
                                    bSweep: bool = false;
                                    outSweepHitResult: ptr FHitResult = nil;
                                    teleport: ETeleportType = ETeleportType.None)

  proc setAbsolute(bNewAbsoluteLocation: bool = false;
                  bNewAbsoluteRotation: bool = false; bNewAbsoluteScale: bool = false)
    ## Set which parts of the relative transform should be relative to parent, and which should be relative to world
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  proc k2_SetWorldLocationAndRotation(newLocation: FVector; newRotation: FRotator;
                                    bSweep: bool; sweepHitResult: var FHitResult;
                                    bTeleport: bool)
  proc setWorldLocationAndRotation(newLocation: FVector; newRotation: FRotator;
                                  bSweep: bool = false;
                                  outSweepHitResult: ptr FHitResult = nil;
                                  teleport: ETeleportType = ETeleportType.None)
    ## Set the relative location and rotation of the component to put it at the supplied pose in world space.
    ## @param NewLocation		New location in world space for the component.
    ## @param NewRotation		New rotation in world space for the component.
    ## @param SweepHitResult	Hit result from any impact if sweep is true.
    ## @param bSweep			Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ## 							Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport			Whether we teleport the physics state (if physics collision is enabled for this object).
    ## 							If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ## 							If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ## 							If CCD is on and not teleporting, this will affect objects along the entire sweep volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="SetWorldLocationAndRotation"))

  proc setWorldLocationAndRotation(newLocation: FVector; newRotation: FQuat;
                                  bSweep: bool = false;
                                  outSweepHitResult: ptr FHitResult = nil;
                                  teleport: ETeleportType = ETeleportType.None)
    ## Set the relative location and FQuat rotation of the component to put it at the supplied pose in world space.

  proc setWorldLocationAndRotationNoPhysics(newLocation: FVector;
      newRotation: FRotator)
    ## Special version of SetWorldLocationAndRotation that does not affect physics.

  method isWorldGeometry(): bool {.noSideEffect.}
    ## Is this component considered 'world' geometry

  method getCollisionEnabled(): ECollisionEnabled {.noSideEffect.}
    ## Returns the form of collision for this component

  proc isCollisionEnabled(): bool {.noSideEffect.}
    ## Utility to see if there is any form of collision enabled on this component

  method getCollisionResponseToChannel(channel: ECollisionChannel): ECollisionResponse {.
      noSideEffect.}
    ## Returns the response that this component has to a specific collision channel.

  method getCollisionObjectType(): ECollisionChannel {.noSideEffect.}
    ## Returns the channel that this component belongs to when it moves.

  proc getCollisionResponseToComponent(otherComponent: ptr USceneComponent): ECollisionResponse {.
      noSideEffect.}
    ## Compares the CollisionObjectType of each component against the Response of the other, to see what kind of response we should generate

  method setMobility(newMobility: EComponentMobility)
    ## Set how often this component is allowed to move during runtime. Causes a component re-register if the component is already registered

  proc getAttachmentRoot(): ptr USceneComponent {.noSideEffect.}
    ## Walks up the attachment chain from this SceneComponent and returns the SceneComponent at the top. this->Attachparent is NULL, returns this.

  proc getAttachmentRootActor(): ptr AActor {.noSideEffect.}
    ## Walks up the attachment chain from this SceneComponent and returns the top-level actor it's attached to.  Returns NULL if unattached.

  proc isAttachedTo(testComp: ptr USceneComponent): bool {.noSideEffect.}
    ## Walks up the attachment chain to see if this component is attached to the supplied component. If TestComp == this, returns false.

  proc getSocketWorldLocationAndRotation(inSocketName: FName;
                                        outLocation: var FVector;
                                        outRotation: var FRotator) {.noSideEffect.}
    ## Find the world-space location and rotation of the given named socket.
    ## If the socket is not found, then it returns the component's location and rotation in world space.
    ## @param InSocketName the name of the socket to find
    ## @param OutLocation (out) set to the world space location of the socket
    ## @param OutRotation (out) set to the world space rotation of the socket
    ## @return whether or not the socket was found
  proc getSocketWorldLocationAndRotation(inSocketName: FName;
                                        outLocation: var FVector;
                                        outRotation: var FQuat) {.noSideEffect.}

  method canAttachAsChild(childComponent: ptr USceneComponent; socketName: FName): bool {.
      noSideEffect.}
    ## Called to see if it's possible to attach another scene component as a child.
    ## Note: This can be called on template component as well!

  method getPlacementExtent(): FBoxSphereBounds {.noSideEffect.}
    ## Get the extent used when placing this component in the editor, used for 'pulling back' hit.

# protected:

  method onChildAttached(childComponent: ptr USceneComponent)
    ## Called after a child scene component is attached to this component.
    ## Note: Do not change the attachment state of the child during this call.

  method onChildDetached(childComponent: ptr USceneComponent)
    ## Called after a child scene component is detached from this component.
    ## Note: Do not change the attachment state of the child during this call.

  method updateNavigationData()
    ## Called after changing transform, tries to update navigation octree for this component

  proc postUpdateNavigationData()
    ## Called after changing transform, tries to update navigation octree for owner

  proc areDynamicDataChangesAllowed(bIgnoreStationary: bool = true): bool {.noSideEffect.}
    ## Determine if dynamic data is allowed to be changed.
    ##
    ## @param bIgnoreStationary Whether or not to ignore stationary mobility when checking. Default is true (i.e. - check for static mobility only).
    ## @return Whether or not dynamic data is allowed to be changed.
