# Copyright 2016 Xored Software, Inc.

declareBuiltinDelegate(FActorDestroyedSignature, dkDynamicMulticast, "GameFramework/Actor.h")
declareBuiltinDelegate(FActorBeginCursorOverSignature, dkDynamicMulticast, "GameFramework/Actor.h")
declareBuiltinDelegate(FActorEndCursorOverSignature, dkDynamicMulticast, "GameFramework/Actor.h")
declareBuiltinDelegate(FActorOnClickedSignature, dkDynamicMulticast, "GameFramework/Actor.h")
declareBuiltinDelegate(FActorOnReleasedSignature, dkDynamicMulticast, "GameFramework/Actor.h")

declareBuiltinDelegate(FTakeAnyDamageSignature, dkDynamicMulticast, "GameFramework/Actor.h",
  damage: cfloat, damageType: ptr UDamageType, instigatedBy: ptr AController, damageCauser: ptr AActor)

declareBuiltinDelegate(FTakePointDamageSignature, dkDynamicMulticast, "GameFramework/Actor.h",
  damage: cfloat, instigatedBy: ptr AController, hitLocation: FVector,
  hitComponent: ptr UPrimitiveComponent, boneName: FName,
  shotFromDirection: FVector, damageType: ptr UDamageType, damageCauser: ptr AActor)

declareBuiltinDelegate(FActorBeginOverlapSignature, dkDynamicMulticast, "GameFramework/Actor.h",
  otherActor: ptr AActor)

declareBuiltinDelegate(FActorEndOverlapSignature, dkDynamicMulticast, "GameFramework/Actor.h",
  otherActor: ptr AActor)

declareBuiltinDelegate(FActorHitSignature, dkDynamicMulticast, "GameFramework/Actor.h",
  selfActor: ptr AActor,otherActor: ptr AActor, normalImpulse: FVector, hit: var FHitResult)

declareBuiltinDelegate(FActorOnInputTouchBeginSignature, dkDynamicMulticast, "GameFramework/Actor.h", fingerIndex: ETouchIndex)
declareBuiltinDelegate(FActorOnInputTouchEndSignature, dkDynamicMulticast, "GameFramework/Actor.h", fingerIndex: ETouchIndex)
declareBuiltinDelegate(FActorBeginTouchOverSignature, dkDynamicMulticast, "GameFramework/Actor.h", fingerIndex: ETouchIndex)
declareBuiltinDelegate(FActorEndTouchOverSignature, dkDynamicMulticast, "GameFramework/Actor.h", fingerIndex: ETouchIndex)
declareBuiltinDelegate(FActorEndPlaySignature, dkDynamicMulticast, "GameFramework/Actor.h", endPlayReason: EEndPlayReason)
declareBuiltinDelegate(FMakeNoiseDelegate, dkDynamicMulticast, "GameFramework/Actor.h",
  actor: ptr AActor, loudness: cfloat, pawn: ptr APawn, vec: FVector, maxRange: cfloat, tag: FName)

when not defined(UE_BUILD_SHIPPING):
  declareBuiltinDelegate(FOnProcessEvent, dkDynamicMulticastRetVal, "GameFramework/Actor.h", bool, actor: ptr AActor, f: ptr UFunction, obj: ptr)

