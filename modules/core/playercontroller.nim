# Copyright 2016 Xored Software, Inc.

# type
#   APlayerController* {.header: "GameFramework/PlayerController.h", importcpp: "APlayerController", nodecl, inheritable.} = object of AController
#     bShowMouseCursor*: bool
#     CurrentClickTraceChannel*: ECollisionChannel
#     DefaultMouseCursor*: EMouseCursor
#     InputComponent*: UInputComponent

## Delegate used to override default viewport audio listener position calculated from camera
declareBuiltinDelegate(FGetAudioListenerPos, dkSimple, "GameFramework/PlayerController.h",
                       location: var FVector, projFront: var FVector, projRight: var FVector)

type
  EDynamicForceFeedbackAction {.size: sizeof(cint),
                                importcpp: "EDynamicForceFeedbackAction",
                                header: "GameFramework/PlayerController.h",
                                pure.} = enum
    Start,
    Update,
    Stop,

wclass(FDynamicForceFeedbackDetails, header: "GameFramework/PlayerController.h"):
  var bAffectsLeftLarge: bool
  var bAffectsLeftSmall: bool
  var bAffectsRightLarge: bool
  var bAffectsRightSmall: bool

  var intensity: cfloat

  proc makeFDynamicForceFeedbackDetails(): FDynamicForceFeedbackDetails {.constructor.}

  proc update(values: var FForceFeedbackValues) {.noSideEffect.}

## Abstract base class for Input Mode structures
wclass(FInputModeDataBase, header: "GameFramework/PlayerController.h"):
  discard

wclass(FInputModeUIOnly of FInputModeDataBase, header: "GameFramework/PlayerController.h"):
  ## Data structure used to setup an input mode that allows only the UI to respond to user input.

  proc makeFInputModeUIOnly(): FInputModeUIOnly {.constructor.}

  proc setLockMouseToViewport(inLockMouseToViewport: bool): var FInputModeUIOnly
    ## Whether to lock the mouse to the viewport


wclass(FInputModeGameAndUI of FInputModeDataBase, header: "GameFramework/PlayerController.h"):
  ## Data structure used to setup an input mode that allows the UI to respond to user input, and if the UI doesn't handle it player input / player controller gets a chance.
  proc makeFInputModeGameAndUI(): FInputModeGameAndUI {.constructor.}

  proc SetLockMouseToViewport(InLockMouseToViewport: bool): var FInputModeGameAndUI
    ## Whether to lock the mouse to the viewport

  proc setHideCursorDuringCapture(inHideCursorDuringCapture: bool): var FInputModeGameAndUI
    ## Whether to hide the cursor during temporary mouse capture caused by a mouse down

wclass(FInputModeGameOnly of FInputModeDataBase, header: "GameFramework/PlayerController.h"):
  ## Data structure used to setup an input mode that allows
  ##  only the player input / player controller to respond to user input.
  proc makeFInputModeGameOnly(): FInputModeGameOnly {.constructor.}

