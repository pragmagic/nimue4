
wclass(FFindFloorResult, header: "GameFramework/CharacterMovementComponent.h", bycopy):
  ## Data about the floor for walking movement, used by CharacterMovementComponent.
  var bBlockingHit: bool
    ## True if there was a blocking hit in the floor test.
  var bWalkableFloor: bool
    ## True if the hit found a valid walkable floor.
  var bLineTrace: bool
    ## True if the hit found a valid walkable floor using a line trace (rather than a sweep test, which happens when the sweep test fails to yield a walkable surface).
  var floorDist: cfloat
    ## The distance to the floor, computed from the swept capsule trace.
  var lineDist: cfloat
    ## The distance to the floor, computed from the trace. Only valid if bLineTrace is true.
  var hitResult: FHitResult
    ## Hit result of the test that found a floor. Includes more specific data about the point of impact and surface normal at that point.

  proc initFFindFloorResult(): FFindFloorResult {.constructor.}

  proc IsWalkableFloor(): bool {.noSideEffect.}
    ## Returns true if the floor result hit a walkable surface.

  proc clear()

  proc setFromSweep(inHit: FHitResult, inSweepFloorDist: cfloat, bIsWalkableFloor: bool)
  proc setFromLineTrace(inHit: FHitResult, inSweepFloorDist: cfloat, inLineDist: cfloat, bIsWalkableFloor: bool)

wclass(FCharacterMovementComponentPostPhysicsTickFunction of FTickFunction, header: "", bycopy):
  ## Tick function that calls UCharacterMovementComponent::PostPhysicsTickComponent
  var target: ptr UCharacterMovementComponent
    ## CharacterMovementComponent that is the target of this tick
  method executeTick(deltaTime: cfloat, tickType: ELevelTick, currentThread: ENamedThreads, myCompletionGraphEvent: FGraphEventRef)
    ## Abstract function actually execute the tick.
    ## @param DeltaTime - frame time to advance, in seconds
    ## @param TickType - kind of tick for this frame
    ## @param CurrentThread - thread we are executing on, useful to pass along as new tasks are created
    ## @param MyCompletionGraphEvent - completion event for this task. Useful for holding the completion of this task until certain child tasks are complete.

  method diagnosticMessage(): FString
    ## Abstract function to describe this tick. Used to print messages about illegal cycles in the dependency graph

