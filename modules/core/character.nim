# Copyright 2016 Xored Software, Inc.

type
  FRootMotionSourceGroup* {.importcpp, header: "GameFramework/RootMotionSource.h", bycopy.} = object
    ## TODO: interface RootMotionSource.h

  FRepRootMotionMontage* {.importcpp, header: "GameFramework/Character.h", bycopy.} = object
    ## Replicated data when playing a root motion montage.
    bIsActive*: bool
      ## Whether this has useful/active data.
    animMontage* {.importcpp: "AnimMontage".}: ptr UAnimMontage
      ## AnimMontage providing Root Motion
    position* {.importcpp: "Position".}: cfloat
      ## Track position of Montage
    location* {.importcpp: "Location".}: FVector_NetQuantize100
      ## Location
    rotation* {.importcpp: "Rotation".}: FRotator
      ## Rotation
    movementBase* {.importcpp: "MovementBase".}: ptr UPrimitiveComponent
      ## Movement Relative to Base
    movementBaseBoneName* {.importcpp: "MovementBaseBoneName".}: FName
      ## Bone on the MovementBase, if a skeletal mesh.
    bRelativePosition*: bool
      ## Additional replicated flag, if MovementBase can't be resolved on the client. So we don't use wrong data.
    bRelativeRotation*: bool
      ## Whether rotation is relative or absolute.
    authoritativeRootMotion* {.importcpp: "AuthoritativeRootMotion".}: FRootMotionSourceGroup
      ## State of Root Motion Sources on Authority
    acceleration* {.importcpp: "Acceleration".}: FVector_NetQuantize10
      ## Acceleration
    linearVelocity* {.importcpp: "LinearVelocity".}: FVector_NetQuantize10
      ## Velocity

  FSimulatedRootMotionReplicatedMove* = object ## Local time when move was received on client and saved.
                                           ## # UPROPERTY()
    time*: cfloat               ## Root Motion information
               ## # UPROPERTY()
    rootMotion*: FRepRootMotionMontage

proc clear*(this: var FRepRootMotionMontage) {.
  header: "GameFramework/Character.h", importcpp: "Clear".}
  ## Clear root motion sources and root motion montage
proc hasRootMotion*(this: FRepRootMotionMontage): bool {.
  header: "GameFramework/Character.h", importcpp: "HasRootMotion", noSideEffect.}

# Utilities for working with movement bases, for which we may need relative positioning info.

proc isDynamicBase*(movementBase: ptr UPrimitiveComponent): bool {.
  header: "GameFramework/Character.h", importcpp: "MovementBaseUtility::IsDynamicBase".}
  ## Determine whether MovementBase can possibly move.

proc shouldUseRelativeLocation*(movementBase: ptr UPrimitiveComponent): bool {.
  header: "GameFramework/Character.h", importcpp: "MovementBaseUtility::UseRelativeLocation".}
  ## Determine if we should use relative positioning when based on a component (because it may move).

proc addTickDependency*(basedObjectTick: var FTickFunction;
                       newBase: ptr UPrimitiveComponent) {.
  header: "GameFramework/Character.h", importcpp: "MovementBaseUtility::AddTickDependency".}
  ## Ensure that BasedObjectTick ticks after NewBase

proc removeTickDependency(basedObjectTick: var FTickFunction;
                          oldBase: ptr UPrimitiveComponent) {.
  header: "GameFramework/Character.h", importcpp: "MovementBaseUtility::RemoveTickDependency".}
  ## Remove tick dependency of BasedObjectTick on OldBase

proc getMovementBaseVelocity(movementBase: ptr UPrimitiveComponent; boneName: FName): FVector {.
  header: "GameFramework/Character.h", importcpp: "MovementBaseUtility::GetMovementBaseVelocity".}
  ## Get the velocity of the given component, first checking the ComponentVelocity and falling back to the physics velocity if necessary.

proc getMovementBaseTangentialVelocity(movementBase: ptr UPrimitiveComponent;
                                       boneName: FName; worldLocation: FVector): FVector {.
  header: "GameFramework/Character.h", importcpp: "MovementBaseUtility::GetMovementBaseTangentialVelocity".}
  ## Get the tangential velocity at WorldLocation for the given component.

