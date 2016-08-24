wclass(APawn of AActor, header: "GameFramework/Pawn.h", notypedef):
  ##  Pawn is the base class of all actors that can be possessed by players or AI.
  ##  They are the physical representations of players and creatures in a level.
  ##
  ##  @see https://docs.unrealengine.com/latest/INT/Gameplay/Framework/Pawn/

  method getLifetimeReplicatedProps(outLifetimeProps: var TArray[FLifetimeProperty]) {.noSideEffect.}

  method getMovementComponent(): ptr UPawnMovementComponent {.noSideEffect.}
    ## Return our PawnMovementComponent, if we have one. By default, returns the first PawnMovementComponent found. Native classes that create their own movement component should override this method for more efficiency.
    ## UFUNCTION(BlueprintCallable, meta=(Tooltip="Return our PawnMovementComponent, if we have one."), Category="Pawn")

  method getMovementBase(): ptr UPrimitiveComponent {.noSideEffect.}
    ## Return PrimitiveComponent we are based on (standing on, attached to, and moving on).

  var bUseControllerRotationPitch: bool
    ## If true, this Pawn's pitch will be updated to match the Controller's ControlRotation pitch, if controlled by a PlayerController.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Pawn)

  var bUseControllerRotationYaw: bool
    ## If true, this Pawn's yaw will be updated to match the Controller's ControlRotation yaw, if controlled by a PlayerController.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Pawn)

  var bUseControllerRotationRoll: bool
    ## If true, this Pawn's roll will be updated to match the Controller's ControlRotation roll, if controlled by a PlayerController.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Pawn)

  var bCanAffectNavigationGeneration: bool
    ## If set to false (default) given pawn instance will never affect navigation generation.
    ## Setting it to true will result in using regular AActor's navigation relevancy
    ## calculation to check if this pawn instance should affect navigation generation
    ## Use SetCanAffectNavigationGeneration to change this value at runtime.
    ## Note that modifying this value at runtime will result in any navigation change only if runtime navigation generation is enabled.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category = Pawn)

  var baseEyeHeight: cfloat
    ## Base eye height above collision center.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Camera)

  var autoPossessPlayer: EAutoReceiveInput
    ## Determines which PlayerController, if any, should automatically possess the pawn when the level starts or when the pawn is spawned.
    ## @see AutoPossessAI
    ##
    ## UPROPERTY(EditAnywhere, Category=Pawn)

  var autoPossessAI: EAutoPossessAI
    ## Determines when the Pawn creates and is possessed by an AI Controller (on level start, when spawned, etc).
    ## Only possible if AIControllerClass is set, and ignored if AutoPossessPlayer is enabled.
    ## @see AutoPossessPlayer
    ##
    ## UPROPERTY(EditAnywhere, Category=Pawn)

  var AIControllerClass: TSubclassOf[AController]
    ## Default class to use when pawn is controlled by AI.
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, meta=(DisplayName="AI Controller Class"), Category=Pawn)

  method getPawnNoiseEmitterComponent(): ptr UPawnNoiseEmitterComponent {.noSideEffect.}
    ## Return our PawnNoiseEmitterComponent, if any. Default implementation returns the first PawnNoiseEmitterComponent found in the components array.
    ## If one isn't found, then it tries to find one on the Pawn's current Controller.

  proc pawnMakeNoise(loudness: cfloat; noiseLocation: FVector;
                     bUseNoiseMakerLocation: bool = true; noiseMaker: ptr AActor = nil)
    ## Inform AIControllers that you've made a noise they might hear (they are sent a HearNoise message if they have bHearNoises==true)
    ## The instigator of this sound is the pawn which is used to call MakeNoise.
    ##
    ## @param Loudness - is the relative loudness of this noise (range 0.0 to 1.0).  Directly affects the hearing range specified by the AI's HearingThreshold.
    ## @param NoiseLocation - Position of noise source.  If zero vector, use the actor's location.
    ## @param bUseNoiseMakerLocation - If true, use the location of the NoiseMaker rather than NoiseLocation.  If false, use NoiseLocation.
    ## @param NoiseMaker - Which actor is the source of the noise.  Not to be confused with the Noise Instigator, which is responsible for the noise (and is the pawn on which this function is called).  If not specified, the pawn instigating the noise will be used as the NoiseMaker
    ##
    ## UFUNCTION(BlueprintCallable, BlueprintAuthorityOnly, Category=AI)

  var playerState: ptr APlayerState
    ## If Pawn is possessed by a player, points to his playerstate.  Needed for network play as controllers are not replicated to clients.
    ## UPROPERTY(replicatedUsing=OnRep_PlayerState, BlueprintReadOnly, Category="Pawn")

  var remoteViewPitch: uint8
    ## Replicated so we can see where remote clients are looking.
    ## UPROPERTY(replicated)

  var lastHitBy: ptr AController
    ## Controller of the last Actor that caused us damage.
    ## UPROPERTY(transient)

  var controller: ptr AController
    ## Controller currently possessing this Actor
    ## UPROPERTY(replicatedUsing=OnRep_Controller)

  var allowedYawError: cfloat
    ## Max difference between pawn's Rotation.Yaw and GetDesiredRotation().Yaw for pawn to be considered as having reached its desired rotation

  method turnOff()
    ## Freeze pawn - stop sounds, animations, physics, weapon firing

  method restart()
    ## Called when the Pawn is being restarted (usually by being possessed by a Controller).

  method pawnStartFire(fireModeNum: uint8 = 0)
    ## Handle StartFire() passed from PlayerController

  proc setRemoteViewPitch(newRemoteViewPitch: cfloat)
    ## Set Pawn ViewPitch, so we can see where remote clients are looking.
    ## Maps 360.0 degrees into a byte
    ## @param	NewRemoteViewPitch	Pitch component to replicate to remote (non owned) clients.

  method unPossessed()
    ## Called when our Controller no longer possesses us.

  method getPawnPhysicsVolume(): ptr APhysicsVolume {.noSideEffect.}
    ## Return Physics Volume for this Pawn

  proc getMovementBaseActor(pawn: ptr APawn): ptr AActor {.isStatic.}
    ## Gets the owning actor of the Movement Base Component on which the pawn is standing.
    ## UFUNCTION(BlueprintPure, Category="Pawn")

  method reachedDesiredRotation(): bool

  method getDefaultHalfHeight(): cfloat {.noSideEffect.}
    ## @return The half-height of the default Pawn, scaled by the component scale.
    ## By default returns the half-height of the RootComponent, regardless of whether it is registered or collidable.

  proc isControlled(): bool {.noSideEffect.}
    ## See if this actor is currently being controlled
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  proc getController(): ptr AController {.noSideEffect.}
    ## Returns controller for this actor.
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  proc getControlRotation(): FRotator {.noSideEffect.}
    ## Get the rotation of the Controller, often the 'view' rotation of this Pawn.
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  method onRep_Controller()
    ## Called when Controller is replicated
    ## UFUNCTION()

  method onRep_PlayerState()
    ## PlayerState Replication Notification Callback
    ## UFUNCTION()

  var bProcessingOutsideWorldBounds: bool
    ## Used to prevent re-entry of OutsideWorldBounds event.

  proc setCanAffectNavigationGeneration(bNewValue: bool)
    ## Use SetCanAffectNavigationGeneration to change this value at runtime.
    ## Note that calling this function at runtime will result in any navigation change only if runtime navigation generation is enabled.
    ## UFUNCTION(BlueprintCallable, Category="AI|Navigation")

  method updateNavigationRelevance()
    ## update all components relevant for navigation generators to match bCanAffectNavigationGeneration flag

  # Begin INavAgentInterface Interface
  method getNavAgentPropertiesRef(): var FNavAgentProperties {.noSideEffect.}

  method getNavAgentLocation(): FVector {.noSideEffect.}
    ## Basically retrieved pawn's location on navmesh
    ## UFUNCTION(BlueprintCallable, Category="Pawn")
  method getMoveGoalReachTest(movingActor: ptr AActor; moveOffset: FVector;
                            goalOffset: var FVector; goalRadius: var cfloat;
                            goalHalfHeight: var cfloat) {.noSideEffect.}
  # End INavAgentInterface Interface

  proc updateNavAgent()
    ## Updates MovementComponent's parameters used by navigation system

  method shouldTakeDamage(damage: cfloat; damageEvent: FDamageEvent;
                        eventInstigator: ptr AController; damageCauser: ptr AActor): bool {.noSideEffect.}
    ## @return true if we are in a state to take damage (checked at the start of TakeDamage.
    ## Subclasses may check this as well if they override TakeDamage and don't want to potentially trigger TakeDamage actions by checking if it returns zero in the super class.

  #if WITH_EDITOR:
  method editorApplyRotation(deltaRotation: FRotator; bAltDown: bool;
                           bShiftDown: bool; bCtrlDown: bool)
  #endif

  proc getGravityDirection(): FVector
    ## @return vector direction of gravity

  method setPlayerDefaults()
    ## Make sure pawn properties are back to default.

  method recalculateBaseEyeHeight()
    ## Set BaseEyeHeight based on current state.

  proc inputEnabled(): bool {.noSideEffect.}

  method possessedBy(newController: ptr AController)
    ## Called when this Pawn is possessed. Only called on the server (or in standalone).
    ##  	@param C The controller possessing this pawn
    ## Event called when the Pawn is possessed by a Controller (normally only occurs on the server/standalone).
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "Possessed"))

  proc receivePossessed(newController: ptr AController)
    ## Event called when the Pawn is no longer possessed by a Controller.
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "Unpossessed"))

  proc receiveUnpossessed(oldController: ptr AController)

  method isLocallyControlled(): bool {.noSideEffect.}
    ## @return true if controlled by a local (not network) Controller.
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  method getViewRotation(): FRotator {.noSideEffect.}
    ## Get the view rotation of the Pawn (direction they are looking, normally Controller->ControlRotation).
    ## @return The view rotation of the Pawn.

  method getPawnViewLocation(): FVector {.noSideEffect.}
    ## @return	Pawn's eye location

  method getBaseAimRotation(): FRotator {.noSideEffect.}
    ## Return the aim rotation for the Pawn.
    ## If we have a controller, by default we aim at the player's 'eyes' direction
    ## that is by default the Pawn rotation for AI, and camera (crosshair) rotation for human players.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  method inFreeCam(): bool {.noSideEffect.}
    ## Return true if player is viewing this Pawn in FreeCam

  method pawnClientRestart()
    ## Tell client that the Pawn is begin restarted. Calls Restart().

  method clientSetRotation(newRotation: FRotator)
    ## Replicated function to set the pawn rotation, allowing the server to force.

  method faceRotation(newControlRotation: FRotator; deltaTime: cfloat = 0.0)
    ## Updates Pawn's rotation to the given rotation, assumed to be the Controller's ControlRotation. Respects the bUseControllerRotation* settings.

  method detachFromControllerPendingDestroy()
    ## Call this function to detach safely pawn from its controller, knowing that we will be destroyed soon.
    ## UFUNCTION(BlueprintCallable, Category="Pawn", meta=(Keywords = "Delete"))

  method spawnDefaultController()
    ## Spawn default controller for this Pawn, and get possessed by it.
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  method getDamageInstigator(instigatedBy: ptr AController; damageType: UDamageType): ptr AController {.noSideEffect.}
    ## Get the controller instigating the damage.
    ## If the damage is caused by the world and the supplied controller is NULL or is this pawn's controller, uses LastHitBy as the instigator.

  method createPlayerInputComponent(): ptr UInputComponent
    ## Creates an InputComponent that can be used for custom input bindings.
    ## Called upon possession by a PlayerController. Return null if you don't want one.

  method destroyPlayerInputComponent()
    ## Destroys the player input component and removes any references to it.

  method setupPlayerInputComponent(inInputComponent: ptr UInputComponent)
    ## Allows a Pawn to set up custom input bindings.
    ## Called upon possession by a PlayerController, using the InputComponent created by CreatePlayerInputComponent().

  method addMovementInput(worldDirection: FVector; scaleValue: cfloat = 1.0; bForce: bool = false)
    ## Add movement input along the given world direction vector (usually normalized) scaled by 'ScaleValue'. If ScaleValue < 0, movement will be in the opposite direction.
    ## Base Pawn classes won't automatically apply movement, it's up to the user to do so in a Tick event. Subclasses such as Character and DefaultPawn automatically handle this input and move.
    ##
    ## @param WorldDirection	Direction in world space to apply input
    ## @param ScaleValue		Scale to apply to input. This can be used for analog input, ie a value of 0.5 applies half the normal value, while -1.0 would reverse the direction.
    ## @param bForce			If true always add the input, ignoring the result of IsMoveInputIgnored().
    ## @see GetPendingMovementInputVector(), GetLastMovementInputVector(), ConsumeMovementInputVector()
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Input", meta=(Keywords="AddInput"))

  proc getPendingMovementInputVector(): FVector {.noSideEffect.}
    ## Return the pending input vector in world space. This is the most up-to-date value of the input vector, pending ConsumeMovementInputVector() which clears it,
    ## Usually only a PawnMovementComponent will want to read this value, or the Pawn itself if it is responsible for movement.
    ##
    ## @return The pending input vector in world space.
    ## @see AddMovementInput(), GetLastMovementInputVector(), ConsumeMovementInputVector()
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Input", meta=(Keywords="GetMovementInput GetInput"))

  proc getLastMovementInputVector(): FVector {.noSideEffect.}
    ## Return the last input vector in world space that was processed by ConsumeMovementInputVector(), which is usually done by the Pawn or PawnMovementComponent.
    ## Any user that needs to know about the input that last affected movement should use this function.
    ## For example an animation update would want to use this, since by default the order of updates in a frame is:
    ## PlayerController (device input) -> MovementComponent -> Pawn -> Mesh (animations)
    ##
    ## @return The last input vector in world space that was processed by ConsumeMovementInputVector().
    ## @see AddMovementInput(), GetPendingMovementInputVector(), ConsumeMovementInputVector()
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Input", meta=(Keywords="GetMovementInput GetInput"))

  method consumeMovementInputVector(): FVector
    ## Returns the pending input vector and resets it to zero.
    ## This should be used during a movement update (by the Pawn or PawnMovementComponent) to prevent accumulation of control input between frames.
    ## Copies the pending input vector to the saved input vector (GetLastMovementInputVector()).
    ## @return The pending input vector.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Input", meta=(Keywords="ConsumeInput"))

  method addControllerPitchInput(val: cfloat)
    ## Add input (affecting Pitch) to the Controller's ControlRotation, if it is a local PlayerController.
    ## This value is multiplied by the PlayerController's InputPitchScale value.
    ## @param Val Amount to add to Pitch. This value is multiplied by the PlayerController's InputPitchScale value.
    ## @see PlayerController::InputPitchScale
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Input", meta=(Keywords="up down addpitch"))

  method addControllerYawInput(val: cfloat)
    ## Add input (affecting Yaw) to the Controller's ControlRotation, if it is a local PlayerController.
    ## This value is multiplied by the PlayerController's InputYawScale value.
    ## @param Val Amount to add to Yaw. This value is multiplied by the PlayerController's InputYawScale value.
    ## @see PlayerController::InputYawScale
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Input", meta=(Keywords="left right turn addyaw"))

  method addControllerRollInput(val: cfloat)
    ## Add input (affecting Roll) to the Controller's ControlRotation, if it is a local PlayerController.
    ## This value is multiplied by the PlayerController's InputRollScale value.
    ## @param Val Amount to add to Roll. This value is multiplied by the PlayerController's InputRollScale value.
    ## @see PlayerController::InputRollScale
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Input", meta=(Keywords="addroll"))

  method isMoveInputIgnored*(): bool {.noSideEffect.}
    ## Helper to see if move input is ignored. If our controller is a PlayerController, checks Controller->IsMoveInputIgnored().
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Input")

  var controlInputVector: FVector
    ## Accumulated control input vector, stored in world space. This is the pending input, which is cleared (zeroed) once consumed.
    ## @see GetPendingMovementInputVector(), AddMovementInput()
    ##
    ## UPROPERTY(Transient)

  var lastControlInputVector: FVector
    ## The last control input vector that was processed by ConsumeMovementInputVector().
    ## @see GetLastMovementInputVector()
    ##
    ## UPROPERTY(Transient)

  proc moveIgnoreActorAdd(actorToIgnore: ptr AActor)
    ## Add an Actor to ignore by Pawn's movement collision

  proc moveIgnoreActorRemove(actorToIgnore: ptr AActor)
    ## Remove an Actor to ignore by Pawn's movement collision