wclass(AActor of UObject, header: "GameFramework/Actor.h", notypedef):
  # AWARE
  # proc getLifetimeReplicatedProps(outLifetimeProps: var TArray[FLifetimeProperty])

  var primaryActorTick: FActorTickFunction
    ## Primary Actor tick function, which calls TickActor().
    ## Tick functions can be configured to control whether ticking is enabled, at what time during a frame the update occurs, and to set up tick dependencies.
    ## @see https://docs.unrealengine.com/latest/INT/API/Runtime/Engine/Engine/FTickFunction/
    ## @see AddTickPrerequisiteActor(), AddTickPrerequisiteComponent()
    ##
    ## UPROPERTY(EditDefaultsOnly, Category="Tick")

  var customTimeDilation: cfloat
    ## Allow each actor to run at a different time speed. The DeltaTime for a frame is multiplied by the global TimeDilation (in WorldSettings) and this CustomTimeDilation for this actor's tick.
    ## UPROPERTY(BlueprintReadWrite, AdvancedDisplay, Category="Misc")

  var bHidden: bool
    ##
    ## Allows us to only see this Actor in the Editor, and not in the actual game.
    ## @see SetActorHiddenInGame()
    ##
    ## UPROPERTY(Interp, EditAnywhere, Category=Rendering, BlueprintReadOnly, replicated, meta=(DisplayName = "Actor Hidden In Game", SequencerTrackClass = "MovieSceneVisibilityTrack"))

  var bNetTemporary: bool
    ## If true, when the actor is spawned it will be sent to the client but receive no further replication updates from the server afterwards.
    ## UPROPERTY()

  var bNetStartup: bool
    ## If true, this actor was loaded directly from the map, and for networking purposes can be addressed by its full path name
    ## UPROPERTY()

  var bOnlyRelevantToOwner: bool
    ## If true, this actor is only relevant to its owner. If this flag is changed during play, all non-owner channels would need to be explicitly closed.
    ## UPROPERTY(Category=Replication, EditDefaultsOnly, BlueprintReadOnly)

  var bAlwaysRelevant: bool
    ## Always relevant for network (overrides bOnlyRelevantToOwner).
    ## UPROPERTY(Category=Replication, EditDefaultsOnly, BlueprintReadWrite)

  var bReplicateMovement: bool
    ## If true, replicate movement/location related properties.
    ## Actor must also be set to replicate.
    ## @see SetReplicates()
    ## @see https://docs.unrealengine.com/latest/INT/Gameplay/Networking/Replication/
    ##
    ## UPROPERTY(ReplicatedUsing=OnRep_ReplicateMovement, Category=Replication, EditDefaultsOnly)

  method onRep_ReplicateMovement()
    ## Called on client when updated bReplicateMovement value is received for this actor.
    ## UFUNCTION()

  var bTearOff: bool
    ## If true, this actor is no longer replicated to new clients, and is "torn off" (becomes a ROLE_Authority) on clients to which it was being replicated.
    ## @see TornOff()
    ##
    ## UPROPERTY(replicated)

  method tearOff()
    ## Networking - Server - TearOff this actor to stop replication to clients. Will set bTearOff to true.
    ## UFUNCTION(BlueprintCallable, Category = Replication)

  var bExchangedRoles: bool
    ## Whether we have already exchanged Role/RemoteRole on the client, as when removing then re-adding a streaming level.
    ## Causes all initialization to be performed again even though the actor may not have actually been reloaded.
    ##
    ## UPROPERTY(transient)

  var bPendingNetUpdate: bool
    ## Is this actor still pending a full net update due to clients that weren't able to replicate the actor at the time of LastNetUpdateTime
    ## UPROPERTY(transient)

  var bNetLoadOnClient: bool
    ## This actor will be loaded on network clients during map load
    ## UPROPERTY(Category=Replication, EditDefaultsOnly)

  var bNetUseOwnerRelevancy: bool
    ## If actor has valid Owner, call Owner's IsNetRelevantFor and GetNetPriority
    ## UPROPERTY(Category=Replication, EditDefaultsOnly, BlueprintReadWrite)

  var bBlockInput: bool
    ## If true, all input on the stack below this actor will not be considered
    ## UPROPERTY(EditDefaultsOnly, Category=Input)

  var bRunningUserConstructionScript: bool
    ## True if this actor is currently running user construction script (used to defer component registration)

  var bReplicates: bool
    ## If true, this actor will replicate to remote machines
    ## @see SetReplicates()
    ##
    ## UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category = "Replication")

  proc setRemoteRoleForBackwardsCompat(inRemoteRole: ENetRole)
    ## This function should only be used in the constructor of classes that need to set the RemoteRole for backwards compatibility purposes

  method hasNetOwner(): bool {.noSideEffect.}
    ## Does this actor have an owner responsible for replication? (APlayerController typically)
    ##
    ## @return true if this actor can call RPCs or false if no such owner chain exists

  proc setReplicates(bInReplicates: bool)
    ## Set whether this actor replicates to network clients. When this actor is spawned on the server it will be sent to clients as well.
    ## Properties flagged for replication will update on clients if they change on the server.
    ## Internally changes the RemoteRole property and handles the cases where the actor needs to be added to the network actor list.
    ## @param bInReplicates Whether this Actor replicates to network clients.
    ## @see https://docs.unrealengine.com/latest/INT/Gameplay/Networking/Replication/
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Replication")

  method setReplicateMovement(bInReplicateMovement: bool)
    ## Set whether this actor's movement replicates to network clients.
    ## @param bInReplicateMovement Whether this Actor's movement replicates to clients.
    ##
    ## UFUNCTION(BlueprintCallable, Category = "Replication")

  proc setAutonomousProxy(bInAutonomousProxy: bool)
    ## Sets whether or not this Actor is an autonomous proxy, which is an actor on a network client that is controlled by a user on that client.

  proc copyRemoteRoleFrom(copyFromActor: ptr AActor)
    ## Copies RemoteRole from another Actor and adds this actor to the list of network actors if necessary.

  proc getRemoteRole(): ENetRole {.noSideEffect.}
    ## Returns how much control the remote machine has over this actor.

  # AWARE: replication
  # var replicatedMovement: FRepMovement
  #   ## Used for replication of our RootComponent's position and velocity
  #   ## UPROPERTY(EditDefaultsOnly, ReplicatedUsing=OnRep_ReplicatedMovement, Category=Replication, AdvancedDisplay)

  # var attachmentReplication: FRepAttachment
  #   ## Used for replicating attachment of this actor's RootComponent to another actor.
  #   ## UPROPERTY(Transient, replicatedUsing=OnRep_AttachmentReplication)

  method onRep_AttachmentReplication()
    ## Called on client when updated AttachmentReplication value is received for this actor.
    ## UFUNCTION()

  var role: ENetRole
    ## Describes how much control the local machine has over the actor.
    ## UPROPERTY(Replicated)

  var netDormancy: ENetDormancy
    ## Dormancy setting for actor to take itself off of the replication list without being destroyed on clients.

  var autoReceiveInput: EAutoReceiveInput
    ## Automatically registers this actor to receive input from a player.
    ## UPROPERTY(EditAnywhere, Category=Input)

  var inputPriority: int32
    ## The priority of this input component when pushed in to the stack.
    ## UPROPERTY(EditAnywhere, Category=Input)

  var netCullDistanceSquared: cfloat
    ## Square of the max distance from the client's viewpoint that this actor is relevant and will be replicated.
    ## UPROPERTY(BlueprintReadOnly, EditDefaultsOnly, Category=Replication)

  var netTag: int32
    ## Internal - used by UWorld::ServerTickClients()
    ## UPROPERTY(transient)

  var netUpdateTime: cfloat
    ## Next time this actor will be considered for replication, set by SetNetUpdateTime()
    ## UPROPERTY()

  var netUpdateFrequency: cfloat
    ## How often (per second) this actor will be considered for replication, used to determine NetUpdateTime
    ## UPROPERTY(Category=Replication, EditDefaultsOnly, BlueprintReadWrite)

  var netPriority: cfloat
    ## Priority for this actor when checking for replication in a low bandwidth or saturated situation, higher priority means it is more likely to replicate
    ## UPROPERTY(Category=Replication, EditDefaultsOnly, BlueprintReadWrite)

  var lastNetUpdateTime: cfloat
    ## Last time this actor was updated for replication via NetUpdateTime
    ## @warning: internal net driver time, not related to WorldSettings.TimeSeconds
    ## UPROPERTY(transient)

  var netDriverName: FName
    ## Used to specify the net driver to replicate on (NAME_None || NAME_GameNetDriver is the default net driver)
    ## UPROPERTY()

  # AWARE: replication
  # method replicateSubobjects(channel: ptr UActorChannel; bunch: ptr FOutBunch;
  #                          repFlags: ptr FReplicationFlags): bool
  #   ## Method that allows an actor to replicate subobjects on its actor channel

  method onSubobjectCreatedFromReplication(newSubobject: ptr UObject)
    ## Called on the actor when a new subobject is dynamically created via replication

  method onSubobjectDestroyFromReplication(subobject: ptr UObject)
    ## Called on the actor when a subobject is dynamically destroyed via replication

  # AWARE: replication
  # method preReplication(changedPropertyTracker: var IRepChangedPropertyTracker)
  #   ## Called on the actor right before replication occurs

  var bAutoDestroyWhenFinished: bool
    ## If true then destroy self when "finished", meaning all relevant components report that they are done and no timelines or timers are in flight.
    ## UPROPERTY(BlueprintReadWrite, Category=Actor)

  var bCanBeDamaged: bool
    ## Whether this actor can take damage. Must be true for damage events (e.g. ReceiveDamage()) to be called.
    ## @see https://www.unrealengine.com/blog/damage-in-ue4
    ## @see TakeDamage(), ReceiveDamage()
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Replicated, Category=Actor)

  var bCollideWhenPlacing: bool
    ## This actor collides with the world when placing in the editor, even if RootComponent collision is disabled. Does not affect spawning, @see SpawnCollisionHandlingMethod
    ## UPROPERTY()

  var bFindCameraComponentWhenViewTarget: bool
    ## If true, this actor should search for an owned camera component to view through when used as a view target.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Actor, AdvancedDisplay)

  var bRelevantForNetworkReplays: bool
    ## If true, this actor will be replicated to network replays (default is true)
    ## UPROPERTY()

  var spawnCollisionHandlingMethod: ESpawnActorCollisionHandlingMethod
    ## Controls how to handle spawning this actor in a situation where it's colliding with something else. "Default" means AlwaysSpawn here.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Actor)

  var creationTime: cfloat
    ## The time this actor was created, relative to World->GetTimeSeconds().
    ## @see UWorld::GetTimeSeconds()

  var instigator: ptr APawn
    ## Pawn responsible for damage caused by this actor.
    ## UPROPERTY(BlueprintReadWrite, replicatedUsing=OnRep_Instigator, meta=(ExposeOnSpawn=true), Category=Actor)

  method onRep_Instigator()
    ## Called on clients when Instigatolr is replicated.
    ## UFUNCTION()

  var children: TArray[ptr AActor]
    ## Array of Actors whose Owner is this actor
    ## UPROPERTY(transient)

  var rootComponent: ptr USceneComponent
    ## Collision primitive that defines the transform (location, rotation, scale) of this Actor.
    ##
    ## UPROPERTY()

  var pivotOffset: FVector # def WITH_EDITORONLY_DATA
    ## Local space pivot offset for the actor
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, AdvancedDisplay, Category = Actor)

  var controllingMatineeActors: TArray[ptr AMatineeActor]
    ## The matinee actors that control this actor.
    ## UPROPERTY(transient)

  var initialLifeSpan: cfloat
    ## How long this Actor lives before dying, 0=forever. Note this is the INITIAL value and should not be modified once play has begun.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Actor)

  var timerHandle_LifeSpanExpired: FTimerHandle
    ## Handle for efficient management of LifeSpanExpired timer

  var bAllowReceiveTickEventOnDedicatedServer: bool
    ## If false, the Blueprint ReceiveTick() event will be disabled on dedicated servers.
    ## @see AllowReceiveTickEventOnDedicatedServer()
    ##
    ## UPROPERTY()

  proc allowReceiveTickEventOnDedicatedServer(): bool {.noSideEffect.}
    ## Return the value of bAllowReceiveTickEventOnDedicatedServer, indicating whether the Blueprint ReceiveTick() event will occur on dedicated servers.

  var layers: TArray[FName]
    ## Layer's the actor belongs to.  This is outside of the editoronly data to allow hiding of LD-specified layers at runtime for profiling.
    ## UPROPERTY()

  #if WITH_EDITORONLY_DATA:
  var bActorLabelEditable: bool
    ## Is the actor label editable by the user?
    ## UPROPERTY()

  var bHiddenEd: bool
    ## Whether this actor is hidden within the editor viewport.
    ## UPROPERTY()

  var bEditable: bool
    ## Whether the actor can be manipulated by editor operations.
    ## UPROPERTY()

  var bListedInSceneOutliner: bool
    ## Whether this actor should be listed in the scene outliner.
    ## UPROPERTY()

  var bHiddenEdLayer: bool
    ## Whether this actor is hidden by the layer browser.
    ## UPROPERTY()

  var bHiddenEdLevel: bool
    ## Whether this actor is hidden by the level browser.
    ## UPROPERTY(transient)

  var bLockLocation: bool
    ## If true, prevents the actor from being moved in the editor viewport.
    ## UPROPERTY()

  var groupActor: ptr AActor
    ## The group this actor is a part of.
    ## UPROPERTY(transient)

  var spriteScale: cfloat
    ## The scale to apply to any billboard components in editor builds (happens in any WITH_EDITOR build, including non-cooked games).
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Rendering, meta=(DisplayName="Editor Billboard Scale"))

  proc getNumUncachedLights(): int32
    ## Returns how many lights are uncached for this actor.
  #endif

  var ParentComponentActor: TWeakObjectPtr[AActor]
    ## The Actor that owns the UChildActorComponent that owns this Actor.
    ## UPROPERTY()

  var bActorSeamlessTraveled: bool
    ## Indicates the actor was pulled through a seamless travel.
    ## UPROPERTY()

  var bIgnoresOriginShifting: bool
    ## Whether this actor should no be affected by world origin shifting.
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, Category=Actor)

  var bEnableAutoLODGeneration: bool
    ## If true, and if World setting has bEnableHigerarhicalLOD is true, then it will generate LODActor from groups of clustered Actor
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, Category=Actor)

  var tags: TArray[FName]
    ## Array of tags that can be used for grouping and categorizing.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, AdvancedDisplay, Category=Actor)

  var hiddenEditorViews: uint64
    ## Bitflag to represent which views this actor is hidden in, via per-view layer visibility.
    ## UPROPERTY(transient)

  #==============================================================================================
  # Delegates
  #==============================================================================================

  var onTakeAnyDamage: FTakeAnyDamageSignature
    ## Called when the actor is damaged in any way.
    ## UPROPERTY(BlueprintAssignable, Category="Game|Damage")

  var onTakePointDamage: FTakePointDamageSignature
    ## Called when the actor is damaged by point damage.
    ## UPROPERTY(BlueprintAssignable, Category="Game|Damage")

  var onActorBeginOverlap: FActorBeginOverlapSignature
    ##  Called when another actor begins to overlap this actor, for example a player walking into a trigger.
    ##  For events when objects have a blocking collision, for example a player hitting a wall, see 'Hit' events.
    ##  @note Components on both this and the other Actor must have bGenerateOverlapEvents set to true to generate overlap events.
    ##
    ## UPROPERTY(BlueprintAssignable, Category="Collision")

  var onActorEndOverlap: FActorEndOverlapSignature
    ## Called when another actor stops overlapping this actor.
    ## @note Components on both this and the other Actor must have bGenerateOverlapEvents set to true to generate overlap events.
    ##
    ## UPROPERTY(BlueprintAssignable, Category="Collision")

  var onBeginCursorOver: FActorBeginCursorOverSignature
    ## Called when the mouse cursor is moved over this actor if mouse over events are enabled in the player controller.
    ## UPROPERTY(BlueprintAssignable, Category="Input|Mouse Input")

  var onEndCursorOver: FActorEndCursorOverSignature
    ## Called when the mouse cursor is moved off this actor if mouse over events are enabled in the player controller.
    ## UPROPERTY(BlueprintAssignable, Category="Input|Mouse Input")

  var onClicked: FActorOnClickedSignature
    ## Called when the left mouse button is clicked while the mouse is over this actor and click events are enabled in the player controller.
    ## UPROPERTY(BlueprintAssignable, Category="Input|Mouse Input")

  var onReleased: FActorOnReleasedSignature
    ## Called when the left mouse button is released while the mouse is over this actor and click events are enabled in the player controller.
    ## UPROPERTY(BlueprintAssignable, Category="Input|Mouse Input")

  var onInputTouchBegin: FActorOnInputTouchBeginSignature
    ## Called when a touch input is received over this actor when touch events are enabled in the player controller.
    ## UPROPERTY(BlueprintAssignable, Category="Input|Touch Input")

  var onInputTouchEnd: FActorOnInputTouchEndSignature
    ## Called when a touch input is received over this component when touch events are enabled in the player controller.
    ## UPROPERTY(BlueprintAssignable, Category="Input|Touch Input")

  var onInputTouchEnter: FActorBeginTouchOverSignature
    ## Called when a finger is moved over this actor when touch over events are enabled in the player controller.
    ## UPROPERTY(BlueprintAssignable, Category="Input|Touch Input")

  var onInputTouchLeave: FActorEndTouchOverSignature
    ## Called when a finger is moved off this actor when touch over events are enabled in the player controller.
    ## UPROPERTY(BlueprintAssignable, Category="Input|Touch Input")

  var onActorHit: FActorHitSignature
    ##  Called when this Actor hits (or is hit by) something solid. This could happen due to things like Character movement, using Set Location with 'sweep' enabled, or physics simulation.
    ##  For events when objects overlap (e.g. walking into a trigger) see the 'Overlap' event.
    ##  @note For collisions during physics simulation to generate hit events, 'Simulation Generates Hit Events' must be enabled.
    ##
    ## UPROPERTY(BlueprintAssignable, Category="Collision")

  method enableInput(playerController: ptr APlayerController)
    ## Pushes this actor on to the stack of input being handled by a PlayerController.
    ## @param PlayerController The PlayerController whose input events we want to receive.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Input")

  method disableInput(playerController: ptr APlayerController)
    ## Removes this actor from the stack of input being handled by a PlayerController.
    ## @param PlayerController The PlayerController whose input events we no longer want to receive. If null, this actor will stop receiving input from all PlayerControllers.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Input")

  proc getInputAxisValue(inputAxisName: FName): cfloat {.noSideEffect.}
    ## Gets the value of the input axis if input is enabled for this actor.
    ## UFUNCTION(BlueprintCallable, meta=(BlueprintInternalUseOnly="true", HideSelfPin="true", HidePin="InputAxisName"))

  proc getInputAxisKeyValue(inputAxisKey: FKey): cfloat {.noSideEffect.}
    ## Gets the value of the input axis key if input is enabled for this actor.
    ## UFUNCTION(BlueprintCallable, meta=(BlueprintInternalUseOnly="true", HideSelfPin="true", HidePin="InputAxisKey"))

  proc getInputVectorAxisValue(inputAxisKey: FKey): FVector {.noSideEffect.}
    ## Gets the value of the input axis key if input is enabled for this actor.
    ## UFUNCTION(BlueprintCallable, meta=(BlueprintInternalUseOnly="true", HideSelfPin="true", HidePin="InputAxisKey"))

  proc getInstigator(): ptr APawn {.noSideEffect.}

  proc getInstigator[T](): ptr T {.noSideEffect.}
    ## Get the instigator, cast as a specific class.
    ## @return The instigator for this weapon if it is the specified type, NULL otherwise.

  proc getInstigatorController(): ptr AController {.noSideEffect.}
    ## Returns the instigator's controller for this actor, or NULL if there is none.
    ## UFUNCTION(BlueprintCallable, meta=(BlueprintProtected = "true"), Category="Game")

  ##=============================================================================
  ## General functions.

  proc getTransform(): FTransform {.noSideEffect.}
    ## Get the actor-to-world transform.
    ## @return The transform that transforms from actor space to world space.
    ##
    ## UFUNCTION(BlueprintCallable, meta=(DisplayName = "GetActorTransform"), Category="Utilities|Transformation")

  proc K2_GetActorLocation(): FVector {.noSideEffect.}
    ## Returns the location of the RootComponent of this Actor
    ## UFUNCTION(BlueprintCallable, meta=(DisplayName = "GetActorLocation", Keywords="position"), Category="Utilities|Transformation")

  proc K2_SetActorLocation(NewLocation: FVector; bSweep: bool;
                           SweepHitResult: var FHitResult; bTeleport: bool): bool
    ## Move the Actor to the specified location.
    ## @param NewLocation The new location to move the Actor to.
    ## @param bSweep    Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ##            Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport   Whether we teleport the physics state (if physics collision is enabled for this object).
    ##            If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ##            If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##            If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ## @param SweepHitResult  The hit result from the move if swept.
    ## @return  Whether the location was successfully set (if not swept), or whether movement occurred at all (if swept).
    ##
    ## UFUNCTION(BlueprintCallable, meta=(DisplayName = "SetActorLocation", Keywords="position"), Category="Utilities|Transformation")

  proc K2_GetActorRotation(): FRotator {.noSideEffect.}
    ## Returns rotation of the RootComponent of this Actor.
    ## UFUNCTION(BlueprintCallable, meta=(DisplayName = "GetActorRotation"), Category="Utilities|Transformation")

  proc getActorForwardVector(): FVector {.noSideEffect.}
    ## Get the forward (X) vector (length 1.0) from this Actor, in world space.
    ## UFUNCTION(BlueprintCallable, Category = "Utilities|Transformation")

  proc getActorUpVector(): FVector {.noSideEffect.}
    ## Get the up (Z) vector (length 1.0) from this Actor, in world space.
    ## UFUNCTION(BlueprintCallable, Category = "Utilities|Transformation")

  proc getActorRightVector(): FVector {.noSideEffect.}
    ## Get the right (Y) vector (length 1.0) from this Actor, in world space.
    ## UFUNCTION(BlueprintCallable, Category = "Utilities|Transformation")

  proc getActorBounds(bOnlyCollidingComponents: bool; origin: var FVector;
                      boxExtent: var FVector) {.noSideEffect.}
    ## Returns the bounding box of all components that make up this Actor.
    ## @param bOnlyCollidingComponents  If true, will only return the bounding box for components with collision enabled.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Collision", meta=(DisplayName = "GetActorBounds"))

  proc K2_GetRootComponent(): ptr USceneComponent {.noSideEffect.}
    ## Returns the RootComponent of this Actor
    ## UFUNCTION(BlueprintCallable, meta=(DisplayName = "GetRootComponent"), Category="Utilities|Transformation")

  method getVelocity(): FVector {.noSideEffect.}
    ## Returns velocity (in cm/s (Unreal Units/second) of the rootcomponent if it is either using physics or has an associated MovementComponent
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  proc setActorLocation(newLocation: FVector; bSweep: bool = false;
                        outSweepHitResult: ptr FHitResult = nil;
                        teleport: ETeleportType = ETeleportType.None): bool {.discardable.}
    ## Move the actor instantly to the specified location.
    ##
    ## @param NewLocation The new location to teleport the Actor to.
    ## @param bSweep    Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ##            Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport   Whether we teleport the physics state (if physics collision is enabled for this object).
    ##            If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ##            If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##            If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ## @param OutSweepHitResult The hit result from the move if swept.
    ## @return  Whether the location was successfully set if not swept, or whether movement occurred if swept.

  proc setActorRotation(newRotation: FRotator): bool {.discardable.}
    ## Set the Actor's rotation instantly to the specified rotation.
    ##
    ## @param NewRotation The new rotation for the Actor.
    ## @return  Whether the rotation was successfully set.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  proc setActorRotation(newRotation: FQuat): bool {.discardable.}

  proc K2_SetActorLocationAndRotation(newLocation: FVector; newRotation: FRotator;
                                      bSweep: bool; sweepHitResult: var FHitResult;
                                      bTeleport: bool): bool
    ## Move the actor instantly to the specified location and rotation.
    ##
    ## @param NewLocation   The new location to teleport the Actor to.
    ## @param NewRotation   The new rotation for the Actor.
    ## @param bSweep      Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ##              Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport     Whether we teleport the physics state (if physics collision is enabled for this object).
    ##              If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ##              If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##              If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ## @param SweepHitResult  The hit result from the move if swept.
    ## @return  Whether the rotation was successfully set.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="SetActorLocationAndRotation"))

  proc setActorLocationAndRotation(newLocation: FVector; newRotation: FRotator;
                                   bSweep: bool = false;
                                   outSweepHitResult: ptr FHitResult = nil;
                                   teleport: ETeleportType = ETeleportType.None): bool
    ## Move the actor instantly to the specified location and rotation.
    ##
    ## @param NewLocation   The new location to teleport the Actor to.
    ## @param NewRotation   The new rotation for the Actor.
    ## @param bSweep      Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ##              Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport     Whether we teleport the physics state (if physics collision is enabled for this object).
    ##              If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ##              If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##              If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ## @param OutSweepHitResult The hit result from the move if swept.
    ## @return  Whether the rotation was successfully set.

  proc setActorLocationAndRotation(newLocation: FVector; newRotation: FQuat;
                                   bSweep: bool = false;
                                   outSweepHitResult: ptr FHitResult = nil;
                                   teleport: ETeleportType = ETeleportType.None): bool

  proc setActorScale3D(newScale3D: FVector)
    ## Set the Actor's world-space scale.
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  proc getActorScale3D(): FVector {.noSideEffect.}
    ## Returns the Actor's world-space scale.
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Orientation")

  proc getDistanceTo(otherActor: ptr AActor): cfloat {.noSideEffect.}
    ## Returns the distance from this Actor to OtherActor.
    ## UFUNCTION(BlueprintCallable, Category = "Utilities|Transformation")

  proc getHorizontalDistanceTo(otherActor: ptr AActor): cfloat {.noSideEffect.}
    ## Returns the distance from this Actor to OtherActor, ignoring Z.
    ## UFUNCTION(BlueprintCallable, Category = "Utilities|Transformation")

  proc getVerticalDistanceTo(OtherActor: ptr AActor): cfloat {.noSideEffect.}
    ## Returns the distance from this Actor to OtherActor, ignoring XY.
    ## UFUNCTION(BlueprintCallable, Category = "Utilities|Transformation")

  proc getDotProductTo(OtherActor: ptr AActor): cfloat {.noSideEffect.}
    ## Returns the dot product from this Actor to OtherActor. Returns -2.0 on failure. Returns 0.0 for coincidental actors.
    ## UFUNCTION(BlueprintCallable, Category = "Utilities|Transformation")

  proc getHorizontalDotProductTo(OtherActor: ptr AActor): cfloat {.noSideEffect.}
    ## Returns the dot product from this Actor to OtherActor, ignoring Z. Returns -2.0 on failure. Returns 0.0 for coincidental actors.
    ## UFUNCTION(BlueprintCallable, Category = "Utilities|Transformation")

  proc K2_AddActorWorldOffset(deltaLocation: FVector; bSweep: bool;
                              sweepHitResult: var FHitResult; bTeleport: bool)
    ## Adds a delta to the location of this actor in world space.
    ##
    ## @param DeltaLocation   The change in location.
    ## @param bSweep      Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ##              Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport     Whether we teleport the physics state (if physics collision is enabled for this object).
    ##              If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ##              If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##              If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ## @param SweepHitResult  The hit result from the move if swept.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="AddActorWorldOffset", Keywords="location position"))

  proc addActorWorldOffset(deltaLocation: FVector; bSweep: bool = false;
                           outSweepHitResult: ptr FHitResult = nil;
                           teleport: ETeleportType = ETeleportType.None)
    ## Adds a delta to the location of this actor in world space.
    ##
    ## @param DeltaLocation   The change in location.
    ## @param bSweep      Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ##              Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param Teleport      Whether we teleport the physics state (if physics collision is enabled for this object).
    ##              If TeleportPhysics, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ##              If None, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##              If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ## @param SweepHitResult  The hit result from the move if swept.


  proc K2_AddActorWorldRotation(deltaRotation: FRotator; bSweep: bool;
                                sweepHitResult: var FHitResult; bTeleport: bool)
  proc addActorWorldRotation(deltaRotation: FRotator; bSweep: bool = false;
                             outSweepHitResult: ptr FHitResult = nil;
                             teleport: ETeleportType = ETeleportType.None)
    ## Adds a delta to the rotation of this actor in world space.
    ##
    ## @param DeltaRotation   The change in rotation.
    ## @param bSweep      Whether to sweep to the target rotation (not currently supported for rotation).
    ## @param bTeleport     Whether we teleport the physics state (if physics collision is enabled for this object).
    ##              If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ##              If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##              If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ## @param SweepHitResult  The hit result from the move if swept.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="AddActorWorldRotation", AdvancedDisplay="bSweep,SweepHitResult,bTeleport"))

  proc addActorWorldRotationd(deltaRotation: FQuat; bSweep: bool = false;
                             outSweepHitResult: ptr FHitResult = nil;
                             teleport: ETeleportType = ETeleportType.None)

  proc K2_AddActorWorldTransform(deltaTransform: FTransform; bSweep: bool;
                                 sweepHitResult: var FHitResult; bTeleport: bool)

  proc addActorWorldTransform(deltaTransform: FTransform; bSweep: bool = false;
                              outSweepHitResult: ptr FHitResult = nil;
                              teleport: ETeleportType = ETeleportType.None)
    ## Adds a delta to the transform of this actor in world space. Scale is unchanged.
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="AddActorWorldTransform"))

  proc K2_SetActorTransform(newTransform: FTransform; bSweep: bool;
                            sweepHitResult: var FHitResult; bTeleport: bool): bool
    ## Set the Actors transform to the specified one.
    ## @param NewTransform    The new transform.
    ## @param bSweep      Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ##              Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport     Whether we teleport the physics state (if physics collision is enabled for this object).
    ##              If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ##              If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##              If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="SetActorTransform"))

  proc setActorTransform(newTransform: FTransform; bSweep: bool = false;
                         outSweepHitResult: ptr FHitResult = nil;
                         teleport: ETeleportType = ETeleportType.None): bool

  proc K2_AddActorLocalOffset(deltaLocation: FVector; bSweep: bool;
                              sweepHitResult: var FHitResult; bTeleport: bool)
    ## Adds a delta to the location of this component in its local reference frame.
    ## @param DelatLocation   The change in location in local space.
    ## @param bSweep      Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ##              Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport     Whether we teleport the physics state (if physics collision is enabled for this object).
    ##              If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ##              If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##              If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="AddActorLocalOffset", Keywords="location position"))

  proc addActorLocalOffset(deltaLocation: FVector; bSweep: bool = false;
                           outSweepHitResult: ptr FHitResult = nil;
                           teleport: ETeleportType = ETeleportType.None)
    ## Adds a delta to the rotation of this component in its local reference frame
    ## @param DeltaRotation   The change in rotation in local space.
    ## @param bSweep      Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ##              Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport     Whether we teleport the physics state (if physics collision is enabled for this object).
    ##              If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ##              If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##              If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="AddActorLocalRotation", AdvancedDisplay="bSweep,SweepHitResult,bTeleport"))

  proc K2_AddActorLocalRotation(deltaRotation: FRotator; bSweep: bool;
                                sweepHitResult: var FHitResult; bTeleport: bool)
  proc addActorLocalRotation(deltaRotation: FRotator; bSweep: bool = false;
                             outSweepHitResult: ptr FHitResult = nil;
                             teleport: ETeleportType = ETeleportType.None)
  proc addActorLocalRotation(deltaRotation: FQuat; bSweep: bool = false;
                             outSweepHitResult: ptr FHitResult = nil;
                             teleport: ETeleportType = ETeleportType.None)

  proc K2_AddActorLocalTransform(newTransform: FTransform; bSweep: bool;
                                 sweepHitResult: var FHitResult; bTeleport: bool)
  proc addActorLocalTransform(newTransform: FTransform; bSweep: bool = false;
                              outSweepHitResult: ptr FHitResult = nil;
                              teleport: ETeleportType = ETeleportType.None)
    ## Adds a delta to the transform of this component in its local reference frame
    ## @param NewTransform    The change in transform in local space.
    ## @param bSweep      Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ##              Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport     Whether we teleport the physics state (if physics collision is enabled for this object).
    ##              If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ##              If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##              If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="AddActorLocalTransform"))

  proc K2_SetActorRelativeLocation(newRelativeLocation: FVector; bSweep: bool;
                                   sweepHitResult: var FHitResult; bTeleport: bool)
    ## Set the actor's RootComponent to the specified relative location.
    ## @param NewRelativeLocation New relative location of the actor's root component
    ## @param bSweep        Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ##                Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport       Whether we teleport the physics state (if physics collision is enabled for this object).
    ##                If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ##                If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##                If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="SetActorRelativeLocation"))
  proc setActorRelativeLocation(newRelativeLocation: FVector; bSweep: bool = false;
                                outSweepHitResult: ptr FHitResult = nil;
                                teleport: ETeleportType = ETeleportType.None)

  proc K2_SetActorRelativeRotation(NewRelativeRotation: FRotator; bSweep: bool;
                                   SweepHitResult: var FHitResult; bTeleport: bool)
  proc setActorRelativeRotation(newRelativeRotation: FRotator; bSweep: bool = false;
                                outSweepHitResult: ptr FHitResult = nil;
                                teleport: ETeleportType = ETeleportType.None)
    ## Set the actor's RootComponent to the specified relative rotation
    ## @param NewRelativeRotation New relative rotation of the actor's root component
    ## @param bSweep        Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ##                Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport       Whether we teleport the physics state (if physics collision is enabled for this object).
    ##                If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ##                If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##                If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="SetActorRelativeRotation", AdvancedDisplay="bSweep,SweepHitResult,bTeleport"))
  proc setActorRelativeRotation(newRelativeRotation: FQuat; bSweep: bool = false;
                                outSweepHitResult: ptr FHitResult = nil;
                                teleport: ETeleportType = ETeleportType.None)

  proc K2_SetActorRelativeTransform(newRelativeTransform: FTransform; bSweep: bool;
                                    sweepHitResult: var FHitResult; bTeleport: bool)
  proc setActorRelativeTransform(newRelativeTransform: FTransform;
                                 bSweep: bool = false;
                                 outSweepHitResult: ptr FHitResult = nil;
                                 teleport: ETeleportType = ETeleportType.None)
    ## Set the actor's RootComponent to the specified relative transform
    ## @param NewRelativeTransform    New relative transform of the actor's root component
    ## @param bSweep      Whether we sweep to the destination location, triggering overlaps along the way and stopping short of the target if blocked by something.
    ##              Only the root component is swept and checked for blocking collision, child components move without sweeping. If collision is off, this has no effect.
    ## @param bTeleport     Whether we teleport the physics state (if physics collision is enabled for this object).
    ##              If true, physics velocity for this object is unchanged (so ragdoll parts are not affected by change in location).
    ##              If false, physics velocity is updated based on the change in position (affecting ragdoll parts).
    ##              If CCD is on and not teleporting, this will affect objects along the entire swept volume.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation", meta=(DisplayName="SetActorRelativeTransform"))

  proc setActorRelativeScale3D(newRelativeScale: FVector)
    ## Set the actor's RootComponent to the specified relative scale 3d
    ## @param NewRelativeScale  New scale to set the actor's RootComponent to
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Transformation")

  proc getActorRelativeScale3D(): FVector {.noSideEffect.}
    ## Return the actor's relative scale 3d
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Orientation")

  method setActorHiddenInGame(bNewHidden: bool)
    ## Sets the actor to be hidden in the game
    ## @param  bNewHidden  Whether or not to hide the actor and all its components
    ##
    ## UFUNCTION(BlueprintCallable, Category="Rendering", meta=( DisplayName = "Set Actor Hidden In Game", Keywords = "Visible Hidden Show Hide" ))

  proc setActorEnableCollision(bNewActorEnableCollision: bool)
    ## Allows enabling/disabling collision for the whole actor
    ## UFUNCTION(BlueprintCallable, Category="Collision")

  proc getActorEnableCollision(): bool {.noSideEffect.}
    ## Get current state of collision for the whole actor
    ## UFUNCTION(BlueprintPure, Category="Collision")

  method K2_DestroyActor()
    ## Destroy the actor
    ## UFUNCTION(BlueprintCallable, Category="Utilities", meta=(Keywords = "Delete", DisplayName = "DestroyActor"))

  proc hasAuthority(): bool {.noSideEffect.}
    ## Returns whether this actor has network authority
    ## UFUNCTION(BlueprintCallable, Category="Networking")

  proc addComponent(templateName: FName; bManualAttachment: bool;
                    relativeTransform: FTransform;
                    componentTemplateContext: ptr UObject): ptr UActorComponent
    ## Creates a new component and assigns ownership to the Actor this is
    ## called for. Automatic attachment causes the first component created to
    ## become the root, and all subsequent components to be attached under that
    ## root. When bManualAttachment is set, automatic attachment is
    ## skipped and it is up to the user to attach the resulting component (or
    ## set it up as the root) themselves.
    ##
    ## @see UK2Node_AddComponent  DO NOT CALL MANUALLY - BLUEPRINT INTERNAL USE ONLY (for Add Component nodes)
    ##
    ## @param TemplateName          The name of the Component Template to use.
    ## @param bManualAttachment       Whether manual or automatic attachment is to be used
    ## @param RelativeTransform       The relative transform between the new component and its attach parent (automatic only)
    ## @param ComponentTemplateContext    Optional UBlueprintGeneratedClass reference to use to find the template in. If null (or not a BPGC), component is sought in this Actor's class
    ##
    ## UFUNCTION(BlueprintCallable, meta=(BlueprintInternalUseOnly = "true", DefaultToSelf="ComponentTemplateContext", InternalUseParam="ComponentTemplateContext"))

  proc attachRootComponentTo(inParent: ptr USceneComponent;
                             inSocketName: FName = NAME_None;
                             attachLocationType: EAttachLocation = EAttachLocation.KeepRelativeOffset;
                             bWeldSimulatedBodies: bool = false)
    ## Attaches the RootComponent of this Actor to the supplied component, optionally at a named socket. It is not valid to call this on components that are not Registered.
    ## @param AttachLocationType Type of attachment, AbsoluteWorld to keep its world position, RelativeOffset to keep the object's relative offset and SnapTo to snap to the new parent.
    ##
    ## UFUNCTION(BlueprintCallable, meta = (DisplayName = "AttachActorToComponent", AttachLocationType = "KeepRelativeOffset"), Category = "Utilities|Transformation")

  proc K2_AttachRootComponentTo(inParent: ptr USceneComponent;
                                inSocketName: FName = NAME_None;
                                attachLocationType: EAttachLocation = EAttachLocation.KeepRelativeOffset;
                                bWeldSimulatedBodies: bool = true)
    ## Attaches the RootComponent of this Actor to the RootComponent of the supplied actor, optionally at a named socket.
    ## @param InParentActor       Actor to attach this actor's RootComponent to
    ## @param InSocketName        Socket name to attach to, if any
    ## @param AttachLocationType  Type of attachment, AbsoluteWorld to keep its world position, RelativeOffset to keep the object's relative offset and SnapTo to snap to the new parent.

  proc attachRootComponentToActor(inParentActor: ptr AActor;
                                  inSocketName: FName = NAME_None;
                                  AttachLocationType: EAttachLocation = EAttachLocation.KeepRelativeOffset;
                                  bWeldSimulatedBodies: bool = false)
    ## Attaches the RootComponent of this Actor to the supplied component, optionally at a named socket. It is not valid to call this on components that are not Registered.
    ## @param AttachLocationType Type of attachment, AbsoluteWorld to keep its world position, RelativeOffset to keep the object's relative offset and SnapTo to snap to the new parent.
    ##
    ## UFUNCTION(BlueprintCallable, meta = (DisplayName = "AttachActorToActor", AttachLocationType = "KeepRelativeOffset"), Category = "Utilities|Transformation")

  proc K2_AttachRootComponentToActor(inParentActor: ptr AActor;
                                     InSocketName: FName = NAME_None;
      AttachLocationType: EAttachLocation = EAttachLocation.KeepRelativeOffset; bWeldSimulatedBodies: bool = true)

  proc detachRootComponentFromParent(bMaintainWorldPosition: bool = true)
    ## Detaches the RootComponent of this Actor from any SceneComponent it is currently attached to.
    ## @param bMaintainWorldTransform If true, update the relative location/rotation of this component to keep its world position the same
    ##
    ## UFUNCTION(BlueprintCallable, meta=(DisplayName = "DetachActorFromActor"), Category="Utilities|Transformation")

  proc DetachSceneComponentsFromParent(InParentComponent: ptr USceneComponent;
                                       bMaintainWorldPosition: bool = true)
    ##  Detaches all SceneComponents in this Actor from the supplied parent SceneComponent.
    ##  @param InParentComponent    SceneComponent to detach this actor's components from
    ##  @param bMaintainWorldTransform  If true, update the relative location/rotation of this component to keep its world position the same

  #==============================================================================
  # Tags

  proc actorHasTag(tag: FName): bool {.noSideEffect.}
    ## See if this actor contains the supplied tag
    ## UFUNCTION(BlueprintCallable, Category="Utilities")

  ##==============================================================================
  ## Misc Blueprint support

  proc getActorTimeDilation(): cfloat {.noSideEffect.}
    ## Get CustomTimeDilation - this can be used for input control or speed control for slomo.
    ## We don't want to scale input globally because input can be used for UI, which do not care for TimeDilation.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities|Time")

  method addTickPrerequisiteActor(prerequisiteActor: ptr AActor)
    ## Make this actor tick after PrerequisiteActor. This only applies to this actor's tick function; dependencies for owned components must be set up separately if desired.
    ## UFUNCTION(BlueprintCallable, Category="Utilities", meta=(Keywords = "dependency"))

  method addTickPrerequisiteComponent(prerequisiteComponent: ptr UActorComponent)
    ## Make this actor tick after PrerequisiteComponent. This only applies to this actor's tick function; dependencies for owned components must be set up separately if desired.
    ## UFUNCTION(BlueprintCallable, Category="Utilities", meta=(Keywords = "dependency"))

  method removeTickPrerequisiteActor(prerequisiteActor: ptr AActor)
    ## Remove tick dependency on PrerequisiteActor.
    ## UFUNCTION(BlueprintCallable, Category="Utilities", meta=(Keywords = "dependency"))

  method removeTickPrerequisiteComponent(PrerequisiteComponent: ptr UActorComponent)
    ## Remove tick dependency on PrerequisiteComponent.
    ## UFUNCTION(BlueprintCallable, Category="Utilities", meta=(Keywords = "dependency"))

  proc getTickableWhenPaused(): bool
    ## Gets whether this actor can tick when paused.
    ## UFUNCTION(BlueprintCallable, Category="Utilities")

  proc setTickableWhenPaused(bTickableWhenPaused: bool)
    ## Sets whether this actor can tick when paused.
    ## UFUNCTION(BlueprintCallable, Category="Utilities")

  #=============================================================================
  # AI functions.

  proc makeNoise(loudness: cfloat = 1.0; noiseInstigator: ptr APawn = nil;
                 noiseLocation: FVector = zeroVector; maxRange: cfloat = 0.0;
                 tag: FName = NAME_None)
    ## Trigger a noise caused by a given Pawn, at a given location.
    ## Note that the NoiseInstigator Pawn MUST have a PawnNoiseEmitterComponent for the noise to be detected by a PawnSensingComponent.
    ## Senders of MakeNoise should have an Instigator if they are not pawns, or pass a NoiseInstigator.
    ##
    ## @param Loudness The relative loudness of this noise. Usual range is 0 (no noise) to 1 (full volume). If MaxRange is used, this scales the max range, otherwise it affects the hearing range specified by the sensor.
    ## @param NoiseInstigator Pawn responsible for this noise.  Uses the actor's Instigator if NoiseInstigator=NULL
    ## @param NoiseLocation Position of noise source.  If zero vector, use the actor's location.
    ## @param MaxRange Max range at which the sound may be heard. A value of 0 indicates no max range (though perception may have its own range). Loudness scales the range. (Note: not supported for legacy PawnSensingComponent, only for AIPerception)
    ## @param Tag Identifier for the noise.
    ##
    ## UFUNCTION(BlueprintCallable, BlueprintAuthorityOnly, Category="AI", meta=(BlueprintProtected = "true"))

  ##=============================================================================
  ## Blueprint

  proc receiveBeginPlay()
    ## Event when play begins for this actor.

  method beginPlay()
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "BeginPlay"))
    ## Event when play begins for this actor.

  proc isActorInitialized(): bool {.noSideEffect.}
    ## Returns whether an actor has been initialized

  proc hasActorBegunPlay(): bool {.noSideEffect.}
    ## Returns whether an actor has had BeginPlay called on it (and not subsequently had EndPlay called)

  proc isActorBeingDestroyed(): bool {.noSideEffect.}
    ## UFUNCTION(BlueprintCallable, Category="Game")

  proc receiveAnyDamage(damage: cfloat; damageType: ptr UDamageType;
                        instigatedBy: ptr AController; damageCauser: ptr AActor)
    ## Event when this actor takes ANY damage
    ## UFUNCTION(BlueprintImplementableEvent, BlueprintAuthorityOnly, meta=(DisplayName = "AnyDamage"), Category="Game|Damage")

  proc receiveRadialDamage(damageReceived: cfloat; damageType: ptr UDamageType;
                           origin: FVector; HitInfo: FHitResult;
                           instigatedBy: ptr AController; damageCauser: ptr AActor)
    ## Event when this actor takes RADIAL damage
    ## @todo Pass it the full array of hits instead of just one?
    ##
    ## UFUNCTION(BlueprintImplementableEvent, BlueprintAuthorityOnly, meta=(DisplayName = "RadialDamage"), Category="Game|Damage")

  proc receivePointDamage(damage: cfloat; damageType: ptr UDamageType;
                          hitLocation: FVector; hitNormal: FVector;
                          hitComponent: ptr UPrimitiveComponent; boneName: FName;
                          shotFromDirection: FVector; instigatedBy: ptr AController;
                          damageCauser: ptr AActor)
    ## Event when this actor takes POINT damage
    ## UFUNCTION(BlueprintImplementableEvent, BlueprintAuthorityOnly, meta=(DisplayName = "PointDamage"), Category="Game|Damage")

  proc receiveTick(deltaSeconds: cfloat)
    ## Event called every frame
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "Tick"))

  method notifyActorBeginOverlap(otherActor: ptr AActor)
    ## Event when this actor overlaps another actor, for example a player walking into a trigger.
    ## For events when objects have a blocking collision, for example a player hitting a wall, see 'Hit' events.
    ## @note Components on both this and the other Actor must have bGenerateOverlapEvents set to true to generate overlap events.

  proc receiveActorBeginOverlap(otherActor: ptr AActor)
    ## Event when this actor overlaps another actor, for example a player walking into a trigger.
    ## For events when objects have a blocking collision, for example a player hitting a wall, see 'Hit' events.
    ## @note Components on both this and the other Actor must have bGenerateOverlapEvents set to true to generate overlap events.
    ##
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "ActorBeginOverlap"), Category="Collision")

  method notifyActorEndOverlap(OtherActor: ptr AActor)
    ##  Event when an actor no longer overlaps another actor, and they have separated.
    ##  @note Components on both this and the other Actor must have bGenerateOverlapEvents set to true to generate overlap events.

  proc receiveActorEndOverlap(OtherActor: ptr AActor)
    ##  Event when an actor no longer overlaps another actor, and they have separated.
    ##  @note Components on both this and the other Actor must have bGenerateOverlapEvents set to true to generate overlap events.
    ##
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "ActorEndOverlap"), Category="Collision")

  method notifyActorBeginCursorOver()
    ## Event when this actor has the mouse moved over it with the clickable interface.

  proc receiveActorBeginCursorOver()
    ## Event when this actor has the mouse moved over it with the clickable interface.
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "ActorBeginCursorOver"), Category="Mouse Input")

  method notifyActorEndCursorOver()
    ## Event when this actor has the mouse moved off of it with the clickable interface.

  proc receiveActorEndCursorOver()
    ## Event when this actor has the mouse moved off of it with the clickable interface.
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "ActorEndCursorOver"), Category="Mouse Input")

  method notifyActorOnClicked()
    ## Event when this actor is clicked by the mouse when using the clickable interface.

  proc receiveActorOnClicked()
    ## Event when this actor is clicked by the mouse when using the clickable interface.
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "ActorOnClicked"), Category="Mouse Input")

  method notifyActorOnReleased()
    ## Event when this actor is under the mouse when left mouse button is released while using the clickable interface.

  proc receiveActorOnReleased()
    ## Event when this actor is under the mouse when left mouse button is released while using the clickable interface.
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "ActorOnReleased"), Category="Mouse Input")

  method notifyActorOnInputTouchBegin(fingerIndex: ETouchIndex)
    ## Event when this actor is touched when click events are enabled.

  proc receiveActorOnInputTouchBegin(fingerIndex: ETouchIndex)
    ## Event when this actor is touched when click events are enabled.
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "BeginInputTouch"), Category="Touch Input")

  method notifyActorOnInputTouchEnd(fingerIndex: ETouchIndex)
    ## Event when this actor is under the finger when untouched when click events are enabled.

  proc receiveActorOnInputTouchEnd(fingerIndex: ETouchIndex)
    ## Event when this actor is under the finger when untouched when click events are enabled.
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "EndInputTouch"), Category="Touch Input")

  method notifyActorOnInputTouchEnter(fingerIndex: ETouchIndex)
    ## Event when this actor has a finger moved over it with the clickable interface.

  proc receiveActorOnInputTouchEnter(fingerIndex: ETouchIndex)
    ## Event when this actor has a finger moved over it with the clickable interface.
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "TouchEnter"), Category="Touch Input")

  method notifyActorOnInputTouchLeave(fingerIndex: ETouchIndex)
    ## Event when this actor has a finger moved off of it with the clickable interface.

  proc receiveActorOnInputTouchLeave(fingerIndex: ETouchIndex)
    ## Event when this actor has a finger moved off of it with the clickable interface.
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "TouchLeave"), Category="Touch Input")

  proc getOverlappingActors(overlappingActors: var TArray[ptr AActor];
                            classFilter: ptr UClass = nil) {.noSideEffect.}
    ## Returns list of actors this actor is overlapping (any component overlapping any component). Does not return itself.
    ## @param OverlappingActors   [out] Returned list of overlapping actors
    ## @param ClassFilter     [optional] If set, only returns actors of this class or subclasses
    ##
    ## UFUNCTION(BlueprintCallable, Category="Collision", meta=(UnsafeDuringActorConstruction="true"))

  proc getOverlappingComponents(overlappingComponents: var TArray[ptr UPrimitiveComponent]) {.noSideEffect.}
    ## Returns list of components this actor is overlapping.
    ## UFUNCTION(BlueprintCallable, Category="Collision", meta=(UnsafeDuringActorConstruction="true"))

  method notifyHit(myComp: ptr UPrimitiveComponent; other: ptr AActor;
                 otherComp: ptr UPrimitiveComponent; bSelfMoved: bool;
                 hitLocation: FVector; hitNormal: FVector; normalImpulse: FVector;
                 hit: FHitResult)
    ## Event when this actor bumps into a blocking object, or blocks another actor that bumps into it.
    ## This could happen due to things like Character movement, using Set Location with 'sweep' enabled, or physics simulation.
    ## For events when objects overlap (e.g. walking into a trigger) see the 'Overlap' event.
    ##
    ## @note For collisions during physics simulation to generate hit events, 'Simulation Generates Hit Events' must be enabled.
    ## @note When receiving a hit from another object's movement (bSelfMoved is false), the directions of 'Hit.Normal' and 'Hit.ImpactNormal'
    ## will be adjusted to indicate force from the other object against this object.

  proc receiveHit(myComp: ptr UPrimitiveComponent; other: ptr AActor;
                  otherComp: ptr UPrimitiveComponent; bSelfMoved: bool;
                  hitLocation: FVector; hitNormal: FVector; normalImpulse: FVector;
                  hit: FHitResult)
    ## Event when this actor bumps into a blocking object, or blocks another actor that bumps into it.
    ## This could happen due to things like Character movement, using Set Location with 'sweep' enabled, or physics simulation.
    ## For events when objects overlap (e.g. walking into a trigger) see the 'Overlap' event.
    ##
    ## @note For collisions during physics simulation to generate hit events, 'Simulation Generates Hit Events' must be enabled.
    ## @note When receiving a hit from another object's movement (bSelfMoved is false), the directions of 'Hit.Normal' and 'Hit.ImpactNormal'
    ## will be adjusted to indicate force from the other object against this object.
    ##
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "Hit"), Category="Collision")

  method setLifeSpan(inLifespan: cfloat)
    ## Set the lifespan of this actor. When it expires the object will be destroyed. If requested lifespan is 0, the timer is cleared and the actor will not be destroyed.
    ## UFUNCTION(BlueprintCallable, Category="Utilities", meta=(Keywords = "delete destroy"))

  method getLifeSpan(): cfloat {.noSideEffect.}
    ## Get the remaining lifespan of this actor. If zero is returned the actor lives forever.
    ## UFUNCTION(BlueprintCallable, Category="Utilities", meta=(Keywords = "delete destroy"))

  proc userConstructionScript()
    ## Construction script, the place to spawn components and do other setup.
    ## @note Name used in CreateBlueprint function
    ## @param Location  The location.
    ## @param Rotation  The rotation.
    ##
    ## UFUNCTION(BlueprintImplementableEvent, meta=(BlueprintInternalUseOnly = "true", DisplayName = "Construction Script"))

  proc destroy(bNetForce: bool = false; bShouldModifyLevel: bool = true): bool
    ## Destroy this actor. Returns true the actor is destroyed or already marked for destruction, false if indestructible.
    ## Destruction is latent. It occurs at the end of the tick.
    ## @param bNetForce       [opt] Ignored unless called during play.  Default is false.
    ## @param bShouldModifyLevel    [opt] If true, Modify() the level before removing the actor.  Default is true.
    ## returns  true if destroyed or already marked for destruction, false if indestructible.

  proc receiveDestroyed()
    ## UFUNCTION(BlueprintImplementableEvent, meta = (Keywords = "delete", DisplayName = "Destroyed"))

  var onDestroyed: FActorDestroyedSignature
    ## Event triggered when the actor is destroyed.
    ## UPROPERTY(BlueprintAssignable, Category="Game")

  proc receiveEndPlay(endPlayReason: EEndPlayReason)
    ## Event to notify blueprints this actor is about to be deleted.
    ## UFUNCTION(BlueprintImplementableEvent, meta=(Keywords = "delete", DisplayName = "End Play"))

  var onEndPlay: FActorEndPlaySignature
    ## Event triggered when the actor is being removed from a level.
    ## UPROPERTY(BlueprintAssignable, Category="Game")

  method postEditMove(bFinished: bool) # when WITH_EDITOR

  ##-----------------------------------------------------------------------------------------------
  ## PROPERTY REPLICATION

  method gatherCurrentMovement()
    ## Fills ReplicatedMovement property

  proc isOwnedBy(testOwner: ptr AActor): bool {.noSideEffect.}
    ## See if this actor is owned by TestOwner.

  proc getActorLocation(rootComponent: ptr): FVector {.isStatic, noSideEffect.}
    ## Returns location of the RootComponent
    ## this is a template for no other reason than to delay compilation until USceneComponent is defined

  proc getActorRotation(rootComponent: ptr): FRotator {.isStatic, noSideEffect.}
    ## Returns rotation of the RootComponent
    ## this is a template for no other reason than to delay compilation until USceneComponent is defined

  proc getActorScale(rootComponent: ptr): FVector {.isStatic, noSideEffect.}
    ## Returns scale of the RootComponent
    ## this is a template for no other reason than to delay compilation until USceneComponent is defined

  proc getActorQuat(rootComponent: ptr): FQuat {.isStatic, noSideEffect.}
    ## Returns quaternion of the RootComponent
    ## this is a template for no other reason than to delay compilation until USceneComponent is defined

  proc getRootComponent(): ptr USceneComponent {.noSideEffect, noSideEffect.}
    ## Returns this actor's root component.

  proc setRootComponent(newRootComponent: ptr USceneComponent): bool {.discardable.}
    ## Sets root component to be the specified component.  NewRootComponent's owner should be this actor.
    ## @return true if successful

  proc getActorLocation(): FVector {.noSideEffect.}
    ## Returns the location of the RootComponent of this Actor

  proc getActorRotation(): FRotator {.noSideEffect.}
    ## Returns the rotation of the RootComponent of this Actor

  proc getActorScale(): FVector {.noSideEffect.}
    ## Returns the scale of the RootComponent of this Actor

  proc getActorQuat(): FQuat {.noSideEffect.}
    ## Returns the quaternion of the RootComponent of this Actor

  #when WITH_EDITOR:
  proc setPivotOffset(inPivotOffset: FVector)
    ## Sets the local space offset added to the actor's pivot as used by the editor
  proc getPivotOffset(): FVector {.noSideEffect.}
    ## Gets the local space offset added to the actor's pivot as used by the editor

  #-----------------------------------------------------------------------------
  #  Relations.
  #-----------------------------------------------------------------------------

  method applyWorldOffset(InOffset: FVector; bWorldShift: bool)
    ## Called by owning level to shift an actor location and all relevant data structures by specified delta
    ##
    ## @param InWorldOffset  Offset vector to shift actor location
    ## @param bWorldShift  Whether this call is part of whole world shifting

  method isLevelBoundsRelevant(): bool {.noSideEffect.}
    ## Indicates whether this actor should participate in level bounds calculations

  #when WITH_EDITOR:

  var bUsePercentageBasedScaling {.isStatic.}: bool
    ## Editor specific
    ## @todo: Remove this flag once it is decided that additive interactive scaling is what we want

  method editorApplyTranslation(deltaTranslation: FVector; bAltDown: bool;
                              bShiftDown: bool; bCtrlDown: bool)
    ## Called by ApplyDeltaToActor to perform an actor class-specific operation based on widget manipulation.
    ## The default implementation is simply to translate the actor's location.

  method editorApplyRotation(deltaRotation: FRotator; bAltDown: bool;
                           bShiftDown: bool; bCtrlDown: bool)
    ## Called by ApplyDeltaToActor to perform an actor class-specific operation based on widget manipulation.
    ## The default implementation is simply to modify the actor's rotation.

  method editorApplyScale(deltaScale: FVector; pivotLocation: ptr FVector;
                        bAltDown: bool; bShiftDown: bool; bCtrlDown: bool)
    ## Called by ApplyDeltaToActor to perform an actor class-specific operation based on widget manipulation.
    ## The default implementation is simply to modify the actor's draw scale.

  method editorApplyMirror(mirrorScale: FVector; pivotLocation: FVector)
    ## Called by MirrorActors to perform a mirroring operation on the actor

  proc setLODParent(inLODParent: ptr UPrimitiveComponent;
                    inParentDrawDistance: cfloat)
    ## Set LOD Parent Primitive

  proc isHiddenEdAtStartup(): bool {.noSideEffect.}
    ## Simple accessor to check if the actor is hidden upon editor startup
    ## @return  true if the actor is hidden upon editor startup; false if it is not

  proc isHiddenEd(): bool {.noSideEffect.}
    ## Returns true if this actor is hidden in the editor viewports.

  proc setIsTemporarilyHiddenInEditor(bIsHidden: bool)
    ## Sets whether or not this actor is hidden in the editor for the duration of the current editor session
    ##
    ## @param bIsHidden True if the actor is hidden

  method isTemporarilyHiddenInEditor(): bool {.noSideEffect.}
    ## @return Whether or not this actor is hidden in the editor for the duration of the current editor session

  proc isEditable(): bool {.noSideEffect.}
    ## @return Returns true if this actor is allowed to be displayed, selected and manipulated by the editor.

  proc isListedInSceneOutliner(): bool {.noSideEffect.}
    ## @return Returns true if this actor should be shown in the scene outliner

  method editorCanAttachTo(inParent: ptr AActor; outReason: var FText): bool {.noSideEffect.}
    ## @return Returns true if this actor is allowed to be attached to the given actor

  method shouldExport(): bool
    ## Called before editor copy, true allow export

  method shouldImport(actorPropString: ptr FString; isMovingLevel: bool): bool
    ## Called before editor paste, true allow import

  method editorKeyPressed(key: FKey; event: EInputEvent)
    ## Called by InputKey when an unhandled key is pressed with a selected actor

  method editorReplacedActor(oldActor: ptr AActor)
    ## Called by ReplaceSelectedActors to allow a new actor to copy properties from an old actor when it is replaced

  method checkForErrors()
    ## Function that gets called from within Map_Check to allow this actor to check itself
    ## for any potential errors and register them with map check dialog.

  method checkForDeprecated()
    ## Function that gets called from within Map_Check to allow this actor to check itself
    ## for any potential errors and register them with map check dialog.

  proc getActorLabel(): var FString {.noSideEffect.}
    ## Returns this actor's current label.  Actor labels are only available in development builds.
    ## @return  The label text

  proc setActorLabel(NewActorLabel: FString; bMarkDirty: bool = true)
    ## Assigns a new label to this actor.  Actor labels are only available in development builds.
    ## @param NewActorLabel The new label string to assign to the actor.  If empty, the actor will have a default label.
    ## @param bMarkDirty    If true the actor's package will be marked dirty for saving.  Otherwise it will not be.  You should pass false for this parameter if dirtying is not allowed (like during loads)

  proc clearActorLabel()
    ## Advanced - clear the actor label.

  proc isActorLabelEditable(): bool {.noSideEffect.}
    ## Returns if this actor's current label is editable.  Actor labels are only available in development builds.
    ## @return  The editable status of the actor's label

  proc getFolderPath(): var FName {.noSideEffect.}
    ## Returns this actor's folder path. Actor folder paths are only available in development builds.
    ## @return  The folder path

  proc setFolderPath(NewFolderPath: FName)
    ## Assigns a new folder to this actor. Actor folder paths are only available in development builds.
    ## @param NewFolderPath   The new folder to assign to the actor.

  proc setFolderPath_Recursively(NewFolderPath: FName)
    ## Assigns a new folder to this actor and any attached children. Actor folder paths are only available in development builds.
    ## @param NewFolderPath   The new folder to assign to the actors.

  method getReferencedContentObjects(objects: var TArray[ptr UObject]): bool {.noSideEffect.}
    ## Used by the "Sync to Content Browser" right-click menu option in the editor.
    ## @param Objects Array to add content object references to.
    ## @return  Whether the object references content (all overrides of this function should return true)

  proc getNumUncachedStaticLightingInteractions(): int32 {.noSideEffect.}
    ## Returns NumUncachedStaticLightingInteractions for this actor
  # end when WITH_EDITOR

  # AWARE: replication
  # method getNetPriority(viewPos: FVector; viewDir: FVector; viewer: ptr AActor;
  #                       viewTarget: ptr AActor; inChannel: ptr UActorChannel;
  #                       time: cfloat; bLowBandwidth: bool): cfloat
  #   ## @param ViewPos   Position of the viewer
  #   ## @param ViewDir   Vector direction of viewer
  #   ## @param Viewer    "net object" owned by the client for whom net priority is being determined (typically player controller)
  #   ## @param ViewTarget  The actor that is currently being viewed/controlled by Viewer, usually a pawn
  #   ## @param InChannel   Channel on which this actor is being replicated.
  #   ## @param Time      Time since actor was last replicated
  #   ## @param bLowBandwidth True if low bandwidth of viewer
  #   ## @return        Priority of this actor for replication

  # method getNetDormancy(viewPos: FVector; viewDir: FVector; viewer: ptr AActor;
  #                     viewTarget: ptr AActor; inChannel: ptr UActorChannel;
  #                     time: cfloat; bLowBandwidth: bool): bool
  #   ## Returns true if the actor should be dormant for a specific net connection. Only checked for DORM_DormantPartial

  # method onActorChannelOpen(inBunch: var FInBunch; connection: ptr UNetConnection)
  #   ## Allows for a specific response from the actor when the actor channel is opened (client side)
  #   ## @param InBunch Bunch received at time of open
  #   ## @param Connection the connection associated with this actor

  # method onSerializeNewActor(outBunch: var FOutBunch)
  #   ## SerializeNewActor has just been called on the actor before network replication (server side)
  #   ## @param OutBunch Bunch containing serialized contents of actor prior to replication

  # method onNetCleanup(connection: ptr UNetConnection)
  #   ## Handles cleaning up the associated Actor when killing the connection
  #   ## @param Connection the connection associated with this actor

  proc exchangeNetRoles(bRemoteOwner: bool)
    ## Swaps Role and RemoteRole if client

  proc registerAllActorTickFunctions(bRegister: bool; bDoComponents: bool)
    ## When called, will call the virtual call chain to register all of the tick functions for both the actor and optionally all components
    ## Do not override this function or make it virtual
    ## @param bRegister - true to register, false, to unregister
    ## @param bDoComponents - true to also apply the change to all components

  proc setActorTickEnabled(bEnabled: bool)
    ## Set this actor's tick functions to be enabled or disabled. Only has an effect if the function is registered
    ## This only modifies the tick function on actor itself
    ## @param bEnabled - Rather it should be enabled or not
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities")

  proc isActorTickEnabled(): bool {.noSideEffect.}
    ##  Returns whether this actor has tick enabled or not
    ## UFUNCTION(BlueprintCallable, Category="Utilities")

  method tickActor(deltaTime: cfloat; tickType: ELevelTick;
                 thisTickFunction: var FActorTickFunction)
    ## ticks the actor
    ## @param  DeltaTime     The time slice of this tick
    ## @param  TickType      The type of tick that is happening
    ## @param  ThisTickFunction  The tick function that is firing, useful for getting the completion handle

  method postActorCreated()
    ## Called when an actor is done spawning into the world (from UWorld::SpawnActor).
    ## For actors with a root component, the location and rotation will have already been set.
    ## Takes place after any construction scripts have been called

  method lifeSpanExpired()
    ## Called when the lifespan of an actor expires (if he has one).

  method postNetInit()
    ## Always called immediately after spawning and reading in replicated properties

  method onRep_ReplicatedMovement()
    ## ReplicatedMovement struct replication event
    ## UFUNCTION()

  method postNetReceiveLocationAndRotation()
    ## Update location and rotation from ReplicatedMovement. Not called for simulated physics!

  method postNetReceiveVelocity(newVelocity: FVector)
    ## Update velocity - typically from ReplicatedMovement, not called for simulated physics!

  method postNetReceivePhysicState()
    ## Update and smooth simulated physic state, replaces PostNetReceiveLocation() and PostNetReceiveVelocity()

  proc setOwner(newOwner: ptr AActor)
    ## Set the owner of this Actor, used primarily for network replication.
    ## @param NewOwner  The Actor whom takes over ownership of this Actor
    ##
    ## UFUNCTION(BlueprintCallable, Category=Actor)

  proc getOwner(): ptr AActor {.noSideEffect.}
    ## Get the owner of this Actor, used primarily for network replication.
    ## @return Actor that owns this Actor
    ##
    ## UFUNCTION(BlueprintCallable, Category=Actor)

  method checkStillInWorld(): bool
    ## This will check to see if the Actor is still in the world.  It will check things like
    ## the KillZ, outside world bounds, etc. and handle the situation.

  #--------------------------------------------------------------------------------------
  # Actor overlap tracking
  #--------------------------------------------------------------------------------------

  proc clearComponentOverlaps()
    ## Dispatch all EndOverlap for all of the Actor's PrimitiveComponents.
    ## Generally used when removing the Actor from the world.

  proc updateOverlaps(bDoNotifies: bool = true)
    ## Queries world and updates overlap detection state for this actor.
    ## @param bDoNotifies   True to dispatch being/end overlap notifications when these events occur.

  proc isOverlappingActor(other: ptr AActor): bool
    ## Check whether any component of this Actor is overlapping any component of another Actor.
    ## @param Other The other Actor to test against
    ## @return Whether any component of this Actor is overlapping any component of another Actor.

  proc isMatineeControlled(): bool {.noSideEffect.}
    ## UFUNCTION(BlueprintCallable, Category="Collision", meta=(UnsafeDuringActorConstruction="true"))
    ## Returns whether a MatineeActor is currently controlling this Actor

  proc isRootComponentStatic(): bool {.noSideEffect.}
    ## See if the root component has ModifyFrequency of MF_Static

  proc isRootComponentStationary(): bool {.noSideEffect.}
    ## See if the root component has Mobility of EComponentMobility::Stationary

  proc isRootComponentMovable(): bool {.noSideEffect.}
    ## See if the root component has Mobility of EComponentMobility::Movable

  #--------------------------------------------------------------------------------------
  # Actor ticking
  #--------------------------------------------------------------------------------------

  proc canEverTick(): bool {.noSideEffect.}
    ## Accessor for the value of bCanEverTick

  method tick(deltaSeconds: cfloat)
    ##  Function called every frame on this Actor. Override this function to implement custom logic to be executed every frame.
    ##  Note that Tick is disabled by default, and you will need to check PrimaryActorTick.bCanEverTick is set to true to enable it.
    ##
    ##  @param  DeltaSeconds  Game time elapsed during last frame modified by the time dilation
    ##

  method shouldTickIfViewportsOnly(): bool {.noSideEffect.}
    ## If true, actor is ticked even if TickType==LEVELTICK_ViewportsOnly

  #--------------------------------------------------------------------------------------
  # Actor relevancy determination
  #--------------------------------------------------------------------------------------

  method isNetRelevantFor(realViewer: ptr AActor; viewTarget: ptr AActor;
                        srcLocation: FVector): bool {.noSideEffect.}
    ##  @param RealViewer - is the "controlling net object" associated with the client for which network relevancy is being checked (typically player controller)
    ##  @param ViewTarget - is the Actor being used as the point of view for the RealViewer
    ##  @param SrcLocation - is the viewing location
    ##
    ##  @return bool - true if this actor is network relevant to the client associated with RealViewer

  method isRelevancyOwnerFor(replicatedActor: ptr AActor; actorOwner: ptr AActor;
                           connectionActor: ptr AActor): bool {.noSideEffect.}
    ## Check if this actor is the owner when doing relevancy checks for actors marked bOnlyRelevantToOwner
    ##
    ## @param ReplicatedActor - the actor we're doing a relevancy test on
    ## @param ActorOwner - the owner of ReplicatedActor
    ## @param ConnectionActor - the controller of the connection that we're doing relevancy checks for
    ##
    ## @return bool - true if this actor should be considered the owner

  proc postSpawnInitialize(spawnTransform: FTransform; inOwner: ptr AActor;
                           inInstigator: ptr APawn; bRemoteOwned: bool; bNoFail: bool;
                           bDeferConstruction: bool)
    ## Called after the actor is spawned in the world. Responsible for setting up actor for play.

  proc finishSpawning(transform: FTransform; bIsDefaultTransform: bool = false)
    ## Called to finish the spawning process, generally in the case of deferred spawning

  method PreInitializeComponents()
    ## Called immediately before gameplay begins.

  method PostInitializeComponents()
    ## Allow actors to initialize themselves on the C++ side

  proc addControllingMatineeActor(inMatineeActor: var AMatineeActor)
    ## Adds a controlling matinee actor for use during matinee playback
    ## @param InMatineeActor  The matinee actor which controls this actor

  proc removeControllingMatineeActor(inMatineeActor: var AMatineeActor)
    ## Removes a controlling matinee actor
    ## @param InMatineeActor  The matinee actor which currently controls this actor

  proc dispatchPhysicsCollisionHit(myInfo: FRigidBodyCollisionInfo;
                                   otherInfo: FRigidBodyCollisionInfo;
                                   rigidCollisionData: FCollisionImpactData)
    ## Dispatches ReceiveHit virtual and OnComponentHit delegate

  method getNetOwner(): ptr AActor {.noSideEffect.}
    ## @return the actor responsible for replication, if any.  Typically the player controller

  method getNetOwningPlayer(): ptr UPlayer
    ## @return the owning UPlayer (if any) of this actor. This will be a local player, a net connection, or NULL.

  method getNetConnection(): ptr UNetConnection {.noSideEffect.}
    ## Get the owning connection used for communicating between client/server
    ## @return NetConnection to the client or server for this actor

  proc getNetMode(): ENetMode {.noSideEffect.}
    ## Gets the net mode for this actor, indicating whether it is a client or server (including standalone/not networked).

  proc getNetDriver(): ptr UNetDriver {.noSideEffect.}

  proc setNetDormancy(newDormancy: ENetDormancy)
    ## Puts actor in dormant networking state

  proc flushNetDormancy()
    ## Forces dormant actor to replicate but doesn't change NetDormancy state (i.e., they will go dormant again if left dormant)
    ## UFUNCTION(BlueprintAuthorityOnly, BlueprintCallable, Category="Networking")

  method registerAllComponents()
    ## Ensure that all the components in the Components array are registered

  method postRegisterAllComponents()
    ## Called after all the components in the Components array are registered

  proc hasValidRootComponent(): bool
    ## Returns true if Actor has a registered root component

  method unregisterAllComponents()
    ## Unregister all currently registered components

  method postUnregisterAllComponents()
    ## Called after all currently registered components are cleared

  method reregisterAllComponents()
    ## Will reregister all components on this actor.
    ## Does a lot of work - should only really be used in editor,
    ## generally use UpdateComponentTransforms or MarkComponentsRenderStateDirty.

  proc incrementalRegisterComponents(numComponentsToRegister: int32): bool
    ## Incrementally registers components associated with this actor
    ##
    ## @param NumComponentsToRegister  Number of components to register in this run, 0 for all
    ## @return true when all components were registered for this actor

  proc markComponentsRenderStateDirty()
    ## Flags all component's render state as dirty

  proc updateComponentTransforms()
    ## Update all components transforms

  proc initializeComponents()
    ## Iterate over components array and call InitializeComponent

  proc uninitializeComponents()
    ## Iterate over components array and call UninitializeComponent

  proc drawDebugComponents(baseColor: FColor = whiteColor) {.noSideEffect.}
    ## Debug rendering to visualize the component tree for this actor.

  method markComponentsAsPendingKill()

  proc isPendingKillPending(): bool {.noSideEffect.}
    ## Returns true if this actor has begun the destruction process.
    ## This is set to true in UWorld::DestroyActor, after the network connection has been closed but before any other shutdown has been performed.
    ## @return true if this actor has begun destruction, or if this actor has been destroyed already.

  proc invalidateLightingCache()
    ## Invalidate lighting cache with default options.

  method invalidateLightingCacheDetailed(bTranslationOnly: bool)
    ## Invalidates anything produced by the last lighting build.

  method teleportTo(destLocation: FVector; DestRotation: FRotator;
                  bIsATest: bool = false; bNoCheck: bool = false): bool
    ##  Used for adding actors to levels or teleporting them to a new location.
    ##  The result of this function is independent of the actor's current location and rotation.
    ##  If the actor doesn't fit exactly at the location specified, tries to slightly move it out of walls and such if bNoCheck is false.
    ##
    ##  @param DestLocation The target destination point
    ##  @param DestRotation The target rotation at the destination
    ##  @param bIsATest is true if this is a test movement, which shouldn't cause any notifications (used by AI pathfinding, for example)
    ##  @param bNoCheck is true if we should skip checking for encroachment in the world or other actors
    ##  @return true if the actor has been successfully moved, or false if it couldn't fit.

  proc K2_TeleportTo(destLocation: FVector; destRotation: FRotator): bool
    ## Teleport this actor to a new location. If the actor doesn't fit exactly at the location specified, tries to slightly move it out of walls and such.
    ##
    ## @param DestLocation The target destination point
    ## @param DestRotation The target rotation at the destination
    ## @return true if the actor has been successfully moved, or false if it couldn't fit.
    ##
    ## UFUNCTION(BlueprintCallable, meta=( DisplayName="Teleport", Keywords = "Move Position" ), Category="Utilities|Transformation")

  method TeleportSucceeded(bIsATest: bool)
    ## Called from TeleportTo() when teleport succeeds

  proc ActorLineTraceSingle(outHit: var FHitResult; start: FVector; endPoint: FVector;
                            traceChannel: ECollisionChannel;
                            params: FCollisionQueryParams): bool
    ##  Trace a ray against the Components of this Actor and return the first blocking hit
    ##  @param  OutHit          First blocking hit found
    ##  @param  Start           Start location of the ray
    ##  @param  End             End location of the ray
    ##  @param  TraceChannel    The 'channel' that this ray is in, used to determine which components to hit
    ##  @param  Params          Additional parameters used for the trace
    ##  @return TRUE if a blocking hit is found

  proc ActorGetDistanceToCollision(Point: FVector; TraceChannel: ECollisionChannel;
                                   ClosestPointOnCollision: var FVector;
      OutPrimitiveComponent: ptr ptr UPrimitiveComponent = nil): cfloat {.noSideEffect.}
    ## Returns Distance to closest Body Instance surface.
    ## Checks against all components of this Actor having valid collision and blocking TraceChannel.
    ##
    ## @param Point           World 3D vector
    ## @param TraceChannel        The 'channel' used to determine which components to consider.
    ## @param ClosestPointOnCollision Point on the surface of collision closest to Point
    ## @param OutPrimitiveComponent   PrimitiveComponent ClosestPointOnCollision is on.
    ##
    ## @return Success if returns > 0.f, if returns 0.f, it is either not convex or inside of the point
    ##        If returns < 0.f, this Actor does not have any primitive with collision

  proc isInLevel(testLevel: ptr ULevel): bool {.noSideEffect.}
    ## Returns true if this actor is contained by TestLevel.
    ## @todo seamless: update once Actor->Outer != Level

  proc getLevel(): ptr ULevel {.noSideEffect.}
    ## Return the ULevel that this Actor is part of.

  method clearCrossLevelReferences()
    ## Do anything needed to clear out cross level references; Called from ULevel::PreSave

  proc routeEndPlay(endPlayReason: EEndPlayReason)
    ## Non-virtual function to evaluate which portions of the EndPlay process should be dispatched for each actor

  method endPlay(endPlayReason: EEndPlayReason)
    ## Overridable function called whenever this actor is being removed from a level

  method isBasedOnActor(other: ptr AActor): bool {.noSideEffect.}
    ## iterates up the Base chain to see whether or not this Actor is based on the given Actor
    ## @param Other the Actor to test for
    ## @return true if this Actor is based on Other Actor

  method isAttachedTo(Other: ptr AActor): bool {.noSideEffect.}
    ## iterates up the Base chain to see whether or not this Actor is attached to the given Actor
    ## @param Other the Actor to test for
    ## @return true if this Actor is attached on Other Actor

  proc getPlacementExtent(): FVector {.noSideEffect.}
    ## Get the extent used when placing this actor in the editor, used for 'pulling back' hit.

  # Blueprint

  proc seedAllRandomStreams() # when WITH_EDITOR
    ## Find all FRandomStream structs in this ACtor and generate new random seeds for them.

  proc resetPropertiesForConstruction()
    ## Reset private properties to defaults, and all FRandomStream structs in this Actor, so they will start their sequence of random numbers again.

  method rerunConstructionScripts()
    ## Rerun construction scripts, destroying all autogenerated components; will attempt to preserve the root component location.

  proc debugShowComponentHierarchy(info: wstring; bShowPosition: bool = true)
    ## Debug helper to show the component hierarchy of this actor.
    ## @param Info  Optional String to display at top of info

  proc debugShowOneComponentHierarchy(sceneComp: ptr USceneComponent;
                                      nestLevel: var int32; bShowPosition: bool)

  proc executeConstruction(transform: FTransform;
                           instanceDataCache: ptr FComponentInstanceDataCache;
                           bIsDefaultTransform: bool = false)
    ## Run any construction script for this Actor. Will call OnConstruction.
    ## @param Transform     The transform to construct the actor at.
    ## @param InstanceDataCache Optional cache of state to apply to newly created components (e.g. precomputed lighting)
    ## @param bIsDefaultTransform Whether or not the given transform is a "default" transform, in which case it can be overridden by template defaults

  method onConstruction(transform: FTransform)
    ## Called when an instance of this class is placed (in editor) or spawned.
    ## @param Transform     The transform the actor was constructed at.

  proc finishAndRegisterComponent(component: ptr UActorComponent)
    ## Helper function to register the specified component, and add it to the serialized components array
    ## @param Component Component to be finalized

  proc createComponentFromTemplate(tmpl: ptr UActorComponent;
                                   inName: FString = FString()): ptr UActorComponent
    ##  Util to create a component based on a template

  proc destroyConstructedComponents()
    ## Destroys the constructed components.

  method registerActorTickFunctions(bRegister: bool)
    ## Virtual call chain to register all tick functions for the actor class hierarchy
    ## @param bRegister - true to register, false, to unregister

  proc processUserConstructionScript()
    ## Runs UserConstructionScript, delays component registration until it's complete.

  proc checkActorComponents(): bool
    ## Checks components for validity, implemented in AActor

  method getAttachParentActor(): ptr AActor {.noSideEffect.}
    ## Walk up the attachment chain from RootComponent until we encounter a different actor, and return it.
    ## If we are not attached to a component in a different actor, returns NULL

  method getAttachParentSocketName(): FName {.noSideEffect.}
    ## Walk up the attachment chain from RootComponent until we encounter a different actor,
    ## and return the socket name in the component.
    ## If we are not attached to a component in a different actor, returns NAME_None

  method getAttachedActors(outActors: var TArray[ptr AActor]) {.noSideEffect.}
    ## Find all Actors which are attached directly to a component in this actor

  proc setTickGroup(newTickGroup: ETickingGroup)
    ## Sets the ticking group for this actor.
    ## @param NewTickGroup the new value to assign
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities", meta=(Keywords = "dependency"))

  method destroyed()
    ## Called once this actor has been deleted

  proc dispatchBlockingHit(myComp: ptr UPrimitiveComponent;
                           otherComp: ptr UPrimitiveComponent; bSelfMoved: bool;
                           hit: FHitResult)
    ## Call ReceiveHit, as well as delegates on Actor and Component

  method fellOutOfWorld(dmgType: UDamageType)
    ## Called when the actor falls out of the world 'safely' (below KillZ and such)

  method outsideWorldBounds()
    ## Called when the Actor is outside the hard limit on world bounds

  method getComponentsBoundingBox(bNonColliding: bool = false): FBox {.noSideEffect.}
    ##  Returns the bounding box of all components in this Actor.
    ##  @param bNonColliding Indicates that you want to include non-colliding components in the bounding box

  method getComponentsBoundingCylinder(collisionRadius: var cfloat;
                                       collisionHalfHeight: var cfloat;
                                       bNonColliding: bool = false) {.noSideEffect.}
    ## Get half-height/radius of a big axis-aligned cylinder around this actors registered colliding components, or all registered components if bNonColliding is false.

  method getSimpleCollisionCylinder(collisionRadius: var cfloat;
                                    collisionHalfHeight: var cfloat) {.noSideEffect.}
    ## Get axis-aligned cylinder around this actor, used for simple collision checks (ie Pawns reaching a destination).
    ## If IsRootComponentCollisionRegistered() returns true, just returns its bounding cylinder, otherwise falls back to GetComponentsBoundingCylinder.

  proc getSimpleCollisionRadius(): cfloat {.noSideEffect.}
    ## @returns the radius of the collision cylinder from GetSimpleCollisionCylinder().

  proc getSimpleCollisionHalfHeight(): cfloat {.noSideEffect.}
    ## @returns the half height of the collision cylinder from GetSimpleCollisionCylinder().

  proc getSimpleCollisionCylinderExtent(): FVector {.noSideEffect.}
    ## @returns collision extents vector for this Actor, based on GetSimpleCollisionCylinder().

  method isRootComponentCollisionRegistered(): bool {.noSideEffect.}
    ## @returns true if the root component is registered and has collision enabled.

  method tornOff()
    ## Networking - called on client when actor is torn off (bTearOff==true), meaning it's no longer replicated to clients.
    ## @see bTearOff

  #=============================================================================
  # Collision functions.
  #=============================================================================

  method getComponentsCollisionResponseToChannel(channel: ECollisionChannel): ECollisionResponse {.noSideEffect.}
    ## Get Collision Response to the Channel that entered for all components
    ## It returns Max of state - i.e. if Component A overlaps, but if Component B blocks, it will return block as response
    ## if Component A ignores, but if Component B overlaps, it will return overlap
    ##
    ## @param Channel - The channel to change the response of

  #=============================================================================
  # Physics
  #=============================================================================

  proc disableComponentsSimulatePhysics()
    ## Stop all simulation from all components in this actor

  proc getWorldSettings(): ptr AWorldSettings {.noSideEffect.}
    ## @return WorldSettings for the World the actor is in
    ## if you'd like to know UWorld this placed actor (not dynamic spawned actor) belong to, use GetTypedOuter[UWorld]()

  method canBeBaseForCharacter(pawn: ptr APawn): bool {.noSideEffect.}
    ## Return true if the given Pawn can be "based" on this actor (ie walk on it).
    ## @param Pawn - The pawn that wants to be based on this actor

  method takeDamage(damageAmount: cfloat; damageEvent: FDamageEvent;
                    eventInstigator: ptr AController; damageCauser: ptr AActor): cfloat
    ## Apply damage to this actor.
    ## @see https://www.unrealengine.com/blog/damage-in-ue4
    ## @param DamageAmount    How much damage to apply
    ## @param DamageEvent   Data package that fully describes the damage received.
    ## @param EventInstigator The Controller responsible for the damage.
    ## @param DamageCauser    The Actor that directly caused the damage (e.g. the projectile that exploded, the rock that landed on you)
    ## @return          The amount of damage actually applied.

  method internalTakeRadialDamage(damage: cfloat;
                                  radialDamageEvent: FRadialDamageEvent;
                                  eventInstigator: ptr AController;
                                  damageCauser: ptr AActor): cfloat

  method internalTakePointDamage(damage: cfloat; RadialDamageEvent: FPointDamageEvent;
                                 eventInstigator: ptr AController;
                                 damageCauser: ptr AActor): cfloat

  method becomeViewTarget(pc: ptr APlayerController)
    ## Called when this actor becomes the given PlayerController's ViewTarget. Triggers the Blueprint event K2_OnBecomeViewTarget.

  method endViewTarget(pc: ptr APlayerController)
    ## Called when this actor is no longer the given PlayerController's ViewTarget. Also triggers the Blueprint event K2_OnEndViewTarget.

  proc K2_OnBecomeViewTarget(pc: ptr APlayerController)
    ## Event called when this Actor becomes the view target for the given PlayerController.
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName="OnBecomeViewTarget", Keywords="Activate Camera"), Category=Actor)

  proc K2_OnEndViewTarget(pc: ptr APlayerController)
    ## Event called when this Actor is no longer the view target for the given PlayerController.
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName="OnEndViewTarget", Keywords="Deactivate Camera"), Category=Actor)

  method calcCamera(deltaTime: cfloat; outResult: var FMinimalViewInfo)
    ## Calculate camera view point, when viewing this actor.
    ##
    ## @param DeltaTime Delta time seconds since last update
    ## @param OutResult Camera configuration

  method getHumanReadableName(): FString {.noSideEffect.}
    ## Returns the human readable string representation of an object.

  method reset()
    ## Reset actor to initial state - used when restarting level without reloading.

  proc K2_OnReset()
    ## Event called when this Actor is reset to its initial state - used when restarting level without reloading.
    ## UFUNCTION(BlueprintImplementableEvent, Category=Actor, meta=(DisplayName="OnReset"))

  method getLastRenderTime(): cfloat {.noSideEffect.}
    ## Returns the most recent time any of this actor's components were rendered

  method forceNetRelevant()
    ## Forces this actor to be net relevant if it is not already by default

  method setNetUpdateTime(newUpdateTime: cfloat)
    ## Updates NetUpdateTime to the new value for future net relevancy checks

  method forceNetUpdate()
    ## Force actor to be updated to clients
    ## UFUNCTION(BlueprintAuthorityOnly, BlueprintCallable, Category="Networking")

  method prestreamTextures(seconds: cfloat; bEnableStreaming: bool;
                           cinematicTextureGroups: int32 = 0)
    ## Calls PrestreamTextures() for all the actor's meshcomponents.
    ## @param Seconds - Number of seconds to force all mip-levels to be resident
    ## @param bEnableStreaming - Whether to start (true) or stop (false) streaming
    ## @param CinematicTextureGroups - Bitfield indicating which texture groups that use extra high-resolution mips

  method getActorEyesViewPoint(outLocation: var FVector; outRotation: var FRotator) {.noSideEffect.}
    ## Returns the point of view of the actor.
    ## Note that this doesn't mean the camera, but the 'eyes' of the actor.
    ## For example, for a Pawn, this would define the eye height location,
    ## and view rotation (which is different from the pawn rotation which has a zeroed pitch component).
    ## A camera first person view will typically use this view point. Most traces (weapon, AI) will be done from this view point.
    ##
    ## @param OutLocation - location of view point
    ## @param OutRotation - view rotation of actor.
    ##
    ## UFUNCTION(BlueprintCallable, Category = Actor)

  method getTargetLocation(requestedBy: ptr AActor = nil): FVector {.noSideEffect.}
    ## @param RequestedBy - the Actor requesting the target location
    ## @return the optimal location to fire weapons at this actor

  method postRenderFor(pc: ptr APlayerController; canvas: ptr UCanvas;
                       cameraPosition: FVector; cameraDir: FVector)
    ##  Hook to allow actors to render HUD overlays for themselves.  Called from AHUD::DrawActorOverlays().
    ##  @param PC is the PlayerController on whose view this overlay is rendered
    ##  @param Canvas is the Canvas on which to draw the overlay
    ##  @param CameraPosition Position of Camera
    ##  @param CameraDir direction camera is pointing in.

  proc isInPersistentLevel(bIncludeLevelStreamingPersistent: bool = false): bool {.noSideEffect.}
    ## whether this Actor is in the persistent level, i.e. not a sublevel

  proc getWorldTimerManager(): ptr FTimerManager {.cppname: "(& #.GetWorldTimerManager())", noSideEffect.}
    ## Get the timer instance from the actors world

  proc getGameInstance(): ptr UGameInstance {.noSideEffect.}
    ## Gets the GameInstance that ultimately contains this actor.

  proc isNetStartupActor(): bool {.noSideEffect.}
    ## Returns true if this is a replicated actor that was placed in the map

  proc getComponents[T](outComponents: var TArray[ptr T])
    ## Get all components derived from class 'T' and fill in the OutComponents array with the result.
    ## It's recommended to use TArrays with a TInlineAllocator to potentially avoid memory allocation costs.
    ## TInlineComponentArray is defined to make this easier, for example:
    ## {
    ##     TInlineComponentArray<UPrimitiveComponent*> PrimComponents(Actor);
    ## }

  proc getComponents(outComponents: var TArray[ptr UActorComponent])
    ## UActorComponent specialization of GetComponents() to avoid unnecessary casts.
    ## It's recommended to use TArrays with a TInlineAllocator to potentially avoid memory allocation costs.
    ## TInlineComponentArray is defined to make this easier, for example:
    ## {
    ##     TInlineComponentArray<UPrimitiveComponent*> PrimComponents;
    ##     Actor->GetComponents(PrimComponents);
    ## }

  proc getComponents(): var TSet[ptr UActorComponent] {.noSideEffect.}
    ## Get a direct reference to the Components set rather than a copy with the null pointers removed.
    ## WARNING: anything that could cause the component to change ownership or be destroyed will invalidate
    ## this array, so use caution when iterating this set!

  proc addOwnedComponent(component: ptr UActorComponent)
    ## Puts a component in to the OwnedComponents array of the Actor.
    ##  The Component must be owned by the Actor or else it will assert
    ##  In general this should not need to be called directly by anything other than UActorComponent functions

  proc removeOwnedComponent(component: ptr UActorComponent)
    ## Removes a component from the OwnedComponents array of the Actor.
    ## In general this should not need to be called directly by anything other than UActorComponent functions

  proc ownsComponent(component: ptr UActorComponent): bool {.noSideEffect.} #when DO_CHECK
    ## Utility function for validating that a component is correctly in its Owner's OwnedComponents array

  proc resetOwnedComponents()
    ## Force the Actor to clear and rebuild its OwnedComponents array by evaluating all children (recursively) and locating components
    ## In general this should not need to be called directly, but can sometimes be necessary as part of undo/redo code paths.

  proc updateReplicatedComponent(component: ptr UActorComponent)
    ## Called when the replicated state of a component changes to update the Actor's cached ReplicatedComponents array

  proc updateAllReplicatedComponents()
    ## Completely synchronizes the replicated components array so that it contains exactly the number of replicated components currently owned

  proc getReplicatedComponents(): var TArray[ptr UActorComponent] {.noSideEffect.}
    ## Returns a constant reference to the replicated components array

  var blueprintCreatedComponents: TArray[ptr UActorComponent]
    ## Array of ActorComponents that are created by blueprints and serialized per-instance.
    ## UPROPERTY(TextExportTransient, NonTransactional)

  proc addInstanceComponent(component: ptr UActorComponent)
    ## Adds a component to the instance components array

  proc removeInstanceComponent(component: ptr UActorComponent)
    ## Removes a component from the instance components array

  proc clearInstanceComponents(bDestroyComponents: bool)
    ## Clears the instance components array

  proc getInstanceComponents(): var TArray[ptr UActorComponent] {.noSideEffect.}
    ## Returns the instance components array

  #=============================================================================
  # Navigation related functions
  #=============================================================================

  method isComponentRelevantForNavigation(component: ptr UActorComponent): bool {.noSideEffect.}
    ## Check if owned component should be relevant for navigation
    ##  Allows implementing master switch to disable e.g. collision export in projectiles

  ##=============================================================================
  ## Debugging functions
  ##=============================================================================

  method displayDebug(canvas: ptr UCanvas; debugDisplay: FDebugDisplayInfo;
                      yl: var cfloat; yPos: var cfloat)
    ## Draw important Actor variables on canvas.  HUD will call DisplayDebug() on the current ViewTarget when the ShowDebug exec is used
    ##
    ## @param Canvas      Canvas to draw on
    ##
    ## @param DebugDisplay    Contains information about what debug data to display
    ##
    ## @param YL    [in]  Height of the previously drawn line.
    ##              [out] Height of the last line drawn by this function.
    ##
    ## @param YPos  [in]  Y position on Canvas for the previously drawn line. YPos += YL, gives position to draw text for next debug line.
    ##              [out] Y position on Canvas for the last line drawn by this function.

  # AWARE
  # proc grabDebugSnapshot(snapshot: ptr FVisualLogEntry) {.noSideEffect.} # when ENABLE_VISUAL_LOG
  #   ##  Hook for Actors to supply visual logger with additional data.
  #   ##  It's guaranteed that Snapshot != NULL

  var processEventDelegate: FOnProcessEvent #when not UE_BUILD_SHIPPING
    ## Delegate for globally hooking ProccessEvent calls - used by a non-public testing plugin

  proc makeNoiseImpl(noiseMaker: ptr AActor; loudness: cfloat;
                     noiseInstigator: ptr APawn; noiseLocation: FVector;
                     maxRange: cfloat; tag: FName)
  proc setMakeNoiseDelegate(newDelegate: FMakeNoiseDelegate)

  # AWARE
  # var detachFence: FRenderCommandFence
  #   ## A fence to track when the primitive is detached from the scene in the rendering thread.