wclass(UCharacterMovementComponent, header: "GameFramework/CharacterMovementComponent.h", notypedef):
  ## # protected:
  ## #* Character movement component belongs to
  ## # UPROPERTY()

  var characterOwner: ptr ACharacter

  ## # public:
  ## #* Custom gravity scale. Gravity is multiplied by this amount for the character.
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadWrite)

  var gravityScale: cfloat

  ## #* Maximum height character can step up
  ## # UPROPERTY(Category="Character Movement: Walking", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var maxStepHeight: cfloat

  ## #* Initial velocity (instantaneous vertical acceleration) when jumping.
  ## # UPROPERTY(Category="Character Movement: Jumping / Falling", EditAnywhere, BlueprintReadWrite, meta=(DisplayName="Jump Z Velocity", ClampMin="0", UIMin="0"))

  var jumpZVelocity: cfloat

  ## #* Fraction of JumpZVelocity to use when automatically "jumping off" of a base actor that's not allowed to be a base for a character. (For example, if you're not allowed to stand on other players.)
  ## # UPROPERTY(Category="Character Movement: Jumping / Falling", EditAnywhere, BlueprintReadWrite, AdvancedDisplay, meta=(ClampMin="0", UIMin="0"))

  var jumpOffJumpZFactor: cfloat

  ## #*
  ## #   Actor's current movement mode (walking, falling, etc).
  ## #      - walking:  Walking on a surface, under the effects of friction, and able to "step up" barriers. Vertical velocity is zero.
  ## #      - falling:  Falling under the effects of gravity, after jumping or walking off the edge of a surface.
  ## #      - flying:   Flying, ignoring the effects of gravity.
  ## #      - swimming: Swimming through a fluid volume, under the effects of gravity and buoyancy.
  ## #      - custom:   User-defined custom movement mode, including many possible sub-modes.
  ## #   This is automatically replicated through the Character owner and for client-server movement functions.
  ## #   @see SetMovementMode(), CustomMovementMode
  ## #
  ## # UPROPERTY(Category="Character Movement: MovementMode", BlueprintReadOnly)

  var movementMode: EMovementMode

  ## #*
  ## #   Current custom sub-mode if MovementMode is set to Custom.
  ## #   This is automatically replicated through the Character owner and for client-server movement functions.
  ## #   @see SetMovementMode()
  ## #
  ## # UPROPERTY(Category="Character Movement: MovementMode", BlueprintReadOnly)

  var customMovementMode: uint8

  ## #* Saved location of object we are standing on, for UpdateBasedMovement() to determine if base moved in the last frame, and therefore pawn needs an update.

  var oldBaseLocation: FVector

  ## #* Saved location of object we are standing on, for UpdateBasedMovement() to determine if base moved in the last frame, and therefore pawn needs an update.

  var oldBaseQuat: FQuat

  ## #*
  ## #   Setting that affects movement control. Higher values allow faster changes in direction.
  ## #   If bUseSeparateBrakingFriction is false, also affects the ability to stop more quickly when braking (whenever Acceleration is zero), where it is multiplied by BrakingFrictionFactor.
  ## #   When braking, this property allows you to control how much friction is applied when moving across the ground, applying an opposing force that scales with current velocity.
  ## #   This can be used to simulate slippery surfaces such as ice or oil by changing the value (possibly based on the material pawn is standing on).
  ## #   @see BrakingDecelerationWalking, BrakingFriction, bUseSeparateBrakingFriction, BrakingFrictionFactor
  ## #
  ## # UPROPERTY(Category="Character Movement: Walking", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var groundFriction: cfloat

  ## #* The maximum ground speed when walking. Also determines maximum lateral speed when falling.
  ## # UPROPERTY(Category="Character Movement: Walking", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var maxWalkSpeed: cfloat

  ## #* The maximum ground speed when walking and crouched.
  ## # UPROPERTY(Category="Character Movement: Walking", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var maxWalkSpeedCrouched: cfloat

  ## #* The maximum swimming speed.
  ## # UPROPERTY(Category="Character Movement: Swimming", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var maxSwimSpeed: cfloat

  ## #* The maximum flying speed.
  ## # UPROPERTY(Category="Character Movement: Flying", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var maxFlySpeed: cfloat

  ## #* The maximum speed when using Custom movement mode.
  ## # UPROPERTY(Category="Character Movement: Custom Movement", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var maxCustomMovementSpeed: cfloat

  ## #* Max Acceleration (rate of change of velocity)
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var maxAcceleration: cfloat

  ## #*
  ## #   Factor used to multiply actual value of friction used when braking.
  ## #   This applies to any friction value that is currently used, which may depend on bUseSeparateBrakingFriction.
  ## #   @note This is 2 by default for historical reasons, a value of 1 gives the true drag equation.
  ## #   @see bUseSeparateBrakingFriction, GroundFriction, BrakingFriction
  ## #
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var brakingFrictionFactor: cfloat

  ## #*
  ## #   Friction (drag) coefficient applied when braking (whenever Acceleration = 0, or if character is exceeding max speed); actual value used is this multiplied by BrakingFrictionFactor.
  ## #   When braking, this property allows you to control how much friction is applied when moving across the ground, applying an opposing force that scales with current velocity.
  ## #   Braking is composed of friction (velocity-dependent drag) and constant deceleration.
  ## #   This is the current value, used in all movement modes; if this is not desired, override it or bUseSeparateBrakingFriction when movement mode changes.
  ## #   @note Only used if bUseSeparateBrakingFriction setting is true, otherwise current friction such as GroundFriction is used.
  ## #   @see bUseSeparateBrakingFriction, BrakingFrictionFactor, GroundFriction, BrakingDecelerationWalking
  ## #
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0", EditCondition="bUseSeparateBrakingFriction"))

  var brakingFriction: cfloat

  ## #*
  ## #   If true, BrakingFriction will be used to slow the character to a stop (when there is no Acceleration).
  ## #   If false, braking uses the same friction passed to CalcVelocity() (ie GroundFriction when walking), multiplied by BrakingFrictionFactor.
  ## #   This setting applies to all movement modes; if only desired in certain modes, consider toggling it when movement modes change.
  ## #   @see BrakingFriction
  ## #
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditDefaultsOnly, BlueprintReadWrite)

  var bUseSeparateBrakingFriction: bool

  ## #*
  ## #   Deceleration when walking and not applying acceleration. This is a constant opposing force that directly lowers velocity by a constant value.
  ## #   @see GroundFriction, MaxAcceleration
  ## #
  ## # UPROPERTY(Category="Character Movement: Walking", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var brakingDecelerationWalking: cfloat

  ## #*
  ## #   Lateral deceleration when falling and not applying acceleration.
  ## #   @see MaxAcceleration
  ## #
  ## # UPROPERTY(Category="Character Movement: Jumping / Falling", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var brakingDecelerationFalling: cfloat

  ## #*
  ## #   Deceleration when swimming and not applying acceleration.
  ## #   @see MaxAcceleration
  ## #
  ## # UPROPERTY(Category="Character Movement: Swimming", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var brakingDecelerationSwimming: cfloat

  ## #*
  ## #   Deceleration when flying and not applying acceleration.
  ## #   @see MaxAcceleration
  ## #
  ## # UPROPERTY(Category="Character Movement: Flying", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var brakingDecelerationFlying: cfloat

  ## #*
  ## #   When falling, amount of lateral movement control available to the character.
  ## #   0 = no control, 1 = full control at max speed of MaxWalkSpeed.
  ## #
  ## # UPROPERTY(Category="Character Movement: Jumping / Falling", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var airControl: cfloat

  ## #*
  ## #   When falling, multiplier applied to AirControl when lateral velocity is less than AirControlBoostVelocityThreshold.
  ## #   Setting this to zero will disable air control boosting. Final result is clamped at 1.
  ## #
  ## # UPROPERTY(Category="Character Movement: Jumping / Falling", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var airControlBoostMultiplier: cfloat

  ## #*
  ## #   When falling, if lateral velocity magnitude is less than this value, AirControl is multiplied by AirControlBoostMultiplier.
  ## #   Setting this to zero will disable air control boosting.
  ## #
  ## # UPROPERTY(Category="Character Movement: Jumping / Falling", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var airControlBoostVelocityThreshold: cfloat

  ## #*
  ## #   Friction to apply to lateral air movement when falling.
  ## #   If bUseSeparateBrakingFriction is false, also affects the ability to stop more quickly when braking (whenever Acceleration is zero).
  ## #   @see BrakingFriction, bUseSeparateBrakingFriction
  ## #
  ## # UPROPERTY(Category="Character Movement: Jumping / Falling", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var fallingLateralFriction: cfloat

  ## #* Collision half-height when crouching (component scale is applied separately)
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadOnly, meta=(ClampMin="0", UIMin="0"))

  var crouchedHalfHeight: cfloat

  ## #* Water buoyancy. A ratio (1.0 = neutral buoyancy, 0.0 = no buoyancy)
  ## # UPROPERTY(Category="Character Movement: Swimming", EditAnywhere, BlueprintReadWrite)

  var buoyancy: cfloat

  ## #*
  ## #   Don't allow the character to perch on the edge of a surface if the contact is this close to the edge of the capsule.
  ## #   Note that characters will not fall off if they are within MaxStepHeight of a walkable surface below.
  ## #
  ## # UPROPERTY(Category="Character Movement: Walking", EditAnywhere, BlueprintReadWrite, AdvancedDisplay, meta=(ClampMin="0", UIMin="0"))

  var perchRadiusThreshold: cfloat

  ## #*
  ## #   When perching on a ledge, add this additional distance to MaxStepHeight when determining how high above a walkable floor we can perch.
  ## #   Note that we still enforce MaxStepHeight to start the step up; this just allows the character to hang off the edge or step slightly higher off the floor.
  ## #   (@see PerchRadiusThreshold)
  ## #
  ## # UPROPERTY(Category="Character Movement: Walking", EditAnywhere, BlueprintReadWrite, AdvancedDisplay, meta=(ClampMin="0", UIMin="0"))

  var perchAdditionalHeight: cfloat

  ## #* Change in rotation per second, used when UseControllerDesiredRotation or OrientRotationToMovement are true. Set a negative value for infinite rotation rate and instant turns.
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadWrite)

  var rotationRate: FRotator

  ## #* If true, smoothly rotate the Character toward the Controller's desired rotation, using RotationRate as the rate of rotation change. Overridden by OrientRotationToMovement.
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadWrite, AdvancedDisplay)

  var bUseControllerDesiredRotation: bool

  ## #*
  ## #   If true, rotate the Character toward the direction of acceleration, using RotationRate as the rate of rotation change. Overrides UseControllerDesiredRotation.
  ## #   Normally you will want to make sure that other settings are cleared, such as bUseControllerRotationYaw on the Character.
  ## #
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadWrite)

  var bOrientRotationToMovement: bool

  ## # protected:
  ## #*
  ## #   True during movement update.
  ## #   Used internally so that attempts to change CharacterOwner and UpdatedComponent are deferred until after an update.
  ## #   @see IsMovementInProgress()
  ## #
  ## # UPROPERTY()

  var bMovementInProgress: bool

  ## # public:
  ## #*
  ## #   If true, high-level movement updates will be wrapped in a movement scope that accumulates updates and defers a bulk of the work until the end.
  ## #   When enabled, touch and hit events will not be triggered until the end of multiple moves within an update, which can improve performance.
  ## #
  ## #   @see FScopedMovementUpdate
  ## #
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, AdvancedDisplay)

  var bEnableScopedMovementUpdates: bool

  ## #* Ignores size of acceleration component, and forces max acceleration to drive character at full velocity.
  ## # UPROPERTY()

  var bForceMaxAccel: bool

  ## #*
  ## #   If true, movement will be performed even if there is no Controller for the Character owner.
  ## #   Normally without a Controller, movement will be aborted and velocity and acceleration are zeroed if the character is walking.
  ## #   Characters that are spawned without a Controller but with this flag enabled will initialize the movement mode to DefaultLandMovementMode or DefaultWaterMovementMode appropriately.
  ## #   @see DefaultLandMovementMode, DefaultWaterMovementMode
  ## #
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadWrite, AdvancedDisplay)

  var bRunPhysicsWithNoController: bool

  ## #*
  ## #   Force the Character in MOVE_Walking to do a check for a valid floor even if he hasn't moved. Cleared after next floor check.
  ## #   Normally if bAlwaysCheckFloor is false we try to avoid the floor check unless some conditions are met, but this can be used to force the next check to always run.
  ## #
  ## # UPROPERTY(Category="Character Movement: Walking", VisibleInstanceOnly, BlueprintReadWrite, AdvancedDisplay)

  var bForceNextFloorCheck: bool

  ## #* If true, the capsule needs to be shrunk on this simulated proxy, to avoid replication rounding putting us in geometry.
  ## #    Whenever this is set to true, this will cause the capsule to be shrunk again on the next update, and then set to false.
  ## # UPROPERTY()

  var bShrinkProxyCapsule: bool

  ## #* If true, Character can walk off a ledge.
  ## # UPROPERTY(Category="Character Movement: Walking", EditAnywhere, BlueprintReadWrite)

  var bCanWalkOffLedges: bool

  ## #* If true, Character can walk off a ledge when crouching.
  ## # UPROPERTY(Category="Character Movement: Walking", EditAnywhere, BlueprintReadWrite)

  var bCanWalkOffLedgesWhenCrouching: bool

  ## #*
  ## #   Signals that smoothed position/rotation has reached target, and no more smoothing is necessary until a future update.
  ## #   This is used as an optimization to skip calls to SmoothClientPosition() when true. SmoothCorrection() sets it false when a new network update is received.
  ## #   SmoothClientPosition_Interpolate() sets this to true when the interpolation reaches the target, before one last call to SmoothClientPosition_UpdateVisuals().
  ## #   If this is not desired, override SmoothClientPosition() to always set this to false to avoid this feature.
  ## #

  var bNetworkSmoothingComplete: bool

  ## #* true to update CharacterOwner and UpdatedComponent after movement ends
  ## # UPROPERTY()

  var bDeferUpdateMoveComponent: bool

  ## #* What to update CharacterOwner and UpdatedComponent after movement ends
  ## # UPROPERTY()

  var deferredUpdatedMoveComponent: ptr USceneComponent

  ## #* Maximum step height for getting out of water
  ## # UPROPERTY(Category="Character Movement: Swimming", EditAnywhere, BlueprintReadWrite, AdvancedDisplay, meta=(ClampMin="0", UIMin="0"))

  var maxOutOfWaterStepHeight: cfloat

  ## #* Z velocity applied when pawn tries to get out of water
  ## # UPROPERTY(Category="Character Movement: Swimming", EditAnywhere, BlueprintReadWrite, AdvancedDisplay)

  var outofWaterZ: cfloat

  ## #* Mass of pawn (for when momentum is imparted to it).
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadWrite, meta=(ClampMin="0", UIMin="0"))

  var mass: cfloat

  ## #* If enabled, the player will interact with physics objects when walking into them.
  ## # UPROPERTY(Category="Character Movement: Physics Interaction", EditAnywhere, BlueprintReadWrite)

  var bEnablePhysicsInteraction: bool

  ## #* If enabled, the TouchForceFactor is applied per kg mass of the affected object.
  ## # UPROPERTY(Category="Character Movement: Physics Interaction", EditAnywhere, BlueprintReadWrite, meta=(editcondition = "bEnablePhysicsInteraction"))

  var bTouchForceScaledToMass: bool

  ## #* If enabled, the PushForceFactor is applied per kg mass of the affected object.
  ## # UPROPERTY(Category="Character Movement: Physics Interaction", EditAnywhere, BlueprintReadWrite, meta=(editcondition = "bEnablePhysicsInteraction"))

  var bPushForceScaledToMass: bool

  ## #* If enabled, the applied push force will try to get the physics object to the same velocity than the player, not faster. This will only
  ## #  scale the force down, it will never apply more force than defined by PushForceFactor.
  ## # UPROPERTY(Category="Character Movement: Physics Interaction", EditAnywhere, BlueprintReadWrite, meta=(editcondition = "bEnablePhysicsInteraction"))

  var bScalePushForceToVelocity: bool

  ## #* Force applied to objects we stand on (due to Mass and Gravity) is scaled by this amount.
  ## # UPROPERTY(Category="Character Movement: Physics Interaction", EditAnywhere, BlueprintReadWrite, meta=(editcondition = "bEnablePhysicsInteraction"))

  var standingDownwardForceScale: cfloat

  ## #* Initial impulse force to apply when the player bounces into a blocking physics object.
  ## # UPROPERTY(Category="Character Movement: Physics Interaction", EditAnywhere, BlueprintReadWrite, meta=(editcondition = "bEnablePhysicsInteraction"))

  var initialPushForceFactor: cfloat

  ## #* Force to apply when the player collides with a blocking physics object.
  ## # UPROPERTY(Category="Character Movement: Physics Interaction", EditAnywhere, BlueprintReadWrite, meta=(editcondition = "bEnablePhysicsInteraction"))

  var pushForceFactor: cfloat

  ## #* Z-Offset for the position the force is applied to. 0.0f is the center of the physics object, 1.0f is the top and -1.0f is the bottom of the object.
  ## # UPROPERTY(Category="Character Movement: Physics Interaction", EditAnywhere, BlueprintReadWrite, meta=(UIMin = "-1.0", UIMax = "1.0"), meta=(editcondition = "bEnablePhysicsInteraction"))

  var pushForcePointZOffsetFactor: cfloat

  ## #* Force to apply to physics objects that are touched by the player.
  ## # UPROPERTY(Category="Character Movement: Physics Interaction", EditAnywhere, BlueprintReadWrite, meta=(editcondition = "bEnablePhysicsInteraction"))

  var touchForceFactor: cfloat

  ## #* Minimum Force applied to touched physics objects. If < 0.0f, there is no minimum.
  ## # UPROPERTY(Category="Character Movement: Physics Interaction", EditAnywhere, BlueprintReadWrite, meta=(editcondition = "bEnablePhysicsInteraction"))

  var minTouchForce: cfloat

  ## #* Maximum force applied to touched physics objects. If < 0.0f, there is no maximum.
  ## # UPROPERTY(Category="Character Movement: Physics Interaction", EditAnywhere, BlueprintReadWrite, meta=(editcondition = "bEnablePhysicsInteraction"))

  var maxTouchForce: cfloat

  ## #* Force per kg applied constantly to all overlapping components.
  ## # UPROPERTY(Category="Character Movement: Physics Interaction", EditAnywhere, BlueprintReadWrite, meta=(editcondition = "bEnablePhysicsInteraction"))

  var repulsionForce: cfloat

  ## # protected:
  ## #*
  ## #   Current acceleration vector (with magnitude).
  ## #   This is calculated each update based on the input vector and the constraints of MaxAcceleration and the current movement mode.
  ## #
  ## # UPROPERTY()

  var acceleration: FVector

  ## #*
  ## #   Location after last PerformMovement update. Used internally to detect changes in position from outside character movement to try to validate the current floor.
  ## #
  ## # UPROPERTY()

  var lastUpdateLocation: FVector

  ## #*
  ## #   Velocity after last PerformMovement update. Used internally to detect changes in velocity from external sources.
  ## #
  ## # UPROPERTY()

  var lastUpdateVelocity: FVector

  ## #* Accumulated impulse to be added next tick.
  ## # UPROPERTY()

  var pendingImpulseToApply: FVector

  ## #* Accumulated force to be added next tick.
  ## # UPROPERTY()

  var pendingForceToApply: FVector

  ## #*
  ## #   Modifier to applied to values such as acceleration and max speed due to analog input.
  ## #
  ## # UPROPERTY()

  var analogInputModifier: cfloat

  ## #* Computes the analog input modifier based on current input vector and/or acceleration.

  proc computeAnalogInputModifier(): cfloat {.noSideEffect.}
  ## # public:
  ## #*
  ## #   Compute remaining time step given remaining time and current iterations.
  ## #   The last iteration (limited by MaxSimulationIterations) always returns the remaining time, which may violate MaxSimulationTimeStep.
  ## #
  ## #   @param RemainingTime		Remaining time in the tick.
  ## #   @param Iterations		Current iteration of the tick (starting at 1).
  ## #   @return The remaining time step to use for the next sub-step of iteration.
  ## #   @see MaxSimulationTimeStep, MaxSimulationIterations
  ## #

  proc getSimulationTimeStep(remainingTime: cfloat; iterations: int32): cfloat {.
      noSideEffect.}
  ## #*
  ## #   Max time delta for each discrete simulation step.
  ## #   Used primarily in the the more advanced movement modes that break up larger time steps (usually those applying gravity such as falling and walking).
  ## #   Lowering this value can address issues with fast-moving objects or complex collision scenarios, at the cost of performance.
  ## #
  ## #   WARNING: if (MaxSimulationTimeStep * MaxSimulationIterations) is too low for the min framerate, the last simulation step may exceed MaxSimulationTimeStep to complete the simulation.
  ## #   @see MaxSimulationIterations
  ## #
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadWrite, AdvancedDisplay, meta=(ClampMin="0.0166", ClampMax="0.50", UIMin="0.0166", UIMax="0.50"))

  var maxSimulationTimeStep: cfloat

  ## #*
  ## #   Max number of iterations used for each discrete simulation step.
  ## #   Used primarily in the the more advanced movement modes that break up larger time steps (usually those applying gravity such as falling and walking).
  ## #   Increasing this value can address issues with fast-moving objects or complex collision scenarios, at the cost of performance.
  ## #
  ## #   WARNING: if (MaxSimulationTimeStep * MaxSimulationIterations) is too low for the min framerate, the last simulation step may exceed MaxSimulationTimeStep to complete the simulation.
  ## #   @see MaxSimulationTimeStep
  ## #
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadWrite, AdvancedDisplay, meta=(ClampMin="1", ClampMax="25", UIMin="1", UIMax="25"))

  var maxSimulationIterations: int32

  ## #*
  ## #   How long to take to smoothly interpolate from the old pawn position on the client to the corrected one sent by the server. Not used by Linear smoothing.
  ## #
  ## # UPROPERTY(Category="Character Movement (Networking)", EditDefaultsOnly, AdvancedDisplay, meta=(ClampMin="0.0", ClampMax="1.0", UIMin="0.0", UIMax="1.0"))

  var networkSimulatedSmoothLocationTime: cfloat

  ## #*
  ## #   How long to take to smoothly interpolate from the old pawn rotation on the client to the corrected one sent by the server. Not used by Linear smoothing.
  ## #
  ## # UPROPERTY(Category="Character Movement (Networking)", EditDefaultsOnly, AdvancedDisplay, meta=(ClampMin="0.0", ClampMax="1.0", UIMin="0.0", UIMax="1.0"))

  var networkSimulatedSmoothRotationTime: cfloat

  ## #* Maximum distance character is allowed to lag behind server location when interpolating between updates.
  ## # UPROPERTY(Category="Character Movement (Networking)", EditDefaultsOnly, meta=(ClampMin="0.0", UIMin="0.0"))

  var networkMaxSmoothUpdateDistance: cfloat

  ## #*
  ## #   Maximum distance beyond which character is teleported to the new server location without any smoothing.
  ## #
  ## # UPROPERTY(Category="Character Movement (Networking)", EditDefaultsOnly, meta=(ClampMin="0.0", UIMin="0.0"))

  var networkNoSmoothUpdateDistance: cfloat

  ## #* Smoothing mode for simulated proxies in network game.
  ## # UPROPERTY(Category="Character Movement (Networking)", EditAnywhere, BlueprintReadOnly)

  var networkSmoothingMode: ENetworkSmoothingMode

  ## #* Used in determining if pawn is going off ledge.  If the ledge is "shorter" than this value then the pawn will be able to walk off it. *
  ## # UPROPERTY(Category="Character Movement: Walking", EditAnywhere, BlueprintReadWrite, AdvancedDisplay)

  var ledgeCheckThreshold: cfloat

  ## #* When exiting water, jump if control pitch angle is this high or above.
  ## # UPROPERTY(Category="Character Movement: Swimming", EditAnywhere, BlueprintReadWrite, AdvancedDisplay)

  var jumpOutOfWaterPitch: cfloat

  ## #* Information about the floor the Character is standing on (updated only during walking movement).
  ## # UPROPERTY(Category="Character Movement: Walking", VisibleInstanceOnly, BlueprintReadOnly)

  var currentFloor: FFindFloorResult

  ## #*
  ## #   Default movement mode when not in water. Used at player startup or when teleported.
  ## #   @see DefaultWaterMovementMode
  ## #   @see bRunPhysicsWithNoController
  ## #
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadWrite)

  var defaultLandMovementMode: EMovementMode

  ## #*
  ## #   Default movement mode when in water. Used at player startup or when teleported.
  ## #   @see DefaultLandMovementMode
  ## #   @see bRunPhysicsWithNoController
  ## #
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadWrite)

  var defaultWaterMovementMode: EMovementMode

  ## # public:
  ## #*
  ## #   If true, walking movement always maintains horizontal velocity when moving up ramps, which causes movement up ramps to be faster parallel to the ramp surface.
  ## #   If false, then walking movement maintains velocity magnitude parallel to the ramp surface.
  ## #
  ## # UPROPERTY(Category="Character Movement: Walking", EditAnywhere, BlueprintReadWrite)

  var bMaintainHorizontalGroundVelocity: bool

  ## #* If true, impart the base actor's X velocity when falling off it (which includes jumping)
  ## # UPROPERTY(Category="Character Movement: Jumping / Falling", EditAnywhere, BlueprintReadWrite)

  var bImpartBaseVelocityX: bool

  ## #* If true, impart the base actor's Y velocity when falling off it (which includes jumping)
  ## # UPROPERTY(Category="Character Movement: Jumping / Falling", EditAnywhere, BlueprintReadWrite)

  var bImpartBaseVelocityY: bool

  ## #* If true, impart the base actor's Z velocity when falling off it (which includes jumping)
  ## # UPROPERTY(Category="Character Movement: Jumping / Falling", EditAnywhere, BlueprintReadWrite)

  var bImpartBaseVelocityZ: bool

  ## #*
  ## #   If true, impart the base component's tangential components of angular velocity when jumping or falling off it.
  ## #   Only those components of the velocity allowed by the separate component settings (bImpartBaseVelocityX etc) will be applied.
  ## #   @see bImpartBaseVelocityX, bImpartBaseVelocityY, bImpartBaseVelocityZ
  ## #
  ## # UPROPERTY(Category="Character Movement: Jumping / Falling", EditAnywhere, BlueprintReadWrite)

  var bImpartBaseAngularVelocity: bool

  ## #* Used by movement code to determine if a change in position is based on normal movement or a teleport. If not a teleport, velocity can be recomputed based on the change in position.
  ## # UPROPERTY(Category="Character Movement (General Settings)", Transient, VisibleInstanceOnly, BlueprintReadWrite)

  var bJustTeleported: bool

  ## #* True when a network replication update is received for simulated proxies.
  ## # UPROPERTY(Transient)

  var bNetworkUpdateReceived: bool

  ## #* True when the networked movement mode has been replicated.
  ## # UPROPERTY(Transient)

  var bNetworkMovementModeChanged: bool

  ## #*
  ## #   True when we should ignore server location difference checks for client error on this movement component
  ## #   This can be useful when character is moving at extreme speeds for a duration and you need it to look
  ## #   smooth on clients. Make sure to disable when done, as this would break this character's server-client
  ## #   movement correction.
  ## #
  ## # UPROPERTY(Transient, Category="Character Movement", EditAnywhere, BlueprintReadWrite)

  var bIgnoreClientMovementErrorChecksAndCorrection: bool

  ## #* if true, event NotifyJumpApex() to CharacterOwner's controller when at apex of jump.  Is cleared when event is triggered.
  ## # UPROPERTY(Category="Character Movement: Jumping / Falling", EditAnywhere, BlueprintReadWrite)

  var bNotifyApex: bool

  ## #* Instantly stop when in flying mode and no acceleration is being applied.
  ## # UPROPERTY()

  var bCheatFlying: bool

  ## #* If true, try to crouch (or keep crouching) on next update. If false, try to stop crouching on next update.
  ## # UPROPERTY(Category="Character Movement (General Settings)", VisibleInstanceOnly, BlueprintReadOnly)

  var bWantsToCrouch: bool

  ## #*
  ## #   If true, crouching should keep the base of the capsule in place by lowering the center of the shrunken capsule. If false, the base of the capsule moves up and the center stays in place.
  ## #   The same behavior applies when the character uncrouches: if true, the base is kept in the same location and the center moves up. If false, the capsule grows and only moves up if the base impacts something.
  ## #   By default this variable is set when the movement mode changes: set to true when walking and false otherwise. Feel free to override the behavior when the movement mode changes.
  ## #
  ## # UPROPERTY(Category="Character Movement (General Settings)", VisibleInstanceOnly, BlueprintReadWrite, AdvancedDisplay)

  var bCrouchMaintainsBaseLocation: bool

  ## #*
  ## #   Whether the character ignores changes in rotation of the base it is standing on.
  ## #   If true, the character maintains current world rotation.
  ## #   If false, the character rotates with the moving base.
  ## #
  ## # UPROPERTY(Category="Character Movement: Walking", EditAnywhere, BlueprintReadWrite)

  var bIgnoreBaseRotation: bool

  ## #*
  ## #   Set this to true if riding on a moving base that you know is clear from non-moving world obstructions.
  ## #   Optimization to avoid sweeps during based movement, use with care.
  ## #
  ## # UPROPERTY()

  var bFastAttachedMove: bool

  ## #*
  ## #   Whether we always force floor checks for stationary Characters while walking.
  ## #   Normally floor checks are avoided if possible when not moving, but this can be used to force them if there are use-cases where they are being skipped erroneously
  ## #   (such as objects moving up into the character from below).
  ## #
  ## # UPROPERTY(Category="Character Movement: Walking", EditAnywhere, BlueprintReadWrite, AdvancedDisplay)

  var bAlwaysCheckFloor: bool

  ## #*
  ## #   Performs floor checks as if the character is using a shape with a flat base.
  ## #   This avoids the situation where characters slowly lower off the side of a ledge (as their capsule 'balances' on the edge).
  ## #
  ## # UPROPERTY(Category="Character Movement: Walking", EditAnywhere, BlueprintReadWrite, AdvancedDisplay)

  var bUseFlatBaseForFloorChecks: bool

  ## #* Used to prevent reentry of JumpOff()
  ## # UPROPERTY()

  var bPerformingJumpOff: bool

  ## #* Used to safely leave NavWalking movement mode
  ## # UPROPERTY()

  var bWantsToLeaveNavWalking: bool

  ## #* If set, component will use RVO avoidance. This only runs on the server.
  ## # UPROPERTY(Category="Character Movement: Avoidance", EditAnywhere, BlueprintReadOnly)

  var bUseRVOAvoidance: bool

  ## #*
  ## #   Should use acceleration for path following?
  ## #   If true, acceleration is applied when path following to reach the target velocity.
  ## #   If false, path following velocity is set directly, disregarding acceleration.
  ## #
  ## # UPROPERTY(Category="Character Movement (General Settings)", EditAnywhere, BlueprintReadWrite, AdvancedDisplay)

  var bRequestedMoveUseAcceleration: bool

  ## # protected:
  ## # AI PATH FOLLOWING
  ## #* Was velocity requested by path following?
  ## # UPROPERTY(Transient)

  var bHasRequestedVelocity: bool

  ## #* Was acceleration requested to be always max speed?
  ## # UPROPERTY(Transient)

  var bRequestedMoveWithMaxSpeed: bool

  ## #* Was avoidance updated in this frame?
  ## # UPROPERTY(Transient)

  var bWasAvoidanceUpdated: bool

  ## #* if set, PostProcessAvoidanceVelocity will be called

  var bUseRVOPostProcess: bool

  ## #* Flag set in pre-physics update to indicate that based movement should be updated post-physics

  var bDeferUpdateBasedMovement: bool

  ## #* Whether to raycast to underlying geometry to better conform navmesh-walking characters
  ## # UPROPERTY(Category="Character Movement: NavMesh Movement", EditAnywhere, BlueprintReadOnly)

  var bProjectNavMeshWalking: bool

  ## #* Use both WorldStatic and WorldDynamic channels for NavWalking geometry conforming
  ## # UPROPERTY(Category = "Character Movement: NavMesh Movement", EditAnywhere, BlueprintReadOnly, AdvancedDisplay)

  var bProjectNavMeshOnBothWorldChannels: bool

  ## #* forced avoidance velocity, used when AvoidanceLockTimer is > 0

  var avoidanceLockVelocity: FVector

  ## #* remaining time of avoidance velocity lock

  var avoidanceLockTimer: cfloat

  ## # public:
  ## # UPROPERTY(Category="Character Movement: Avoidance", EditAnywhere, BlueprintReadOnly)

  var avoidanceConsiderationRadius: cfloat

  ## #*
  ## #   Velocity requested by path following.
  ## #   @see RequestDirectMove()
  ## #
  ## # UPROPERTY(Transient)

  var requestedVelocity: FVector

  ## #* No default value, for now it's assumed to be valid if GetAvoidanceManager() returns non-NULL.
  ## # UPROPERTY(Category="Character Movement: Avoidance", VisibleAnywhere, BlueprintReadOnly, AdvancedDisplay)

  var avoidanceUID: int32

  ## #* Moving actor's group mask
  ## # UPROPERTY(Category="Character Movement: Avoidance", EditAnywhere, BlueprintReadOnly, AdvancedDisplay)

  var avoidanceGroup: FNavAvoidanceMask

  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc setAvoidanceGroup(groupFlags: int32)
  ## #* Will avoid other agents if they are in one of specified groups
  ## # UPROPERTY(Category="Character Movement: Avoidance", EditAnywhere, BlueprintReadOnly, AdvancedDisplay)

  var groupsToAvoid: FNavAvoidanceMask

  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc setGroupsToAvoid(groupFlags: int32)
  ## #* Will NOT avoid other agents if they are in one of specified groups, higher priority than GroupsToAvoid
  ## # UPROPERTY(Category="Character Movement: Avoidance", EditAnywhere, BlueprintReadOnly, AdvancedDisplay)

  var groupsToIgnore: FNavAvoidanceMask

  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc setGroupsToIgnore(groupFlags: int32)
  ## #* De facto default value 0.5 (due to that being the default in the avoidance registration function), indicates RVO behavior.
  ## # UPROPERTY(Category="Character Movement: Avoidance", EditAnywhere, BlueprintReadOnly)

  var avoidanceWeight: cfloat

  ## #* Temporarily holds launch velocity when pawn is to be launched so it happens at end of movement.
  ## # UPROPERTY()

  var pendingLaunchVelocity: FVector

  ## #* last known location projected on navmesh, used by NavWalking mode

  var cachedNavLocation: FNavLocation

  ## #* Last valid projected hit result from raycast to geometry from navmesh

  var cachedProjectedNavMeshHitResult: FHitResult

  ## #* How often we should raycast to project from navmesh to underlying geometry
  ## # UPROPERTY(Category="Character Movement: NavMesh Movement", EditAnywhere, BlueprintReadWrite, meta=(editcondition = "bProjectNavMeshWalking"))

  var navMeshProjectionInterval: cfloat

  ## # UPROPERTY(Transient)

  var navMeshProjectionTimer: cfloat

  ## #* Speed at which to interpolate agent navmesh offset between traces. 0: Instant (no interp) > 0: Interp speed")
  ## # UPROPERTY(Category="Character Movement: NavMesh Movement", EditAnywhere, BlueprintReadWrite, meta=(editcondition = "bProjectNavMeshWalking", ClampMin="0", UIMin="0"))

  var navMeshProjectionInterpSpeed: cfloat

  ## #*
  ## #   Scale of the total capsule height to use for projection from navmesh to underlying geometry in the upward direction.
  ## #   In other words, start the trace at [CapsuleHeight * NavMeshProjectionHeightScaleUp] above nav mesh.
  ## #
  ## # UPROPERTY(Category="Character Movement: NavMesh Movement", EditAnywhere, BlueprintReadWrite, meta=(editcondition = "bProjectNavMeshWalking", ClampMin="0", UIMin="0"))

  var navMeshProjectionHeightScaleUp: cfloat

  ## #*
  ## #   Scale of the total capsule height to use for projection from navmesh to underlying geometry in the downward direction.
  ## #   In other words, trace down to [CapsuleHeight * NavMeshProjectionHeightScaleDown] below nav mesh.
  ## #
  ## # UPROPERTY(Category="Character Movement: NavMesh Movement", EditAnywhere, BlueprintReadWrite, meta=(editcondition = "bProjectNavMeshWalking", ClampMin="0", UIMin="0"))

  var navMeshProjectionHeightScaleDown: cfloat

  ## #* Change avoidance state and registers in RVO manager if needed
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement", meta = (UnsafeDuringActorConstruction = "true"))

  proc setAvoidanceEnabled(bEnable: bool)
  ## #* Get the Character that owns UpdatedComponent.
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc getCharacterOwner(): ptr ACharacter {.noSideEffect.}
  ## #*
  ## #   Change movement mode.
  ## #
  ## #   @param NewMovementMode	The new movement mode
  ## #   @param NewCustomMode		The new custom sub-mode, only applicable if NewMovementMode is Custom.
  ## #
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc setMovementMode(newMovementMode: EMovementMode; newCustomMode: uint8 = 0)
  ## #*
  ## #   Set movement mode to use when returning to walking movement (either MOVE_Walking or MOVE_NavWalking).
  ## #   If movement mode is currently one of Walking or NavWalking, this will also change the current movement mode (via SetMovementMode())
  ## #   if the new mode is not the current ground mode.
  ## #
  ## #   @param  NewGroundMovementMode New ground movement mode. Must be either MOVE_Walking or MOVE_NavWalking, other values are ignored.
  ## #   @see GroundMovementMode
  ## #

  proc setGroundMovementMode(newGroundMovementMode: EMovementMode)
  ## #*
  ## #   Get current GroundMovementMode value.
  ## #   @return current GroundMovementMode
  ## #   @see GroundMovementMode, SetGroundMovementMode()
  ## #

  proc getGroundMovementMode(): EMovementMode {.noSideEffect.}
  ## # protected:
  ## #* Called after MovementMode has changed. Base implementation does special handling for starting certain modes, then notifies the CharacterOwner.

  proc onMovementModeChanged(previousMovementMode: EMovementMode;
                            previousCustomMode: uint8)
  ## # public:

  proc packNetworkMovementMode(): uint8 {.noSideEffect.}
  proc unpackNetworkMovementMode(receivedMode: uint8;
                                outMode: var EMovementMode;
                                outCustomMode: var uint8;
                                outGroundMode: var EMovementMode) {.
      noSideEffect.}
  proc applyNetworkMovementMode(receivedMode: uint8)
  ## #* @return true if the character is in the 'Walking' movement mode.
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc isWalking(): bool {.noSideEffect.}
  ## #*
  ## #   @return true if currently performing a movement update.
  ## #   @see bMovementInProgress
  ## #

  proc isMovementInProgress(): bool {.noSideEffect.}

