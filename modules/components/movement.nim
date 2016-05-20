# Copyright 2016 Xored Software, Inc.

type EPlaneConstraintAxisSetting {.size:sizeof(uint8),
                                   header: "GameFramework/MovementComponent.h",
                                   importcpp.} = enum
  Custom, ## Lock movement to a user-defined axis.
  X, ## Lock movement in the X axis.
  Y, ## Lock movement in the Y axis.
  Z, ## Lock movement in the Z axis.
  UseGlobalPhysicsSetting ## Use the global physics project setting.

wclass(UMovementComponent of UActorComponent, header: "GameFramework/MovementComponent.h", notypedef):
  ## UCLASS(ClassGroup=Movement, abstract, BlueprintType)
  ## MovementComponent is an abstract component class that defines functionality for moving a PrimitiveComponent (our UpdatedComponent) each tick.
  ## Base functionality includes:
  ##   - Restricting movement to a plane or axis.
  ##   - Utility functions for special handling of collision results (SlideAlongSurface(), ComputeSlideVector(), TwoWallAdjust()).
  ##   - Utility functions for moving when there may be initial penetration (SafeMoveUpdatedComponent(), ResolvePenetration()).
  ##   - Automatically registering the component tick and finding a component to move on the owning Actor.
  ## Normally the root component of the owning actor is moved, however another component may be selected (see SetUpdatedComponent()).
  ## During swept (non-teleporting) movement only collision of UpdatedComponent is considered, attached components will teleport to the end location ignoring collision.

  var updatedComponent: ptr USceneComponent
    ## The component we move and update.
    ## If this is null at startup and bAutoRegisterUpdatedComponent is true, the owning Actor's root component will automatically be set as our UpdatedComponent at startup.
    ## @see bAutoRegisterUpdatedComponent, SetUpdatedComponent(), UpdatedPrimitive
    ##
    ## UPROPERTY(BlueprintReadOnly, DuplicateTransient, Category=MovementComponent)

  var updatedPrimitive: ptr UPrimitiveComponent
    ## UpdatedComponent, cast as a UPrimitiveComponent. May be invalid if UpdatedComponent was null or not a UPrimitiveComponent.
    ##
    ## UPROPERTY(BlueprintReadOnly, DuplicateTransient, Category=MovementComponent)

  var moveComponentFlags: EMoveComponentFlags
    ## Flags that control the behavior of calls to MoveComponent() on our UpdatedComponent.
    ## @see EMoveComponentFlags

  var velocity: FVector
    ## Current velocity of updated component.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Velocity)

  var bConstrainToPlane: bool
    ## If true, movement will be constrained to a plane.
    ## @see PlaneConstraintNormal, PlaneConstraintOrigin, PlaneConstraintAxisSetting
    ##
    ## UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category=PlanarMovement)

  var bSnapToPlaneAtStart: bool
    ## If true and plane constraints are enabled, then the updated component will be snapped to the plane when first attached.
    ## UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category=PlanarMovement, meta=(editcondition=bConstrainToPlane))

  var planeConstraintNormal: FVector
    ## The normal or axis of the plane that constrains movement, if bConstrainToPlane is enabled.
    ## If for example you wanted to constrain movement to the X-Z plane (so that Y cannot change), the normal would be set to X=0 Y=1 Z=0.
    ## This is recalculated whenever PlaneConstraintAxisSetting changes.
    ## @see bConstrainToPlane, SetPlaneConstraintNormal(), SetPlaneConstraintFromVectors()
    ##
    ## UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category=PlanarMovement, meta=(editcondition=bConstrainToPlane))

  var planeConstraintOrigin: FVector
    ## The origin of the plane that constrains movement, if plane constraint is enabled.
    ## This defines the behavior of snapping a position to the plane, such as by SnapUpdatedComponentToPlane().
    ## @see bConstrainToPlane, SetPlaneConstraintOrigin().
    ##
    ## UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category=PlanarMovement, meta=(editcondition=bConstrainToPlane))

  proc getPlaneConstraintNormalFromAxisSetting(axisSetting: EPlaneConstraintAxisSetting): FVector {.noSideEffect.}
    ## Helper to compute the plane constraint axis from the current setting.
    ##
    ## @param  AxisSetting Setting to use when computing the axis.
    ## @return Plane constraint axis/normal.

  var bUpdateOnlyIfRendered: bool
    ## If true, skips TickComponent() if UpdatedComponent was not recently rendered.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MovementComponent)

  var bAutoUpdateTickRegistration: bool
    ## If true, whenever the updated component is changed, this component will enable or disable its tick dependent on whether it has something to update.
    ## This will NOT enable tick at startup if bAutoActivate is false, because presumably you have a good reason for not wanting it to start ticking initially.
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=MovementComponent)

  var bAutoRegisterUpdatedComponent: bool
    ## If true, registers the owner's Root component as the UpdatedComponent if there is not one currently assigned.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=MovementComponent)

  method getGravityZ(): cfloat {.noSideEffect.}
    ## @return gravity that affects this component
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement")

  method getMaxSpeed(): cfloat {.noSideEffect.}
    ## @return Maximum speed of component in current movement mode.
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement")

  method isExceedingMaxSpeed(maxSpeed: cfloat): bool {.noSideEffect.}
    ## Returns true if the current velocity is exceeding the given max speed (usually the result of GetMaxSpeed()), within a small error tolerance.
    ## Note that under normal circumstances updates cause by acceleration will not cause this to be true, however external forces or changes in the max speed limit
    ## can cause the max speed to be violated.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement")

  method stopMovementImmediately()
    ## Stops movement immediately (zeroes velocity, usually zeros acceleration for components with acceleration).
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement")

  method shouldSkipUpdate(deltaTime: cfloat): bool {.noSideEffect.}
    ## Possibly skip update if moved component is not rendered or can't move.
    ## @param DeltaTime @todo this parameter is not used in the function.
    ## @return true if component movement update should be skipped

  method getPhysicsVolume(): ptr APhysicsVolume {.noSideEffect.}
    ## @return PhysicsVolume this MovementComponent is using, or the world's default physics volume if none. *
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement")

  method physicsVolumeChanged(newVolume: ptr APhysicsVolume)
    ## Delegate when PhysicsVolume of UpdatedComponent has been changed
    ## UFUNCTION()

  method setUpdatedComponent(newUpdatedComponent: ptr USceneComponent)
    ## Assign the component we move and update.
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement")

  method isInWater(): bool {.noSideEffect.}
    ## Return true if it's in PhysicsVolume with water flag *

  method updateTickRegistration()
    ## Update tick registration state, determined by bAutoUpdateTickRegistration. Called by SetUpdatedComponent.

  method handleImpact(hit: FHitResult; timeSlice: cfloat = 0.0;
                    moveDelta: FVector = zeroVector)
    ## Called for Blocking impact
    ## @param Hit: Describes the collision.
    ## @param TimeSlice: Time period for the simulation that produced this hit.  Useful for
    ##		  putting Hit.Time in context.  Can be zero in certain situations where it's not appropriate,
    ##		  be sure to handle that.
    ## @param MoveDelta: Attempted move that resulted in the hit.

  method updateComponentVelocity()
    ## Update ComponentVelocity of UpdatedComponent. This needs to be called by derived classes at the end of an update whenever Velocity has changed.

  method initCollisionParams(outParams: var FCollisionQueryParams;
                             outResponseParam: var FCollisionResponseParams) {.noSideEffect.}
    ## Initialize collision params appropriately based on our collision settings. Use this before any Line, Overlap, or Sweep tests.

  method overlapTest(location: FVector; rotationQuat: FQuat;
                     collisionChannel: ECollisionChannel;
                     collisionShape: FCollisionShape; ignoreActor: ptr AActor): bool {.noSideEffect.}
    ## Return true if the given collision shape overlaps other geometry at the given location and rotation. The collision params are set by InitCollisionParams().

  proc moveUpdatedComponent(delta: FVector; newRotation: FQuat; bSweep: bool;
                            outHit: ptr FHitResult = nil;
                            teleport: ETeleportType = ETeleportType.None): bool
    ## Moves our UpdatedComponent by the given Delta, and sets rotation to NewRotation. Respects the plane constraint, if enabled.
    ## @note This simply calls the virtual MoveUpdatedComponentImpl() which can be overridden to implement custom behavior.
    ## @note The overload taking rotation as an FQuat is slightly faster than the version using FRotator (which will be converted to an FQuat).
    ## @note The 'Teleport' flag is currently always treated as 'None' (not teleporting) when used in an active FScopedMovementUpdate.
    ## @return True if some movement occurred, false if no movement occurred. Result of any impact will be stored in OutHit.

  proc moveUpdatedComponent(delta: FVector; NewRotation: FRotator; bSweep: bool;
                            outHit: ptr FHitResult = nil;
                            teleport: ETeleportType = ETeleportType.None): bool

  method moveUpdatedComponentImpl(delta: FVector; newRotation: FQuat; bSweep: bool;
                                  outHit: ptr FHitResult = nil;
                                  teleport: ETeleportType = ETeleportType.None): bool

  proc K2_MoveUpdatedComponent(delta: FVector; newRotation: FRotator;
                               outHit: var FHitResult; bSweep: bool = true;
                               bTeleport: bool = false): bool
    ## Moves our UpdatedComponent by the given Delta, and sets rotation to NewRotation.
    ## Respects the plane constraint, if enabled.
    ## @return True if some movement occurred, false if no movement occurred. Result of any impact will be stored in OutHit.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement", meta=(DisplayName = "MoveUpdatedComponent", AdvancedDisplay="bTeleport"))

  proc safeMoveUpdatedComponent(delta: FVector; newRotation: FQuat; bSweep: bool;
                                outHit: var FHitResult;
                                teleport: ETeleportType = ETeleportType.None): bool
    ## Calls MoveUpdatedComponent(), handling initial penetrations by calling ResolvePenetration().
    ## If this adjustment succeeds, the original movement will be attempted again.
    ## @note The overload taking rotation as an FQuat is slightly faster than the version using FRotator (which will be converted to an FQuat).
    ## @note The 'Teleport' flag is currently always treated as 'None' (not teleporting) when used in an active FScopedMovementUpdate.
    ## @return result of the final MoveUpdatedComponent() call.

  proc safeMoveUpdatedComponent(delta: FVector; newRotation: FRotator; bSweep: bool;
                                outHit: var FHitResult;
                                teleport: ETeleportType = ETeleportType.None): bool

  method getPenetrationAdjustment(hit: FHitResult): FVector {.noSideEffect.}
    ## Calculate a movement adjustment to try to move out of a penetration from a failed move.
    ## @param Hit the result of the failed move
    ## @return The adjustment to use after a failed move, or a zero vector if no attempt should be made.

  proc resolvePenetration(adjustment: FVector; hit: FHitResult; newRotation: FQuat): bool
    ## Try to move out of penetration in an object after a failed move. This function should respect the plane constraint if applicable.
    ## @note This simply calls the virtual ResolvePenetrationImpl() which can be overridden to implement custom behavior.
    ## @note The overload taking rotation as an FQuat is slightly faster than the version using FRotator (which will be converted to an FQuat)..
    ## @param Adjustment	The requested adjustment, usually from GetPenetrationAdjustment()
    ## @param Hit			The result of the failed move
    ## @return True if the adjustment was successful and the original move should be retried, or false if no repeated attempt should be made.

  proc resolvePenetration(adjustment: FVector; hit: FHitResult; newRotation: FRotator): bool
  proc resolvePenetrationImpl(adjustment: FVector; hit: FHitResult; newRotation: FQuat): bool

  method computeSlideVector(delta: FVector; time: cfloat; normal: FVector; hit: FHitResult): FVector {.noSideEffect.}
    ## Compute a vector to slide along a surface, given an attempted move, time, and normal.
    ## @param Delta:	Attempted move.
    ## @param Time:		Amount of move to apply (between 0 and 1).
    ## @param Normal:	Normal opposed to movement. Not necessarily equal to Hit.Normal.
    ## @param Hit:		HitResult of the move that resulted in the slide.

  method slideAlongSurface(delta: FVector; time: cfloat; normal: FVector;
                         hit: var FHitResult; bHandleImpact: bool = false): cfloat
    ## Slide smoothly along a surface, and slide away from multiple impacts using TwoWallAdjust if necessary. Calls HandleImpact for each surface hit, if requested.
    ## Uses SafeMoveUpdatedComponent() for movement, and ComputeSlideVector() to determine the slide direction.
    ## @param Delta:	Attempted movement vector.
    ## @param Time:		Percent of Delta to apply (between 0 and 1). Usually equal to the remaining time after a collision: (1.0 - Hit.Time).
    ## @param Normal:	Normal opposing movement, along which we will slide.
    ## @param Hit:		[In] HitResult of the attempted move that resulted in the impact triggering the slide. [Out] HitResult of last attempted move.
    ## @param bHandleImpact:	Whether to call HandleImpact on each hit.
    ## @return The percentage of requested distance (Delta * Percent) actually applied (between 0 and 1). 0 if no movement occurred, non-zero if movement occurred.

  method twoWallAdjust(delta: var FVector; hit: FHitResult; oldHitNormal: FVector) {.noSideEffect.}
    ## Compute a movement direction when contacting two surfaces.
    ## @param Delta:		[In] Amount of move attempted before impact. [Out] Computed adjustment based on impacts.
    ## @param Hit:			Impact from last attempted move
    ## @param OldHitNormal:	Normal of impact before last attempted move
    ## @return Result in Delta that is the direction to move when contacting two surfaces.

  method addRadialForce(origin: FVector; radius: cfloat; strength: cfloat;
                      falloff: ERadialImpulseFalloff)
    ## Adds force from radial force components.
    ## Intended to be overridden by subclasses; default implementation does nothing.
    ## @param	Origin		The origin of the force
    ## @param	Radius		The radius in which the force will be applied
    ## @param	Strength	The strength of the force
    ## @param	Falloff		The falloff from the force's origin

  method addRadialImpulse(origin: FVector; radius: cfloat; strength: cfloat;
                        falloff: ERadialImpulseFalloff; bVelChange: bool)
    ## Adds impulse from radial force components.
    ## Intended to be overridden by subclasses; default implementation does nothing.
    ## @param	Origin		The origin of the force
    ## @param	Radius		The radius in which the force will be applied
    ## @param	Strength	The strength of the force
    ## @param	Falloff		The falloff from the force's origin
    ## @param	bVelChange	If true, the Strength is taken as a change in velocity instead of an impulse (ie. mass will have no affect).

  method setPlaneConstraintAxisSetting(newAxisSetting: EPlaneConstraintAxisSetting)
    ## Set the plane constraint axis setting.
    ## Changing this setting will modify the current value of PlaneConstraintNormal.
    ##
    ## @param  NewAxisSetting New plane constraint axis setting.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement|Planar")

  proc getPlaneConstraintAxisSetting(): EPlaneConstraintAxisSetting {.noSideEffect.}
    ## Get the plane constraint axis setting.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement|Planar")

  method setPlaneConstraintNormal(planeNormal: FVector)
    ## Sets the normal of the plane that constrains movement, enforced if the plane constraint is enabled.
    ## Changing the normal automatically sets PlaneConstraintAxisSetting to "Custom".
    ##
    ## @param PlaneNormal	The normal of the plane. If non-zero in length, it will be normalized.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement|Planar")

  method setPlaneConstraintFromVectors(forward: FVector; up: FVector)
    ## Uses the Forward and Up vectors to compute the plane that constrains movement, enforced if the plane constraint is enabled.
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement|Planar")

  method setPlaneConstraintOrigin(planeOrigin: FVector)
    ## Sets the origin of the plane that constrains movement, enforced if the plane constraint is enabled.
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement|Planar")

  method setPlaneConstraintEnabled(bEnabled: bool)
    ## Sets whether or not the plane constraint is enabled.
    ## UFUNCTION(BlueprintCallable, Category = "Components|Movement|Planar")

  method getPlaneConstraintNormal(): var FVector {.noSideEffect.}
    ## @return The normal of the plane that constrains movement, enforced if the plane constraint is enabled.
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement|Planar")

  method getPlaneConstraintOrigin(): var FVector {.noSideEffect.}
    ## Get the plane constraint origin. This defines the behavior of snapping a position to the plane, such as by SnapUpdatedComponentToPlane().
    ## @return The origin of the plane that constrains movement, if the plane constraint is enabled.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement|Planar")

  method constrainDirectionToPlane(direction: FVector): FVector {.noSideEffect.}
    ## Constrain a direction vector to the plane constraint, if enabled.
    ## @see SetPlaneConstraint
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement|Planar")

  method constrainLocationToPlane(location: FVector): FVector {.noSideEffect.}
    ## Constrain a position vector to the plane constraint, if enabled.
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement|Planar")

  method constrainNormalToPlane(normal: FVector): FVector {.noSideEffect.}
    ## Constrain a normal vector (of unit length) to the plane constraint, if enabled.
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement|Planar")

  method snapUpdatedComponentToPlane()
    ## Snap the updated component to the plane constraint, if enabled.
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement|Planar")

  method onTeleported()
    ## Called by owning Actor upon successful teleport from AActor::TeleportTo().
