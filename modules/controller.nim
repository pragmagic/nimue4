# Copyright 2016 Xored Software, Inc.

wclass(AController of AActor, header: "GameFramework/Controller.h", notypedef):
  var playerState: ptr APlayerState
    ## PlayerState containing replicated information about the player
    ## using this controller (only exists for players, not NPCs).
    ## UPROPERTY(replicatedUsing=OnRep_PlayerState, BlueprintReadOnly, Category="Controller")

  method getControlRotation(): FRotator {.noSideEffect.}
    ## Get the control rotation. This is the full aim rotation, which may be different than a camera orientation (for example in a third person view),
    ## and may differ from the rotation of the controlled Pawn (which may choose not to visually pitch or roll, for example).
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  method setControlRotation(newRotation: FRotator)
    ## Set the control rotation. The RootComponent's rotation will also be updated to match it if RootComponent->bAbsoluteRotation is true.
    ## UFUNCTION(BlueprintCallable, Category="Pawn", meta=(Tooltip="Set the control rotation."))

  method setInitialLocationAndRotation(newLocation: FVector; newRotation: FRotator)
    ## Set the initial location and rotation of the controller, as well as the control rotation. Typically used when the controller is first created.
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  var controlRotation: FRotator
    ## The control rotation of the Controller. See GetControlRotation.
    ## UPROPERTY()

  var bAttachToPawn: bool
    ## If true, the controller location will match the possessed Pawn's location.
    ## If false, it will not be updated. Rotation will match ControlRotation in either case.
    ## Since a Controller's location is normally inaccessible, this is intended mainly for purposes of
    ## being able to attach an Actor that follows the possessed Pawn location,
    ## but that still has the full aim rotation (since a Pawn might update only some components of the rotation).
    ##
    ## UPROPERTY(EditDefaultsOnly, AdvancedDisplay, Category="Controller|Transform")

  method attachToPawn(inPawn: ptr APawn)
    ## Physically attach the Controller to the specified Pawn, so that our position reflects theirs.
    ## The attachment persists during possession of the pawn.
    ## The Controller's rotation continues to match the ControlRotation.
    ## Attempting to attach to a NULL Pawn will call DetachFromPawn() instead.

  method detachFromPawn()
    ## Detach the RootComponent from its parent, but only if bAttachToPawn is true and it was attached to a Pawn.

  method addPawnTickDependency(newPawn: ptr APawn)
    ## Add dependency that makes us tick before the given Pawn.
    ## This minimizes latency between input processing and Pawn movement.

  method removePawnTickDependency(inOldPawn: ptr APawn)
    ## Remove dependency that makes us tick before the given Pawn.

  var startSpot: TWeakObjectPtr[AActor]
    ## Actor marking where this controller spawned in.

  #=============================================================================
  # CONTROLLER STATE PROPERTIES
  #=============================================================================

  var stateName: FName
    ## UPROPERTY()

  method changeState(NewState: FName)
    ## Change the current state to named state

  proc isInState(InStateName: FName): bool {.noSideEffect.}
    ## States (uses FNames for replication, correlated to state flags)
    ## @param StateName the name of the state to test against
    ## @return true if current state is StateName

  proc getStateName(): FName {.noSideEffect.}
    ## @return the name of the current state

  method lineOfSightTo(other: ptr AActor; viewPoint: FVector = ForceInit;
                       bAlternateChecks: bool = false): bool {.noSideEffect.}
    ## Checks line to center and top of other actor
    ## @param Other is the actor whose visibility is being checked.
    ## @param ViewPoint is eye position visibility is being checked from.
    ##        If vect(0,0,0) passed in, uses current viewtarget's eye position.
    ## @param bAlternateChecks used only in AIController implementation
    ## @return true if controller's pawn can see Other actor.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Controller")

  method onRep_Pawn()
    ## Replication Notification Callbacks
    ## UFUNCTION()

  method onRep_PlayerState()
    ## UFUNCTION()

  proc castToPlayerController(): ptr APlayerController
    ## @fixme, shouldn't be necessary once general cast support is in.
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  proc clientSetLocation(newLocation: FVector; newRotation: FRotator)
    ## Replicated function to set the pawn location and rotation, allowing server to force (ex. teleports).
    ## UFUNCTION(reliable, client)

  proc clientSetRotation(newRotation: FRotator; bResetCamera: bool = false)
    ## Replicated function to set the pawn rotation, allowing the server to force.
    ## UFUNCTION(reliable, client)

  proc K2_GetPawn(): ptr APawn {.noSideEffect.}
    ## Return the Pawn that is currently 'controlled' by this PlayerController
    ## UFUNCTION(BlueprintCallable, Category="Pawn", meta=(DisplayName="Get Controlled Pawn"))

  method getLifetimeReplicatedProps(outLifetimeProps: var TArray[FLifetimeProperty]) {.noSideEffect.}

  proc getPawn(): ptr APawn {.noSideEffect.}
    ## Getter for Pawn

  proc getCharacter(): ptr ACharacter {.noSideEffect.}
    ## Getter for Character

  method setPawn(inPawn: ptr APawn)
    ## Setter for Pawn. Normally should only be used internally when possessing/unpossessing a Pawn.

  proc setPawnFromRep(inPawn: ptr APawn)
    ## Calls SetPawn and RepNotify locally

  proc getViewTarget(): ptr AActor {.noSideEffect.}
    ## Get the actor the controller is looking at
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  proc getDesiredRotation(): FRotator {.noSideEffect.}
    ## Get the desired pawn target rotation
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  proc isLocalPlayerController(): bool {.noSideEffect.}
    ## returns whether this Controller is a locally controlled PlayerController.
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  proc isLocalController(): bool {.noSideEffect.}
    ## Returns whether this Controller is a local controller.
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  proc cleanupPlayerState()
    ## Called from Destroyed(). Cleans up PlayerState.

  proc possess(inPawn: ptr APawn)
    ## Handles attaching this controller to the specified pawn.
    ## Only runs on the network authority (where HasAuthority() returns true).
    ## @param InPawn The Pawn to be possessed.
    ## @see HasAuthority()
    ##
    ## UFUNCTION(BlueprintCallable, BlueprintAuthorityOnly, Category="Pawn")

  proc unPossess()
    ## Called to unpossess our pawn for any reason that is not the pawn being destroyed (destruction handled by PawnDestroyed()).
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  proc pawnPendingDestroy(inPawn: ptr APawn)
    ## Called to unpossess our pawn because it is going to be destroyed.
    ## (other unpossession handled by UnPossess())

  proc instigatedAnyDamage(damage: cfloat; damageType: ptr UDamageType;
                           damagedActor: ptr AActor; damageCauser: ptr AActor)
    ## Called when this controller instigates ANY damage

  proc initPlayerState()
    ## Spawns and initializes the PlayerState for this Controller

  proc gameHasEnded(endGameFocus: ptr AActor = nil; bIsWinner: bool = false)
    ## Called from game mode upon end of the game, used to transition to proper state.
    ## @param EndGameFocus Actor to set as the view target on end game
    ## @param bIsWinner true if this controller is on winning team

  proc getPlayerViewPoint(location: var FVector; rotation: var FRotator) {.noSideEffect.}
    ## Returns Player's Point of View
    ## For the AI this means the Pawn's 'Eyes' ViewPoint
    ## For a Human player, this means the Camera's ViewPoint
    ##
    ## @output  out_Location, view location of player
    ## @output  out_rotation, view rotation of player

  proc failedToSpawnPawn()
    ## GameMode failed to spawn pawn for me.

  # Begin INavAgentInterface Interface
  proc getNavAgentPropertiesRef(): var FNavAgentProperties {.noSideEffect.}

  proc getNavAgentLocation(): FVector {.noSideEffect.}

  proc getMoveGoalReachTest(movingActor: ptr AActor; moveOffset: FVector;
                            goalOffset: var FVector; goalRadius: var cfloat;
                            goalHalfHeight: var cfloat) {.noSideEffect.}

  proc shouldPostponePathUpdates(): bool {.noSideEffect.}
  proc isFollowingAPath(): bool {.noSideEffect.}
  # End INavAgentInterface Interface

  proc initNavigationControl(pathFollowingComp: var ptr UPathFollowingComponent)
    ## Prepares path following component

  proc updateNavigationComponents()
    ## If controller has any navigation-related components then this function
    ## makes them update their cached data

  proc stopMovement()
    ## Aborts the move the controller is currently performing

  proc beginInactiveState()
    ## State entered when inactive (no possessed pawn, not spectating, etc).

  proc endInactiveState()
    ## State entered when inactive (no possessed pawn, not spectating, etc).

  proc receiveInstigatedAnyDamage(damage: cfloat; damageType: ptr UDamageType;
                                  damagedActor: ptr AActor; damageCauser: ptr AActor)
    ## Event when this controller instigates ANY damage

  proc currentLevelUnloaded()
    ## Called when the level this controller is in is unloaded via streaming.

  proc getTransformComponent(): ptr USceneComponent {.noSideEffect.}
    ## Returns TransformComponent subobject