# when WITH_EDITOR:
  # proc postEditChangeProperty(propertyChangedEvent: var FPropertyChangedEvent)
# endwhen
  ## #* Make movement impossible (sets movement mode to MOVE_None).
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc disableMovement()
  ## #* Return true if we have a valid CharacterOwner and UpdatedComponent.

  proc hasValidData(): bool {.noSideEffect.}
  ## #*
  ## #   Update Velocity and Acceleration to air control in the desired Direction for character using path following.
  ## #   @param Direction is the desired direction of movement
  ## #   @param ZDiff is the height difference between the destination and the Pawn's current position
  ## #   @see RequestDirectMove()
  ## #

  proc performAirControlForPathFollowing(direction: FVector; ZDiff: cfloat)
  ## #* Transition from walking to falling

  proc startFalling(iterations: int32; remainingTime: cfloat; timeTick: cfloat;
                  delta: FVector; subLoc: FVector)
  ## #*
  ## #   Whether Character should go into falling mode when walking and changing position, based on an old and new floor result (both of which are considered walkable).
  ## #   Default implementation always returns false.
  ## #   @return true if Character should start falling
  ## #

  proc shouldCatchAir(oldFloor: FFindFloorResult; newFloor: FFindFloorResult): bool
  ## #* Adjust distance from floor, trying to maintain a slight offset from the floor when walking (based on CurrentFloor).

  proc adjustFloorHeight()
  ## #* Return PrimitiveComponent we are based on (standing and walking on).
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc getMovementBase(): ptr UPrimitiveComponent {.noSideEffect.}
  ## #* Update or defer updating of position based on Base movement

  proc maybeUpdateBasedMovement(deltaSeconds: cfloat)
  ## #* Update position based on Base movement

  proc updateBasedMovement(deltaSeconds: cfloat)
  ## #* Update controller's view rotation as pawn's base rotates

  proc updateBasedRotation(finalRotation: var FRotator; reducedRotation: FRotator)
  ## #* Call SaveBaseLocation() if not deferring updates (bDeferUpdateBasedMovement is false).

  proc maybeSaveBaseLocation()
  ## #* Update OldBaseLocation and OldBaseQuat if there is a valid movement base, and store the relative location/rotation if necessary. Ignores bDeferUpdateBasedMovement and forces the update.

  proc saveBaseLocation()
  ## #* changes physics based on MovementMode

  proc startNewPhysics(deltaTime: cfloat; iterations: int32)
  ## #*
  ## #   Perform jump. Called by Character when a jump has been detected because Character->bPressedJump was true. Checks CanJump().
  ## #   Note that you should usually trigger a jump through Character::Jump() instead.
  ## #   @param	bReplayingMoves: true if this is being done as part of replaying moves on a locally controlled client after a server correction.
  ## #   @return	True if the jump was triggered successfully.
  ## #

  proc doJump(bReplayingMoves: bool): bool
  ## #* Queue a pending launch with velocity LaunchVel.

  proc launch(launchVel: FVector)
  ## #* Handle a pending launch during an update. Returns true if the launch was triggered.

  proc handlePendingLaunch(): bool
  ## #*
  ## #   If we have a movement base, get the velocity that should be imparted by that base, usually when jumping off of it.
  ## #   Only applies the components of the velocity enabled by bImpartBaseVelocityX, bImpartBaseVelocityY, bImpartBaseVelocityZ.
  ## #
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc getImpartedMovementBaseVelocity(): FVector {.noSideEffect.}
  ## #* Force this pawn to bounce off its current base, which isn't an acceptable base for it.

  proc jumpOff(movementBaseActor: ptr AActor)
  ## #* Can be overridden to choose to jump based on character velocity, base actor dimensions, etc.

  proc getBestDirectionOffActor(baseActor: ptr AActor): FVector {.noSideEffect.}
  ## # Calculates the best direction to go to "jump off" an actor.
  ## #*
  ## #   Determine whether the Character should jump when exiting water.
  ## #   @param	JumpDir is the desired direction to jump out of water
  ## #   @return	true if Pawn should jump out of water
  ## #

  proc shouldJumpOutOfWater(jumpDir: var FVector): bool
  ## #* Jump onto shore from water

  proc jumpOutOfWater(wallNormal: FVector)
  ## #* @return how far to rotate character during the time interval DeltaTime.

  proc getDeltaRotation(deltaTime: cfloat): FRotator {.noSideEffect.}
  ## #*
  ## #    Compute a target rotation based on current movement. Used by PhysicsRotation() when bOrientRotationToMovement is true.
  ## #    Default implementation targets a rotation based on Acceleration.
  ## #
  ## #    @param CurrentRotation	- Current rotation of the Character
  ## #    @param DeltaTime		- Time slice for this movement
  ## #    @param DeltaRotation	- Proposed rotation change based simply on DeltaTime * RotationRate
  ## #
  ## #    @return The target rotation given current movement.
  ## #

  proc computeOrientToMovementRotation(currentRotation: FRotator; deltaTime: cfloat;
                                      deltaRotation: var FRotator): FRotator {.
      noSideEffect.}
  ## #*
  ## #   Use velocity requested by path following to compute a requested acceleration and speed.
  ## #   This does not affect the Acceleration member variable, as that is used to indicate input acceleration.
  ## #   This may directly affect current Velocity.
  ## #
  ## #   @param DeltaTime				Time slice for this operation
  ## #   @param MaxAccel				Max acceleration allowed in OutAcceleration result.
  ## #   @param MaxSpeed				Max speed allowed when computing OutRequestedSpeed.
  ## #   @param Friction				Current friction.
  ## #   @param BrakingDeceleration	Current braking deceleration.
  ## #   @param OutAcceleration		Acceleration computed based on requested velocity.
  ## #   @param OutRequestedSpeed		Speed of resulting velocity request, which can affect the max speed allowed by movement.
  ## #   @return Whether there is a requested velocity and acceleration, resulting in valid OutAcceleration and OutRequestedSpeed values.
  ## #

  proc applyRequestedMove(deltaTime: cfloat; maxAccel: cfloat; maxSpeed: cfloat;
                        friction: cfloat; brakingDeceleration: cfloat;
                        outAcceleration: var FVector; outRequestedSpeed: var cfloat): bool
  ## #* Called if bNotifyApex is true and character has just passed the apex of its jump.

  proc notifyJumpApex()
  ## #*
  ## #   Compute new falling velocity from given velocity and gravity. Applies the limits of the current Physics Volume's TerminalVelocity.
  ## #

  proc newFallVelocity(initialVelocity: FVector; gravity: FVector; deltaTime: cfloat): FVector {.
      noSideEffect.}
  ## # Determine how deep in water the character is immersed.
  ## #   @return float in range 0.0 = not in water, 1.0 = fully immersed
  ## #

  proc immersionDepth(): cfloat {.noSideEffect.}
  ## #*
  ## #   Updates Velocity and Acceleration based on the current state, applying the effects of friction and acceleration or deceleration. Does not apply gravity.
  ## #   This is used internally during movement updates. Normally you don't need to call this from outside code, but you might want to use it for custom movement modes.
  ## #
  ## #   @param	DeltaTime						time elapsed since last frame.
  ## #   @param	Friction						coefficient of friction when not accelerating, or in the direction opposite acceleration.
  ## #   @param	bFluid							true if moving through a fluid, causing Friction to always be applied regardless of acceleration.
  ## #   @param	BrakingDeceleration				deceleration applied when not accelerating, or when exceeding max velocity.
  ## #
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc calcVelocity(deltaTime: cfloat; friction: cfloat; bFluid: bool;
                  brakingDeceleration: cfloat)
  ## #* Compute the max jump height based on the JumpZVelocity velocity and gravity.
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc getMaxJumpHeight(): cfloat {.noSideEffect.}
  ## #* @return Maximum acceleration for the current state, based on MaxAcceleration and any additional modifiers.
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement", meta=(DeprecatedFunction, DisplayName="GetModifiedMaxAcceleration", DeprecationMessage="GetModifiedMaxAcceleration() is deprecated, apply your own modifiers to GetMaxAcceleration() if desired."))

  proc k2_GetModifiedMaxAcceleration(): cfloat {.noSideEffect.}
  ## #* @return Maximum acceleration for the current state.
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc getMaxAcceleration(): cfloat {.noSideEffect.}
  ## #* @return Current acceleration, computed from input vector each update.
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement", meta=(Keywords="Acceleration GetAcceleration"))

  proc getCurrentAcceleration(): FVector {.noSideEffect.}
  ## #* @return Modifier [0..1] based on the magnitude of the last input vector, which is used to modify the acceleration and max speed during movement.
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc getAnalogInputModifier(): cfloat {.noSideEffect.}
  ## #* @return true if we can step up on the actor in the given FHitResult.

  proc canStepUp(hit: FHitResult): bool {.noSideEffect.}
  ## #* Struct updated by StepUp() to return result of final step down, if applicable.

  type
    FStepDownResult = object
      bComputedFloor: bool      ## # True if the floor was computed as a result of the step down.
      floorResult: FFindFloorResult ## # The result of the floor test if the floor was updated.


  proc constructFStepDownResult(): FStepDownResult {.constructor.}
  ## #*
  ## #   Move up steps or slope. Does nothing and returns false if CanStepUp(Hit) returns false.
  ## #
  ## #   @param GravDir			Gravity vector direction (assumed normalized or zero)
  ## #   @param Delta				Requested move
  ## #   @param Hit				[In] The hit before the step up.
  ## #   @param OutStepDownResult	[Out] If non-null, a floor check will be performed if possible as part of the final step down, and it will be updated to reflect this result.
  ## #   @return true if the step up was successful.
  ## #

  proc stepUp(gravDir: FVector; delta: FVector; hit: FHitResult;
            outStepDownResult: ptr FStepDownResult = nil): bool
  ## #* Update the base of the character, which is the PrimitiveComponent we are standing on.

  proc setBase(newBase: ptr UPrimitiveComponent; boneName: FName = NAME_None;
              bNotifyActor: bool = true)
  ## #*
  ## #   Update the base of the character, using the given floor result if it is walkable, or null if not. Calls SetBase().
  ## #

  proc setBaseFromFloor(floorResult: FFindFloorResult)
  ## #*
  ## #   Applies downward force when walking on top of physics objects.
  ## #   @param DeltaSeconds Time elapsed since last frame.
  ## #

  proc applyDownwardForce(deltaSeconds: cfloat)
  ## #* Applies repulsion force to all touched components.

  proc applyRepulsionForce(deltaSeconds: cfloat)
  ## #* Applies momentum accumulated through AddImpulse() and AddForce().

  proc applyAccumulatedForces(deltaSeconds: cfloat)
  ## #*
  ## #   Handle start swimming functionality
  ## #   @param OldLocation - Location on last tick
  ## #   @param OldVelocity - velocity at last tick
  ## #   @param timeTick - time since at OldLocation
  ## #   @param remainingTime - DeltaTime to complete transition to swimming
  ## #   @param Iterations - physics iteration count
  ## #

  proc startSwimming(oldLocation: FVector; oldVelocity: FVector; timeTick: cfloat;
                    remainingTime: cfloat; iterations: int32)
  ## # Swimming uses gravity - but scaled by (1.f - buoyancy)

  proc swim(delta: FVector; hit: var FHitResult): cfloat
  ## #* Get as close to waterline as possible, staying on same side as currently.

  proc findWaterLine(start: FVector; `end`: FVector): FVector
  ## #* Handle falling movement.

  proc physFalling(deltaTime: cfloat; iterations: int32)
  ## # Helpers for PhysFalling
  ## #*
  ## #   Get the lateral acceleration to use during falling movement. The Z component of the result is ignored.
  ## #   Default implementation returns current Acceleration value modified by GetAirControl(), with Z component removed,
  ## #   with magnitude clamped to GetMaxAcceleration().
  ## #   This function is used internally by PhysFalling().
  ## #
  ## #   @param DeltaTime Time step for the current update.
  ## #   @return Acceleration to use during falling movement.
  ## #

  proc getFallingLateralAcceleration(deltaTime: cfloat): FVector
  ## #*
  ## #   Get the air control to use during falling movement.
  ## #   Given an initial air control (TickAirControl), applies the result of BoostAirControl().
  ## #   This function is used internally by GetFallingLateralAcceleration().
  ## #
  ## #   @param DeltaTime			Time step for the current update.
  ## #   @param TickAirControl	Current air control value.
  ## #   @param FallAcceleration	Acceleration used during movement.
  ## #   @return Air control to use during falling movement.
  ## #   @see AirControl, BoostAirControl(), LimitAirControl(), GetFallingLateralAcceleration()
  ## #

  proc getAirControl(deltaTime: cfloat; tickAirControl: cfloat;
                    fallAcceleration: FVector): FVector
  ## # protected:
  ## #*
  ## #   Increase air control if conditions of AirControlBoostMultiplier and AirControlBoostVelocityThreshold are met.
  ## #   This function is used internally by GetAirControl().
  ## #
  ## #   @param DeltaTime			Time step for the current update.
  ## #   @param TickAirControl	Current air control value.
  ## #   @param FallAcceleration	Acceleration used during movement.
  ## #   @return Modified air control to use during falling movement
  ## #   @see GetAirControl()
  ## #

  proc boostAirControl(deltaTime: cfloat; tickAirControl: cfloat;
                      fallAcceleration: FVector): cfloat
  ## #*
  ## #   Limits the air control to use during falling movement, given an impact while falling.
  ## #   This function is used internally by PhysFalling().
  ## #
  ## #   @param DeltaTime			Time step for the current update.
  ## #   @param FallAcceleration	Acceleration used during movement.
  ## #   @param HitResult			Result of impact.
  ## #   @param bCheckForValidLandingSpot If true, will use IsValidLandingSpot() to determine if HitResult is a walkable surface. If false, this check is skipped.
  ## #   @return Modified air control acceleration to use during falling movement.
  ## #   @see PhysFalling()
  ## #

  proc limitAirControl(deltaTime: cfloat; fallAcceleration: FVector;
                      hitResult: FHitResult; bCheckForValidLandingSpot: bool): FVector
  ## #* Handle landing against Hit surface over remaingTime and iterations, calling SetPostLandedPhysics() and starting the new movement mode.

  proc processLanded(hit: FHitResult; remainingTime: cfloat; iterations: int32)
  ## #* Use new physics after landing. Defaults to swimming if in water, walking otherwise.

  proc setPostLandedPhysics(hit: FHitResult)
  ## #* Switch collision settings for NavWalking mode (ignore world collisions)

  proc setNavWalkingPhysics(bEnable: bool)
  ## #* Get Navigation data for the Character. Returns null if there is no associated nav data.

  proc getNavData(): ptr ANavigationData {.noSideEffect.}
  ## #*
  ## #   Checks to see if the current location is not encroaching blocking geometry so the character can leave NavWalking.
  ## #   Restores collision settings and adjusts character location to avoid getting stuck in geometry.
  ## #   If it's not possible, MovementMode change will be delayed until character reach collision free spot.
  ## #   @return True if movement mode was successfully changed
  ## #

  proc tryToLeaveNavWalking(): bool
  ## #*
  ## #   Attempts to better align navmesh walking characters with underlying geometry (sometimes
  ## #   navmesh can differ quite significantly from geometry).
  ## #   Updates CachedProjectedNavMeshHitResult, access this for more info about hits.
  ## #

  proc projectLocationFromNavMesh(deltaSeconds: cfloat; currentFeetLocation: FVector;
                                targetNavLocation: FVector; upOffset: cfloat;
                                downOffset: cfloat): FVector
  ## # public:
  ## #* Called by owning Character upon successful teleport from AActor::TeleportTo().

  proc onTeleported()
  ## #*
  ## #   Checks if new capsule size fits (no encroachment), and call CharacterOwner->OnStartCrouch() if successful.
  ## #   In general you should set bWantsToCrouch instead to have the crouch persist during movement, or just use the crouch functions on the owning Character.
  ## #   @param	bClientSimulation	true when called when bIsCrouched is replicated to non owned clients, to update collision cylinder and offset.
  ## #

  proc crouch(bClientSimulation: bool = false)
  ## #*
  ## #   Checks if default capsule size fits (no encroachment), and trigger OnEndCrouch() on the owner if successful.
  ## #   @param	bClientSimulation	true when called when bIsCrouched is replicated to non owned clients, to update collision cylinder and offset.
  ## #

  proc unCrouch(bClientSimulation: bool = false)
  ## #* @return true if the character is allowed to crouch in the current state. By default it is allowed when walking or falling, if CanEverCrouch() is true.

  proc canCrouchInCurrentState(): bool {.noSideEffect.}
  ## #* @return true if there is a suitable floor SideStep from current position.

  proc checkLedgeDirection(oldLocation: FVector; sideStep: FVector; gravDir: FVector): bool {.
      noSideEffect.}
  ## #*
  ## #   @param Delta is the current move delta (which ended up going over a ledge).
  ## #   @return new delta which moves along the ledge
  ## #

  proc getLedgeMove(oldLocation: FVector; delta: FVector; gravDir: FVector): FVector {.
      noSideEffect.}
  ## #* Check if pawn is falling

  proc checkFall(oldFloor: FFindFloorResult; hit: FHitResult; delta: FVector;
                oldLocation: FVector; remainingTime: cfloat; timeTick: cfloat;
                iterations: int32; bMustJump: bool): bool
  ## #*
  ## #    Revert to previous position OldLocation, return to being based on OldBase.
  ## #    if bFailMove, stop movement and notify controller
  ## #

  proc revertMove(oldLocation: FVector; oldBase: ptr UPrimitiveComponent;
                inOldBaseLocation: FVector; oldFloor: FFindFloorResult;
                bFailMove: bool)
  ## #* Perform rotation over deltaTime

  proc physicsRotation(deltaTime: cfloat)
  ## #* Delegate when PhysicsVolume of UpdatedComponent has been changed *

  proc physicsVolumeChanged(newVolume: ptr APhysicsVolume)
  ## #* Set movement mode to the default based on the current physics volume.

  proc setDefaultMovementMode()
  ## #*
  ## #   Moves along the given movement direction using simple movement rules based on the current movement mode (usually used by simulated proxies).
  ## #
  ## #   @param InVelocity:			Velocity of movement
  ## #   @param DeltaSeconds:			Time over which movement occurs
  ## #   @param OutStepDownResult:	[Out] If non-null, and a floor check is performed, this will be updated to reflect that result.
  ## #

  proc moveSmooth(inVelocity: FVector; deltaSeconds: cfloat;
                outStepDownResult: ptr FStepDownResult = nil)
  proc setUpdatedComponent(newUpdatedComponent: ptr USceneComponent)
  ## #* @Return MovementMode string

  proc getMovementName(): FString {.noSideEffect.}
  ## #*
  ## #   Add impulse to character. Impulses are accumulated each tick and applied together
  ## #   so multiple calls to this function will accumulate.
  ## #   An impulse is an instantaneous force, usually applied once. If you want to continually apply
  ## #   forces each frame, use AddForce().
  ## #   Note that changing the momentum of characters like this can change the movement mode.
  ## #
  ## #   @param	Impulse				Impulse to apply.
  ## #   @param	bVelocityChange		Whether or not the impulse is relative to mass.
  ## #
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc addImpulse(impulse: FVector; bVelocityChange: bool = false)
  ## #*
  ## #   Add force to character. Forces are accumulated each tick and applied together
  ## #   so multiple calls to this function will accumulate.
  ## #   Forces are scaled depending on timestep, so they can be applied each frame. If you want an
  ## #   instantaneous force, use AddImpulse.
  ## #   Adding a force always takes the actor's mass into account.
  ## #   Note that changing the momentum of characters like this can change the movement mode.
  ## #
  ## #   @param	Force			Force to apply.
  ## #
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc addForce(force: FVector)
  ## #*
  ## #   Draw important variables on canvas.  Character will call DisplayDebug() on the current ViewTarget when the ShowDebug exec is used
  ## #
  ## #   @param Canvas - Canvas to draw on
  ## #   @param DebugDisplay - Contains information about what debug data to display
  ## #   @param YL - Height of the current font
  ## #   @param YPos - Y position on Canvas. YPos += YL, gives position to draw text for next debug line.
  ## #

  proc displayDebug(canvas: ptr UCanvas; debugDisplay: FDebugDisplayInfo;
                    YL: var cfloat; YPos: var cfloat)
  ## #*
  ## #   Draw in-world debug information for character movement (called with p.VisualizeMovement > 0).
  ## #

  proc visualizeMovement() {.noSideEffect.}
  ## #* Check if swimming pawn just ran into edge of the pool and should jump out.

  proc checkWaterJump(checkPoint: FVector; wallNormal: var FVector): bool
  ## #* @return whether this pawn is currently allowed to walk off ledges

  proc canWalkOffLedges(): bool {.noSideEffect.}
  ## #* @return The distance from the edge of the capsule within which we don't allow the character to perch on the edge of a surface.
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc getPerchRadiusThreshold(): cfloat {.noSideEffect.}
  ## #*
  ## #   Returns the radius within which we can stand on the edge of a surface without falling (if this is a walkable surface).
  ## #   Simply computed as the capsule radius minus the result of GetPerchRadiusThreshold().
  ## #
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc getValidPerchRadius(): cfloat {.noSideEffect.}
  ## #* Return true if the hit result should be considered a walkable surface for the character.
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc isWalkable(hit: FHitResult): bool {.noSideEffect.}
  ## #* Get the max angle in degrees of a walkable surface for the character.

  proc getWalkableFloorAngle(): cfloat {.noSideEffect.}
  ## #* Get the max angle in degrees of a walkable surface for the character.
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement", meta=(DisplayName = "GetWalkableFloorAngle"))

  proc k2_GetWalkableFloorAngle(): cfloat {.noSideEffect.}
  ## #* Set the max angle in degrees of a walkable surface for the character. Also computes WalkableFloorZ.
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc setWalkableFloorAngle(inWalkableFloorAngle: cfloat)
  ## #* Get the Z component of the normal of the steepest walkable surface for the character. Any lower than this and it is not walkable.

  proc getWalkableFloorZ(): cfloat {.noSideEffect.}
  ## #* Get the Z component of the normal of the steepest walkable surface for the character. Any lower than this and it is not walkable.
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement", meta=(DisplayName = "GetWalkableFloorZ"))

  proc k2_GetWalkableFloorZ(): cfloat {.noSideEffect.}
  ## #* Set the Z component of the normal of the steepest walkable surface for the character. Also computes WalkableFloorAngle.
  ## # UFUNCTION(BlueprintCallable, Category="Pawn|Components|CharacterMovement")

  proc setWalkableFloorZ(inWalkableFloorZ: cfloat)
  ## #* Post-physics tick function for this character
  ## # UPROPERTY()

  var postPhysicsTickFunction: FCharacterMovementComponentPostPhysicsTickFunction

  ## #* Tick function called after physics (sync scene) has finished simulation, before cloth

  proc postPhysicsTickComponent(deltaTime: cfloat; thisTickFunction: var FCharacterMovementComponentPostPhysicsTickFunction)
  ## # protected:
  ## #* @note Movement update functions should only be called through StartNewPhysics()

  proc physWalking(deltaTime: cfloat; iterations: int32)
  ## #* @note Movement update functions should only be called through StartNewPhysics()

  proc physNavWalking(deltaTime: cfloat; iterations: int32)
  ## #* @note Movement update functions should only be called through StartNewPhysics()

  proc physFlying(deltaTime: cfloat; iterations: int32)
  ## #* @note Movement update functions should only be called through StartNewPhysics()

  proc physSwimming(deltaTime: cfloat; iterations: int32)
  ## #* @note Movement update functions should only be called through StartNewPhysics()

  proc physCustom(deltaTime: cfloat; iterations: int32)
  ## #*
  ## #   Compute a vector of movement, given a delta and a hit result of the surface we are on.
  ## #
  ## #   @param Delta:				Attempted movement direction
  ## #   @param RampHit:				Hit result of sweep that found the ramp below the capsule
  ## #   @param bHitFromLineTrace:	Whether the floor trace came from a line trace
  ## #
  ## #   @return If on a walkable surface, this returns a vector that moves parallel to the surface. The magnitude may be scaled if bMaintainHorizontalGroundVelocity is true.
  ## #   If a ramp vector can't be computed, this will just return Delta.
  ## #

  proc computeGroundMovementDelta(delta: FVector; rampHit: FHitResult;
                                bHitFromLineTrace: bool): FVector {.noSideEffect.}
  ## #*
  ## #   Move along the floor, using CurrentFloor and ComputeGroundMovementDelta() to get a movement direction.
  ## #   If a second walkable surface is hit, it will also be moved along using the same approach.
  ## #
  ## #   @param InVelocity:			Velocity of movement
  ## #   @param DeltaSeconds:			Time over which movement occurs
  ## #   @param OutStepDownResult:	[Out] If non-null, and a floor check is performed, this will be updated to reflect that result.
  ## #

  proc moveAlongFloor(inVelocity: FVector; deltaSeconds: cfloat;
                    outStepDownResult: ptr FStepDownResult = nil)
  ## #* Notification that the character is stuck in geometry.  Only called during walking movement.

  proc onCharacterStuckInGeometry()
  ## #*
  ## #   Adjusts velocity when walking so that Z velocity is zero.
  ## #   When bMaintainHorizontalGroundVelocity is false, also rescales the velocity vector to maintain the original magnitude, but in the horizontal direction.
  ## #

  proc maintainHorizontalGroundVelocity()
  ## #* Overridden to set bJustTeleported to true, so we don't make incorrect velocity calculations based on adjusted movement.

  proc resolvePenetrationImpl(adjustment: FVector; hit: FHitResult; newRotation: FQuat): bool
  ## #* Handle a blocking impact. Calls ApplyImpactPhysicsForces for the hit, if bEnablePhysicsInteraction is true.

  proc handleImpact(hit: FHitResult; timeSlice: cfloat = 0.0;
                  moveDelta: FVector = zeroVector)
  ## #*
  ## #   Apply physics forces to the impacted component, if bEnablePhysicsInteraction is true.
  ## #   @param Impact				HitResult that resulted in the impact
  ## #   @param ImpactAcceleration	Acceleration of the character at the time of impact
  ## #   @param ImpactVelocity		Velocity of the character at the time of impact
  ## #

  proc applyImpactPhysicsForces(impact: FHitResult; impactAcceleration: FVector;
                              impactVelocity: FVector)
  ## #* Custom version of SlideAlongSurface that handles different movement modes separately; namely during walking physics we might not want to slide up slopes.

  proc slideAlongSurface(delta: FVector; time: cfloat; normal: FVector;
                        hit: var FHitResult; bHandleImpact: bool): cfloat
  ## #* Custom version that allows upwards slides when walking if the surface is walkable.

  proc twoWallAdjust(delta: var FVector; hit: FHitResult; oldHitNormal: FVector) {.
      noSideEffect.}
  ## #*
  ## #   Calculate slide vector along a surface.
  ## #   Has special treatment when falling, to avoid boosting up slopes (calling HandleSlopeBoosting() in this case).
  ## #
  ## #   @param Delta:	Attempted move.
  ## #   @param Time:		Amount of move to apply (between 0 and 1).
  ## #   @param Normal:	Normal opposed to movement. Not necessarily equal to Hit.Normal (but usually is).
  ## #   @param Hit:		HitResult of the move that resulted in the slide.
  ## #   @return			New deflected vector of movement.
  ## #

  proc computeSlideVector(delta: FVector; time: cfloat; normal: FVector; hit: FHitResult): FVector {.
      noSideEffect.}
  ## #*
  ## #   Limit the slide vector when falling if the resulting slide might boost the character faster upwards.
  ## #   @param SlideResult:	Vector of movement for the slide (usually the result of ComputeSlideVector)
  ## #   @param Delta:		Original attempted move
  ## #   @param Time:			Amount of move to apply (between 0 and 1).
  ## #   @param Normal:		Normal opposed to movement. Not necessarily equal to Hit.Normal (but usually is).
  ## #   @param Hit:			HitResult of the move that resulted in the slide.
  ## #   @return:				New slide result.
  ## #

  proc handleSlopeBoosting(slideResult: FVector; delta: FVector; time: cfloat;
                          normal: FVector; hit: FHitResult): FVector {.noSideEffect.}
  ## #* Slows towards stop.

  proc applyVelocityBraking(deltaTime: cfloat; friction: cfloat;
                          brakingDeceleration: cfloat)
  ## #*
  ## #   Return true if the 2D distance to the impact point is inside the edge tolerance (CapsuleRadius minus a small rejection threshold).
  ## #   Useful for rejecting adjacent hits when finding a floor or landing spot.
  ## #

  proc isWithinEdgeTolerance(capsuleLocation: FVector; testImpactPoint: FVector;
                            capsuleRadius: cfloat): bool {.noSideEffect.}
  ## #*
  ## #   Sweeps a vertical trace to find the floor for the capsule at the given location. Will attempt to perch if ShouldComputePerchResult() returns true for the downward sweep result.
  ## #
  ## #   @param CapsuleLocation:		Location where the capsule sweep should originate
  ## #   @param OutFloorResult:		[Out] Contains the result of the floor check. The HitResult will contain the valid sweep or line test upon success, or the result of the sweep upon failure.
  ## #   @param bZeroDelta:			If true, the capsule was not actively moving in this update (can be used to avoid unnecessary floor tests).
  ## #   @param DownwardSweepResult:	If non-null and it contains valid blocking hit info, this will be used as the result of a downward sweep test instead of doing it as part of the update.
  ## #

  proc findFloor(capsuleLocation: FVector; outFloorResult: var FFindFloorResult;
                bZeroDelta: bool; downwardSweepResult: ptr FHitResult = nil) {.
      noSideEffect.}
  ## #*
  ## #   Compute distance to the floor from bottom sphere of capsule and store the result in OutFloorResult.
  ## #   This distance is the swept distance of the capsule to the first point impacted by the lower hemisphere, or distance from the bottom of the capsule in the case of a line trace.
  ## #   SweepDistance MUST be greater than or equal to the line distance.
  ## #   @see FindFloor
  ## #
  ## #   @param CapsuleLocation:	Location of the capsule used for the query
  ## #   @param LineDistance:		If non-zero, max distance to test for a simple line check from the capsule base. Used only if the sweep test fails to find a walkable floor, and only returns a valid result if the impact normal is a walkable normal.
  ## #   @param SweepDistance:	If non-zero, max distance to use when sweeping a capsule downwards for the test.
  ## #   @param OutFloorResult:	Result of the floor check. The HitResult will contain the valid sweep or line test upon success, or the result of the sweep upon failure.
  ## #   @param SweepRadius:		The radius to use for sweep tests. Should be <= capsule radius.
  ## #   @param DownwardSweepResult:	If non-null and it contains valid blocking hit info, this will be used as the result of a downward sweep test instead of doing it as part of the update.
  ## #

  proc computeFloorDist(capsuleLocation: FVector; lineDistance: cfloat;
                      sweepDistance: cfloat; outFloorResult: var FFindFloorResult;
                      sweepRadius: cfloat;
                      downwardSweepResult: ptr FHitResult = nil) {.noSideEffect.}
  ## #*
  ## #   Sweep against the world and return the first blocking hit.
  ## #   Intended for tests against the floor, because it may change the result of impacts on the lower area of the test (especially if bUseFlatBaseForFloorChecks is true).
  ## #
  ## #   @param OutHit			First blocking hit found.
  ## #   @param Start				Start location of the capsule.
  ## #   @param End				End location of the capsule.
  ## #   @param TraceChannel		The 'channel' that this trace is in, used to determine which components to hit.
  ## #   @param CollisionShape	Capsule collision shape.
  ## #   @param Params			Additional parameters used for the trace.
  ## #   @param ResponseParam		ResponseContainer to be used for this trace.
  ## #   @return True if OutHit contains a blocking hit entry.
  ## #

  proc floorSweepTest(outHit: var FHitResult; start: FVector; `end`: FVector;
                    traceChannel: ECollisionChannel;
                    collisionShape: FCollisionShape; params: FCollisionQueryParams;
                    responseParam: FCollisionResponseParams): bool {.noSideEffect.}
  ## #* Verify that the supplied hit result is a valid landing spot when falling.

  proc isValidLandingSpot(capsuleLocation: FVector; hit: FHitResult): bool {.
      noSideEffect.}
  ## #*
  ## #   Determine whether we should try to find a valid landing spot after an impact with an invalid one (based on the Hit result).
  ## #   For example, landing on the lower portion of the capsule on the edge of geometry may be a walkable surface, but could have reported an unwalkable impact normal.
  ## #

  proc shouldCheckForValidLandingSpot(deltaTime: cfloat; delta: FVector;
                                    hit: FHitResult): bool {.noSideEffect.}
  ## #*
  ## #   Check if the result of a sweep test (passed in InHit) might be a valid location to perch, in which case we should use ComputePerchResult to validate the location.
  ## #   @see ComputePerchResult
  ## #   @param InHit:			Result of the last sweep test before this query.
  ## #   @param bCheckRadius:		If true, only allow the perch test if the impact point is outside the radius returned by GetValidPerchRadius().
  ## #   @return Whether perching may be possible, such that ComputePerchResult can return a valid result.
  ## #

  proc shouldComputePerchResult(inHit: FHitResult; bCheckRadius: bool = true): bool {.
      noSideEffect.}
  ## #*
  ## #   Compute the sweep result of the smaller capsule with radius specified by GetValidPerchRadius(),
  ## #   and return true if the sweep contacts a valid walkable normal within InMaxFloorDist of InHit.ImpactPoint.
  ## #   This may be used to determine if the capsule can or cannot stay at the current location if perched on the edge of a small ledge or unwalkable surface.
  ## #   Note: Only returns a valid result if ShouldComputePerchResult returned true for the supplied hit value.
  ## #
  ## #   @param TestRadius:			Radius to use for the sweep, usually GetValidPerchRadius().
  ## #   @param InHit:				Result of the last sweep test before the query.
  ## #   @param InMaxFloorDist:		Max distance to floor allowed by perching, from the supplied contact point (InHit.ImpactPoint).
  ## #   @param OutPerchFloorResult:	Contains the result of the perch floor test.
  ## #   @return True if the current location is a valid spot at which to perch.
  ## #

  proc computePerchResult(testRadius: cfloat; inHit: FHitResult;
                        inMaxFloorDist: cfloat;
                        outPerchFloorResult: var FFindFloorResult): bool {.
      noSideEffect.}
  ## #* Called when the collision capsule touches another primitive component
  ## # UFUNCTION()

  proc capsuleTouched(other: ptr AActor; otherComp: ptr UPrimitiveComponent;
                    otherBodyIndex: int32; bFromSweep: bool; sweepResult: FHitResult)
  ## # Enum used to control GetPawnCapsuleExtent behavior

  type
    EShrinkCapsuleExtent = enum
      SHRINK_None,              ## # Don't change the size of the capsule
      SHRINK_RadiusCustom,      ## # Change only the radius, based on a supplied param
      SHRINK_HeightCustom,      ## # Change only the height, based on a supplied param
      SHRINK_AllCustom          ## # Change both radius and height, based on a supplied param


  ## #* Get the capsule extent for the Pawn owner, possibly reduced in size depending on ShrinkMode.
  ## #   @param ShrinkMode			Controls the way the capsule is resized.
  ## #   @param CustomShrinkAmount	The amount to shrink the capsule, used only for ShrinkModes that specify custom.
  ## #   @return The capsule extent of the Pawn owner, possibly reduced in size depending on ShrinkMode.
  ## #

  proc getPawnCapsuleExtent(shrinkMode: EShrinkCapsuleExtent;
                          customShrinkAmount: cfloat = 0.0): FVector {.noSideEffect.}
  ## #* Get the collision shape for the Pawn owner, possibly reduced in size depending on ShrinkMode.
  ## #   @param ShrinkMode			Controls the way the capsule is resized.
  ## #   @param CustomShrinkAmount	The amount to shrink the capsule, used only for ShrinkModes that specify custom.
  ## #   @return The capsule extent of the Pawn owner, possibly reduced in size depending on ShrinkMode.
  ## #

  proc getPawnCapsuleCollisionShape(shrinkMode: EShrinkCapsuleExtent;
                                  customShrinkAmount: cfloat = 0.0): FCollisionShape {.
      noSideEffect.}
  ## #* Adjust the size of the capsule on simulated proxies, to avoid overlaps due to replication rounding.
  ## #    Changes to the capsule size on the proxy should set bShrinkProxyCapsule=true and possibly call AdjustProxyCapsuleSize() immediately if applicable.
  ## #

  proc adjustProxyCapsuleSize()
  ## #* Enforce constraints on input given current state. For instance, don't move upwards if walking and looking up.

  proc constrainInputAcceleration(inputAcceleration: FVector): FVector {.noSideEffect.}
  ## #* Scale input acceleration, based on movement acceleration rate.

  proc scaleInputAcceleration(inputAcceleration: FVector): FVector {.noSideEffect.}
  ## #*
  ## #   Event triggered at the end of a movement update. If scoped movement updates are enabled (bEnableScopedMovementUpdates), this is within such a scope.
  ## #   If that is not desired, bind to the CharacterOwner's OnMovementUpdated event instead, as that is triggered after the scoped movement update.
  ## #

  proc onMovementUpdated(deltaSeconds: cfloat; oldLocation: FVector;
                        oldVelocity: FVector)
  ## #* Internal function to call OnMovementUpdated delegate on CharacterOwner.

  proc callMovementUpdateDelegate(deltaSeconds: cfloat; oldLocation: FVector;
                                oldVelocity: FVector)
  ## #*
  ## #   Event triggered when we are moving on a base but we are not able to move the full DeltaPosition because something has blocked us.
  ## #   Note: MoveComponentFlags includes the flag to ignore the movement base while this event is fired.
  ## #   @param DeltaPosition		How far we tried to move with the base.
  ## #   @param OldLocation		Location before we tried to move with the base.
  ## #   @param MoveOnBaseHit		Hit result for the object we hit when trying to move with the base.
  ## #

  proc onUnableToFollowBaseMove(deltaPosition: FVector; oldLocation: FVector;
                              moveOnBaseHit: FHitResult)
  ## # public:
  ## #*
  ## #   Project a location to navmesh to find adjusted height.
  ## #   @param TestLocation		Location to project
  ## #   @param NavFloorLocation	Location on navmesh
  ## #   @return True if projection was performed (successfully or not)
  ## #

  proc findNavFloor(testLocation: FVector; navFloorLocation: var FNavLocation): bool {.
      noSideEffect.}
  ## # protected:
  ## # Movement functions broken out based on owner's network Role.
  ## # TickComponent calls the correct version based on the Role.
  ## # These may be called during move playback and correction during network updates.
  ## #
  ## #* Perform movement on an autonomous client

  proc performMovement(deltaTime: cfloat)
  ## #* Special Tick for Simulated Proxies

  proc simulatedTick(deltaSeconds: cfloat)
  ## #* Simulate movement on a non-owning client. Called by SimulatedTick().

  proc simulateMovement(deltaTime: cfloat)
  ## # public:
  ## #* Force a client update by making it appear on the server that the client hasn't updated in a long time.

  proc forceReplicationUpdate()
  ## #*
  ## #   Generate a random angle in degrees that is approximately equal between client and server.
  ## #   Note that in networked games this result changes with low frequency and has a low period,
  ## #   so should not be used for frequent randomization.
  ## #

  proc getNetworkSafeRandomAngleDegrees(): cfloat {.noSideEffect.}
  ## #* Round acceleration, for better consistency and lower bandwidth in networked games.

  proc roundAcceleration(inAccel: FVector): FVector {.noSideEffect.}
  ## #--------------------------------
  ## # INetworkPredictionInterface implementation
  ## #--------------------------------
  ## # Server hook
  ## #--------------------------------

  proc sendClientAdjustment()
  proc forcePositionUpdate(deltaTime: cfloat)
  ## #--------------------------------
  ## # Client hook
  ## #--------------------------------
  ## #*
  ## #   React to new transform from network update. Sets bNetworkSmoothingComplete to false to ensure future smoothing updates.
  ## #   IMPORTANT: It is expected that this function triggers any movement/transform updates to match the network update if desired.
  ## #

  proc smoothCorrection(oldLocation: FVector; oldRotation: FQuat; newLocation: FVector;
                      newRotation: FQuat)

  ## #*
  ## #   Smooth mesh location for network interpolation, based on values set up by SmoothCorrection.
  ## #   Internally this simply calls SmoothClientPosition_Interpolate() then SmoothClientPosition_UpdateVisuals().
  ## #   This function is not called when bNetworkSmoothingComplete is true.
  ## #   @param DeltaSeconds Time since last update.
  ## #

  proc smoothClientPosition(deltaSeconds: cfloat)
  ## #*
  ## #   Update interpolation values for client smoothing. Does not change actual mesh location.
  ## #   Sets bNetworkSmoothingComplete to true when the interpolation reaches the target.
  ## #

  proc smoothClientPosition_Interpolate(deltaSeconds: cfloat)
  ## #* Update mesh location based on interpolated values.

  proc smoothClientPosition_UpdateVisuals()
  proc packYawAndPitchTo32(yaw: cfloat; pitch: cfloat): uint32
  ## #
  ## # ========================================================================
  ## # Here's how player movement prediction, replication and correction works in network games:
  ## #
  ## # Every tick, the TickComponent() function is called.  It figures out the acceleration and rotation change for the frame,
  ## # and then calls PerformMovement() (for locally controlled Characters), or ReplicateMoveToServer() (if it's a network client).
  ## #
  ## # ReplicateMoveToServer() saves the move (in the PendingMove list), calls PerformMovement(), and then replicates the move
  ## # to the server by calling the replicated function ServerMove() - passing the movement parameters, the client's
  ## # resultant position, and a timestamp.
  ## #
  ## # ServerMove() is executed on the server.  It decodes the movement parameters and causes the appropriate movement
  ## # to occur.  It then looks at the resulting position and if enough time has passed since the last response, or the
  ## # position error is significant enough, the server calls ClientAdjustPosition(), a replicated function.
  ## #
  ## # ClientAdjustPosition() is executed on the client.  The client sets its position to the servers version of position,
  ## # and sets the bUpdatePosition flag to true.
  ## #
  ## # When TickComponent() is called on the client again, if bUpdatePosition is true, the client will call
  ## # ClientUpdatePosition() before calling PerformMovement().  ClientUpdatePosition() replays all the moves in the pending
  ## # move list which occurred after the timestamp of the move the server was adjusting.
  ## #
  ## #* Perform local movement and send the move to the server.

  proc replicateMoveToServer(deltaTime: cfloat; newAcceleration: FVector)
  ## #* If bUpdatePosition is true, then replay any unacked moves. Returns whether any moves were actually replayed.

  proc clientUpdatePositionAfterServerUpdate(): bool
  ## #* Call the appropriate replicated servermove() function to send a client player move to the server.

  # proc callServerMove(newMove: ptr FSavedMove_Character;
  #                   oldMove: ptr FSavedMove_Character)
  ## #*
  ## #   Have the server check if the client is outside an error tolerance, and queue a client adjustment if so.
  ## #   If either GetPredictionData_Server_Character()->bForceClientUpdate or ServerCheckClientError() are true, the client adjustment will be sent.
  ## #   RelativeClientLocation will be a relative location if MovementBaseUtility::UseRelativePosition(ClientMovementBase) is true, or a world location if false.
  ## #   @see ServerCheckClientError()
  ## #

  proc serverMoveHandleClientError(clientTimeStamp: cfloat; deltaTime: cfloat;
                                  accel: FVector; relativeClientLocation: FVector;
                                  clientMovementBase: ptr UPrimitiveComponent;
                                  clientBaseBoneName: FName;
                                  clientMovementMode: uint8)
  ## #*
  ## #   Check for Server-Client disagreement in position or other movement state important enough to trigger a client correction.
  ## #   @see ServerMoveHandleClientError()
  ## #

  proc serverCheckClientError(clientTimeStamp: cfloat; deltaTime: cfloat;
                            accel: FVector; clientWorldLocation: FVector;
                            relativeClientLocation: FVector;
                            clientMovementBase: ptr UPrimitiveComponent;
                            clientBaseBoneName: FName; clientMovementMode: uint8): bool
  ## # Process a move at the given time stamp, given the compressed flags representing various events that occurred (ie jump).

  proc moveAutonomous(clientTimeStamp: cfloat; deltaTime: cfloat;
                    compressedFlags: uint8; newAccel: FVector)
  ## #* Unpack compressed flags from a saved move and set state accordingly. See FSavedMove_Character.

  proc updateFromCompressedFlags(flags: uint8)


  # proc canDelaySendingMove(newMove: FSavedMovePtr): bool
  # ## #* Return true if it is OK to delay sending this player movement to the server, in order to conserve bandwidth.

  ## #* Ticks the characters pose and accumulates root motion

  proc tickCharacterPose(deltaTime: cfloat)
  ## # public:
  ## #* React to instantaneous change in position. Invalidates cached floor recomputes it if possible if there is a current movement base.

  proc updateFloorFromAdjustment()
  ## #* Minimum time between client TimeStamp resets.
  ## #  !! This has to be large enough so that we don't confuse the server if the client can stall or timeout.
  ## #  We do this as we use floats for TimeStamps, and server derives DeltaTime from two TimeStamps.
  ## #  As time goes on, accuracy decreases from those floating point numbers.
  ## #  So we trigger a TimeStamp reset at regular intervals to maintain a high level of accuracy.
  ## # UPROPERTY()

  var minTimeBetweenTimeStampResets: cfloat

  # ## #* On the Server, verify that an incoming client TimeStamp is valid and has not yet expired.
  # ## #  It will also handle TimeStamp resets if it detects a gap larger than MinTimeBetweenTimeStampResets / 2.f
  # ## #  !! ServerData.CurrentClientTimeStamp can be reset !!
  # ## #  @returns true if TimeStamp is valid, or false if it has expired.

  # proc verifyClientTimeStamp(timeStamp: cfloat; serverData: var FNetworkPredictionData_Server_Character): bool

