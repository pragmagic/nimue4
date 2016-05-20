# Copyright 2016 Xored Software, Inc.

##=============================================================================
## GameMode defines the rules and mechanics of the game.  It is only
## instanced on the server and will never exist on the client.
##=============================================================================

var enteringMapMatchState* {.importc: "MatchState::EnteringMap",
                             header: "GameFramework/GameMode.h".}: FName
  ## We are entering this map, actors are not yet ticking

var waitingToStartMatchState* {.importc: "MatchState::WaitingToStart",
                                header: "GameFramework/GameMode.h".}: FName
  ## Actors are ticking, but the match has not yet started

var inProgressMatchState* {.importc: "MatchState::InProgress",
                            header: "GameFramework/GameMode.h".}: FName
  ## Normal gameplay is occurring.
  ## Specific games will have their own state machine inside this state.

var waitingPostMatchMatchState* {.importc: "MatchState::WaitingPostMatch",
                                  header: "GameFramework/GameMode.h".}: FName
  ## Match has ended so we aren't accepting new players, but actors are still ticking

var leavingMapMatchState* {.importc: "MatchState::LeavingMap",
                            header: "GameFramework/GameMode.h".}: FName
  ## We are transitioning out of the map to another location

var abortedMatchState* {.importc: "MatchState::Aborted",
                         header: "GameFramework/GameMode.h".}: FName
  ## Match has failed due to network issues or other problems, cannot continue

# If a game needs to add additional states, you may need to override HasMatchStarted and HasMatchEnded to deal with the new states
# Do not add any states before WaitingToStart or after WaitingPostMatch

## Default delegate that provides an implementation for those that don't have special needs other than a toggle
declareBuiltinDelegate(FCanUnpause, dkSimpleRetVal, "GameFramework/GameMode.h", bool)

type
  FGameClassShortName* {.header: "GameFramework/GameMode.h", importcpp.}  = object
    ## Configurable shortened aliases for GameMode classes.
    ## For convenience when typing urls, for instance.
    shortName: FString
      ## Abbreviation that can be used as an alias for the class name
    gameClassName: FString
      ## The class name to use when the alias is specified in a URL