proc getMovementBaseTransform(movementBase: ptr UPrimitiveComponent;
                              boneName: FName; outLocation: var FVector;
                              outQuat: var FQuat): bool {.
  header: "GameFramework/Character.h", importcpp: "MovementBaseUtility::GetMovementBaseTransform".}
  ## Get the transforms for the given MovementBase, optionally at the location of a bone. Returns false if MovementBase is NULL, or if BoneName is not a valid bone.

type
  FBasedMovementInfo* = object
    ## Struct to hold information about the "base" object the character is standing on.
    movementBase* {.importcpp: "MovementBase".}: ptr UPrimitiveComponent
      ## Component we are based on
    boneName* {.importcpp: "BoneName".}: FName
      ## Bone name on component, for skeletal meshes. NAME_None if not a skeletal mesh or if bone is invalid.
    location* {.importcpp: "Location".}: FVector_NetQuantize100
      ## Location relative to MovementBase. Only valid if HasRelativeLocation() is true.
    rotation* {.importcpp: "Rotation".}: FRotator
      ## Rotation: relative to MovementBase if HasRelativeRotation() is true, absolute otherwise.
    bServerHasBaseComponent*: bool
      ## Whether the server says that there is a base. On clients, the component may not have resolved yet.
    bRelativeRotation*: bool
      ## Whether rotation is relative to the base or absolute. It can only be relative if location is also relative.
    bServerHasVelocity*: bool
      ## Whether there is a velocity on the server. Used for forcing replication when velocity goes to zero.

proc hasRelativeLocation(this: FBasedMovementInfo): bool {.
  header: "GameFramework/Character.h", importcpp: "HasRelativeLocation", noSideEffect.}
proc hasRelativeRotation(this: FBasedMovementInfo): bool {.
  header: "GameFramework/Character.h", importcpp: "HasRelativeRotation", noSideEffect.}
proc isBaseUnresolved(this: FBasedMovementInfo): bool {.
  header: "GameFramework/Character.h", importcpp: "IsBaseUnresolved", noSideEffect.}

declareBuiltinDelegate(FMovementModeChangedSignature, dkDynamicMulticast, "GameFramework/Character.h",
                       character: ptr ACharacter, prevMovementMode: EMovementMode, prevCustomMode: uint8)
declareBuiltinDelegate(FCharacterMovementUpdatedSignature, dkDynamicMulticast, "GameFramework/Character.h",
                       deltaSeconds: cfloat, oldLocation: FVector, oldVelocity: FVector)
declareBuiltinDelegate(FCharacterReachedApexSignature, dkDynamicMulticast, "GameFramework/Character.h")
declareBuiltinDelegate(FLandedSignature, dkDynamicMulticast, "GameFramework/Character.h",
                       hit: FHitResult)

wclass(ACharacter of APawn, header: "GameFramework/Character.h", notypedef):
  ## Characters are Pawns that have a mesh, collision, and built-in movement logic.
  ## They are responsible for all physical interaction between the player or AI and the world, and also implement basic networking and input models.
  ## They are designed for a vertically-oriented player representation that can walk, jump, fly, and swim through the world using CharacterMovementComponent.
  ##
  ## @see APawn, UCharacterMovementComponent
  ## @see https://docs.unrealengine.com/latest/INT/Gameplay/Framework/Pawn/Character/

