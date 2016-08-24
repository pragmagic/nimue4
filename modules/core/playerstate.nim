# Copyright 2016 Xored Software, Inc.

wclass(APlayerState of AInfo, header: "GameFramework/PlayerState.h", notypedef):
  ## A PlayerState is created for every player on a server (or in a standalone game).
  ## PlayerStates are replicated to all clients, and contain network game relevant information about the player, such as playername, score, etc.
  ##
  ## UCLASS(BlueprintType, Blueprintable, notplaceable)

  var score: cfloat
    ## Player's current score.
    ## UPROPERTY(replicatedUsing=OnRep_Score, BlueprintReadOnly, Category=PlayerState)

  var ping: uint8
    ## Replicated compressed ping for this player (holds ping in msec divided by 4)
    ## UPROPERTY(replicated, BlueprintReadOnly, Category=PlayerState)

  var playerName: FString
    ## Player name, or blank if none.
    ## UPROPERTY(replicatedUsing=OnRep_PlayerName, BlueprintReadOnly, Category=PlayerState)

  var oldName: FString
    ## Previous player name.  Saved on client-side to detect player name changes.

  var playerId: int32
    ## Unique net id number. Actual value varies based on current online subsystem, use it only as a guaranteed unique number per player.
    ## UPROPERTY(replicated, BlueprintReadOnly, Category=PlayerState)

  var bIsSpectator: bool
    ## Whether this player is currently a spectator
    ## UPROPERTY(replicated, BlueprintReadOnly, Category=PlayerState)

  var bOnlySpectator: bool
    ## Whether this player can only ever be a spectator
    ## UPROPERTY(replicated)

  var bIsABot: bool
    ## True if this PlayerState is associated with an AIController
    ## UPROPERTY(replicated, BlueprintReadOnly, Category=PlayerState)

  var bHasBeenWelcomed: bool
    ## Client side flag - whether this player has been welcomed or not (player entered message)

  var bIsInactive: bool
    ## Means this PlayerState came from the GameMode's InactivePlayerArray
    ## UPROPERTY(replicatedUsing=OnRep_bIsInactive)

  var bFromPreviousLevel: bool
    ## indicates this is a PlayerState from the previous level of a seamless travel,
    ## waiting for the player to finish the transition before creating a new one
    ## this is used to avoid preserving the PlayerState in the InactivePlayerArray if the player leaves
    ##
    ## UPROPERTY(replicated)

  var startTime: int32
    ## Elapsed time on server when this PlayerState was first created.
    ## UPROPERTY(replicated)

  var engineMessageClass: typedesc[ULocalMessage]
    ## This is used for sending game agnostic messages that can be localized
    ## UPROPERTY()

  var exactPing: cfloat
    ## Exact ping as float (rounded and compressed in replicated Ping)

  var savedNetworkAddress: FString
    ## Used to match up InactivePlayerState with rejoining playercontroller.

  # var uniqueId: FUniqueNetIdRepl
  #   ## The id used by the network to uniquely identify a player.
  #   ##   NOTE: the internals of this property should *never* be exposed to the player as it's transient
  #   ##   and opaque in meaning (ie it might mean date/time followed by something else).
  #   ##   It is OK to use and pass around this property, though.
  #   ## UPROPERTY(replicatedUsing=OnRep_UniqueId)

  var sessionName: FName
    ## The session that the player needs to join/remove from as it is created/leaves

  # Replication Notification Callbacks

  method onRep_Score()
    ## UFUNCTION()

  method onRep_PlayerName()
    ## UFUNCTION()

  method onRep_bIsInactive()
    ## UFUNCTION()

  method onRep_UniqueId()
    ## UFUNCTION()

  method clientInitialize(controller: ptr AController)
    ## Called by Controller when its PlayerState is initially replicated.

  method updatePing(inPing: cfloat)
    ## Receives ping updates for the client (both clientside and serverside), from the net driver
    ## NOTE: This updates much more frequently clientside, thus the clientside ping will often be different to what the server displays

  method recalculateAvgPing()
    ## Recalculates the replicated Ping value once per second (both clientside and serverside), based upon collected ping data

  method shouldBroadCastWelcomeMessage(bExiting: bool = false): bool
    ## Returns true if should broadcast player welcome/left messages.
    ## Current conditions: must be a human player a network game

  method setPlayerName(name: FString)
    ## set the player name to `name`

  method setUniqueId(inUniqueId: TSharedPtr[FUniqueNetId])
    ## Associate an online unique id with this player
    ## @param InUniqueId the unique id associated with this player

  method registerPlayerWithSession(bWasFromInvite: bool)
    ## Register a player with the online subsystem
    ## @param bWasFromInvite was this player invited directly

  method unregisterPlayerWithSession()
    ## Unregister a player with the online subsystem

  method duplicate(): ptr APlayerState
    ## Create duplicate PlayerState (for saving Inactive PlayerState)

  method overrideWith(playerState: ptr APlayerState)

  method copyProperties(playerState: ptr APlayerState)
    ## Copy properties which need to be saved in inactive PlayerState

  method seamlessTravelTo(newPlayerState: ptr APlayerState)
    ## called by seamless travel when initializing a player on the other side -
    ## copy properties to the new PlayerState that should persist

  method isPrimaryPlayer(): bool {.noSideEffect.}
    ## return true if PlayerState is primary (ie. non-splitscreen) player