wclass(AGameMode of AInfo, header: "GameFramework/GameMode.h", notypedef):
  ## The GameMode defines the game being played. It governs the game rules, scoring, what actors
  ## are allowed to exist in this game type, and who may enter the game.
  ##
  ## It is only instanced on the server and will never exist on the client.
  ##
  ## A GameMode actor is instantiated when the level is initialized for gameplay in
  ## C++ UGameEngine::LoadMap().
  ##
  ## The class of this GameMode actor is determined by (in order) either the URL ?game=xxx,
  ## the GameMode Override value set in the World Settings, or the DefaultGameMode entry set
  ## in the game's Project Settings.
  ##
  ## @see https://docs.unrealengine.com/latest/INT/Gameplay/Framework/GameMode/index.html

  proc getMatchState(): FName {.noSideEffect.}
    ## Code to deal with the match state machine
    ## Returns the current match state, this is an accessor to protect the state machine flow
    ## UFUNCTION(BlueprintCallable, Category="Game")

  method hasMatchStarted(): bool {.noSideEffect.}
    ## Returns true if the match state is InProgress or later
    ## UFUNCTION(BlueprintCallable, Category="Game")

  method isMatchInProgress(): bool {.noSideEffect.}
    ## Returns true if the match state is InProgress or other gameplay state
    ## UFUNCTION(BlueprintCallable, Category="Game")

  method hasMatchEnded(): bool {.noSideEffect.}
    ## Returns true if the match state is WaitingPostMatch or later
    ## UFUNCTION(BlueprintCallable, Category="Game")

  method startPlay()
    ## Transitions to WaitingToStart and calls BeginPlay on actors.
    ## UFUNCTION(BlueprintCallable, Category="Game")

  method postSeamlessTravel()
    ## Called after a seamless level transition has been completed on the *new* GameMode.
    ## Used to reinitialize players already in the game as they won't have *Login() called on them

  method startMatch()
    ## Transition from WaitingToStart to InProgress. You can call this manually, will also get called if ReadyToStartMatch returns true
    ## UFUNCTION(BlueprintCallable, Category="Game")

  method endMatch()
    ## Transition from InProgress to WaitingPostMatch. You can call this manually, will also get called if ReadyToEndMatch returns true
    ## UFUNCTION(BlueprintCallable, Category="Game")

  method startToLeaveMap()
    ## Transition to LeavingMap state.
    ## Start the transition out of the current map.
    ## Called at start of seamless travel, or right before map change for hard travel.

  method restartGame()
    ## Restart the game, by default travel to the current map
    ## UFUNCTION(BlueprintCallable, Category="Game")

  method returnToMainMenuHost()
    ## Return to main menu, and disconnect any players
    ## UFUNCTION(BlueprintCallable, Category="Game")

  method abortMatch()
    ## Report that a match has failed due to unrecoverable error
    ## UFUNCTION(BlueprintCallable, Category="Game")

  var matchState: FName
    ## What match state we are currently in

  method setMatchState(newState: FName)
    ## Updates the match state and calls the appropriate transition functions

  proc k2_OnSetMatchState(newState: FName)
    ## Implementable event to respond to match state changes
    ## UFUNCTION(BlueprintImplementableEvent, Category="Game", meta=(DisplayName="OnSetMatchState"))

  method handleMatchIsWaitingToStart()
    ## Games should override these functions to deal with their game specific logic
    ## Called when the state transitions to WaitingToStart

  proc readyToStartMatch(): bool
    ## @return True if ready to Start Match. Games should override this
    ## UFUNCTION(BlueprintNativeEvent, Category="Game")

  method handleMatchHasStarted()
    ## Called when the state transitions to InProgress

  proc readyToEndMatch(): bool
    ## @return true if ready to End Match. Games should override this
    ## UFUNCTION(BlueprintNativeEvent, Category="Game")

  method handleMatchHasEnded()
    ## Called when the map transitions to WaitingPostMatch

  method handleLeavingMap()
    ## Called when the match transitions to LeavingMap

  method handleMatchAborted()
    ## Called when the match transitions to Aborted

  var bUseSeamlessTravel: bool
    ## Perform map travels using SeamlessTravel() which loads in the background and doesn't disconnect clients
    ## @see World::SeamlessTravel()
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="GameMode")

  var bPauseable: bool
    ## Whether the game is pauseable.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="GameMode")

  var bStartPlayersAsSpectators: bool
    ## Whether players should immediately spawn when logging in, or stay as spectators until they manually spawn
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="GameMode")

  var bDelayedStart: bool
    ## Whether the game should immediately start when the first player logs in. Affects the default behavior of ReadyToStartMatch
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="GameMode")

  var optionsString: FString
    ## Save options string and parse it when needed
    ## UPROPERTY(BlueprintReadOnly, Category="GameMode")

  var defaultPawnClass: TSubclassOf[APawn]
    ## The default pawn class used by players.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Classes)

  var HUDClass: TSubclassOf[AHUD]
    ## HUD class this game uses.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Classes, meta=(DisplayName="HUD Class"))

  var numSpectators: int32
    ## Current number of spectators.
    ## UPROPERTY(BlueprintReadOnly, Category=GameMode)

  var numPlayers: int32
    ## Current number of human players.
    ## UPROPERTY(BlueprintReadOnly, Category=GameMode)

  var numBots: int32
    ## number of non-human players (AI controlled but participating as a player).
    ## UPROPERTY(BlueprintReadOnly, Category=GameMode)

  var minRespawnDelay: cfloat
    ## Minimum time before player can respawn after dying.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=GameMode, meta=(DisplayName="Minimum Respawn Delay"))

  var gameSession: ptr AGameSession
    ## Game Session handles login approval, arbitration, online game interface
    ## UPROPERTY()

  var numTravellingPlayers: int32
    ## Number of players that are still traveling from a previous map
    ## UPROPERTY(BlueprintReadOnly, Category=GameMode)

  var currentID: int32
    ## Used to assign unique PlayerIDs to each PlayerState.

  var defaultPlayerName: FText
    ## The default player name assigned to players that join with no name specified.
    ## UPROPERTY(EditAnywhere, Category=GameMode)

  var engineMessageClass: TSubclassOf[ULocalMessage]
    ## Contains strings describing localized game agnostic messages.
    ## UPROPERTY()

  var playerControllerClass: TSubclassOf[APlayerController]
    ## The class of PlayerController to spawn for players logging in.
    ## UPROPERTY(EditAnywhere, noclear, BlueprintReadOnly, Category=Classes)

  var spectatorClass: TSubclassOf[ASpectatorPawn]
    ## The pawn class used by the PlayerController for players when spectating.
    ## UPROPERTY(EditAnywhere, noclear, BlueprintReadOnly, Category=Classes)

  var replaySpectatorPlayerControllerClass: TSubclassOf[APlayerController]
    ## The PlayerController class used when spectating a network replay.
    ## UPROPERTY(EditAnywhere, noclear, BlueprintReadOnly, Category = Classes)

  var playerStateClass: TSubclassOf[APlayerState]
    ## A PlayerState of this class will be associated with every player to replicate relevant player information to all clients.
    ## UPROPERTY(EditAnywhere, noclear, BlueprintReadOnly, Category=Classes)

  var gameStateClass: TSubclassOf[AGameState]
    ## Class of GameState associated with this GameMode.
    ## UPROPERTY(EditAnywhere, noclear, BlueprintReadOnly, Category=Classes)

  var gameState: ptr AGameState
    ## GameState is used to replicate game state relevant properties to all clients.
    ## UPROPERTY(Transient)

  proc getGameState[T](): ptr T {.noSideEffect.}
    ## Helper template to returns the current GameState casted to the desired type.

  var inactivePlayerArray: TArray[ptr APlayerState]
    ## PlayerStates of players who have disconnected from the server (saved in case they reconnect)
    ## UPROPERTY()

  var pausers: TArray[FCanUnpause]
    ## The list of delegates to check before unpausing a game

