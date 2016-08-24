# Copyright 2016 Xored Software, Inc.

wclass(AGameState of AInfo, header: "GameFramework/GameState.h", notypedef):
  var gameModeClass: TSubclassOf[AGameMode]
    ## Class of the server's game mode, assigned by GameMode.
    ## UPROPERTY(replicatedUsing=OnRep_GameModeClass)

  var authorityGameMode: ptr AGameMode
    ## Instance of the current game mode, exists only on the server. For non-authority clients, this will be NULL.
    ## UPROPERTY(Transient, BlueprintReadOnly, Category=GameState)

  var spectatorClass: TSubclassOf[ASpectatorPawn]
    ## Class used by spectators, assigned by GameMode.
    ## UPROPERTY(replicatedUsing=OnRep_SpectatorClass)

  proc getMatchState(): FName {.noSideEffect.}
    ## Code to deal with the match state machine
    ## Returns the current match state, this is an accessor to protect the state machine flow

  proc hasMatchStarted(): bool {.noSideEffect.}
    ## Returns true if the match state is InProgress or later

  proc isMatchInProgress(): bool {.noSideEffect.}
    ## Returns true if we're in progress

  proc hasMatchEnded(): bool {.noSideEffect.}
    ## Returns true if match is WaitingPostMatch or later

  proc setMatchState(newState: FName)
    ## Updates the match state and calls the appropriate transition functions, only valid on server

  var elapsedTime: int32
    ## Elapsed game time since match has started.
    ## UPROPERTY(replicatedUsing=OnRep_ElapsedTime, BlueprintReadOnly, Category = GameState)

  var playerArray: TArray[ptr APlayerState]
    ## Array of all PlayerStates, maintained on both server and clients (PlayerStates are always relevant)
    ## UPROPERTY(BlueprintReadOnly, Category=GameState)

  proc onRep_GameModeClass()
    ## GameMode class notification callback.
    ## UFUNCTION()

  proc onRep_SpectatorClass()
    ## Callback when we receive the spectator class
    ## UFUNCTION()

  proc onRep_MatchState()
    ## Match state has changed
    ## UFUNCTION()

  proc onRep_ElapsedTime()
    ## Gives clients the chance to do something when time gets updates
    ## UFUNCTION()


  proc getDefaultGameMode(): ptr AGameMode {.noSideEffect.}
    ## Helper to return the default object of the GameMode class corresponding to this GameState

  proc receivedGameModeClass()
    ## Called when the GameClass property is set (at startup for the server, after the variable has been replicated on clients)

  proc receivedSpectatorClass()
    ## Called when the SpectatorClass property is set (at startup for the server, after the variable has been replicated on clients)

  proc seamlessTravelTransitionCheckpoint(bToTransitionMap: bool)
    ## Called during seamless travel transition twice (once when the transition map is loaded, once when destination map is loaded)

  proc addPlayerState(playerState: ptr APlayerState)
    ## Add PlayerState to the PlayerArray

  proc removePlayerState(playerState: ptr APlayerState)
    ## Remove PlayerState from the PlayerArray.

  proc defaultTimer()
    ## Called periodically, overridden by subclasses

  proc shouldShowGore(): bool {.noSideEffect.}
    ## Should players show gore?

  proc getServerWorldTimeSeconds(): cfloat {.noSideEffect.}
    ## Returns the simulated TimeSeconds on the server
    ## UFUNCTION(BlueprintCallable, Category=GameState)

  proc updateServerTimeSeconds()
    ## Called periodically to update ReplicatedWorldTimeSeconds

  proc onRep_ReplicatedWorldTimeSeconds()
    ## Allows clients to calculate ServerWorldTimeSecondsDelta
    ## UFUNCTION()

  var replicatedWorldTimeSeconds: cfloat
    ## Server TimeSeconds. Useful for syncing up animation and gameplay.
    ## UPROPERTY(replicatedUsing=OnRep_ReplicatedWorldTimeSeconds, transient)

  var serverWorldTimeSecondsDelta: cfloat
    ## The difference from the local world's TimeSeconds and the server world's TimeSeconds.
    ## UPROPERTY(transient)

  var serverWorldTimeSecondsUpdateFrequency: cfloat
    ## Frequency that the server updates the replicated TimeSeconds from the world. Set to zero to disable periodic updates.
    ## UPROPERTY(EditDefaultsOnly, Category=GameState)

  var timerHandle_DefaultTimer: FTimerHandle
    ## Handle for efficient management of DefaultTimer timer

  var timerHandle_UpdateServerTimeSeconds: FTimerHandle
    ## Handle for efficient management of the UpdateServerTimeSeconds timer

  var matchState: FName
    ## What match state we are currently in
    ## UPROPERTY(ReplicatedUsing=OnRep_MatchState, BlueprintReadOnly, VisibleInstanceOnly, Category = GameState)

  var previousMatchState: FName
    ## Previous map state, used to handle if multiple transitions happen per frame
    ## UPROPERTY(BlueprintReadOnly, VisibleInstanceOnly, Category = GameState)

  proc handleMatchIsWaitingToStart()
    ## Called when the state transitions to WaitingToStart

  proc handleMatchHasStarted()
    ## Called when the state transitions to InProgress

  proc handleMatchHasEnded()
    ## Called when the map transitions to WaitingPostMatch

  proc handleLeavingMap()
    ## Called when the match transitions to LeavingMap