proc getDebugName*(actor: ptr AActor): FString {.importcpp: "AActor::GetDebugName(#)", nodecl.}

proc findComponentByClass*[T: UActorComponent](this: ptr AActor): ptr T {.importcpp: "#.FindComponentByClass<'*0>()", nodecl, noSideEffect.}
proc getComponentByClass*(this: ptr AActor, class: TSubclassOf[UActorComponent]): ptr UActorComponent {.importcpp: "#.GetComponentByClass(@)", nodecl, noSideEffect.}

proc getComponentsByClass*[T: UActorComponent](this: ptr AActor): TArray[ptr UActorComponent] {.importcpp: "#.GetComponentsByClass('*0::StaticClass())", nodecl, noSideEffect.}
  ## Gets all the components that inherit from the given class.
  ## Currently returns an array of UActorComponent which must be cast to the correct type.
  ## UFUNCTION(BlueprintCallable, Category = "Actor", meta = (ComponentClass = "ActorComponent"), meta=(DeterminesOutputType="ComponentClass"))
proc getComponentsByClass*(this: ptr AActor, class: TSubclassOf[UActorComponent]): TArray[ptr UActorComponent] {.importcpp: "#.GetComponentsByClass(@)", nodecl, noSideEffect.}
  ## Gets all the components that inherit from the given class.
  ## Currently returns an array of UActorComponent which must be cast to the correct type.
  ## UFUNCTION(BlueprintCallable, Category = "Actor", meta = (ComponentClass = "ActorComponent"), meta=(DeterminesOutputType="ComponentClass"))