# public:

  proc getLifetimeReplicatedProps(outLifetimeProps: var TArray[FLifetimeProperty]) {.noSideEffect.}

  var meshComponentName {.isStatic.}: FName
    ## Name of the MeshComponent. Use this name if you want to prevent creation of the component (with ObjectInitializer.DoNotCreateDefaultSubobject).

  var characterMovementComponentName {.isStatic.}: FName
    ## Name of the CharacterMovement component. Use this name if you want to use a different class (with ObjectInitializer.SetDefaultSubobjectClass).

  var capsuleComponentName {.isStatic.}: FName
    ## Name of the CapsuleComponent.

  method setBase(newBase: ptr UPrimitiveComponent; boneName: FName = NAME_None;
                 bNotifyActor: bool = true) {.isStatic.}
    ## Sets the component the Character is walking on, used by CharacterMovement walking movement to be able to follow dynamic objects.

  method onRep_ReplicatedBasedMovement()
    ## Rep notify for ReplicatedBasedMovement
    ## UFUNCTION()

  method setReplicateMovement(bInReplicateMovement: bool)
    ## Set whether this actor's movement replicates to network clients.
    ## UFUNCTION(BlueprintCallable, Category = "Replication")

  proc getBasedMovement(): var FBasedMovementInfo {.noSideEffect.}
    ## Accessor for BasedMovement

  proc getReplicatedBasedMovement(): var FBasedMovementInfo {.noSideEffect.}
    ## Accessor for ReplicatedBasedMovement

  proc saveRelativeBasedMovement(newRelativeLocation: FVector; newRotation: FRotator;
                                 bRelativeRotation: bool)
    ## Save a new relative location in BasedMovement and a new rotation with is either relative or absolute.

  proc getReplicatedMovementMode(): uint8 {.noSideEffect.}
    ## Returns ReplicatedMovementMode

  proc getBaseTranslationOffset(): var FVector {.noSideEffect.}
    ## @return Saved translation offset of mesh.

  method getBaseRotationOffset(): FQuat {.noSideEffect.}
    ## @return Saved rotation offset of mesh.

  method getNavAgentLocation(): FVector {.noSideEffect.}

  var crouchedEyeHeight: cfloat
    ## Default crouched eye height
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Camera)

  var bIsCrouched: bool
    ## Set by character movement to specify that this Character is currently crouched.
    ## UPROPERTY(BlueprintReadOnly, replicatedUsing=OnRep_IsCrouched, Category=Character)

  method onRep_IsCrouched()
    ## Handle Crouching replicated from server
    ## UFUNCTION()

  var bPressedJump: bool
    ## When true, player wants to jump
    ## UPROPERTY(BlueprintReadOnly, Category="Pawn|Character")

  var bClientUpdating: bool
    ## When true, applying updates to network client (replaying saved moves for a locally controlled character)
    ## UPROPERTY(Transient)

  var bClientWasFalling: bool
    ## True if Pawn was initially falling when started to replay network moves.
    ## UPROPERTY(Transient)

  var bClientResimulateRootMotion: bool
    ## If server disagrees with root motion track position, client has to resimulate root motion from last AckedMove.
    ## UPROPERTY(Transient)

  var bClientResimulateRootMotionSources: bool
    ## If server disagrees with root motion state, client has to resimulate root motion from last AckedMove.
    ## UPROPERTY(Transient)

  var bSimGravityDisabled: bool
    ## Disable simulated gravity (set when character encroaches geometry on client, to keep him from falling through floors)
    ## UPROPERTY()

  var bClientCheckEncroachmentOnNetUpdate: bool
    ## UPROPERTY(Transient)

  var bServerMoveIgnoreRootMotion: bool
    ## Disable root motion on the server. When receiving a DualServerMove, where the first move is not root motion and the second is.
    ## UPROPERTY(Transient)

  var jumpKeyHoldTime: cfloat
    ## Jump key Held Time.
    ## This is the time that the player has held the jump key, in seconds.
    ##
    ## UPROPERTY(Transient, BlueprintReadOnly, VisibleInstanceOnly, Category=Character)

  var jumpMaxHoldTime: cfloat
    ## The max time the jump key can be held.
    ## Note that if StopJumping() is not called before the max jump hold time is reached,
    ## then the character will carry on receiving vertical velocity. Therefore it is usually
    ## best to call StopJumping() when jump input has ceased (such as a button up event).
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Replicated, Category=Character)

  method applyDamageMomentum(damageTaken: cfloat; damageEvent: FDamageEvent;
                           pawnInstigator: ptr APawn; damageCauser: ptr AActor)
    ## Apply momentum caused by damage.

  method jump()
    ## Make the character jump on the next update.
    ## If you want your character to jump according to the time that the jump key is held,
    ## then you can set JumpKeyHoldTime to some non-zero value. Make sure in this case to
    ## call StopJumping() when you want the jump's z-velocity to stop being applied (such
    ## as on a button up event), otherwise the character will carry on receiving the
    ## velocity until JumpKeyHoldTime is reached.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Character")

  method stopJumping()
    ## Stop the character from jumping on the next update.
    ## Call this from an input event (such as a button 'up' event) to cease applying
    ## jump Z-velocity. If this is not called, then jump z-velocity will be applied
    ## until JumpMaxHoldTime is reached.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Character")

  proc canJump(): bool {.noSideEffect.}
    ## Check if the character can jump in the current state.
    ##
    ## The default implementation may be overridden or extended by implementing the custom CanJump event in Blueprints.
    ##
    ## @Return Whether the character can jump in the current state.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Character")

  method isJumpProvidingForce(): bool {.noSideEffect.}
    ## True if jump is actively providing a force, such as when the jump key is held and the time it has been held is less than JumpMaxHoldTime.
    ## @see CharacterMovement->IsFalling
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Character")

  method playAnimMontage(animMontage: ptr UAnimMontage; inPlayRate: cfloat = 1.0;
                         startSectionName: FName = NAME_None): cfloat {.discardable.}
    ## Play Animation Montage on the character mesh *
    ## UFUNCTION(BlueprintCallable, Category=Animation)

  method stopAnimMontage(animMontage: ptr UAnimMontage = nil)
    ## Stop Animation Montage. If NULL, it will stop what's currently active. The Blend Out Time is taken from the montage asset that is being stopped. *
    ## UFUNCTION(BlueprintCallable, Category=Animation)

  proc getCurrentMontage(): ptr UAnimMontage
    ## Return current playing Montage *
    ## UFUNCTION(BlueprintCallable, Category=Animation)

  method launchCharacter(launchVelocity: FVector; bXYOverride: bool; bZOverride: bool)
    ## Set a pending launch velocity on the Character. This velocity will be processed on the next CharacterMovementComponent tick,
    ## and will set it to the "falling" state. Triggers the OnLaunched event.
    ## @PARAM LaunchVelocity is the velocity to impart to the Character
    ## @PARAM bXYOverride if true replace the XY part of the Character's velocity instead of adding to it.
    ## @PARAM bZOverride if true replace the Z component of the Character's velocity instead of adding to it.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Character")

  proc onLaunched(launchVelocity: FVector; bXYOverride: bool; bZOverride: bool)
    ## Let blueprint know that we were launched
    ## UFUNCTION(BlueprintImplementableEvent)

  proc onJumped()
    ## Event fired when the character has just started jumping
    ## UFUNCTION(BlueprintNativeEvent, Category="Pawn|Character")
  method onJumped_Implementation()


  method falling()
    ## Called when the character's movement enters falling

  method notifyJumpApex()
    ## Called when character's jump reaches Apex. Needs CharacterMovement->bNotifyApex = true

  var onReachedJumpApex: FCharacterReachedApexSignature
    ## Broadcast when Character's jump reaches its apex. Needs CharacterMovement->bNotifyApex = true
    ## UPROPERTY(BlueprintAssignable)

  method landed(hit: FHitResult)
    ## Called upon landing when falling, to perform actions based on the Hit result. Triggers the OnLanded event.
    ## Note that movement mode is still "Falling" during this event. Current Velocity value is the velocity at the time of landing.
    ## Consider OnMovementModeChanged() as well, as that can be used once the movement mode changes to the new mode (most likely Walking).
    ##
    ## @param Hit Result describing the landing that resulted in a valid landing spot.
    ## @see OnMovementModeChanged()

  var landedDelegate: FLandedSignature
    ## Called upon landing when falling, to perform actions based on the Hit result.
    ## Note that movement mode is still "Falling" during this event. Current Velocity value is the velocity at the time of landing.
    ## Consider OnMovementModeChanged() as well, as that can be used once the movement mode changes to the new mode (most likely Walking).
    ##
    ## @param Hit Result describing the landing that resulted in a valid landing spot.
    ## @see OnMovementModeChanged()

  proc onLanded(hit: FHitResult)
    ## Called upon landing when falling, to perform actions based on the Hit result.
    ## Note that movement mode is still "Falling" during this event. Current Velocity value is the velocity at the time of landing.
    ## Consider OnMovementModeChanged() as well, as that can be used once the movement mode changes to the new mode (most likely Walking).
    ##
    ## @param Hit Result describing the landing that resulted in a valid landing spot.
    ## @see OnMovementModeChanged()
    ##
    ## UFUNCTION(BlueprintImplementableEvent)

  proc onWalkingOffLedge(previousFloorImpactNormal: FVector;
                        previousFloorContactNormal: FVector;
                        previousLocation: FVector; timeDelta: cfloat)
    ## Event fired when the Character is walking off a surface and is about to fall because CharacterMovement->CurrentFloor became unwalkable.
    ## If CharacterMovement->MovementMode does not change during this event then the character will automatically start falling afterwards.
    ## @note Z velocity is zero during walking movement, and will be here as well. Another velocity can be computed here if desired and will be used when starting to fall.
    ##
    ## @param  PreviousFloorImpactNormal Normal of the previous walkable floor.
    ## @param  PreviousFloorContactNormal Normal of the contact with the previous walkable floor.
    ## @param  PreviousLocation	Previous character location before movement off the ledge.
    ## @param  TimeTick	Time delta of movement update resulting in moving off the ledge.
    ##
    ## UFUNCTION(BlueprintNativeEvent, Category="Pawn|Character")
  method onWalkingOffLedge_Implementation(previousFloorImpactNormal: FVector;
                                      previousFloorContactNormal: FVector;
                                      previousLocation: FVector; timeDelta: cfloat)

  method moveBlockedBy(impact: FHitResult)
    ## Called when pawn's movement is blocked
    ## @PARAM Impact describes the blocking hit.

  method crouch(bClientSimulation: bool = false)
    ## Request the character to start crouching. The request is processed on the next update of the CharacterMovementComponent.
    ## @see OnStartCrouch
    ## @see IsCrouched
    ## @see CharacterMovement->WantsToCrouch
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Character", meta=(HidePin="bClientSimulation"))

  method unCrouch(bClientSimulation: bool = false)
    ## Request the character to stop crouching. The request is processed on the next update of the CharacterMovementComponent.
    ## @see OnEndCrouch
    ## @see IsCrouched
    ## @see CharacterMovement->WantsToCrouch
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Character", meta=(HidePin="bClientSimulation"))

  method canCrouch(): bool
    ## @return true if this character is currently able to crouch (and is not currently crouched)

  method onEndCrouch(halfHeightAdjust: cfloat; scaledHalfHeightAdjust: cfloat)
    ## Called when Character stops crouching. Called on non-owned Characters through bIsCrouched replication.
    ## @param	HalfHeightAdjust		difference between default collision half-height, and actual crouched capsule half-height.
    ## @param	ScaledHalfHeightAdjust	difference after component scale is taken in to account.

  proc k2_OnEndCrouch(halfHeightAdjust: cfloat; scaledHalfHeightAdjust: cfloat)
    ## Event when Character stops crouching.
    ## @param	HalfHeightAdjust		difference between default collision half-height, and actual crouched capsule half-height.
    ## @param	ScaledHalfHeightAdjust	difference after component scale is taken in to account.
    ##
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "OnEndCrouch"))

  method onStartCrouch(halfHeightAdjust: cfloat; scaledHalfHeightAdjust: cfloat)
    ## Called when Character crouches. Called on non-owned Characters through bIsCrouched replication.
    ## @param	HalfHeightAdjust		difference between default collision half-height, and actual crouched capsule half-height.
    ## @param	ScaledHalfHeightAdjust	difference after component scale is taken in to account.

  proc k2_OnStartCrouch(halfHeightAdjust: cfloat; scaledHalfHeightAdjust: cfloat)
    ## Event when Character crouches.
    ## @param	HalfHeightAdjust		difference between default collision half-height, and actual crouched capsule half-height.
    ## @param	ScaledHalfHeightAdjust	difference after component scale is taken in to account.
    ##
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "OnStartCrouch"))

  method onMovementModeChanged(prevMovementMode: EMovementMode;
                             previousCustomMode: uint8 = 0)
    ## Called from CharacterMovementComponent to notify the character that the movement mode has changed.
    ## @param	PrevMovementMode	Movement mode before the change
    ## @param	PrevCustomMode		Custom mode before the change (applicable if PrevMovementMode is Custom)

  var movementModeChangedDelegate: FMovementModeChangedSignature
    ## Native multicast delegate for MovementMode changing.

  proc k2_OnMovementModeChanged(prevMovementMode: EMovementMode;
                                newMovementMode: EMovementMode;
                                prevCustomMode: uint8; newCustomMode: uint8)
    ## Called from CharacterMovementComponent to notify the character that the movement mode has changed.
    ## @param	PrevMovementMode	Movement mode before the change
    ## @param	NewMovementMode		New movement mode
    ## @param	PrevCustomMode		Custom mode before the change (applicable if PrevMovementMode is Custom)
    ## @param	NewCustomMode		New custom mode (applicable if NewMovementMode is Custom)
    ##
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "OnMovementModeChanged"))

  proc k2_UpdateCustomMovement(deltaTime: cfloat)
    ## Event for implementing custom character movement mode. Called by CharacterMovement if MovementMode is set to Custom.
    ## @note C++ code should override UCharacterMovementComponent::PhysCustom() instead.
    ## @see UCharacterMovementComponent::PhysCustom()
    ##
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "UpdateCustomMovement"))

  var onCharacterMovementUpdated: FCharacterMovementUpdatedSignature
    ## Event triggered at the end of a CharacterMovementComponent movement update.
    ## This is the preferred event to use rather than the Tick event when performing custom updates to CharacterMovement properties based on the current state.
    ## This is mainly due to the nature of network updates, where client corrections in position from the server can cause multiple iterations of a movement update,
    ## which allows this event to update as well, while a Tick event would not.
    ##
    ## @param	DeltaSeconds		Delta time in seconds for this update
    ## @param	InitialLocation		Location at the start of the update. May be different than the current location if movement occurred.
    ## @param	InitialVelocity		Velocity at the start of the update. May be different than the current velocity.
    ##
    ## UPROPERTY(BlueprintAssignable, Category="Pawn|Character")

  method shouldNotifyLanded(hit: FHitResult): bool
    ## Returns true if the Landed() event should be called. Used by CharacterMovement to prevent notifications while playing back network moves.

  method checkJumpInput(deltaTime: cfloat)
    ## Trigger jump if jump button has been pressed.

  method clearJumpInput()
    ## Reset jump input state after having checked input.

  method getJumpMaxHoldTime(): cfloat {.noSideEffect.}
    ## Get the maximum jump time for the character.
    ## Note that if StopJumping() is not called before the max jump hold time is reached,
    ## then the character will carry on receiving vertical velocity. Therefore it is usually
    ## best to call StopJumping() when jump input has ceased (such as a button up event).
    ##
    ## @return Maximum jump time for the character


  proc clientCheatWalk()
    ## UFUNCTION(reliable, client)
  proc clientCheatWalk_Implementation()

  proc clientCheatFly()
    ## UFUNCTION(reliable, client)
  proc clientCheatFly_Implementation()

  proc clientCheatGhost()
    ## UFUNCTION(reliable, client)
  proc clientCheatGhost_Implementation()