# protected:

  var gameModeClassAliases: TArray[FGameClassShortName]
    ## Handy alternate short names for GameMode classes (e.g. "DM" could be an alias for "MyProject.MyGameModeMP_DM".
    ## UPROPERTY(config)

  var inactivePlayerStateLifeSpan: cfloat
    ## Time a playerstate will stick around in an inactive state after a player logout
    ## UPROPERTY(EditAnywhere, Category=GameMode)

  var bHandleDedicatedServerReplays: bool
    ## If true, dedicated servers will record replays when HandleMatchHasStarted/HandleMatchHasStopped is called
    ## UPROPERTY(config)

# public:

  method setBandwidthLimit(asyncIOBandwidthLimit: cfloat)
    ## Alters the synthetic bandwidth limit for a running game.
    ## UFUNCTION(exec)

  proc shouldReset(actorToReset: ptr AActor): bool
    ## Overridable function to determine whether an Actor should have Reset called when the game has Reset called on it.
    ## Default implementation returns true
    ## @param ActorToReset The actor to make a determination for
    ## @return true if ActorToReset should have Reset() called on it while restarting the game,
    ## 		   false if the GameMode will manually reset it or if the actor does not need to be reset
    ##
    ##
    ## UFUNCTION(BlueprintNativeEvent, Category="Game")

  method resetLevel()
    ## Overridable function called when resetting level.
    ## Default implementation calls Reset() on all actors except GameMode and Controllers
    ##
    ## UFUNCTION(BlueprintCallable, Category="Game")

  proc shouldStartInCinematicMode(player: ptr APlayerController;
                                outHidePlayer: var bool; outHideHud: var bool;
                                outDisableMovement: var bool;
                                outDisableTurning: var bool): bool
    ## Check to see if we should start in cinematic mode (e.g. matinee movie capture).
    ## @param	OutHidePlayer		Whether to hide the player
    ## @param	OutHideHud			Whether to hide the HUD
    ## @param	OutDisableMovement	Whether to disable movement
    ## @param	OutDisableTurning	Whether to disable turning
    ## @return	true if we should turn on cinematic mode,
    ## 					false if if we should not.

  method initGame(mapName: FString; options: FString; errorMessage: var FString)
    ## Initialize the game.
    ## The GameMode's InitGame() event is called before any other functions (including PreInitializeComponents() )
    ## and is used by the GameMode to initialize parameters and spawn its helper classes.
    ## @warning: this is called before actors' PreInitializeComponents.

  method initGameState()
    ## Initialize the GameState actor with default settings
    ## called during PreInitializeComponents() of the GameMode after a GameState has been spawned
    ## as well as during Reset()

  method getNetworkNumber(): FString
    ## Get local address

  proc playerSwitchedToSpectatorOnly(pc: ptr APlayerController)
    ## Will remove the controller from the correct count then add them to the spectator count.

  proc removePlayerControllerFromPlayerCount(pc: ptr APlayerController)
    ## Removes the passed in player controller from the correct count for player/spectator/tranistioning *

  proc getNumPlayers(): int32
    ## Total number of players
    ## UFUNCTION(BlueprintCallable, Category="Game")

  proc setPause(pc: ptr APlayerController;
                canUnpauseDelegate: FCanUnpause = FCanUnpause()): bool
    ## Adds the delegate to the list if the player Controller has the right to pause
    ## the game. The delegate is called to see if it is ok to unpause the game, e.g.
    ## the reason the game was paused has been cleared.
    ## @param PC the player Controller to check for admin privs
    ## @param CanUnpauseDelegate the delegate to query when checking for unpause

  proc clearPause()
    ## Checks the list of delegates to determine if the pausing can be cleared. If
    ## the delegate says it's ok to unpause, that delegate is removed from the list
    ## and the rest are checked. The game is considered unpaused when the list is
    ## empty.

  proc forceClearUnpauseDelegates(pauseActor: ptr AActor)
    ## Forcibly removes an object's CanUnpause delegates from the list of pausers.  If any of the object's CanUnpause delegate
    ## handlers were in the list, triggers a call to ClearPause().
    ##
    ## Called when the player controller is being destroyed to prevent the game from being stuck in a paused state when a PC that
    ## paused the game is destroyed before the game is unpaused.

  method getDefaultGameClassPath(mapName: FString;
                               options: FString;
                               portal: FString): FString {.noSideEffect.}
    ## @return the full path to the optimal GameMode class to use for the specified map and options
    ## this is used for preloading cooked packages, etc. and therefore doesn't need to include any fallbacks
    ## as GetGameModeClass() will be called later to actually find/load the desired class

  method getGameModeClass(mapName: FString; options: FString; portal: FString): TSubclassOf[
      AGameMode] {.noSideEffect.}
    ## @return the class of GameMode to spawn for the game on the specified map and the specified options
    ## this function should include any fallbacks in case the desired class can't be found

  method getGameSessionClass(): TSubclassOf[AGameSession] {.noSideEffect.}
    ## @return GameSession class to use for this game

  method notifyPendingConnectionLost()
    ## Called when a connection closes before getting to PostLogin()

  method getTravelType(): bool
    ## @return true if we want to travel_absolute

  method processServerTravel(url: FString; bAbsolute: bool = false)
    ## Optional handling of ServerTravel for network games.

  method processClientTravel(url: var FString; nextMapGuid: FGuid; bSeamless: bool;
                           bAbsolute: bool): ptr APlayerController
    ## Notifies all clients to travel to the specified URL.
    ##
    ## @param	URL				a string containing the mapname (or IP address) to travel to, along with option key/value pairs
    ## @param	NextMapGuid		the GUID of the server's version of the next map
    ## @param	bSeamless		indicates whether the travel should use seamless travel or not.
    ## @param	bAbsolute		indicates which type of travel the server will perform (i.e. TRAVEL_Relative or TRAVEL_Absolute)

  method preLogin(options: FString; address: FString; uniqueId: TSharedPtr[FUniqueNetId];
                errorMessage: var FString)
    ## Accept or reject a player attempting to join the server.  Fails login if you set the ErrorMessage to a non-empty string.
    ## PreLogin is called before Login.  Significant game time may pass before Login is called, especially if content is downloaded.
    ##
    ## @param	Options					The URL options (e.g. name/spectator) the player has passed
    ## @param	Address					The network address of the player
    ## @param	UniqueId				The unique id the player has passed to the server
    ## @param	ErrorMessage			When set to a non-empty value, the player will be rejected using the error message set

  method login(newPlayer: ptr UPlayer; inRemoteRole: ENetRole; portal: FString;
            options: FString; uniqueId: TSharedPtr[FUniqueNetId];
            errorMessage: var FString): ptr APlayerController
    ## Called to login new players by creating a player controller, overridable by the game
    ##
    ## Sets up basic properties of the player (name, unique id, registers with backend, etc) and should not be used to do
    ## more complicated game logic.  The player controller is not fully initialized within this function as far as networking is concerned.
    ## Save "game logic" for PostLogin which is called shortly afterward.
    ##
    ## @param NewPlayer pointer to the UPlayer object that represents this player (either local or remote)
    ## @param RemoteRole the remote role this controller has
    ## @param Portal desired portal location specified by the client
    ## @param Options game options passed in by the client at login
    ## @param UniqueId platform specific unique identifier for the logging in player
    ## @param ErrorMessage [out] error message, if any, why this login will be failing
    ##
    ## If login is successful, returns a new PlayerController to associate with this player. Login fails if ErrorMessage string is set.
    ##
    ## @return a new player controller for the logged in player, NULL if login failed for any reason

  method postLogin(newPlayer: ptr APlayerController)
    ## Called after a successful login.  This is the first place it is safe to call replicated functions on the PlayerAController.

  proc k2_PostLogin(newPlayer: ptr APlayerController)
    ## Notification that a player has successfully logged in, and has been given a player controller
    ## UFUNCTION(BlueprintImplementableEvent, Category="Game", meta=(DisplayName="OnPostLogin"))

  method spawnPlayerController(inRemoteRole: ENetRole; spawnLocation: FVector;
                            spawnRotation: FRotator): ptr APlayerController
    ## Spawns a PlayerController at the specified location; split out from Login()/HandleSeamlessTravelPlayer() for easier overriding
    ##
    ## @param RemoteRole the role this controller will play remotely
    ## @param SpawnLocation location in the world to spawn
    ## @param SpawnRotation rotation to set relative to the world
    ##
    ## @return PlayerController for the player, NULL if there is any reason this player shouldn't exist or due to some error

  proc mustSpectate(newPlayerController: ptr APlayerController): bool {.noSideEffect.}
    ## @Returns true if NewPlayerController may only join the server as a spectator.
    ## UFUNCTION(BlueprintNativeEvent, Category="Game")

  proc getDefaultPawnClassForController(inController: ptr AController): ptr UClass
    ## returns default pawn class for given controller
    ## UFUNCTION(BlueprintNativeEvent, Category="Game")

  proc initStartSpot(startSpot: ptr AActor; newPlayer: ptr AController)
    ## Called when StartSpot is selected for spawning NewPlayer to allow optional initialization.
    ## UFUNCTION(BlueprintNativeEvent, Category="Game")

  proc spawnDefaultPawnFor(newPlayer: ptr AController; startSpot: ptr AActor): ptr APawn
    ## @param	NewPlayer - Controller for whom this pawn is spawned
    ## @param	StartSpot - PlayerStart at which to spawn pawn
    ## @return	a pawn of the default pawn class
    ##
    ## UFUNCTION(BlueprintNativeEvent, Category="Game")

  method replicateStreamingStatus(PC: ptr APlayerController)
    ## replicates the current level streaming status to the given PlayerController

  method genericPlayerInitialization(c: ptr AController)
    ## handles all player initialization that is shared between the travel methods
    ## (i.e. called from both PostLogin() and HandleSeamlessTravelPlayer())

  method startNewPlayer(newPlayer: ptr APlayerController)
    ## Start match, or let player enter, immediately

  method logout(exiting: ptr AController)
    ## Called when a Controller with a PlayerState leaves the match.

  proc k2_OnLogout(exitingController: ptr AController)
    ## Implementable event when a Controller with a PlayerState leaves the match.
    ## UFUNCTION(BlueprintImplementableEvent, Category="Game", meta=(DisplayName="OnLogout"))

  method setPlayerDefaults(playerPawn: ptr APawn)
    ## Make sure pawn properties are back to default
    ## Also a good place to modify them on spawn

  proc canSpectate(viewer: ptr APlayerController; viewTarget: ptr APlayerState): bool
    ## Return whether Viewer is allowed to spectate from the point of view of ViewTarget.
    ## UFUNCTION(BlueprintNativeEvent, Category="Game")

  method changeName(controller: ptr AController; newName: FString; bNameChange: bool)
    ## Sets the name for a controller
    ## @param Controller	The controller of the player to change the name of
    ## @param NewName		The name to set the player to
    ## @param bNameChange	Whether the name is changing or if this is the first time it has been set
    ##
    ## UFUNCTION(BlueprintCallable, Category="Game")

  proc k2_OnChangeName(other: ptr AController; newName: FString; bNameChange: bool)
    ## Overridable event for GameMode blueprint to respond to a change name call
    ## @param Controller	The controller of the player to change the name of
    ## @param NewName		The name to set the player to
    ## @param bNameChange	Whether the name is changing or if this is the first time it has been set
    ##
    ## UFUNCTION(BlueprintImplementableEvent,Category="Game",meta=(DisplayName="OnChangeName"))

  method sendPlayer(aPlayer: ptr APlayerController; URL: FString)
    ## Send a player to a URL.

  method broadcast(sender: ptr AActor; msg: FString; `type`: FName = NAME_None)
    ## Broadcast a string to all players.

  method broadcastLocalized(sender: ptr AActor; message: TSubclassOf[ULocalMessage];
                        switch: int32 = 0;
                        relatedPlayerState_1: ptr APlayerState = nil;
                        relatedPlayerState_2: ptr APlayerState = nil;
                        optionalObject: ptr UObject = nil)
    ## Broadcast a localized message to all players.
    ## Most message deal with 0 to 2 related PlayerStates.
    ## The LocalMessage class defines how the PlayerState's and optional actor are used.

  method shouldSpawnAtStartSpot(player: ptr AController): bool
    ## @return true if the given Controller StartSpot property should be used as the spawn location for its Pawn

  proc findPlayerStart(player: ptr AController; incomingName: FString = TEXT("")): ptr AActor
    ## Return the 'best' player start for this player to start from.
    ## @param Player The AController for whom we are choosing a Player Start
    ## @param IncomingName Specifies the tag of a Player Start to use
    ## @returns Actor chosen as player start (usually a PlayerStart)
    ##
    ## UFUNCTION(BlueprintNativeEvent, Category="Game")

  proc k2_FindPlayerStart(player: ptr AController): ptr AActor
    ## UFUNCTION(BlueprintPure, Category=Game, meta=(DisplayName="FindPlayerStart"))

  proc choosePlayerStart(player: ptr AController): ptr AActor
    ## Return the 'best' player start for this player to start from.
    ## Default implementation just returns the first PlayerStart found.
    ## @param Player is the controller for whom we are choosing a playerstart
    ## @returns AActor chosen as player start (usually a PlayerStart)
    ##
    ## UFUNCTION(BlueprintNativeEvent, Category="Game")

  proc playerCanRestart(player: ptr APlayerController): bool
    ## @return true if it's valid to call RestartPlayer. Will call Player->CanRestartPlayer
    ## UFUNCTION(BlueprintNativeEvent, Category="Game")

  method updateGameplayMuteList(aPlayer: ptr APlayerController)
    ## Used to notify the game type that it is ok to update a player's gameplay
    ## specific muting information now. The playercontroller needs to notify
    ## the server when it is possible to do so or the unique net id will be
    ## incorrect and the muting not work.
    ##
    ## @param aPlayer the playercontroller that is ready for updates

  method allowCheats(p: ptr APlayerController): bool
    ## @return true if player is allowed to access the cheats

  method allowPausing(PC: ptr APlayerController = nil): bool
    ## @return	true if the player is allowed to pause the game.

  method preCommitMapChange(previousMapName: FString; nextMapName: FString)
    ## Called from CommitMapChange before unloading previous level. Used for asynchronous level streaming
    ## @param PreviousMapName - Name of the previous persistent level
    ## @param NextMapName - Name of the persistent level being streamed to

  method postCommitMapChange()
    ## Called from CommitMapChange after unloading previous level and loading new level+sublevels.
    ## Used for asynchronous level streaming

  method addInactivePlayer(playerState: ptr APlayerState; PC: ptr APlayerController)
    ## Add PlayerState to the inactive list, remove from the active list

  method findInactivePlayer(PC: ptr APlayerController): bool
    ## Attempt to find and associate an inactive PlayerState with entering PC.
    ## @Returns true if a PlayerState was found and associated with PC.

  method overridePlayerState(PC: ptr APlayerController; oldPlayerState: ptr APlayerState)
    ## Override PC's PlayerState with the values in OldPlayerState.

  method getSeamlessTravelActorList(bToEntry: bool; actorList: var TArray[ptr AActor])
    ## called on server during seamless level transitions to get the list of Actors that should be moved into the new level
    ## PlayerControllers, Role < ROLE_Authority Actors, and any non-Actors that are inside an Actor that is in the list
    ## (i.e. Object.Outer == Actor in the list)
    ## are all automatically moved regardless of whether they're included here
    ## only dynamic actors in the PersistentLevel may be moved (this includes all actors spawned during gameplay)
    ## this is called for both parts of the transition because actors might change while in the middle (e.g. players might join or leave the game)
    ## @see also PlayerController::GetSeamlessTravelActorList() (the function that's called on clients)
    ## @param bToEntry true if we are going from old level -> entry, false if we are going from entry -> new level
    ## @param ActorList (out) list of actors to maintain

  method getRedirectURL(mapName: FString): FString {.noSideEffect.}
    ## Allow the game to specify a place for clients to download MapName

  method swapPlayerControllers(oldPC: ptr APlayerController;
                            newPC: ptr APlayerController)
    ## Used to swap a viewport/connection's PlayerControllers when seamless traveling and the new GameMode's
    ## controller class is different than the previous
    ## includes network handling
    ## @param OldPC - the old PC that should be discarded
    ## @param NewPC - the new PC that should be used for the player

  proc k2_OnSwapPlayerControllers(oldPC: ptr APlayerController;
                                  newPC: ptr APlayerController)
    ## UFUNCTION(BlueprintImplementableEvent, Category="Game", meta=(DisplayName="OnSwapPlayerControllers"))

  method handleSeamlessTravelPlayer(c: var ptr AController)
    ## Handles reinitializing players that remained through a seamless level transition
    ## called from C++ for players that finished loading after the server
    ## @param C the Controller to handle

  method setSeamlessTravelViewTarget(PC: ptr APlayerController)
    ## SetViewTarget of player control on server change

  method matineeCancelled()
    ## Called when this PC is in cinematic mode, and its matinee is canceled by the user.

  method restartPlayer(newPlayer: ptr AController)
    ## Does end of game handling for the online layer

  proc k2_OnRestartPlayer(newPlayer: ptr AController)
    ## UFUNCTION(BlueprintImplementableEvent, Category="Game", meta=(DisplayName="OnRestartPlayer"))

  proc staticGetFullGameClassName(str: FString) : FString {.isStatic.}
    ## Given a string, return a fully-qualified GameMode class name

  method isHandlingReplays(): bool
    ## Returns true if replays will start/stop during gameplay starting/stopping

# protected:

  method initNewPlayer(newPlayerController: ptr APlayerController;
                     uniqueId: TSharedPtr[FUniqueNetId]; options: FString;
                     portal: FString = TEXT("")): FString
    ## Customize incoming player based on URL options
    ##
    ## @param NewPlayerController player logging in
    ## @param UniqueId unique id for this player
    ## @param Options URL options that came at login