wclass(APlayerController of AController, header: "GameFramework/PlayerController.h", notypedef):
  ## PlayerControllers are used by human players to control Pawns.
  ##
  ## ControlRotation (accessed via GetControlRotation()), determines the aiming
  ## orientation of the controlled Pawn.
  ##
  ## In networked games, PlayerControllers exist on the server for every player-controlled pawn,
  ## and also on the controlling client's machine. They do NOT exist on a client's
  ## machine for pawns controlled by remote players elsewhere on the network.
  ##
  ## @see https://docs.unrealengine.com/latest/INT/Gameplay/Framework/Controller/PlayerController/

  var player: ptr UPlayer
    ## UPlayer associated with this PlayerController.  Could be a local player or a net connection.
    ## UPROPERTY()

  var bShortConnectTimeOut: bool
    ## When true, reduces connect timeout from InitialConnectionTimeOut to ConnectionTimeout.
    ## Set once initial level load is complete (client may be unresponsive during level loading).

  var acknowledgedPawn: ptr APawn
    ## Used in net games so client can acknowledge it possessed a specific pawn.
    ## UPROPERTY()

  var controllingDirTrackInst: ptr UInterpTrackInstDirector
    ## Director track that's currently possessing this player controller, or none if not possessed.
    ## UPROPERTY(transient)

  var localPlayerCachedLODDistanceFactor: cfloat
    ## last used FOV based multiplier to distance to an object when determining if it exceeds the object's cull distance
    ## @note: only valid for local player

  var myHUD: ptr AHUD
    ## Heads up display associated with this PlayerController.
    ## UPROPERTY()

  # ******************************************************************************
  # Camera/view related variables
  # ******************************************************************************

  var playerCameraManager: ptr APlayerCameraManager
    ## Camera manager associated with this Player Controller.
    ## UPROPERTY(BlueprintReadOnly, Category=PlayerController)

  var playerCameraManagerClass: TSubclassOf[APlayerCameraManager]

  var bAutoManageActiveCameraTarget: bool
    ## True to allow this player controller to manage the camera target for you,
    ## typically by using the possessed pawn as the camera target. Set to false
    ## if you want to manually control the camera target.
    ##
    ## UPROPERTY(EditAnywhere, Category=PlayerController)

  var targetViewRotation: FRotator
    ## Used to replicate the view rotation of targets not owned/possessed by this PlayerController.
    ## UPROPERTY(replicated)

  var blendedTargetViewRotation: FRotator
    ## Smoothed version of TargetViewRotation to remove jerkiness from intermittent replication updates.

  var hiddenActors: TArray[ptr AActor]
    ## The actors which the camera shouldn't see - e.g. used to hide actors which the camera penetrates
    ## UPROPERTY()

  var lastSpectatorStateSynchTime: cfloat
    ## Used to make sure the client is kept synchronized when in a spectator state
    ## UPROPERTY()

  var lastSpectatorSyncLocation: FVector
    ## Last location synced on the server for a spectator.
    ## UPROPERTY(Transient)

  var lastSpectatorSyncRotation: FRotator
    ## Last rotation synced on the server for a spectator.
    ## UPROPERTY(Transient)

  var clientCap: int32
    ## Cap set by server on bandwidth from client to server in bytes/sec (only has impact if >=2600)
    ## UPROPERTY()

  var cheatManager: ptr UCheatManager
    ## Object that manages "cheat" commands.  Not instantiated in shipping builds.
    ## UPROPERTY(transient)

  var cheatClass: TSubclassOf[UCheatManager]
    ## class of my CheatManager.
    ## UPROPERTY()

  var playerInput: ptr UPlayerInput
    ## Object that manages player input.
    ## UPROPERTY(transient)

  var activeForceFeedbackEffects: TArray[FActiveForceFeedbackEffect]
    ## UPROPERTY(transient)

  var dynamicForceFeedbacks: TMap[int32, FDynamicForceFeedbackDetails]

  var activeHapticEffect_Left: TSharedPtr[FActiveHapticFeedbackEffect]
    ## Currently playing haptic effects for both the left and right hand

  var activeHapticEffect_Right: TSharedPtr[FActiveHapticFeedbackEffect]

  var pendingMapChangeLevelNames: TArray[FName]
    ## list of names of levels the server is in the middle of sending us for a PrepareMapChange() call

  var bCinematicMode: bool
    ## Is this player currently in cinematic mode?  Prevents rotation/movement/firing/etc

  var bIsUsingStreamingVolumes: bool
    ## Whether this controller is using streaming volumes.

  var bPlayerIsWaiting: bool
    ## True if PlayerController is currently waiting for the match to start or to respawn. Only valid in Spectating state.
    ## UPROPERTY(VisibleInstanceOnly, BlueprintReadOnly, Category=PlayerController)

  proc serverSetSpectatorWaiting(bWaiting: bool)
    ## Indicate that the Spectator is waiting to join/respawn.
    ## UFUNCTION(server, reliable, WithValidation, Category=PlayerController)

  proc clientSetSpectatorWaiting(bWaiting: bool)
    ## Indicate that the Spectator is waiting to join/respawn.
    ## UFUNCTION(client, reliable, Category=PlayerController)

  var netPlayerIndex: uint8
    ## index identifying players using the same base connection (splitscreen clients)
    ## Used by netcode to match replicated PlayerControllers to the correct splitscreen viewport and child connection
    ## replicated via special internal code, not through normal variable replication
    ##
    ## UPROPERTY(DuplicateTransient)

  var muteList: FPlayerMuteList
    ## List of muted players in various categories

  var pendingSwapConnection: ptr UNetConnection
    ## this is set on the OLD PlayerController when performing a swap over a network connection
    ## so we know what connection we're waiting on acknowledgment from to finish destroying this PC
    ## (or when the connection is closed)
    ## @see GameMode::SwapPlayerControllers()
    ##
    ## UPROPERTY(DuplicateTransient)

  var netConnection: ptr UNetConnection
    ## The net connection this controller is communicating on, NULL for local players on server
    ## UPROPERTY(DuplicateTransient)

  var rotationInput: FRotator
    ## Input axes values, accumulated each tick.

  var inputYawScale: cfloat
    ## Yaw input speed scaling
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, config, Category=PlayerController)

  var inputPitchScale: cfloat
    ## Pitch input speed scaling
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, config, Category=PlayerController)

  var inputRollScale: cfloat
    ## Roll input speed scaling
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, config, Category=PlayerController)

  var bShowMouseCursor: bool
    ## Whether the mouse cursor should be displayed.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MouseInterface)

  var bEnableClickEvents: bool
    ## Whether actor/component click events should be generated.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MouseInterface)

  var bEnableTouchEvents: bool
    ## Whether actor/component touch events should be generated.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MouseInterface)

  var bEnableMouseOverEvents: bool
    ## Whether actor/component mouse over events should be generated.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MouseInterface)

  var bEnableTouchOverEvents: bool
    ## Whether actor/component touch over events should be generated.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MouseInterface)

  var bForceFeedbackEnabled: bool
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Game|Feedback")

  var defaultMouseCursor: EMouseCursor
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=MouseInterface)

  var currentMouseCursor: EMouseCursor
    ## UPROPERTY(BlueprintReadWrite, Category=MouseInterface)

  var defaultClickTraceChannel: ECollisionChannel
    ## Default trace channel used for determining what world object was clicked on.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=MouseInterface)

  var currentClickTraceChannel: ECollisionChannel
    ## Trace channel currently being used for determining what world object was clicked on.
    ## UPROPERTY(BlueprintReadWrite, Category=MouseInterface)

  var hitResultTraceDistance: cfloat
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MouseInterface, meta=(DisplayName="Trace Distance"))

  var forceFeedbackValues: FForceFeedbackValues

  proc enableCheats()
    ## Enables cheats within the game
    ## UFUNCTION(exec)

  proc unFreeze()
    ## Timer used by RoundEnded and Inactive states to accept player input again

  proc FOV(newFOV: cfloat)
    ## Set the field of view to NewFOV
    ## UFUNCTION(exec)

  proc restartLevel()
    ## Restarts the current level
    ## UFUNCTION(exec)

  proc localTravel(url: FString)
    ## Causes the client to travel to the given URL
    ## UFUNCTION(exec)

  proc clientReturnToMainMenu(returnReason: FString)
    ## Return the client to the main menu gracefully
    ## UFUNCTION(Reliable, Client)

  proc clientRepObjRef(obj: ptr UObject)
    ## Development RPC for testing object reference replication
    ## UFUNCTION(Reliable, Client)

  proc setPause(bPause: bool; canUnpauseDelegate: FCanUnpause = FCanUnpause()): bool
    ## Locally try to pause game (call serverpause to pause network game); returns success indicator.  Calls GameMode's SetPause().
    ## @return true if succeeded to pause

  proc pause()
    ## Command to try to pause the game.
    ## UFUNCTION(exec)

  proc setName(s: FString)
    ## Trys to set the player's name to the given name.
    ## UFUNCTION(exec)

  proc switchLevel(url: FString)
    ## SwitchLevel to the given MapURL.
    ## UFUNCTION(exec)

  proc notifyLoadedWorld(worldPackageName: FName; bFinalDest: bool)
    ## called to notify the server when the client has loaded a new world via seamless traveling
    ## @param WorldPackageName the name of the world package that was loaded
    ## @param bFinalDest whether this world is the destination map for the travel (i.e. not the transition level)

  proc playerTick(deltaTime: cfloat)
    ## Processes player input (immediately after PlayerInput gets ticked) and calls UpdateRotation().
    ## PlayerTick is only called if the PlayerController has a PlayerInput object. Therefore, it will only be called for locally controlled PlayerControllers.

  proc preProcessInput(deltaTime: cfloat; bGamePaused: bool)
    ## Method called prior to processing input

  proc postProcessInput(deltaTime: cfloat; bGamePaused: bool)
    ## Method called after processing input

  proc setCinematicMode(bInCinematicMode: bool; bAffectsMovement: bool;
                        bAffectsTurning: bool)
    ## Adjust input based on cinematic mode
    ## @param  bInCinematicMode  specify true if the player is entering cinematic mode; false if the player is leaving cinematic mode.
    ## @param  bAffectsMovement  specify true to disable movement in cinematic mode, enable it when leaving
    ## @param  bAffectsTurning   specify true to disable turning in cinematic mode or enable it when leaving

  proc setIgnoreMoveInput(bNewMoveInput: bool)
    ##  Locks or unlocks movement input, consecutive calls stack up and require the same amount of calls to undo, or can all be undone using ResetIgnoreMoveInput.
    ##  @param bNewMoveInput  If true, move input is ignored. If false, input is not ignored.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Input")

  proc resetIgnoreMoveInput()
    ## Stops ignoring move input by resetting the ignore move input state.
    ## UFUNCTION(BlueprintCallable, Category = "Input", meta = (Keywords = "ClearIgnoreMoveInput"))

  proc isMoveInputIgnored(): bool {.noSideEffect.}
    ## Returns true if movement input is ignored.
    ## UFUNCTION(BlueprintCallable, Category="Input")

  proc setIgnoreLookInput*(bNewLookInput: bool)
    ##  Locks or unlocks look input, consecutive calls stack up and require the same amount of calls to undo, or can all be undone using ResetIgnoreLookInput.
    ##  @param bNewLookInput  If true, look input is ignored. If false, input is not ignored.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Input")

  proc resetIgnoreLookInput*()
    ## Stops ignoring look input by resetting the ignore look input state.
    ## UFUNCTION(BlueprintCallable, Category = "Input", meta = (Keywords = "ClearIgnoreLookInput"))

  proc isLookInputIgnored*(): bool {.noSideEffect.}
    ## Returns true if look input is ignored.
    ## UFUNCTION(BlueprintCallable, Category="Input")

  proc resetIgnoreInputFlags*()
    ## reset move and look input ignore flags to defaults
    ## UFUNCTION(BlueprintCallable, Category="Input")

  proc getHitResultAtScreenPosition(screenPosition: FVector2D;
                                    traceChannel: ECollisionChannel;
                                    collisionQueryParams: FCollisionQueryParams;
                                    hitResult: var FHitResult): bool {.noSideEffect.}

  proc getHitResultAtScreenPosition(screenPosition: FVector2D;
                                    TraceChannel: ECollisionChannel;
                                    bTraceComplex: bool; HitResult: var FHitResult): bool {.noSideEffect.}
  proc getHitResultAtScreenPosition(screenPosition: FVector2D;
                                    TraceChannel: ETraceTypeQuery;
                                    bTraceComplex: bool; HitResult: var FHitResult): bool {.noSideEffect.}

  proc getHitResultAtScreenPosition(screenPosition: FVector2D; ObjectTypes: TArray[TEnumAsByte[EObjectTypeQuery]];
                                    bTraceComplex: bool; HitResult: var FHitResult): bool {.noSideEffect.}

  proc getHitResultUnderCursorByChannel(traceChannel: ETraceTypeQuery;
                                        bTraceComplex: bool;
                                        hitResult: var FHitResult): bool {.noSideEffect.}
    ## UFUNCTION(BlueprintCallable, Category="Game|Player", meta=(bTraceComplex=true))

  proc getHitResultUnderCursorForObjects(objectTypes: TArray[EObjectTypeQuery];
                                         bTraceComplex: bool;
                                         hitResult: var FHitResult): bool {.noSideEffect.}
    ## UFUNCTION(BlueprintCallable, Category="Game|Player", meta=(bTraceComplex=true))

  proc getHitResultUnderFingerByChannel(fingerIndex: ETouchIndex;
                                        traceChannel: ETraceTypeQuery;
                                        bTraceComplex: bool;
                                        hitResult: var FHitResult): bool {.noSideEffect.}
    ## UFUNCTION(BlueprintCallable, Category="Game|Player", meta=(bTraceComplex=true))

  proc getHitResultUnderFingerForObjects(fingerIndex: ETouchIndex; objectTypes: TArray[EObjectTypeQuery];
                                         bTraceComplex: bool; hitResult: var FHitResult): bool {.
      noSideEffect.}
    ## UFUNCTION(BlueprintCallable, Category="Game|Player", meta=(bTraceComplex=true))

  proc deprojectMousePositionToWorld(worldLocation: var FVector;
                                     worldDirection: var FVector): bool {.noSideEffect.}
    ## Convert current mouse 2D position to World Space 3D position and direction. Returns false if unable to determine value.
    ## UFUNCTION(BlueprintCallable, Category = "Game|Player", meta = (DisplayName = "ConvertMouseLocationToWorldSpace", Keywords = "deproject"))

  proc deprojectScreenPositionToWorld(screenX: cfloat; ScreenY: cfloat;
                                      worldLocation: var FVector;
                                      worldDirection: var FVector): bool {.noSideEffect.}
    ## Convert current mouse 2D position to World Space 3D position and direction. Returns false if unable to determine value. *
    ## UFUNCTION(BlueprintCallable, Category = "Game|Player", meta = (DisplayName = "ConvertScreenLocationToWorldSpace", Keywords = "deproject"))

  proc projectWorldLocationToScreen(worldLocation: FVector;
                                    screenLocation: var FVector2D): bool {.noSideEffect.}
    ## Convert a World Space 3D position into a 2D Screen Space position.
    ## @return true if the world coordinate was successfully projected to the screen.
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Game|Player", meta = (DisplayName = "ConvertWorldLocationToScreenLocation", Keywords = "project"))

  proc projectWorldLocationToScreenWithDistance(worldLocation: FVector;
      screenLocation: var FVector): bool {.noSideEffect.}
    ## Convert a World Space 3D position into a 3D Screen Space position.
    ## @return true if the world coordinate was successfully projected to the screen.

  proc updateRotation(deltaTime: cfloat)
    ## Updates the rotation of player, based on ControlRotation after RotationInput has been applied.
    ## This may then be modified by the PlayerCamera, and is passed to Pawn->FaceRotation().

  proc beginPlayingState()
    ## Pawn has been possessed, so changing state to NAME_Playing. Start it walking and begin playing with it.

  proc endPlayingState()
    ## Leave playing state.

  proc hasNetOwner(): bool {.noSideEffect.}
    ## overridden to return that player controllers are capable of RPCs

  proc startFire(fireModeNum: uint8 = 0)
    ## Fire the player's currently selected weapon with the optional firemode.
    ## UFUNCTION(exec)

  proc levelStreamingStatusChanged(levelObject: ptr ULevelStreaming;
                                   bNewShouldBeLoaded: bool;
                                   bNewShouldBeVisible: bool;
                                   bNewShouldBlockOnLoad: bool; LODIndex: int32)
    ## Notify player of change to level

  proc delayedPrepareMapChange()
    ## used to wait until a map change can be prepared when one was already in progress

  proc getSeamlessTravelActorList(bToEntry: bool; actorList: var TArray[ptr AActor])
    ## Called on client during seamless level transitions to get the list of Actors that should be moved into the new level
    ## PlayerControllers, Role < ROLE_Authority Actors, and any non-Actors that are inside an Actor that is in the list
    ## (i.e. Object.Outer == Actor in the list)
    ## are all automatically moved regardless of whether they're included here
    ## only dynamic actors in the PersistentLevel may be moved (this includes all actors spawned during gameplay)
    ## this is called for both parts of the transition because actors might change while in the middle (e.g. players might join or leave the game)
    ## @see also GameMode::GetSeamlessTravelActorList() (the function that's called on servers)
    ## @param bToEntry true if we are going from old level -> entry, false if we are going from entry -> new level
    ## @param ActorList (out) list of actors to maintain

  proc seamlessTravelTo(newPC: ptr APlayerController)
    ## Called when seamless traveling and we are being replaced by the specified PC
    ## clean up any persistent state (post process chains on LocalPlayers, for example)
    ## (not called if PlayerControllerClass is the same for the from and to GameModes)

  proc seamlessTravelFrom(oldPC: ptr APlayerController)
    ## Called when seamless traveling and the specified PC is being replaced by this one
    ## copy over data that should persist
    ## (not called if PlayerControllerClass is the same for the from and to GameModes)

  proc clientEnableNetworkVoice(bEnable: bool)
    ## Tell the client to enable or disable voice chat (not muting)
    ## @param bEnable enable or disable voice chat
    ##
    ## UFUNCTION(Reliable, Client)

  proc startTalking()
    ## Enable voice chat transmission

  proc stopTalking()
    ## Disable voice chat transmission

  proc toggleSpeaking(bInSpeaking: bool)
    ## Toggle voice chat on and off
    ## @param bSpeaking enable or disable voice chat
    ##
    ## UFUNCTION(exec)

  proc clientVoiceHandshakeComplete()
    ## Tells the client that the server has all the information it needs and that it
    ## is ok to start sending voice packets. The server will already send voice packets
    ## when this function is called, since it is set server side and then forwarded
    ##
    ## NOTE: This is done as an RPC instead of variable replication because ordering matters
    ##
    ## UFUNCTION(Reliable, Client)

  proc serverMutePlayer(playerId: FUniqueNetIdRepl)
    ## Tell the server to mute a player for this controller
    ## @param PlayerId player id to mute
    ##
    ## UFUNCTION(server, reliable, WithValidation)


  proc serverUnmutePlayer(playerId: FUniqueNetIdRepl)
    ## Tell the server to unmute a player for this controller
    ## @param PlayerId player id to unmute
    ##
    ## UFUNCTION(server, reliable, WithValidation )

  proc clientMutePlayer(playerId: FUniqueNetIdRepl)
    ## Tell the client to mute a player for this controller
    ## @param PlayerId player id to mute
    ##
    ## UFUNCTION(Reliable, Client)

  proc clientUnmutePlayer(playerId: FUniqueNetIdRepl)
    ## Tell the client to unmute a player for this controller
    ## @param PlayerId player id to unmute
    ##
    ## UFUNCTION(Reliable, Client)

  proc gameplayMutePlayer(playerNetId: FUniqueNetIdRepl)
    ## Mutes a remote player on the server and then tells the client to mute
    ##
    ## @param PlayerNetId the remote player to mute

  proc gameplayUnmutePlayer(playerNetId: FUniqueNetIdRepl)
    ## Unmutes a remote player on the server and then tells the client to unmute
    ##
    ## @param PlayerNetId the remote player to unmute

  proc isPlayerMuted(playerId: FUniqueNetId): bool
    ## Is the specified player muted by this controlling player
    ## for any reason (gameplay, system, etc), check voice interface IsMuted() for system mutes
    ##
    ## @param PlayerId potentially muted player
    ## @return true if player is muted, false otherwise

  proc notifyDirectorControl(bNowControlling: bool;
                             currentMatinee: ptr AMatineeActor)
    ## Notification when a matinee director track starts or stops controlling the ViewTarget of this PlayerController

  proc consoleKey(key: FKey)
    ## Console control commands, useful when remote debugging so you can't touch the console the normal way
    ## UFUNCTION(exec)

  proc sendToConsole(command: FString)
    ## Sends a command to the console to execute if not shipping version
    ## UFUNCTION(exec)

  proc clientAddTextureStreamingLoc(inLoc: FVector; duration: cfloat;
                                    bOverrideLocation: bool)
    ## Adds a location to the texture streaming system for the specified duration.
    ## UFUNCTION(reliable, client, SealedEvent)

  proc clientCancelPendingMapChange()
    ## Tells client to cancel any pending map change.
    ## UFUNCTION(Reliable, Client)

  proc clientCapBandwidth(cap: int32)
    ## Set CurrentNetSpeed to the lower of its current value and Cap.
    ## UFUNCTION(Reliable, Client)

  proc clientCommitMapChange()
    ## Actually performs the level transition prepared by PrepareMapChange().
    ## UFUNCTION(Reliable, Client)

  proc clientFlushLevelStreaming()
    ## Tells the client to block until all pending level streaming actions are complete
    ## happens at the end of the tick
    ## primarily used to force update the client ASAP at join time
    ##
    ## UFUNCTION(reliable, client, SealedEvent)

  proc clientForceGarbageCollection()
    ## Forces GC at the end of the tick on the client
    ## UFUNCTION(Reliable, Client)

  proc clientGameEnded(endGameFocus: ptr AActor; bIsWinner: bool)
    ## Replicated function called by GameHasEnded().
    ## @param EndGameFocus - actor to view with camera
    ## @param bIsWinner - true if this controller is on winning team
    ##
    ## UFUNCTION(Reliable, Client)

  proc clientGotoState(newState: FName)
    ## Server uses this to force client into NewState .
    ## @Note ALL STATE NAMES NEED TO BE DEFINED IN name table in UnrealNames.h to be correctly replicated (so they are mapped to the same thing on client and server).
    ##
    ## UFUNCTION(Reliable, Client)

  proc clientIgnoreLookInput(bIgnore: bool)
    ## calls IgnoreLookInput on client
    ## UFUNCTION(Reliable, Client)

  proc clientIgnoreMoveInput(bIgnore: bool)
    ## calls IgnoreMoveInput on client
    ## UFUNCTION(Reliable, Client)

  proc clientMessage(s: FString; typ: FName = NAME_None; msgLifeTime: cfloat = 0)
    ## Outputs a message to HUD
    ## @param S - message to display
    ## @param Type - @todo document
    ## @param MsgLifeTime - Optional length of time to display 0 = default time
    ##
    ## UFUNCTION(Reliable, Client)

  proc clientPlayCameraAnim(animToPlay: ptr UCameraAnim; scale: cfloat = 0;
                            rate: cfloat = 0; blendInTime: cfloat = 0;
                            blendOutTime: cfloat = 0; bLoop: bool = false;
                            bRandomStartTime: bool = false; space: ECameraAnimPlaySpace = CameraLocal;
                            customPlaySpace: FRotator = zeroRotator)
    ## Play the indicated CameraAnim on this camera.
    ## @param AnimToPlay - Camera animation to play
    ## @param Scale - "Intensity" scalar.  This is the scale at which the anim was first played.
    ## @param Rate -  Multiplier for playback rate.  1.0 = normal.
    ## @param BlendInTime - Time to interpolate in from zero, for smooth sterarts
    ## @param BlendOutTime - Time to interpolate out to zero, for smooth finishes
    ## @param bLoop - True if the animation should loop, false otherwise
    ## @param bRandomStartTime - Whether or not to choose a random time to start playing.  Only really makes sense for bLoop = true
    ## @param Space - Animation play area
    ## @param CustomPlaySpace - Matrix used when Space = CAPS_UserDefined
    ##
    ## UFUNCTION(unreliable, client, BlueprintCallable, Category = "Game|Feedback")

  proc clientPlayCameraShake(shake: TSubclassOf[UCameraShake]; scale: cfloat = 0;
                             playSpace: ECameraAnimPlaySpace = CameraLocal;
                             userPlaySpaceRot: FRotator = zeroRotator)
    ## Play Camera Shake
    ## @param Shake - Camera shake animation to play
    ## @param Scale - Scalar defining how "intense" to play the anim
    ## @param PlaySpace - Which coordinate system to play the shake in (used for CameraAnims within the shake).
    ## @param UserPlaySpaceRot - Matrix used when PlaySpace = CAPS_UserDefined
    ##
    ## UFUNCTION(unreliable, client, BlueprintCallable, Category="Game|Feedback")

  proc clientPlaySound(sound: ptr USoundBase; volumeMultiplier: cfloat = 1.0;
                       pitchMultiplier: cfloat = 1.0)
    ## Play sound client-side (so only the client will hear it)
    ## @param Sound - Sound to play
    ## @param VolumeMultiplier - Volume multiplier to apply to the sound
    ## @param PitchMultiplier - Pitch multiplier to apply to the sound
    ##
    ## UFUNCTION(unreliable, client)

  proc clientPlaySoundAtLocation(sound: ptr USoundBase; location: FVector;
                                 volumeMultiplier: cfloat = 1.0;
                                 pitchMultiplier: cfloat = 1.0)
    ## Play sound client-side at the specified location
    ## @param Sound - Sound to play
    ## @param Location - Location to play the sound at
    ## @param VolumeMultiplier - Volume multiplier to apply to the sound
    ## @param PitchMultiplier - Pitch multiplier to apply to the sound
    ##
    ## UFUNCTION(unreliable, client)

  proc clientPrepareMapChange(levelName: FName; bFirst: bool; bLast: bool)
    ## Asynchronously loads the given level in preparation for a streaming map transition.
    ## the server sends one function per level name since dynamic arrays can't be replicated
    ## @param LevelNames - the names of the level packages to load. LevelNames[0] will be the new persistent (primary) level
    ## @param bFirst - whether this is the first item in the list (so clear the list first)
    ## @param bLast - whether this is the last item in the list (so start preparing the change after receiving it)
    ##
    ## UFUNCTION(Reliable, Client)

  proc clientPrestreamTextures(forcedActor: ptr AActor; forceDuration: cfloat;
                               bEnableStreaming: bool;
                               cinematicTextureGroups: int32 = 0)
    ## Forces the streaming system to disregard the normal logic for the specified duration and
    ## instead always load all mip-levels for all textures used by the specified actor.
    ## @param ForcedActor   - The actor whose textures should be forced into memory.
    ## @param ForceDuration   - Number of seconds to keep all mip-levels in memory, disregarding the normal priority logic.
    ## @param bEnableStreaming  - Whether to start (true) or stop (false) streaming
    ## @param CinematicTextureGroups  - Bitfield indicating which texture groups that use extra high-resolution mips
    ##
    ## UFUNCTION(Reliable, Client)

  proc clientReset()
    ## Tell client to reset the PlayerController
    ## UFUNCTION(Reliable, Client)

  proc clientRestart(newPawn: ptr APawn)
    ## Tell client to restart the level
    ## UFUNCTION(Reliable, Client)

  proc clientSetBlockOnAsyncLoading()
    ## Tells the client to block until all pending level streaming actions are complete.
    ## Happens at the end of the tick primarily used to force update the client ASAP at join time.
    ##
    ## UFUNCTION(Reliable, Client)

  proc clientSetCameraFade(bEnableFading: bool;
                           fadeColor: FColor = ForceInit;
                           fadeAlpha: FVector2D = ForceInit;
                           fadeTime: cfloat = 0; bFadeAudio: bool = false)
    ## Tell client to fade camera
    ## @Param bEnableFading - true if we should apply FadeColor/FadeAmount to the screen
    ## @Param FadeColor - Color to fade to
    ## @Param FadeAlpha - Amount of fading to apply
    ## @Param FadeTime - length of time for fade to occur over
    ## @Param bFadeAudio - true to apply fading of audio alongside the video
    ##
    ## UFUNCTION(Reliable, Client)

  proc clientSetCameraMode(newCamMode: FName)
    ## Replicated function to set camera style on client
    ## @param NewCamMode, name defining the new camera mode
    ##
    ## UFUNCTION(Reliable, Client)

  proc clientSetCinematicMode(bInCinematicMode: bool; bAffectsMovement: bool;
                              bAffectsTurning: bool; bAffectsHUD: bool)
    ## Called by the server to synchronize cinematic transitions with the client
    ## UFUNCTION(Reliable, Client)

  proc clientSetForceMipLevelsToBeResident*(material: ptr UMaterialInterface;
      forceDuration: cfloat; cinematicTextureGroups: int32 = 0)
    ## Forces the streaming system to disregard the normal logic for the specified duration and
    ## instead always load all mip-levels for all textures used by the specified material.
    ##
    ## @param Material    - The material whose textures should be forced into memory.
    ## @param ForceDuration - Number of seconds to keep all mip-levels in memory, disregarding the normal priority logic.
    ## @param CinematicTextureGroups  - Bitfield indicating which texture groups that use extra high-resolution mips
    ##
    ## UFUNCTION(Reliable, Client)

  proc clientSetHUD(NewHUDClass: TSubclassOf[AHUD])
    ## Set the client's class of HUD and spawns a new instance of it. If there was already a HUD active, it is destroyed.
    ## UFUNCTION(BlueprintCallable, Category="HUD", Reliable, Client)

  proc getViewportSize(SizeX: var int32; SizeY: var int32) {.noSideEffect.}
    ## Helper to get the size of the HUD canvas for this player controller.  Returns 0 if there is no HUD
    ## UFUNCTION(BlueprintCallable, Category="HUD")

  proc getHUD(): ptr AHUD {.noSideEffect.}
    ## Gets the HUD currently being used by this player controller
    ## UFUNCTION(BlueprintCallable, Category="HUD")

  proc clientSetViewTarget(a: ptr AActor; TransitionParams: FViewTargetTransitionParams = FViewTargetTransitionParams())
    ## Set the view target
    ## @param A - new actor to set as view target
    ## @param TransitionParams - parameters to use for controlling the transition
    ##
    ## UFUNCTION(Reliable, Client)

  proc clientSpawnCameraLensEffect(LensEffectEmitterClass: TSubclassOf[AEmitterCameraLensEffectBase])
    ## Spawn a camera lens effect (e.g. blood).
    ## UFUNCTION(unreliable, client, BlueprintCallable, Category="Game|Feedback")

  proc clientClearCameraLensEffects()
    ## Removes all Camera Lens Effects.
    ## UFUNCTION(reliable, client, BlueprintCallable, Category="Game|Feedback")

  proc clientStopCameraAnim(animToStop: ptr UCameraAnim)
    ## Stop camera animation on client.
    ## UFUNCTION(Reliable, Client)

  proc clientStopCameraShake(shake: TSubclassOf[UCameraShake])
    ## Stop camera shake on client.
    ## UFUNCTION(reliable, client, BlueprintCallable, Category="Game|Feedback")

  proc clientPlayForceFeedback(forceFeedbackEffect: ptr UForceFeedbackEffect;
                               bLooping: bool; tag: FName)
    ## Play a force feedback pattern on the player's controller
    ## @param `forceFeedbackEffect` The force feedback pattern to play
    ## @param bLooping Whether the pattern should be played repeatedly or be a single one shot
    ## @param `tag` A tag that allows stopping of an effect.
    ##              If another effect with this Tag is playing, it will be stopped and replaced
    ##
    ## UFUNCTION(unreliable, client, BlueprintCallable, Category="Game|Feedback")

  proc clientStopForceFeedback(forceFeedbackEffect: ptr UForceFeedbackEffect;
                               tag: FName)
    ## Stops a playing force feedback pattern
    ## @param ForceFeedbackEffect   If set only patterns from that effect will be stopped
    ## @param Tag           If not none only the pattern with this tag will be stopped
    ##
    ## UFUNCTION(reliable, client, BlueprintCallable, Category="Game|Feedback")

  proc playDynamicForceFeedback(intensity: cfloat; duration: cfloat;
                                bAffectsLeftLarge: bool; bAffectsLeftSmall: bool;
                                bAffectsRightLarge: bool; bAffectsRightSmall: bool;
                                action: EDynamicForceFeedbackAction;
                                latentInfo: FLatentActionInfo)
    ## Latent action that controls the playing of force feedback
    ## Begins playing when Start is called.  Calling Update or Stop if the feedback is not active will have no effect.
    ## Completed will execute when Stop is called or the duration ends.
    ## When Update is called the Intensity, Duration, and affect values will be updated with the current inputs
    ## @param Intensity       How strong the feedback should be.  Valid values are between 0.0 and 1.0
    ## @param Duration        How long the feedback should play for.  If the value is negative it will play until stopped
    ## @param   bAffectsLeftLarge   Whether the intensity should be applied to the large left servo
    ## @param   bAffectsLeftSmall   Whether the intensity should be applied to the small left servo
    ## @param   bAffectsRightLarge    Whether the intensity should be applied to the large right servo
    ## @param   bAffectsRightSmall    Whether the intensity should be applied to the small right servo
    ##
    ## UFUNCTION(BlueprintCallable,
    ##           meta=(Latent, LatentInfo="LatentInfo", ExpandEnumAsExecs="Action",
    ##                 Duration="-1", bAffectsLeftLarge="true", bAffectsLeftSmall="true", bAffectsRightLarge="true",
    ##                 bAffectsRightSmall="true", AdvancedDisplay="bAffectsLeftLarge,bAffectsLeftSmall,bAffectsRightLarge,bAffectsRightSmall"),
    ##                 Category="Game|Feedback")

  proc playHapticEffect(hapticEffect: ptr UHapticFeedbackEffect;
                        hand: EControllerHand; Scale: cfloat = 1.0)
    ## Play a haptic feedback curve on the player's controller
    ## @param  HapticEffect      The haptic effect to play
    ## @param  Hand          Which hand to play the effect on
    ## @param  Scale         Scale between 0.0 and 1.0 on the intensity of playback
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Game|Feedback")

  proc stopHapticEffect(hand: EControllerHand)
    ##Stops a playing haptic feedback curve
    ##@param  HapticEffect      The haptic effect to stop
    ##@param  Hand          Which hand to stop the effect for
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Game|Feedback")

  proc ыetHapticsByValue(frequency: cfloat; amplitude: cfloat;
                         hand: EControllerHand)
    ## Sets the value of the haptics for the specified hand directly, using frequency and amplitude.  NOTE:  If a curve is already
    ## playing for this hand, it will be cancelled in favour of the specified values.
    ##
    ## @param  Frequency       The normalized frequency [0.0, 1.0] to play through the haptics system
    ## @param  Amplitude       The normalized amplitude [0.0, 1.0] to set the haptic feedback to
    ## @param  Hand          Which hand to play the effect on
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Game|Feedback")

  proc ClientTravel(url: FString; travelType: ETravelType; bSeamless: bool = false;
                    mapPackageGuid: FGuid = FGuid())
    ## Travel to a different map or IP address. Calls the PreClientTravel event before doing anything.
    ## NOTE: This is implemented as a locally executed wrapper for ClientTravelInternal, to avoid API compatability breakage
    ##
    ## @param URL       A string containing the mapname (or IP address) to travel to, along with option key/value pairs
    ## @param TravelType    specifies whether the client should append URL options used in previous travels; if true is specified
    ##              for the bSeamlesss parameter, this value must be TRAVEL_Relative.
    ## @param bSeamless     Indicates whether to use seamless travel (requires TravelType of TRAVEL_Relative)
    ## @param MapPackageGuid  The GUID of the map package to travel to - this is used to find the file when it has been autodownloaded,
    ##              so it is only needed for clients
    ##
    ## UFUNCTION()

  proc сlientTravelInternal(url: FString; travelType: ETravelType;
                            bSeamless: bool = false; mapPackageGuid: FGuid = FGuid())
    ## Internal clientside implementation of ClientTravel - use ClientTravel to call this
    ##
    ## @param URL       A string containing the mapname (or IP address) to travel to, along with option key/value pairs
    ## @param TravelType    specifies whether the client should append URL options used in previous travels; if true is specified
    ##              for the bSeamlesss parameter, this value must be TRAVEL_Relative.
    ## @param bSeamless     Indicates whether to use seamless travel (requires TravelType of TRAVEL_Relative)
    ## @param MapPackageGuid  The GUID of the map package to travel to - this is used to find the file when it has been autodownloaded,
    ##              so it is only needed for clients
    ##
    ## UFUNCTION(Reliable, Client)

  proc clientUpdateLevelStreamingStatus(packageName: FName;
                                        bNewShouldBeLoaded: bool;
                                        bNewShouldBeVisible: bool;
                                        bNewShouldBlockOnLoad: bool; LODIndex: int32)
    ## Replicated Update streaming status
    ## @param PackageName - Name of the level package name used for loading.
    ## @param bNewShouldBeLoaded - Whether the level should be loaded
    ## @param bNewShouldBeVisible - Whether the level should be visible if it is loaded
    ## @param bNewShouldBlockOnLoad - Whether we want to force a blocking load
    ## @param LODIndex        - Current LOD index for a streaming level
    ##
    ## UFUNCTION(Reliable, Client)

  proc clientWasKicked(kickReason: FText)
    ## Notify client they were kicked from the server
    ## UFUNCTION(Reliable, Client)

  proc clientStartOnlineSession()
    ## Notify client that the session is starting
    ## UFUNCTION(Reliable, Client)

  proc clientEndOnlineSession()
    ## Notify client that the session is about to start
    ## UFUNCTION(Reliable, Client)

  proc clientRetryClientRestart(newPawn: ptr APawn)
    ## Assign Pawn to player, but avoid calling ClientRestart if we have already accepted this pawn
    ## UFUNCTION(Reliable, Client)

  proc safeRetryClientRestart()
    ## Call ClientRetryClientRestart, but only if the current pawn is not the currently acknowledged pawn
    ## (and throttled to avoid saturating the network).

  proc clientReceiveLocalizedMessage(message: TSubclassOf[ULocalMessage];
                                     switch: int32 = 0; relatedPlayerState_1: ptr APlayerState = nil;
      relatedPlayerState_2: ptr APlayerState = nil; optionalObject: ptr UObject = nil)
    ## Send client localized message id
    ## UFUNCTION(Reliable, Client)

  proc serverAcknowledgePossession(pawn: ptr APawn)
    ## acknowledge possession of pawn
    ## UFUNCTION(reliable, server, WithValidation)

  proc serverCamera(newMode: FName)
    ## Change mode of camera
    ## UFUNCTION(reliable, server, WithValidation)

  proc serverChangeName(s: FString)
    ## Change name of server
    ## UFUNCTION(reliable, server, WithValidation)

  proc serverNotifyLoadedWorld(worldPackageName: FName)
    ## Called to notify the server when the client has loaded a new world via seamless traveling
    ## @param WorldPackageName the name of the world package that was loaded
    ##
    ## UFUNCTION(reliable, server, WithValidation, SealedEvent)

  proc serverPause()
    ## Replicate pause request to the server
    ## UFUNCTION(reliable, server, WithValidation)

  proc serverRestartPlayer()
    ## Attempts to restart this player, generally called from the client upon respawn request.
    ## UFUNCTION(reliable, server, WithValidation)

  proc serverSetSpectatorLocation(newLoc: FVector; newRot: FRotator)
    ## When spectating, updates spectator location/rotation and pings the server to make sure spectating should continue.
    ## UFUNCTION(unreliable, server, WithValidation)

  proc safeServerUpdateSpectatorState()
    ## Calls ServerSetSpectatorLocation but throttles it to reduce bandwidth and only calls it when necessary.

  proc serverCheckClientPossession()
    ## Tells the server to make sure the possessed pawn is in sync with the client.
    ## UFUNCTION(unreliable, server, WithValidation)

  proc serverCheckClientPossessionReliable()
    ## Reliable version of ServerCheckClientPossession to be used when there is no likely danger of spamming the network.
    ## UFUNCTION(reliable, server, WithValidation)

  proc safeServerCheckClientPossession()
    ## Call ServerCheckClientPossession on the server, but only if the current pawn
    ## is not the acknowledged pawn (and throttled to avoid saturating the network).

  proc serverShortTimeout()
    ## Notifies the server that the client has ticked gameplay code, and should no longer get
    ## the extended "still loading" timeout grace period
    ## UFUNCTION(reliable, server, WithValidation)

  proc serverUpdateCamera(camLoc: FVector_NetQuantize; camPitchAndYaw: int32)
    ## If PlayerCamera.bUseClientSideCameraUpdates is set, client will replicate camera positions to the server.
    ## @TODO - combine pitch/yaw into one int, maybe also send location compressed
    ## UFUNCTION(unreliable, server, WithValidation)

  proc serverUpdateLevelVisibility(packageName: FName; bIsVisible: bool)
    ## Called when the client adds/removes a streamed level
    ## the server will only replicate references to Actors in visible levels so that it's impossible to send references to
    ## Actors the client has not initialized
    ## @param PackageName the name of the package for the level whose status changed
    ##
    ## UFUNCTION(reliable, server, WithValidation, SealedEvent)

  proc serverVerifyViewTarget()
    ## Used by client to request server to confirm current viewtarget (server will respond with ClientSetViewTarget() ).
    ## UFUNCTION(reliable, server, WithValidation)

  proc serverViewNextPlayer()
    ## Move camera to next player on round ended or spectating
    ## UFUNCTION(unreliable, server, WithValidation)

  proc serverViewPrevPlayer()
    ## Move camera to previous player on round ended or spectating
    ## UFUNCTION(unreliable, server, WithValidation)

  proc serverViewSelf(transitionParams: FViewTargetTransitionParams = FViewTargetTransitionParams())
    ## Move camera to current user
    ## UFUNCTION(unreliable, server, WithValidation)

  proc clientTeamMessage(senderPlayerState: ptr APlayerState; s: FString; typ: FName;
                         msgLifeTime: cfloat = 0)
    ## @todo document
    ## UFUNCTION(Reliable, Client)

  proc serverToggleAILogging()
    ## Used by UGameplayDebuggingControllerComponent to replicate messages for AI debugging in network games.
    ## UFUNCTION(reliable, server, WithValidation)

  proc addPitchInput(val: cfloat)
    ## Add Pitch (look up) input. This value is multiplied by InputPitchScale.
    ## @param Val Amount to add to Pitch. This value is multiplied by InputPitchScale.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Game|Player", meta=(Keywords="up down"))

  proc addYawInput(val: cfloat)
    ## Add Yaw (turn) input. This value is multiplied by InputYawScale.
    ## @param Val Amount to add to Yaw. This value is multiplied by InputYawScale.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Game|Player", meta=(Keywords="left right turn"))

  proc addRollInput(val: cfloat)
    ## Add Roll input. This value is multiplied by InputRollScale.
    ## @param Val Amount to add to Roll. This value is multiplied by InputRollScale.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Game|Player")

  proc isInputKeyDown(key: FKey): bool {.noSideEffect.}
    ## Returns true if the given key/button is pressed on the input of the controller (if present)
    ## UFUNCTION(BlueprintCallable, Category="Game|Player")

  proc wasInputKeyJustPressed(key: FKey): bool {.noSideEffect.}
    ## Returns true if the given key/button was up last frame and down this frame.
    ## UFUNCTION(BlueprintCallable, Category="Game|Player")

  proc wasInputKeyJustReleased(key: FKey): bool {.noSideEffect.}
    ## Returns true if the given key/button was down last frame and up this frame.
    ## UFUNCTION(BlueprintCallable, Category="Game|Player")

  proc getInputAnalogKeyState(key: FKey): cfloat {.noSideEffect.}
    ## Returns the analog value for the given key/button.  If analog isn't supported, returns 1 for down and 0 for up.
    ## UFUNCTION(BlueprintCallable, Category="Game|Player")

  proc getInputVectorKeyState(key: FKey): FVector {.noSideEffect.}
    ## Returns the vector value for the given key/button.
    ## UFUNCTION(BlueprintCallable, Category="Game|Player")

  proc getInputTouchState(fingerIndex: ETouchIndex; locationX: var cfloat;
                          locationY: var cfloat; bIsCurrentlyPressed: var bool) {.noSideEffect.}
    ## Retrieves the X and Y screen coordinates of the specified touch key. Returns false if the touch index is not down
    ## UFUNCTION(BlueprintCallable, Category="Game|Player")

  proc getInputMotionState(tilt: var FVector; rotationRate: var FVector;
                           gravity: var FVector; acceleration: var FVector)
    ## Retrieves the current motion state of the player's input device
    ## UFUNCTION(BlueprintCallable, Category="Game|Player")

  proc getMousePosition(locationX: var cfloat; locationY: var cfloat): bool {.noSideEffect.}
    ## Retrieves the X and Y screen coordinates of the mouse cursor. Returns false if there is no associated mouse device
    ## UFUNCTION(BlueprintCallable, Category="Game|Player")

  proc getInputKeyTimeDown(key: FKey): cfloat {.noSideEffect.}
    ## Returns how long the given key/button has been down.  Returns 0 if it's up or it just went down this frame.
    ## UFUNCTION(BlueprintCallable, Category="Game|Player")

  proc getInputMouseDelta(deltaX: var cfloat; deltaY: var cfloat) {.noSideEffect.}
    ## Retrieves how far the mouse moved this frame.
    ## UFUNCTION(BlueprintCallable, Category="Game|Player")

  proc getInputAnalogStickState(whichStick: EControllerAnalogStick; stickX: var cfloat;
                                stickY: var cfloat) {.noSideEffect.}
    ## Retrieves the X and Y displacement of the given analog stick.
    ## UFUNCTION(BlueprintCallable, Category="Game|Player")

  proc activateTouchInterface(newTouchInterface: ptr UTouchInterface)
    ## Activates a new touch interface for this player controller
    ## UFUNCTION(BlueprintCallable, Category="Game|Player")

  proc setVirtualJoystickVisibility(bVisible: bool)
    ## Set the virtual joystick visibility.
    ## UFUNCTION(BlueprintCallable, Category = "Game|Player")

  proc setInputMode(inData: FInputModeDataBase)
    ## Setup an input mode.

  proc camera(newMode: FName)
    ## Change Camera mode
    ## @param New camera mode to set
    ##
    ## UFUNCTION(exec)

  proc SetViewTargetWithBlend(newViewTarget: ptr AActor; blendTime: cfloat = 0;
                              blendFunc: EViewTargetBlendFunction = VTBlend_Linear;
                              blendExp: cfloat = 0; bLockOutgoing: bool = false)
    ## Set the view target blending with variable control
    ## @param NewViewTarget - new actor to set as view target
    ## @param BlendTime - time taken to blend
    ## @param BlendFunc - Cubic, Linear etc functions for blending
    ## @param BlendExp -  Exponent, used by certain blend functions to control the shape of the curve.
    ## @param bLockOutgoing - If true, lock outgoing viewtarget to last frame's camera position for the remainder of the blend.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Game|Player", meta=(Keywords = "Camera"))

  var currentClickablePrimitive: TWeakObjectPtr[UPrimitiveComponent]
    ## Clickable object currently under the mouse cursor.

  var currentTouchablePrimitives: ptr TWeakObjectPtr[UPrimitiveComponent]
    ## Touchable objects currently under fingers.

  var currentInputStack: TArray[TWeakObjectPtr[UInputComponent]]
    ## Internal.  Current stack of InputComponents.

  var inactiveStateInputComponent: ptr UInputComponent
    ## InputComponent we use when player is in Inactive state.
    ## UPROPERTY()

  proc setupInactiveStateInputComponent(inComponent: ptr UInputComponent)
    ## Sets up input bindings for the input component pushed on the stack in the inactive state.

  proc updateStateInputComponents()
    ## Refresh state specific input components

  var bCinemaDisableInputMove: bool
    ## The state of the inputs from cinematic mode

  var bCinemaDisableInputLook: bool
    ## The state of the inputs from cinematic mode

  var bShouldPerformFullTickWhenPaused: bool
    ## Whether we fully tick when the game is paused, if our tick function is allowed to do so.
    ## If false, we do a minimal update during the tick.

  var ignoreMoveInput: uint8
    ## Ignores movement input. Stacked state storage, Use accessor function IgnoreMoveInput()

  var ignoreLookInput: uint8
    ## Ignores look input. Stacked state storage, use accessor function IgnoreLookInput().

  # AWARE
  # var virtualJoystick: TSharedPtr[SVirtualJoystick]
  #   ## The virtual touch interface

  var currentTouchInterface: ptr UTouchInterface
    ## The currently set touch interface
    ## UPROPERTY()

  var timerHandle_UnFreeze: FTimerHandle
    ## Handle for efficient management of UnFreeze timer

  proc pushInputComponent(input: ptr UInputComponent)
    ## Adds an inputcomponent to the top of the input stack.

  proc popInputComponent(input: ptr UInputComponent): bool
    ## Removes given inputcomponent from the input stack (regardless of if it's the top, actually).
  proc flushPressedKeys()

  proc inputKey(key: FKey; eventType: EInputEvent; amountDepressed: cfloat; bGamepad: bool): bool

  proc inputTouch(handle: uint32; typ: ETouchType; touchLocation: FVector2D;
                  deviceTimestamp: FDateTime; touchpadIndex: uint32): bool
  proc inputAxis(key: FKey; delta: cfloat; deltaTime: cfloat; numSamples: int32;
                 bGamepad: bool): bool
  proc inputMotion(tilt: FVector; rotationRate: FVector; gravity: FVector;
                   acceleration: FVector): bool

  proc setPlayer(inPlayer: ptr UPlayer)
    ## Associate a new UPlayer with this PlayerController.

  proc getLocalPlayer(): ptr ULocalPlayer {.noSideEffect.}
    ## Returns the ULocalPlayer for this controller if it exists, or null otherwise

  proc smoothTargetViewRotation(targetPawn: ptr APawn; deltaSeconds: cfloat)
    ## Called client-side to smoothly interpolate received TargetViewRotation (result is in BlendedTargetViewRotation)
    ## @param TargetPawn   is the pawn which is the current ViewTarget
    ## @param DeltaSeconds is the time interval since the last smoothing update

  proc consoleCommand(command: FString; bWriteToLog: bool = true): FString {.discardable.}
    ## Executes the Exec() command on the UPlayer object
    ##
    ## @param Command command to execute (string of commands optionally separated by a | (pipe))
    ## @param bWriteToLog write out to the log

  # AWARE: deps
  # proc notifyActorChannelFailure(actorChan: ptr UActorChannel)
  #   ## called on the server when the client sends a message indicating it was unable to initialize an Actor channel,
  #   ## most commonly because the desired Actor's archetype couldn't be serialized
  #   ## the default is to do nothing (Actor simply won't exist on the client), but this function gives the game code
  #   ## an opportunity to try to correct the problem

  proc updateHiddenActors(viewLocation: FVector)
    ## Builds a list of actors that are hidden based upon gameplay
    ## @param ViewLocation the view point to hide/unhide from

  proc updateHiddenComponents(viewLocation: FVector;
                              hiddenComponents: var TSet[FPrimitiveComponentId])
    ## Builds a list of components that are hidden based upon gameplay
    ## @param ViewLocation the view point to hide/unhide from
    ## @param HiddenComponents the list to add to/remove from

  proc buildHiddenComponentList(viewLocation: FVector;
                                HiddenComponents: var TSet[FPrimitiveComponentId])
    ## Builds a list of componenhs that are hidden based upon gameplay.
    ## This calls both UpdateHiddenActors and UpdateHiddenComponents, merging the two lists.
    ## @param ViewLocation the view point to hide/unhide from
    ## @param HiddenComponents this list will have all components that should be hidden added to it

  proc setControllingDirector(newControllingDirector: ptr UInterpTrackInstDirector;
                              bClientSimulatingViewTarget: bool)
    ## Sets the Matinee director track instance that's currently possessing this player controller
    ## @param   NewControllingDirector    The director track instance that's now controlling this player controller (or NULL for none)
    ## @param bClientSimulatingViewTarget True to allow clients to simulate their own camera cuts (ignored if NewControllingDirector is NULL).

  proc getControllingDirector(): ptr UInterpTrackInstDirector
    ## Returns the Matinee director track that's currently possessing this player controller, or NULL for none

  proc spawnPlayerCameraManager()
    ## spawn cameras for servers and owning players

  proc getAudioListenerPosition(outLocation: var FVector; outFrontDir: var FVector;
                                outRightDir: var FVector)
    ## Get audio listener position and orientation

  proc setAudioListenerOverride(attachToComponent: ptr USceneComponent;
                                location: FVector; rotation: FRotator)
    ## Used to override the default positioning of the audio listener
    ##
    ## @param AttachToComponent Optional component to attach the audio listener to
    ## @param Location Depending on whether Component is attached this is either an offset from its location or an absolute position
    ## @param Rotation Depending on whether Component is attached this is either an offset from its rotation or an absolute rotation
    ##
    ## UFUNCTION(BlueprintCallable, Category="Game|Audio")

  proc clearAudioListenerOverride()
    ## Clear any overrides that have been applied to audio listener
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Game|Audio")

  var bOverrideAudioListener: bool
    ## Whether to override the normal audio listener positioning method

  var audioListenerComponent: TWeakObjectPtr[USceneComponent]
    ## Component that is currently driving the audio listener position/orientation

  var audioListenerLocationOverride: FVector
    ## Currently overridden location of audio listener

  var audioListenerRotationOverride: FRotator
    ## Currently overridden rotation of audio listener

  proc setupInputComponent()
    ## Allows the PlayerController to set up custom input bindings.

  proc setNetSpeed(newSpeed: int32)
    ## Store the net speed
    ## @param NewSpeed current speed of network

  proc getPlayerNetworkAddress(): FString
    ## Get the local players network address
    ## @return the address

  proc getServerNetworkAddress(): FString
    ## Get the server network address
    ## @return the adress

  proc cleanUpAudioComponents()
    ## Clears out 'left-over' audio components.

  proc addCheats(bForce: bool = false)
    ## Notifies the server that the client has ticked gameplay code,
    ## and should no longer get the extended "still loading" timeout grace period

  proc spawnDefaultHUD()
    ## Spawn a HUD (make sure that PlayerController always has valid HUD, even if ClientSetHUD() hasn't been called

  proc createTouchInterface()
    ## Create the touch interface, and activate an initial touch interface (if touch interface is desired)

  proc cleanupGameViewport()
    ## Gives the PlayerController an opportunity to cleanup any changes it applied to the game viewport, primarily for the touch interface

  proc acknowledgePossession(pawn: ptr APawn)
    ## @Returns true if input should be frozen (whether UnFreeze timer is active)

  proc pawnLeavingGame()
    ## Clean up when a Pawn's player is leaving a game. Base implementation destroys the pawn.

  proc updatePing(inPing: cfloat)
    ## Takes ping updates from the net driver (both clientside and serverside),
    ## and passes them on to PlayerState::UpdatePing

  proc getNextViewablePlayer(dir: int32): ptr APlayerState
    ## Get next active viewable player in PlayerArray.
    ## @param dir is the direction to go in the array

  proc viewAPlayer(dir: int32)
    ## View next active player in PlayerArray.
    ## @param dir is the direction to go in the array

  proc canRestartPlayer(): bool
    ## @return true if this controller thinks it's able to restart. Called from GameMode::PlayerCanRestart

  proc setCinematicMode(bInCinematicMode: bool; bHidePlayer: bool; bAffectsHUD: bool;
                        bAffectsMovement: bool; bAffectsTurning: bool)
    ## Server/SP only function for changing whether the player is in cinematic mode.  Updates values of various state variables, then replicates the call to the client
    ## to sync the current cinematic mode.
    ## @param bInCinematicMode  specify true if the player is entering cinematic mode; false if the player is leaving cinematic mode.
    ## @param bHidePlayer     specify true to hide the player's pawn (only relevant if bInCinematicMode is true)
    ## @param bAffectsHUD     specify true if we should show/hide the HUD to match the value of bCinematicMode
    ## @param bAffectsMovement  specify true to disable movement in cinematic mode, enable it when leaving
    ## @param bAffectsTurning   specify true to disable turning in cinematic mode or enable it when leaving
    ##
    ## UFUNCTION(BlueprintCallable, Category="Game|Cinematic", meta=(bHidePlayer="true", bAffectsHUD="true"))

  proc isSplitscreenPlayer(outSplitscreenPlayerIndex: ptr int32 = nil): bool {.noSideEffect.}
    ## Determines whether this player is playing split-screen.
    ## @param OutSplitscreenPlayerIndex receives the index [into the player's local GamePlayers array] for this player, if playing splitscreen.
    ## @return  true if this player is playing splitscreen.

  proc isPrimaryPlayer(): bool {.noSideEffect.}
    ## Wrapper for determining whether this player is the first player on their console.
    ## @return  true if this player is not using splitscreen, or is the first player in the split-screen layout.

  proc getSplitscreenPlayerByIndex(playerIndex: int32 = 1): ptr APlayerState {.noSideEffect.}
    ## Returns the PlayerState associated with the player at the specified index.
    ## @param PlayerIndex   the index [into the local player's GamePlayers array] for the player PlayerState to find
    ## @return  the PlayerState associated with the player at the specified index, or None if the player is not a split-screen player or
    ##      the index was out of range.

  proc getSplitscreenPlayerCount(): int32 {.noSideEffect.}
    ## Returns the number of split-screen players playing on this player's machine.
    ## @return  the total number of players on the player's local machine, or 0 if this player isn't playing split-screen.

  proc updateCameraManager(deltaSeconds: cfloat)
    ## Update the camera manager; this is called after all actors have been ticked.

  proc receivedGameModeClass(gameModeClass: TSubclassOf[AGameMode])
    ## This function will be called to notify the player controller that the world has received its game class. In the case of a client
    ## we need to initialize the Input System here.
    ##
    ## @Param GameModeClass - The Class of the game that was replicated

  proc notifyServerReceivedClientData(inPawn: ptr APawn; timeStamp: cfloat): bool
    ## Notify the server that client data was received on the Pawn.
    ## @return true if InPawn is acknowledged on the server, false otherwise.

  proc startSpectatingOnly()
    ## Start spectating mode, as the only mode allowed.

  proc defaultCanUnpause(): bool
    ## Default implementation of pausing check for 'CanUnpause' delegates
    ## @return True if pausing is allowed

  proc isPaused(): bool
    ## @return true if game is currently paused.
  proc inputEnabled(): bool {.noSideEffect.}

  proc shouldPerformFullTickWhenPaused(): bool {.noSideEffect.}
    ## @return true if we fully tick when paused (and if our tick function is enabled when paused).

  proc hasClientLoadedCurrentWorld(): bool
    ## returns whether the client has completely loaded the server's current world (valid on server only)

  proc forceSingleNetUpdateFor(target: ptr AActor)
    ## forces a full replication check of the specified Actor on only the client that owns this PlayerController
    ## this function has no effect if this PC is not a remote client or if the Actor is not relevant to that client

  proc setViewTarget(newViewTarget: ptr AActor; transitionParams: FViewTargetTransitionParams = FViewTargetTransitionParams())
    ## Set the view target
    ## @param A - new actor to set as view target
    ## @param TransitionParams - parameters to use for controlling the transition

  proc autoManageActiveCameraTarget(suggestedTarget: ptr AActor)
    ## If bAutoManageActiveCameraTarget is true, then automatically manage the active camera target.
    ## If there a CameraActor placed in the level with an auto-activate player assigned to it, that will be preferred, otherwise SuggestedTarget will be used.

  proc onServerStartedVisualLogger(bIsLogging: bool)
    ## Notify from server that Visual Logger is recording, to show that information on client about possible performance issues
    ##
    ## UFUNCTION(Reliable, Client)
  proc getAutoActivateCameraForPlayer(): ptr ACameraActor {.noSideEffect.}
  proc shouldShowMouseCursor(): bool {.noSideEffect.}
  proc getMouseCursor(): EMouseCursor {.noSideEffect.}

  # Spectating

  proc getSpectatorPawn(): ptr ASpectatorPawn {.noSideEffect.}
    ## Get the Pawn used when spectating. NULL when not spectating.
    ## UFUNCTION(BlueprintCallable, Category = "Pawn")

  proc getPawnOrSpectator(): ptr APawn {.noSideEffect.}
    ## Returns the first of GetPawn() or GetSpectatorPawn() that is not NULL, or NULL otherwise.

  proc receivedSpectatorClass(spectatorClass: TSubclassOf[ASpectatorPawn])
    ## Called to notify the controller that the spectator class has been received.

  proc getFocalLocation(): FVector {.noSideEffect.}
    ## Returns the location the PlayerController is focused on.
    ## If there is a possessed Pawn, returns the Pawn's location.
    ## If there is a spectator Pawn, returns that Pawn's location.
    ## Otherwise, returns the PlayerController's spawn location (usually the last known Pawn location after it has died).
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Pawn")

  proc beginSpectatingState()
    ## Event when spectating begins.

  proc endSpectatingState()
    ## Event when no longer spectating.

  proc setSpectatorPawn(newSpectatorPawn: ptr ASpectatorPawn)
    ## Set the spectator pawn. Will also call AttachToPawn() using the new spectator.

  proc spawnSpectatorPawn(): ptr ASpectatorPawn
    ## Spawn a SpectatorPawn to use as a spectator and initialize it.
    ## By default it is spawned at the PC's current location and rotation.

  proc destroySpectatorPawn()
    ## Destroys the SpectatorPawn and sets it to NULL.

  var spawnLocation: FVector
    ## The location used internally when there is no pawn or spectator,
    ## to know where to spawn the spectator or focus the camera on death.
    ## UPROPERTY(Replicated)

  proc setSpawnLocation(newLocation: FVector)
    ## Set the SpawnLocation for use when changing states or when there is no pawn or spectator.

  proc getSpawnLocation(): FVector {.noSideEffect.}
    ## Get the location used when initially created, or when changing states when there is no pawn or spectator.

  proc receivedPlayer()
    ## Called after this PlayerController's viewport/net connection is associated with this player controller.

  proc initInputSystem()
    ## Spawn the appropriate class of PlayerInput.
    ## Only called for playercontrollers that belong to local players.

  proc isFrozen(): bool
    ## @returns true if input should be frozen (whether UnFreeze timer is active)

  proc preClientTravel(pendingURL: FString; travelType: ETravelType;
                       bIsSeamlessTravel: bool)
    ## Called when the local player is about to travel to a new map or IP address.  Provides subclass with an opportunity
    ## to perform cleanup or other tasks prior to the travel.

  proc setCameraMode(newCamMode: FName)
    ## Set new camera mode

  proc resetCameraMode()
    ## Reset Camera Mode to default.

  proc sendClientAdjustment()
    ## Called on server at end of tick, to let client Pawns handle updates from the server.
    ## Done this way to avoid ever sending more than one ClientAdjustment per server tick.

  proc setAsLocalPlayerController()
    ## Designate this player controller as local (public for GameMode to use, not expected to be called anywhere else)

  var seamlessTravelCount: uint16

  var lastCompletedSeamlessTravelCount: uint16
    ## The value of SeamlessTravelCount, upon the last call to GameMode::HandleSeamlessTravelPlayer; used to detect seamless travel
    ## UPROPERTY()