# protected:
  # ## #* Internal const check for client timestamp validity without side-effects.
  # ## #    @see VerifyClientTimeStamp

  # proc isClientTimeStampValid(timeStamp: cfloat;
  #                           serverData: FNetworkPredictionData_Server_Character;
  #                           bTimeStampResetDetected: var bool): bool {.noSideEffect.}

# Root Motion
# public:

  # var currentRootMotion: FRootMotionSourceGroup
  #   ## #* Root Motion Group containing active root motion sources being applied to movement
  #   ## # UPROPERTY(Transient)

  ## #* @return true if we have Root Motion from any source to use in PerformMovement() physics.

  proc hasRootMotionSources(): bool {.noSideEffect.}

  # proc applyRootMotionSource(sourcePtr: ptr FRootMotionSource): uint16
  #   ## #* Apply a RootMotionSource to current root motion
  #   ## #    @return LocalID for this Root Motion Source



  # proc getRootMotionSource(instanceName: FName): TSharedPtr[FRootMotionSource]
  #   ## #* Get a RootMotionSource from current root motion by name



  # proc getRootMotionSourceByID(rootMotionSourceID: uint16): TSharedPtr[
  #     FRootMotionSource]
  #   ## #* Get a RootMotionSource from current root motion by ID

  ## #* Remove a RootMotionSource from current root motion by name

  proc removeRootMotionSource(instanceName: FName)
  ## #* Remove a RootMotionSource from current root motion by ID

  proc removeRootMotionSourceByID(rootMotionSourceID: uint16)

  # proc convertRootMotionServerIDsToLocalIDs(
  #     localRootMotionToMatchWith: FRootMotionSourceGroup;
  #     inOutServerRootMotion: var FRootMotionSourceGroup; timeStamp: cfloat)
  #   ## #* Converts received server IDs in a root motion group to local IDs