# proc getComponentsByTag(actor: ptr AActor, class: ptr UClass, tag: FName): TArray[ptr UActorComponent] {.importcpp: "#.GetComponentsByTag(@)", nodecl, noSideEffect.}

proc getComponentsByTagInternal[T: UActorComponent](this: ptr AActor, tag: FName): TArray[ptr UActorComponent] {.importcpp: "#.GetComponentsByTag('**0::StaticClass(), #)", nodecl, noSideEffect.}
  ## Gets all the components that inherit from the given class with a given tag.

proc getComponentsByTag*[T: UActorComponent](this: ptr AActor, tag: FName): TArray[ptr T] =
  let concreteArray = getComponentsByTagInternal[T](this, tag)
  result = initArray[ptr T](concreteArray.len)
  for item in concreteArray:
    result.add(cast[ptr T](item))

proc getComponentsByTag*[T: UActorComponent](this: ptr AActor, tag: cstring{lit}): TArray[ptr T] =
  result = getComponentsByTag[T](this, initFName(tag))

type TActorIterator {.importcpp: "TActorIterator", header: "EngineUtils.h".} [T: AActor] = object
proc initActorIterator[T: AActor](world: ptr UWorld): TActorIterator[T] {.importcpp: "'0(@)", nodecl, constructor.}
proc isValid[T](it: TActorIterator[T]): bool {.importcpp: "((bool)(#))", nodecl, noSideEffect.}
proc next[T](it: var TActorIterator[T]) {.importcpp: "(++#)", nodecl.}
proc getActor[T](it: TActorIterator[T]): ptr T {.importcpp: "(*#)", nodecl, noSideEffect.}

iterator actors*[T: AActor](world: ptr UWorld): ptr T =
  var it = initActorIterator[T](world)
  while it.isValid:
    yield it.getActor()
    it.next()

proc findActor*[T: AActor](world: ptr UWorld): ptr T =
  for actor in actors[T](world):
    return actor