# Root Motion

  var savedRootMotion: FRootMotionSourceGroup
    ## For LocallyControlled Autonomous clients.
    ## During a PerformMovement() after root motion is prepared, we save it off into this and
    ## then record it into our SavedMoves.
    ## During SavedMove playback we use it as our "Previous Move" SavedRootMotion which includes
    ## last received root motion from the Server
    ##
    ## UPROPERTY(Transient)

  var clientRootMotionParams: FRootMotionMovementParams
    ## For LocallyControlled Autonomous clients. Saved root motion data to be used by SavedMoves.
    ## UPROPERTY(Transient)

  var rootMotionRepMoves: TArray[FSimulatedRootMotionReplicatedMove]
    ## Array of previously received root motion moves from the server.
    ## UPROPERTY(Transient)

  proc findRootMotionRepMove(clientMontageInstance: FAnimMontageInstance): int32 {.noSideEffect.}
    ## Find usable root motion replicated move from our buffer.
    ## Goes through the buffer back in time, to find the first move that clears 'CanUseRootMotionRepMove' below.
    ## Returns index of that move or INDEX_NONE otherwise.

  proc canUseRootMotionRepMove(rootMotionRepMove: FSimulatedRootMotionReplicatedMove;
                               clientMontageInstance: FAnimMontageInstance): bool {.noSideEffect.}
    ## true if buffered move is usable to teleport client back to.

  proc restoreReplicatedMove(rootMotionRepMove: FSimulatedRootMotionReplicatedMove): bool
    ## Restore actor to an old buffered move.

  method onUpdateSimulatedPosition(oldLocation: FVector; oldRotation: FQuat)
    ## Called on client after position update is received to respond to the new location and rotation.
    ## Actual change in location is expected to occur in CharacterMovement->SmoothCorrection(), after which this occurs.
    ## Default behavior is to check for penetration in a blocking object if bClientCheckEncroachmentOnNetUpdate is enabled, and set bSimGravityDisabled=true if so.

  var repRootMotion: FRepRootMotionMontage
    ## Replicated Root Motion montage
    ## UPROPERTY(ReplicatedUsing=OnRep_RootMotion)

  proc onRep_RootMotion()
    ## Handles replicated root motion properties on simulated proxies and position correction.
    ## UFUNCTION()

  proc simulatedRootMotionPositionFixup(deltaSeconds: cfloat)
    ## Position fix up for Simulated Proxies playing Root Motion

  proc getRootMotionAnimMontageInstance(): ptr FAnimMontageInstance {.noSideEffect.}
    ## Get FAnimMontageInstance playing RootMotion

  proc isPlayingRootMotion(): bool {.noSideEffect.}
    ## true if we are playing Root Motion right now
    ## UFUNCTION(BlueprintCallable, Category=Animation)

  proc isPlayingNetworkedRootMotionMontage(): bool {.noSideEffect.}
    ## true if we are playing Root Motion right now, through a Montage with RootMotionMode == ERootMotionMode::RootMotionFromMontagesOnly.
    ## This means code path for networked root motion is enabled.
    ## UFUNCTION(BlueprintCallable, Category = Animation)

  method preReplication(changedPropertyTracker: var IRepChangedPropertyTracker)
    ## Called on the actor right before replication occurs

  proc getMesh(): ptr USkeletalMeshComponent {.noSideEffect.}
    ## Returns Mesh subobject *