# protected:
  ## #* Restores Velocity to LastPreAdditiveVelocity during Root Motion Phys*() function calls

  proc restorePreAdditiveRootMotionVelocity()
  ## #* Applies root motion from root motion sources to velocity (override and additive)

  proc applyRootMotionToVelocity(deltaTime: cfloat)


# public:

#   ## #*
#   ## # 	Animation root motion (special case for now)
#   ## #
#   ## #* Root Motion movement params. Holds result of anim montage root motion during PerformMovement(), and is overridden
#   ## #    during autonomous move playback to force historical root motion for MoveAutonomous() calls
#   ## # UPROPERTY(Transient)

#   var rootMotionParams: FRootMotionMovementParams

#   ## #* True when SimulatedProxies are simulating RootMotion
#   ## # UPROPERTY(Transient)

#   var bWasSimulatingRootMotion: bool

#   ## #* @return true if we have Root Motion from animation to use in PerformMovement() physics.
#   ## #  Not valid outside of the scope of that function. Since RootMotion is extracted and used in it.

  proc hasAnimRootMotion(): bool {.noSideEffect.}
  ## #* Simulate Root Motion physics on Simulated Proxies

  proc simulateRootMotion(deltaSeconds: cfloat; localRootMotionTransform: FTransform)
  ## #*
  ## #   Calculate velocity from root motion. Under some movement conditions, only portions of root motion may be used (e.g. when falling Z may be ignored).
  ## #   @param RootMotionDeltaMove	Change in location from root motion.
  ## #   @param DeltaSeconds			Elapsed time
  ## #   @param CurrentVelocity		Non-root motion velocity at current time, used for components of result that may ignore root motion.
  ## #

  proc calcRootMotionVelocity(rootMotionDeltaMove: FVector; deltaSeconds: cfloat;
                            currentVelocity: FVector): FVector {.noSideEffect.}
  ## # RVO Avoidance
  ## #* calculate RVO avoidance and apply it to current velocity

  proc calcAvoidanceVelocity(deltaTime: cfloat)
  ## #* allows modifing avoidance velocity, called when bUseRVOPostProcess is set

  proc postProcessAvoidanceVelocity(newVelocity: var FVector)
  ## # public:
  ## # 	/** Minimum delta time considered when ticking. Delta times below this are not considered. This is a very small non-zero value to avoid potential divide-by-zero in simulation code. */
  ## # 	static const float MIN_TICK_TIME;
  ## # 	/** Minimum acceptable distance for Character capsule to float above floor when walking. */
  ## # 	static const float MIN_FLOOR_DIST;
  ## # 	/** Maximum acceptable distance for Character capsule to float above floor when walking. */
  ## # 	static const float MAX_FLOOR_DIST;
  ## # 	/** Reject sweep impacts that are this close to the edge of the vertical portion of the capsule when performing vertical sweeps, and try again with a smaller capsule. */
  ## # 	static const float SWEEP_EDGE_REJECT_DISTANCE;
  ## # 	/** Stop completely when braking and velocity magnitude is lower than this. */
  ## # 	static const float BRAKE_TO_STOP_VELOCITY;