# when WITH_EDITORONLY_DATA:
  proc getArrowComponent(): ptr UArrowComponent {.noSideEffect.}
    ## Returns ArrowComponent subobject *
# endwhen

  proc getCharacterMovement(): ptr UCharacterMovementComponent {.noSideEffect.}
    ## Returns CharacterMovement subobject *

  proc getCapsuleComponent(): ptr UCapsuleComponent {.noSideEffect.}
    ## Returns CapsuleComponent subobject *

# protected:
  var basedMovement: FBasedMovementInfo
    ## Info about our current movement base (object we are standing on).
    ## UPROPERTY()

  var replicatedBasedMovement: FBasedMovementInfo
    ## Replicated version of relative movement. Read-only on simulated proxies!
    ## UPROPERTY(ReplicatedUsing=OnRep_ReplicatedBasedMovement)

  var baseTranslationOffset: FVector
    ## Saved translation offset of mesh.
    ## UPROPERTY()

  var baseRotationOffset: FQuat
    ## Saved rotation offset of mesh.
    ## UPROPERTY()

  method baseChange()
    ## Event called after actor's base changes (if SetBase was requested to notify us with bNotifyPawn).

  var replicatedMovementMode: uint8
    ## CharacterMovement MovementMode (and custom mode) replicated for simulated proxies. Use CharacterMovementComponent::UnpackNetworkMovementMode() to translate it.
    ## UPROPERTY(Replicated)

  var bInBaseReplication: bool
    ## Flag that we are receiving replication of the based movement.
    ## UPROPERTY()

  proc canJumpInternal(): bool {.noSideEffect.}
    ## Customizable event to check if the character can jump in the current state.
    ## Default implementation returns true if the character is on the ground and not crouching,
    ## has a valid CharacterMovementComponent and CanEverJump() returns true.
    ## Default implementation also allows for 'hold to jump higher' functionality:
    ## As well as returning true when on the ground, it also returns true when GetMaxJumpTime is more
    ## than zero and IsJumping returns true.
    ##
    ##
    ## @Return Whether the character can jump in the current state.
    ##
    ## UFUNCTION(BlueprintNativeEvent, Category="Pawn|Character", meta=(DisplayName="CanJump"))
  method canJumpInternal_Implementation(): bool {.noSideEffect.}
