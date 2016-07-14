# Copyright 2016 Xored Software, Inc.

type
  FBlueprintToDebuggedObjectMap = TMap[TWeakObjectPtr[UBlueprint], TWeakObjectPtr[UObject]]
  FLatentActionManager* {.importcpp, header: "Engine/LatentActionManager.h".} = object
  FActorSpawnParameters* {.importcpp, header: "Engine/World.h".} = object ## A name to assign as the Name of the Actor being spawned. If no value is specified, the name of the spawned Actor will be automatically generated using the form [Class]_[Number].
    name* {.importcpp: "Name".}: FName
    templateActor* {.importcpp: "Template".}: ptr AActor
      ## An Actor to use as a template when spawning the new Actor. The spawned Actor will be initialized using the property values of the template Actor. If left NULL the class default object (CDO) will be used to initialize the spawned Actor.
    owner* {.importcpp: "Owner".}: ptr AActor
      ## The Actor that spawned this Actor. (Can be left as NULL).
    instigator* {.importcpp: "Instigator".}: ptr APawn
      ## The APawn that is responsible for damage done by the spawned Actor. (Can be left as NULL).
    overrideLevel* {.importcpp: "OverrideLevel".}: ptr ULevel
      ## The ULevel to spawn the Actor in, i.e. the Outer of the Actor. If left as NULL the Outer of the Owner is used. If the Owner is NULL the persistent level is used.
    spawnCollisionHandlingOverride* {.importcpp: "SpawnCollisionHandlingOverride".}: ESpawnActorCollisionHandlingMethod
      ## Method for resolving collisions at the spawn point. Undefined means no override, use the actor's setting.
    bRemoteOwned*: bool
      ## Is the actor remotely owned.
    bNoFail*: bool
      ## Determines whether spawning will not fail if certain conditions are not met. If true, spawning will not fail because the class being spawned is `bStatic=true` or because the class of the template Actor is not the same as the class of the Actor being spawned.
    bDeferConstruction*: bool
      ## Determines whether the construction script will be run. If true, the construction script will not be run on the spawned Actor. Only applicable if the Actor is being spawned from a Blueprint.
    bAllowDuringConstructionScript*: bool
      ## Determines whether or not the actor may be spawned when running a construction script. If true spawning will fail if a construction script is being run.
    objectFlags* {.importcpp: "ObjectFlags".}: EObjectFlags
      ## Flags used to describe the spawned actor/object instance.

  WorldInitializationValues* {.importcpp: "InitializationValues", header: "Engine/World.h".} = object
    bInitializeScenes*: bool
      ## Are sounds allowed to be generated from this world.
    bAllowAudioPlayback*: bool
      ## Should the render scene create hit proxies.
    bRequiresHitProxies*: bool
      ## Should the physics scene be created. bInitializeScenes must be true for this to be considered.
    bCreatePhysicsScene*: bool
      ## Should the navigation system be created for this world.
    bCreateNavigation*: bool
      ## Should the AI system be created for this world.
    bCreateAISystem*: bool
      ## Should physics be simulated in this world.
    bShouldSimulatePhysics*: bool
      ## Are collision trace calls valid within this world.
    bEnableTraceCollision*: bool
      ## Should actions performed to objects in this world be saved to the transaction buffer.
    bTransactional*: bool
      ## Should the FX system be created for this world.
    bCreateFXSystem*: bool

  FLevelViewportInfo* {.header: "Engine/World.h", importcpp.} = object
    ## Saved editor viewport state information
    camPosition {.importcpp: "CamPosition".}: FVector
      ## Where the camera is positioned within the viewport.
    camRotation {.importcpp: "CamRotation".}: FRotator
      ## The camera's position within the viewport.
    camOrthoZoom {.importcpp: "CamOrthoZoom".}: float
      ## The zoom value  for orthographic mode.
    camUpdated {.importcpp: "CamUpdated".}: bool
      ## Whether camera settings have been systematically changed since the last level viewport update.

  UWorldComposition* {.importcpp, header: "Engine/WorldComposition.h".} = object of UObject

proc initWorldInitializationValues*(): WorldInitializationValues {.importcpp: "'0()", constructor, nodecl.}
proc initFActorSpawnParameters*(): FActorSpawnParameters {.importcpp: "'0()", constructor, nodecl.}

declareBuiltinDelegate(FOnLevelsChangedEvent, dkMulticast, "Engine/World.h")
declareBuiltinDelegate(FOnSelectedLevelsChangedEvent, dkMulticast, "Engine/World.h")
declareBuiltinDelegate(FOnNetTickEvent, dkMulticast, "Engine/World.h")
declareBuiltinDelegate(FOnTickFlushEvent, dkMulticast, "Engine/World.h")

wclass(UWorld of UObject, header: "Engine/World.h", notypedef):
# when WITH_EDITORONLY_DATA:
  # ## List of all the layers referenced by the world's actors
  # ## UPROPERTY()
  # var layers: TArray[ptr ULayer]
  # ## Group actors currently "active"
  # ## UPROPERTY(transient)
  # var activeGroupActors: TArray[ptr AActor]
  # ## Information for thumbnail rendering
  # ## UPROPERTY(VisibleAnywhere, Instanced, Category=Thumbnail)
  # var thumbnailInfo: ptr UThumbnailInfo
  # ## Persistent level containing the world info, default brush and actors spawned during gameplay among other things
  # ## UPROPERTY(Transient)
# endwhen

  var persistentLevel: ptr ULevel

  var netDriver: ptr UNetDriver
    ## The NAME_GameNetDriver game connection(s) for client/server communication
    ## UPROPERTY(Transient)

  var lineBatcher: ptr ULineBatchComponent
    ## Line Batchers. All lines to be drawn in the world.
    ## UPROPERTY(Transient)

  var persistentLineBatcher: ptr ULineBatchComponent
    ## Persistent Line Batchers. They don't get flushed every frame.
    ## UPROPERTY(Transient)

  var foregroundLineBatcher: ptr ULineBatchComponent
    ## Foreground Line Batchers. This can't be Persistent.
    ## UPROPERTY(Transient)

  var gameState: ptr AGameState
    ## The replicated actor which contains game state information that can be accessible to clients
    ## UPROPERTY(Transient)

  var networkManager: ptr AGameNetworkManager
    ## Instance of this world's game-specific networking management
    ## UPROPERTY(Transient)

  var physicsCollisionHandler: ptr UPhysicsCollisionHandler
    ## Instance of this world's game-specific physics collision handler
    ## UPROPERTY(Transient)

  var extraReferencedObjects: TArray[ptr UObject]
    ## Array of any additional objects that need to be referenced by this world, to make sure they aren't GC'd
    ## UPROPERTY(Transient)

  var perModuleDataObjects: TArray[ptr UObject]
    ## External modules can have additional data associated with this UWorld.
    ## This is a list of per module world data objects. These aren't
    ## loaded/saved by default.
    ##
    ## UPROPERTY(Transient)

  var streamingLevels: TArray[ptr ULevelStreaming]
    ## Level collection. ULevels are referenced by FName (Package name) to avoid serialized references. Also contains offsets in world units
    ## UPROPERTY(Transient)

  var streamingLevelsPrefix: FString
    ## Prefix we used to rename streaming levels, non empty in PIE and standalone preview
    ## UPROPERTY()

  var currentLevelPendingVisibility: ptr ULevel
    ## Pointer to the current level in the queue to be made visible, NULL if none are pending.
    ## UPROPERTY(Transient)

  var demoNetDriver: ptr UDemoNetDriver
    ## Fake NetDriver for capturing network traffic to record demos
    ## UPROPERTY()

  var myParticleEventManager: ptr AParticleEventManager
    ## Particle event manager
    ## UPROPERTY()

# public:
  var viewLocationsRenderedLastFrame: TArray[FVector]
    ## View locations rendered in the previous frame, if any.

  var bWorldWasLoadedThisTick: bool
    ## set for one tick after completely loading and initializing a new world
    ## (regardless of whether it's LoadMap() or seamless travel)

  var bTriggerPostLoadMap: bool
    ## Triggers a call to PostLoadMap() the next Tick, turns off loading movie if LoadMap() has been called.


# public:
  var networkActors: TSet[ptr AActor]
    ## Array of actors that are candidates for sending over the network


# when WITH_EDITOR:
  ## Hierarchical LOD System. Used when WorldSetting.bEnableHierarchicalLODSystem is true
  # var hierarchicalLODBuilder: ptr FHierarchicalLODBuilder
#endwhen

# public
  proc setNavigationSystem(inNavigationSystem: ptr UNavigationSystem)
    # Set the pointer to the Navgation system.
  var scene: ptr FSceneInterface
    # The interface to the scene manager for this world.
  var featureLevel: ERHIFeatureLevel
    # The current renderer feature level of this world

# when WITH_EDITORONLY_DATA:
  ## Saved editor viewport states - one for each view type. Indexed using ELevelViewportType from UnrealEdTypes.h.
  ## UPROPERTY(NonTransactional)
  var editorViews: TArray[FLevelViewportInfo]
#endwhen

  proc setCurrentLevel(inLevel: ptr ULevel): bool
    ## Set the CurrentLevel for this world.
    ## @return true if the current level changed.

  proc getCurrentLevel(): ptr ULevel {.noSideEffect.}
    ## Get the CurrentLevel for this world.

  var worldTypePreLoadMap: TMap[FName, EWorldType]
    ## A static map that is populated before loading a world from a package.
    ## This is so UWorld can look up its WorldType in ::PostLoad

  proc getBlueprintObjectsBeingDebugged(): var FBlueprintToDebuggedObjectMap {.
      noSideEffect.}
    ## Map of blueprints that are bieng debugged and the object instance they are debugging.

  proc createFXSystem()
    ## Creates a new FX system for this world

# when WITH_EDITOR:
  ## Change the feature level that this world is current rendering with
  proc changeFeatureLevel(inFeatureLevel: ERHIFeatureLevel;
                        bShowSlowProgressDialog: bool = true)
# endwhen

# public:

  var url {.cppname: "URL".}: FURL
    ## The URL that was used when loading this World.

  # var FXSystem: ptr FFXSystemInterface
  # ## Interface to the FX system managing particles and related effects for this world.

  var bInTick: bool
    ## Whether we are in the middle of ticking actors/components or not

  var bIsBuilt: bool
    ## Whether we have already built the collision tree or not

  var bTickNewlySpawned: bool
    ## We are in the middle of actor ticking, so add tasks for newly spawned actors

  var tickGroup: ETickingGroup
    ## The current ticking group

  var bPostTickComponentUpdate: bool
    ## Indicates that during world ticking we are doing the final component update of dirty components
    ## (after PostAsyncWork and effect physics scene has run)

  var playerNum: int32
    ## Counter for allocating game- unique controller player numbers

  var timeSinceLastPendingKillPurge: cfloat
    ## Time in seconds (game time so we respect time dilation) since the last time we purged references to pending kill objects

  var fullPurgeTriggered: bool
    ## Whether a full purge has been triggered, so that the next GarbageCollect will do a full purge no matter what.

  var bShouldDelayGarbageCollect: bool
    ## Whether we should delay GC for one frame to finish some pending operation

  var bIsWorldInitialized: bool
    ## Whether world object has been initialized via Init()

  var streamingVolumeUpdateDelay: int32
    ## Number of frames to delay Streaming Volume updating, useful if you preload a bunch of levels but the camera hasn't caught up yet (INDEX_NONE for infinite)

  var bIsLevelStreamingFrozen: bool
    ## Is level streaming currently frozen?

  var bShouldForceUnloadStreamingLevels: bool
    ## Is forcibly unloading streaming levels?

  var bShouldForceVisibleStreamingLevels: bool
    ## Is forcibly making streaming levels visible?

  var bDoDelayedUpdateCullDistanceVolumes: bool
    ## True we want to execute a call to UpdateCulledTriggerVolumes during Tick

  var worldType: EWorldType
    ## If true, this is a preview world used for editor tools, and not an actual loaded map world

  var bHack_Force_UsesGameHiddenFlags_True: bool
    ## Force UsesGameHiddenFlags to return true.

  var bIsRunningConstructionScript: bool
    ## If true this world is in the process of running the construction script for an actor

  var bShouldSimulatePhysics: bool
    ## If true this world will tick physics to simulate. This isn't same as having Physics Scene.
    ## You need Physics Scene if you'd like to trace. This flag changed ticking

# when WITH_EDITOR:
  ## this is special flag to enable collision by default for components that are not Volume
  ## currently only used by editor level viewport world, and do not use this for in-game scene
  ##
  var bEnableTraceCollision: bool
#endwhen

  var debugDrawTraceTag: FName
    ## When non-'None', all line traces where the TraceTag match this will be drawn

  # var postProcessVolumes: TArray[ptr IInterface_PostProcessVolume]
  # ## An array of post processing volumes, sorted in ascending order of priority.

  var highestPriorityAudioVolume: ptr AAudioVolume
    ## Pointer to the higest priority audio volumes, each volume has a reference to the next lower priority volume creating a linked list of prioritized audio volumes in descending order

  var audioDeviceHandle: uint32
    ## Handle to the active audio device for this world.

  var lastTimeUnbuiltLightingWasEncountered: cdouble
    ## Time in FPlatformTime::Seconds unbuilt time was last encountered. 0 means not yet.

  var timeSeconds: cfloat
    ## Time in seconds since level began play, but IS paused when the game is paused, and IS dilated/clamped.

  var realTimeSeconds: cfloat
    ## Time in seconds since level began play, but is NOT paused when the game is paused, and is NOT dilated/clamped.

  var audioTimeSeconds: cfloat
    ## Time in seconds since level began play, but IS paused when the game is paused, and is NOT dilated/clamped.

  var deltaTimeSeconds: cfloat
    ## Frame delta time in seconds adjusted by e.g. time dilation.

  var pauseDelay: cfloat
    ## time at which to start pause

  var originLocation: FIntVector
    ## Current location of this world origin

  var requestedOriginLocation: FIntVector
    ## Requested new world origin location

  var bOriginOffsetThisFrame: bool
    ## Whether world origin was rebased this frame

  var worldComposition: ptr UWorldComposition
    ## All levels information from which our world is composed
    ## UPROPERTY()

  var flushLevelStreamingType: EFlushLevelStreamingType
    ## Whether we flushing level streaming state

# public:

  var nextTravelType: ETravelType
    ## The type of travel to perform next when doing a server travel

  var nextURL: FString
    ## The URL to be used for the upcoming server travel

  var nextSwitchCountdown: cfloat
    ## Amount of time to wait before traveling to next map, gives clients time to receive final RPCs @see ServerTravelPause

  var preparingLevelNames: TArray[FName]
    ## array of levels that were loaded into this map via PrepareMapChange() / CommitMapChange() (to inform newly joining clients)

  var committedPersistentLevelName: FName
    ## Name of persistent level if we've loaded levels via CommitMapChange() that aren't normally in the StreamingLevels array (to inform newly joining clients)

  var numLightingUnbuiltObjects: uint32
    ## This is a int on the level which is set when a light that needs to have lighting rebuilt
    ## is moved.  This is then checked in CheckMap for errors to let you know that this level should
    ## have lighting rebuilt.

  var bDropDetail: bool
    ## frame rate is below DesiredFrameRate, so drop high detail actors

  var bAggressiveLOD: bool
    ## frame rate is well below DesiredFrameRate, so make LOD more aggressive

  var bIsDefaultLevel: bool
    ## That map is default map or not

  var bRequestedBlockOnAsyncLoading: bool
    ## Whether it was requested that the engine bring up a loading screen and block on async loading.

  var bActorsInitialized: bool
    ## Whether actors have been initialized for play

  var bBegunPlay: bool
    ## Whether BeginPlay has been called on actors

  var bMatchStarted: bool
    ## Whether the match has been started

  var bPlayersOnly: bool
    ## When ticking the world, only update players.

  var bPlayersOnlyPending: bool
    ## Indicates that at the end the frame bPlayersOnly will be set to true.

  var bStartup: bool
    ## Is the world in its actor initialization phase.

  var bIsTearingDown: bool
    ## Is the world being torn down

  var bKismetScriptError: bool
    ## This is a bool that indicates that one or more blueprints in the level (blueprint instances, level script, etc)
    ## have compile errors that could not be automatically resolved.

  var bDebugPauseExecution: bool
    ## Kismet debugging flags - they can be only editor only, but they're uint32, so it doens't make much difference

  var bAllowAudioPlayback: bool
    ## Indicates this scene always allows audio playback.

  var bDebugFrameStepExecution: bool
    ## When set, will tell us to pause simulation after one tick.
    ## If a breakpoint is encountered before tick is complete we will stop there instead.

  var bAreConstraintsDirty: bool
    ## Keeps track whether actors moved via PostEditMove and therefore constraint syncup should be performed.
    ## UPROPERTY(transient)

  var asyncPreRegisterLevelStreamingTasks: FThreadSafeCounter
    ## Coordinates async tasks started in post load that we want completed before we register components.
    ## May not be here for long; currently used to convert foliage instance buffers.

 # LINE TRACE

  proc lineTraceTestByChannel(start: FVector; `end`: FVector;
                            traceChannel: ECollisionChannel;
                            params: FCollisionQueryParams = defaultQueryParam;
      responseParam: FCollisionResponseParams = defaultResponseParam): bool {.
      noSideEffect.}
    ## Trace a ray against the world using a specific channel and return if a blocking hit is found.
    ## @param  Start           Start location of the ray
    ## @param  End             End location of the ray
    ## @param  TraceChannel    The 'channel' that this ray is in, used to determine which components to hit
    ## @param  Params          Additional parameters used for the trace
    ## 	@param 	ResponseParam	ResponseContainer to be used for this trace
    ## @return TRUE if a blocking hit is found

  proc lineTraceTestByObjectType(start: FVector; `end`: FVector;
                                objectQueryParams: FCollisionObjectQueryParams;
                                params: FCollisionQueryParams = defaultQueryParam): bool {.
      noSideEffect.}
    ## Trace a ray against the world using object types and return if a blocking hit is found.
    ## @param  Start           	Start location of the ray
    ## @param  End             	End location of the ray
    ## 	@param	ObjectQueryParams	List of object types it's looking for
    ## @param  Params          	Additional parameters used for the trace
    ## @return TRUE if any hit is found

  proc lineTraceTestByProfile(start: FVector; `end`: FVector; profileName: FName;
                            params: FCollisionQueryParams = defaultQueryParam): bool {.
      noSideEffect.}
    ## Trace a ray against the world using a specific profile and return if a blocking hit is found.
    ## @param  Start           Start location of the ray
    ## @param  End             End location of the ray
    ## @param  ProfileName     The 'profile' used to determine which components to hit
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if a blocking hit is found

  proc lineTraceSingleByChannel(outHit: var FHitResult; start: FVector; `end`: FVector;
                              traceChannel: ECollisionChannel;
                              params: FCollisionQueryParams = defaultQueryParam;
      responseParam: FCollisionResponseParams = defaultResponseParam): bool {.
      noSideEffect.}
    ## Trace a ray against the world using a specific channel and return the first blocking hit
    ## @param  OutHit          First blocking hit found
    ## @param  Start           Start location of the ray
    ## @param  End             End location of the ray
    ## @param  TraceChannel    The 'channel' that this ray is in, used to determine which components to hit
    ## @param  Params          Additional parameters used for the trace
    ## 	@param 	ResponseParam	ResponseContainer to be used for this trace
    ## @return TRUE if a blocking hit is found

  proc lineTraceSingleByObjectType(outHit: var FHitResult; start: FVector;
                                  `end`: FVector;
                                  objectQueryParams: FCollisionObjectQueryParams;
      params: FCollisionQueryParams = defaultQueryParam): bool {.noSideEffect.}
    ## Trace a ray against the world using object types and return the first blocking hit
    ## @param  OutHit          First blocking hit found
    ## @param  Start           Start location of the ray
    ## @param  End             End location of the ray
    ## 	@param	ObjectQueryParams	List of object types it's looking for
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if any hit is found

  proc lineTraceSingleByProfile(outHit: var FHitResult; start: FVector; `end`: FVector;
                              profileName: FName;
                              params: FCollisionQueryParams = defaultQueryParam): bool {.
      noSideEffect.}
    ## Trace a ray against the world using a specific profile and return the first blocking hit
    ## @param  OutHit          First blocking hit found
    ## @param  Start           Start location of the ray
    ## @param  End             End location of the ray
    ## @param  ProfileName     The 'profile' used to determine which components to hit
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if a blocking hit is found

  proc lineTraceMultiByChannel(outHits: var TArray[FHitResult]; start: FVector;
                              `end`: FVector; traceChannel: ECollisionChannel;
                              params: FCollisionQueryParams = defaultQueryParam;
      responseParam: FCollisionResponseParams = defaultResponseParam): bool {.
      noSideEffect.}
    ## Trace a ray against the world using a specific channel and return overlapping hits and then first blocking hit
    ## Results are sorted, so a blocking hit (if found) will be the last element of the array
    ## Only the single closest blocking result will be generated, no tests will be done after that
    ## @param  OutHits         Array of hits found between ray and the world
    ## @param  Start           Start location of the ray
    ## @param  End             End location of the ray
    ## @param  TraceChannel    The 'channel' that this ray is in, used to determine which components to hit
    ## @param  Params          Additional parameters used for the trace
    ## 	@param 	ResponseParam	ResponseContainer to be used for this trace
    ## @return TRUE if OutHits contains any blocking hit entries

  proc lineTraceMultiByObjectType(outHits: var TArray[FHitResult]; start: FVector;
                                `end`: FVector;
                                objectQueryParams: FCollisionObjectQueryParams;
      params: FCollisionQueryParams = defaultQueryParam): bool {.noSideEffect.}
    ## Trace a ray against the world using object types and return overlapping hits and then first blocking hit
    ## Results are sorted, so a blocking hit (if found) will be the last element of the array
    ## Only the single closest blocking result will be generated, no tests will be done after that
    ## @param  OutHits         Array of hits found between ray and the world
    ## @param  Start           Start location of the ray
    ## @param  End             End location of the ray
    ## 	@param	ObjectQueryParams	List of object types it's looking for
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if any hit is found

  proc lineTraceMultiByProfile(outHits: var TArray[FHitResult]; start: FVector;
                              `end`: FVector; profileName: FName;
                              params: FCollisionQueryParams = defaultQueryParam): bool {.
      noSideEffect.}
    ## Trace a ray against the world using a specific profile and return overlapping hits and then first blocking hit
    ## Results are sorted, so a blocking hit (if found) will be the last element of the array
    ## Only the single closest blocking result will be generated, no tests will be done after that
    ## @param  OutHits         Array of hits found between ray and the world
    ## @param  Start           Start location of the ray
    ## @param  End             End location of the ray
    ## @param  ProfileName     The 'profile' used to determine which components to hit
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if OutHits contains any blocking hit entries

  proc sweepTestByChannel(start: FVector; `end`: FVector; rot: FQuat;
                        traceChannel: ECollisionChannel;
                        collisionShape: FCollisionShape;
                        params: FCollisionQueryParams = defaultQueryParam;
      responseParam: FCollisionResponseParams = defaultResponseParam): bool {.
      noSideEffect.}
    ## Sweep a shape against the world using a specific channel and return if a blocking hit is found.
    ## @param  Start           Start location of the shape
    ## @param  End             End location of the shape
    ## @param  TraceChannel    The 'channel' that this trace uses, used to determine which components to hit
    ## @param	CollisionShape	CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## 	@param 	ResponseParam	ResponseContainer to be used for this trace
    ## @return TRUE if a blocking hit is found

  proc sweepTestByObjectType(start: FVector; `end`: FVector; rot: FQuat;
                            objectQueryParams: FCollisionObjectQueryParams;
                            collisionShape: FCollisionShape;
                            params: FCollisionQueryParams = defaultQueryParam): bool {.
      noSideEffect.}
    ## Sweep a shape against the world using object types and return if a blocking hit is found.
    ## @param  Start           Start location of the shape
    ## @param  End             End location of the shape
    ## 	@param	ObjectQueryParams	List of object types it's looking for
    ## @param	CollisionShape	CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if any hit is found

  proc sweepTestByProfile(start: FVector; `end`: FVector; rot: FQuat; profileName: FName;
                        collisionShape: FCollisionShape;
                        params: FCollisionQueryParams): bool {.noSideEffect.}
    ## Sweep a shape against the world using a specific profile and return if a blocking hit is found.
    ## @param  Start           Start location of the shape
    ## @param  End             End location of the shape
    ## @param  ProfileName     The 'profile' used to determine which components to hit
    ## @param	CollisionShape	CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if a blocking hit is found

  proc sweepSingleByChannel(outHit: var FHitResult; start: FVector; `end`: FVector;
                          rot: FQuat; traceChannel: ECollisionChannel;
                          collisionShape: FCollisionShape;
                          params: FCollisionQueryParams = defaultQueryParam;
      responseParam: FCollisionResponseParams = defaultResponseParam): bool {.
      noSideEffect.}
    ## Sweep a shape against the world and return the first blocking hit using a specific channel
    ## @param  OutHit          First blocking hit found
    ## @param  Start           Start location of the shape
    ## @param  End             End location of the shape
    ## @param  TraceChannel    The 'channel' that this trace is in, used to determine which components to hit
    ## @param	CollisionShape	CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## 	@param 	ResponseParam	ResponseContainer to be used for this trace
    ## @return TRUE if OutHits contains any blocking hit entries

  proc sweepSingleByObjectType(outHit: var FHitResult; start: FVector; `end`: FVector;
                              rot: FQuat;
                              objectQueryParams: FCollisionObjectQueryParams;
                              collisionShape: FCollisionShape;
                              params: FCollisionQueryParams = defaultQueryParam): bool {.
      noSideEffect.}
    ## Sweep a shape against the world and return the first blocking hit using object types
    ## @param  OutHit          First blocking hit found
    ## @param  Start           Start location of the shape
    ## @param  End             End location of the shape
    ## 	@param	ObjectQueryParams	List of object types it's looking for
    ## @param	CollisionShape	CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if any hit is found

  proc sweepSingleByProfile(outHit: var FHitResult; start: FVector; `end`: FVector;
                          rot: FQuat; profileName: FName;
                          collisionShape: FCollisionShape;
                          params: FCollisionQueryParams = defaultQueryParam): bool {.
      noSideEffect.}
    ## Sweep a shape against the world and return the first blocking hit using a specific profile
    ## @param  OutHit          First blocking hit found
    ## @param  Start           Start location of the shape
    ## @param  End             End location of the shape
    ## @param  ProfileName     The 'profile' used to determine which components to hit
    ## @param	CollisionShape	CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if OutHits contains any blocking hit entries

  proc sweepMultiByChannel(outHits: var TArray[FHitResult]; start: FVector;
                          `end`: FVector; rot: FQuat; traceChannel: ECollisionChannel;
                          collisionShape: FCollisionShape;
                          params: FCollisionQueryParams = defaultQueryParam;
      responseParam: FCollisionResponseParams = defaultResponseParam): bool {.
      noSideEffect.}
    ## Sweep a shape against the world and return all initial overlaps using a specific channel (including blocking) if requested, then overlapping hits and then first blocking hit
    ## Results are sorted, so a blocking hit (if found) will be the last element of the array
    ## Only the single closest blocking result will be generated, no tests will be done after that
    ## @param  OutHits         Array of hits found between ray and the world
    ## @param  Start           Start location of the shape
    ## @param  End             End location of the shape
    ## @param  TraceChannel    The 'channel' that this ray is in, used to determine which components to hit
    ## @param	CollisionShape	CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## 	@param 	ResponseParam	ResponseContainer to be used for this trace
    ## @return TRUE if OutHits contains any blocking hit entries

  proc sweepMultiByObjectType(outHits: var TArray[FHitResult]; start: FVector;
                            `end`: FVector; rot: FQuat;
                            objectQueryParams: FCollisionObjectQueryParams;
                            collisionShape: FCollisionShape;
                            params: FCollisionQueryParams = defaultQueryParam): bool {.
      noSideEffect.}
    ## Sweep a shape against the world and return all initial overlaps using object types (including blocking) if requested, then overlapping hits and then first blocking hit
    ## Results are sorted, so a blocking hit (if found) will be the last element of the array
    ## Only the single closest blocking result will be generated, no tests will be done after that
    ## @param  OutHits         Array of hits found between ray and the world
    ## @param  Start           Start location of the shape
    ## @param  End             End location of the shape
    ## 	@param	ObjectQueryParams	List of object types it's looking for
    ## @param	CollisionShape	CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if any hit is found

  proc sweepMultiByProfile(outHits: var TArray[FHitResult]; start: FVector;
                          `end`: FVector; rot: FQuat; profileName: FName;
                          collisionShape: FCollisionShape;
                          params: FCollisionQueryParams = defaultQueryParam): bool {.
      noSideEffect.}
    ## Sweep a shape against the world and return all initial overlaps using a specific profile, then overlapping hits and then first blocking hit
    ## Results are sorted, so a blocking hit (if found) will be the last element of the array
    ## Only the single closest blocking result will be generated, no tests will be done after that
    ## @param  OutHits         Array of hits found between ray and the world
    ## @param  Start           Start location of the shape
    ## @param  End             End location of the shape
    ## @param  ProfileName     The 'profile' used to determine which components to hit
    ## @param	CollisionShape	CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if OutHits contains any blocking hit entries

  proc overlapBlockingTestByChannel(pos: FVector; rot: FQuat;
                                  traceChannel: ECollisionChannel;
                                  collisionShape: FCollisionShape; params: FCollisionQueryParams = defaultQueryParam;
      responseParam: FCollisionResponseParams = defaultResponseParam): bool {.
      noSideEffect.}
    ## Test the collision of a shape at the supplied location using a specific channel, and return if any blocking overlap is found
    ## @param  Pos             Location of center of box to test against the world
    ## @param  TraceChannel    The 'channel' that this query is in, used to determine which components to hit
    ## @param  CollisionShape	CollisionShape - supports Box, Sphere, Capsule, Convex
    ## @param  Params          Additional parameters used for the trace
    ## @param  ResponseParam	ResponseContainer to be used for this trace
    ## @return TRUE if any blocking results are found

  proc overlapAnyTestByChannel(pos: FVector; rot: FQuat;
                              traceChannel: ECollisionChannel;
                              collisionShape: FCollisionShape;
                              params: FCollisionQueryParams = defaultQueryParam;
      responseParam: FCollisionResponseParams = defaultResponseParam): bool {.
      noSideEffect.}
    ## Test the collision of a shape at the supplied location using a specific channel, and return if any blocking or overlapping shape is found
    ## @param  Pos             Location of center of box to test against the world
    ## @param  TraceChannel    The 'channel' that this query is in, used to determine which components to hit
    ## @param  CollisionShape	CollisionShape - supports Box, Sphere, Capsule, Convex
    ## @param  Params          Additional parameters used for the trace
    ## @param  ResponseParam	ResponseContainer to be used for this trace
    ## @return TRUE if any blocking or overlapping results are found

  proc overlapAnyTestByObjectType(pos: FVector; rot: FQuat;
                                objectQueryParams: FCollisionObjectQueryParams;
                                collisionShape: FCollisionShape; params: FCollisionQueryParams = defaultQueryParam): bool {.
      noSideEffect.}
    ## Test the collision of a shape at the supplied location using object types, and return if any overlap is found
    ## @param  Pos             Location of center of box to test against the world
    ## @param  ObjectQueryParams	List of object types it's looking for
    ## @param  CollisionShape	CollisionShape - supports Box, Sphere, Capsule, Convex
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if any blocking results are found

  proc overlapBlockingTestByProfile(pos: FVector; rot: FQuat; profileName: FName;
                                  collisionShape: FCollisionShape; params: FCollisionQueryParams = defaultQueryParam): bool {.
      noSideEffect.}
    ## Test the collision of a shape at the supplied location using a specific profile, and return if any blocking overlap is found
    ## @param  Pos             Location of center of box to test against the world
    ## @param  ProfileName     The 'profile' used to determine which components to hit
    ## @param	CollisionShape	CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if any blocking results are found

  proc overlapAnyTestByProfile(pos: FVector; rot: FQuat; profileName: FName;
                              collisionShape: FCollisionShape;
                              params: FCollisionQueryParams = defaultQueryParam): bool {.
      noSideEffect.}
    ## Test the collision of a shape at the supplied location using a specific profile, and return if any blocking or overlap is found
    ## @param  Pos             Location of center of box to test against the world
    ## @param  ProfileName     The 'profile' used to determine which components to hit
    ## @param	CollisionShape	CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if any blocking or overlapping results are found

  proc overlapMultiByChannel(outOverlaps: var TArray[FOverlapResult]; pos: FVector;
                            rot: FQuat; traceChannel: ECollisionChannel;
                            collisionShape: FCollisionShape;
                            params: FCollisionQueryParams = defaultQueryParam;
      responseParam: FCollisionResponseParams = defaultResponseParam): bool {.
      noSideEffect.}
    ## Test the collision of a shape at the supplied location using a specific channel, and determine the set of components that it overlaps
    ## @param  OutOverlaps     Array of components found to overlap supplied box
    ## @param  Pos             Location of center of shape to test against the world
    ## @param  TraceChannel    The 'channel' that this query is in, used to determine which components to hit
    ## @param	CollisionShape	CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## 	@param 	ResponseParam	ResponseContainer to be used for this trace
    ## @return TRUE if OutOverlaps contains any blocking results

  proc overlapMultiByObjectType(outOverlaps: var TArray[FOverlapResult]; pos: FVector;
                              rot: FQuat;
                              objectQueryParams: FCollisionObjectQueryParams;
                              collisionShape: FCollisionShape;
                              params: FCollisionQueryParams = defaultQueryParam): bool {.
      noSideEffect.}
    ## Test the collision of a shape at the supplied location using object types, and determine the set of components that it overlaps
    ## @param  OutOverlaps     Array of components found to overlap supplied box
    ## @param  Pos             Location of center of shape to test against the world
    ## 	@param	ObjectQueryParams	List of object types it's looking for
    ## @param	CollisionShape	CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if any overlap is found

  proc overlapMultiByProfile(outOverlaps: var TArray[FOverlapResult]; pos: FVector;
                            rot: FQuat; profileName: FName;
                            collisionShape: FCollisionShape;
                            params: FCollisionQueryParams = defaultQueryParam): bool {.
      noSideEffect.}
    ## Test the collision of a shape at the supplied location using a specific profile, and determine the set of components that it overlaps
    ## @param  OutOverlaps     Array of components found to overlap supplied box
    ## @param  Pos             Location of center of shape to test against the world
    ## @param  ProfileName     The 'profile' used to determine which components to hit
    ## @param	CollisionShape	CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if OutOverlaps contains any blocking results

# COMPONENT SWEEP

  proc componentSweepMulti(outHits: var TArray[FHitResult];
                          primComp: ptr UPrimitiveComponent; start: FVector;
                          `end`: FVector; rot: FQuat; params: FComponentQueryParams): bool {.
      noSideEffect.}
    ## Sweep the geometry of the supplied component, and determine the set of components that it hits.
    ## @note The overload taking rotation as an FQuat is slightly faster than the version using FRotator (which will be converted to an FQuat)..
    ## @param  OutHits         Array of hits found between ray and the world
    ## @param  PrimComp        Component's geometry to test against the world. Transform of this component is ignored
    ## @param  Start           Start location of the trace
    ## @param  End             End location of the trace
    ## @param  Rot             Rotation of PrimComp geometry for test against the world (rotation remains constant over sweep)
    ## @param  Params          Additional parameters used for the trace
    ## @return TRUE if OutHits contains any blocking hit entries
  proc componentSweepMulti(outHits: var TArray[FHitResult];
                          primComp: ptr UPrimitiveComponent; start: FVector;
                          `end`: FVector; rot: FRotator; params: FComponentQueryParams): bool {.
      noSideEffect.}

# COMPONENT OVERLAP

  proc componentOverlapMulti(outOverlaps: var TArray[FOverlapResult];
                            primComp: ptr UPrimitiveComponent; pos: FVector;
                            rot: FQuat; params: FComponentQueryParams = defaultComponentQueryParams;
      objectQueryParams: FCollisionObjectQueryParams = defaultObjectQueryParam): bool {.
      noSideEffect.}
    ## Test the collision of the supplied component at the supplied location/rotation using object types, and determine the set of components that it overlaps
    ## @note The overload taking rotation as an FQuat is slightly faster than the version using FRotator (which will be converted to an FQuat)..
    ## @param  OutOverlaps     Array of overlaps found between component in specified pose and the world
    ## @param  PrimComp        Component's geometry to test against the world. Transform of this component is ignored
    ## @param  Pos             Location of PrimComp geometry for test against the world
    ## @param  Rot             Rotation of PrimComp geometry for test against the world
    ## 	@param	ObjectQueryParams	List of object types it's looking for. When this enters, we do object query with component shape
    ## @return TRUE if any hit is found

  proc componentOverlapMulti(outOverlaps: var TArray[FOverlapResult];
                            primComp: ptr UPrimitiveComponent; pos: FVector;
                            rot: FRotator; params: FComponentQueryParams = defaultComponentQueryParams;
      objectQueryParams: FCollisionObjectQueryParams = defaultObjectQueryParam): bool {.
      noSideEffect.}

  proc componentOverlapMultiByChannel(outOverlaps: var TArray[FOverlapResult];
                                    primComp: ptr UPrimitiveComponent; pos: FVector;
                                    rot: FQuat; traceChannel: ECollisionChannel;
      params: FComponentQueryParams = defaultComponentQueryParams; objectQueryParams: FCollisionObjectQueryParams = defaultObjectQueryParam): bool {.
      noSideEffect.}
    ## Test the collision of the supplied component at the supplied location/rotation using a specific channel, and determine the set of components that it overlaps
    ## @note The overload taking rotation as an FQuat is slightly faster than the version using FRotator (which will be converted to an FQuat)..
    ## @param  OutOverlaps     Array of overlaps found between component in specified pose and the world
    ## @param  PrimComp        Component's geometry to test against the world. Transform of this component is ignored
    ## @param  Pos             Location of PrimComp geometry for test against the world
    ## @param  Rot             Rotation of PrimComp geometry for test against the world
    ## @param  TraceChannel	The 'channel' that this query is in, used to determine which components to hit
    ## @return TRUE if OutOverlaps contains any blocking results

  proc componentOverlapMultiByChannel(outOverlaps: var TArray[FOverlapResult];
                                    primComp: ptr UPrimitiveComponent; pos: FVector;
                                    rot: FRotator; traceChannel: ECollisionChannel;
      params: FComponentQueryParams = defaultComponentQueryParams; objectQueryParams: FCollisionObjectQueryParams = defaultObjectQueryParam): bool {.
      noSideEffect.}

  proc asyncLineTraceByChannel(start: FVector; `end`: FVector;
                              traceChannel: ECollisionChannel;
                              params: FCollisionQueryParams = defaultQueryParam;
      responseParam: FCollisionResponseParams = defaultResponseParam;
                              inDelegate: ptr FTraceDelegate = nil;
                              userData: uint32 = 0; bMultiTrace: bool = false): FTraceHandle

  proc asyncLineTraceByObjectType(start: FVector; `end`: FVector;
                                  objectQueryParams: FCollisionObjectQueryParams;
                                  params: FCollisionQueryParams = defaultQueryParam;
                                  inDelegate: ptr FTraceDelegate = nil;
                                  userData: uint32 = 0; bMultiTrace: bool = false): FTraceHandle
    ## Interface for Async. Pretty much same parameter set except you can optional set delegate to be called when execution is completed and you can set UserData if you'd like
    ## if no delegate, you can query trace data using QueryTraceData or QueryOverlapData
    ## the data is available only in the next frame after request is made - in other words, if request is made in frame X, you can get the result in frame (X+1)
    ##
    ## @param  Start           Start location of the ray
    ## @param  End             End location of the ray
    ## 	@param	ObjectQueryParams	List of object types it's looking for
    ## @param  Params          Additional parameters used for the trace
    ## 	@param	InDeleagte		Delegate function to be called - to see example, search FTraceDelegate
    ## 							Example can be void MyActor::TraceDone(const FTraceHandle& TraceHandle, FTraceDatum & TraceData)
    ## 							Before sending to the function,
    ##
    ## 							FTraceDelegate TraceDelegate;
    ## 							TraceDelegate.BindRaw(this, &MyActor::TraceDone);
    ##
    ## 	@param	UserData		UserData
    ## 	@param bMultiTrace		true if you'd like to get continuous result from the trace, false if you want single

  proc asyncSweepByChannel(start: FVector; `end`: FVector;
                           traceChannel: ECollisionChannel;
                           collisionShape: FCollisionShape;
                           params: FCollisionQueryParams = defaultQueryParam;
                           responseParam: FCollisionResponseParams = defaultResponseParam;
                           inDelegate: ptr FTraceDelegate = nil; userData: uint32 = 0;
                           bMultiTrace: bool = false): FTraceHandle
    ## Interface for Async trace
    ## Pretty much same parameter set except you can optional set delegate to be called when execution is completed and you can set UserData if you'd like
    ## if no delegate, you can query trace data using QueryTraceData or QueryOverlapData
    ## the data is available only in the next frame after request is made - in other words, if request is made in frame X, you can get the result in frame (X+1)
    ##
    ## @param  Start           Start location of the shape
    ## @param  End             End location of the shape
    ## @param  TraceChannel    The 'channel' that this trace is in, used to determine which components to hit
    ## @param	CollisionShape		CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## 	@param 	ResponseParam	ResponseContainer to be used for this trace
    ## 	@param	InDeleagte		Delegate function to be called - to see example, search FTraceDelegate
    ## 							Example can be void MyActor::TraceDone(const FTraceHandle& TraceHandle, FTraceDatum & TraceData)
    ## 							Before sending to the function,
    ##
    ## 							FTraceDelegate TraceDelegate;
    ## 							TraceDelegate.BindRaw(this, &MyActor::TraceDone);
    ##
    ## 	@param	UserData		UserData
    ## 	@param bMultiTrace		true if you'd like to get continuous result from the trace, false if you want single

  proc asyncSweepByObjectType(start: FVector; `end`: FVector;
                              objectQueryParams: FCollisionObjectQueryParams;
                              collisionShape: FCollisionShape;
                              params: FCollisionQueryParams = defaultQueryParam;
                              inDelegate: ptr FTraceDelegate = nil;
                              userData: uint32 = 0; bMultiTrace: bool = false): FTraceHandle
    ## Interface for Async trace
    ## Pretty much same parameter set except you can optional set delegate to be called when execution is completed and you can set UserData if you'd like
    ## if no delegate, you can query trace data using QueryTraceData or QueryOverlapData
    ## the data is available only in the next frame after request is made - in other words, if request is made in frame X, you can get the result in frame (X+1)
    ##
    ## @param  Start           Start location of the shape
    ## @param  End             End location of the shape
    ## 	@param	ObjectQueryParams	List of object types it's looking for
    ## @param	CollisionShape		CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## 	@param	InDeleagte		Delegate function to be called - to see example, search FTraceDelegate
    ## 							Example can be void MyActor::TraceDone(const FTraceHandle& TraceHandle, FTraceDatum & TraceData)
    ## 							Before sending to the function,
    ##
    ## 							FTraceDelegate TraceDelegate;
    ## 							TraceDelegate.BindRaw(this, &MyActor::TraceDone);
    ##
    ## 	@param	UserData		UserData
    ## 	@param bMultiTrace		true if you'd like to get continuous result from the trace, false if you want single

# overlap functions

  proc asyncOverlapByChannel(pos: FVector; rot: FQuat; traceChannel: ECollisionChannel;
                            collisionShape: FCollisionShape;
                            params: FCollisionQueryParams = defaultQueryParam;
      responseParam: FCollisionResponseParams = defaultResponseParam;
                            inDelegate: ptr FOverlapDelegate = nil;
                            userData: uint32 = 0): FTraceHandle
    ## Interface for Async trace
    ## Pretty much same parameter set except you can optional set delegate to be called when execution is completed and you can set UserData if you'd like
    ## if no delegate, you can query trace data using QueryTraceData or QueryOverlapData
    ## the data is available only in the next frame after request is made - in other words, if request is made in frame X, you can get the result in frame (X+1)
    ##
    ## @param  Pos             Location of center of shape to test against the world
    ## 	@param	bMultiTrace		true if you'd like to do multi trace, or false otherwise
    ## @param  TraceChannel    The 'channel' that this query is in, used to determine which components to hit
    ## @param	CollisionShape		CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## 	@param 	ResponseParam	ResponseContainer to be used for this trace
    ## 	@param	InDeleagte		Delegate function to be called - to see example, search FTraceDelegate
    ## 							Example can be void MyActor::TraceDone(const FTraceHandle& TraceHandle, FTraceDatum & TraceData)
    ## 							Before sending to the function,
    ##
    ## 							FTraceDelegate TraceDelegate;
    ## 							TraceDelegate.BindRaw(this, &MyActor::TraceDone);
    ##
    ## 	@param UserData			UserData

  proc asyncOverlapByObjectType(pos: FVector; rot: FQuat;
                              objectQueryParams: FCollisionObjectQueryParams;
                              collisionShape: FCollisionShape;
                              params: FCollisionQueryParams = defaultQueryParam;
                              inDelegate: ptr FOverlapDelegate = nil;
                              userData: uint32 = 0): FTraceHandle
    ## Interface for Async trace
    ## Pretty much same parameter set except you can optional set delegate to be called when execution is completed and you can set UserData if you'd like
    ## if no delegate, you can query trace data using QueryTraceData or QueryOverlapData
    ## the data is available only in the next frame after request is made - in other words, if request is made in frame X, you can get the result in frame (X+1)
    ##
    ## @param  Pos             Location of center of shape to test against the world
    ## 	@param	ObjectQueryParams	List of object types it's looking for
    ## @param	CollisionShape		CollisionShape - supports Box, Sphere, Capsule
    ## @param  Params          Additional parameters used for the trace
    ## 	@param	InDeleagte		Delegate function to be called - to see example, search FTraceDelegate
    ## 							Example can be void MyActor::TraceDone(const FTraceHandle& TraceHandle, FTraceDatum & TraceData)
    ## 							Before sending to the function,
    ##
    ## 							FTraceDelegate TraceDelegate;
    ## 							TraceDelegate.BindRaw(this, &MyActor::TraceDone);
    ##
    ## 	@param UserData			UserData

  proc queryTraceData(handle: FTraceHandle; outData: var FTraceDatum): bool
    ## Query function
    ## return true if already done and returning valid result - can be hit or no hit
    ## return false if either expired or not yet evaluated or invalid
    ## Use IsTraceHandleValid to find out if valid and to be evaluated

  proc queryOverlapData(handle: FTraceHandle; outData: var FOverlapDatum): bool
    ## Query function
    ## return true if already done and returning valid result - can be hit or no hit
    ## return false if either expired or not yet evaluated or invalid
    ## Use IsTraceHandleValid to find out if valid and to be evaluated

  proc isTraceHandleValid(handle: FTraceHandle; bOverlapTrace: bool): bool
    ## See if TraceHandle is still valid or not
    ##
    ## @param	Handle			TraceHandle that was returned when request Trace
    ## @param	bOverlapTrace	true if this is overlap test Handle, not trace test handle
    ##
    ## return true if it will be evaluated OR it has valid result
    ## return false if it already has expired Or not valid

  proc getNavigationSystem(): ptr UNavigationSystem
    ## NavigationSystem getter

  proc createAISystem(): ptr UAISystemBase
    ## AISystem getter. if AISystem is missing it tries to create one and returns the result.
    ## 	@NOTE the result can be NULL, for example on client games or if no AI module or AISystem class have not been specified
    ## 	@see UAISystemBase::AISystemClassName and UAISystemBase::AISystemModuleName

  proc getAISystem(): ptr UAISystemBase
    ## AISystem getter

  proc getAvoidanceManager(): ptr UAvoidanceManager
    ## Avoidance manager getter

  proc getNumPawns(): int32 {.noSideEffect.}


  proc getFirstPlayerController(): ptr APlayerController {.noSideEffect.}
    ## @return Returns the first player controller, or NULL if there is not one.

  proc getFirstLocalPlayerFromController(): ptr ULocalPlayer {.noSideEffect.}
    ## 	Get the first valid local player via the first player controller.
    ##
    ## @return Pointer to the first valid ULocalPlayer, or NULL if there is not one.

  proc registerAutoActivateCamera(cameraActor: ptr ACameraActor; playerIndex: int32)
    ## Register a CameraActor that auto-activates for a PlayerController.

  proc getGameViewport(): ptr UGameViewportClient {.noSideEffect.}
    ## Returns a reference to the game viewport displaying this world if one exists.

# public:

  proc getDefaultBrush(): ptr ABrush {.noSideEffect.}
    ## Returns the default brush for the persistent level.
    ## This is usually the 'builder brush' for editor builds, undefined for non editor instances and may be NULL.

  proc areActorsInitialized(): bool {.noSideEffect.}
    ## Returns true if the actors have been initialized and are ready to start play

  proc hasBegunPlay(): bool {.noSideEffect.}
    ## Returns true if gameplay has already started, false otherwise.

  proc getTimeSeconds(): cfloat {.noSideEffect.}
    ## Returns time in seconds since world was brought up for play, IS stopped when game pauses, IS dilated/clamped
    ##
    ## @return time in seconds since world was brought up for play

  proc getRealTimeSeconds(): cfloat {.noSideEffect.}
    ## Returns time in seconds since world was brought up for play, does NOT stop when game pauses, NOT dilated/clamped
    ##
    ## @return time in seconds since world was brought up for play

  proc getAudioTimeSeconds(): cfloat {.noSideEffect.}
    ## Returns time in seconds since world was brought up for play, IS stopped when game pauses, NOT dilated/clamped
    ##
    ## @return time in seconds since world was brought up for play

  proc getDeltaSeconds(): cfloat {.noSideEffect.}
    ## Returns the frame delta time in seconds adjusted by e.g. time dilation.
    ##
    ## @return frame delta time in seconds adjusted by e.g. time dilation

  proc timeSince(time: cfloat): cfloat {.noSideEffect.}
    ## Helper for getting the time since a certain time.

  proc createPhysicsScene()
    ## Creates a new physics scene for this world.

  proc getPhysicsScene(): ptr FPhysScene {.noSideEffect.}
    ## Returns a pointer to the physics scene for this world.

  proc setPhysicsScene(inScene: ptr FPhysScene)
    ## Set the physics scene to use by this world

  proc getDefaultPhysicsVolume(): ptr APhysicsVolume {.noSideEffect.}
    ## Returns the default physics volume and creates it if necessary.
    ##
    ## @return default physics volume

  proc hasDefaultPhysicsVolume(): bool {.noSideEffect.}
    ## Returns true if a DefaultPhysicsVolume has been created.

  proc addPhysicsVolume(volume: ptr APhysicsVolume)
    ## Add a physics volume to the list of those in the world. DefaultPhysicsVolume is not tracked. Used internally by APhysicsVolume.

  proc removePhysicsVolume(volume: ptr APhysicsVolume)
    ## Removes a physics volume from the list of those in the world.

  proc getNonDefaultPhysicsVolumeCount(): int32 {.noSideEffect.}
    ## Get the count of all PhysicsVolumes in the world that are not a DefaultPhysicsVolume.

  proc getLevelScriptActor(ownerLevel: ptr ULevel = nil): ptr ALevelScriptActor {.
      noSideEffect.}
    ## Returns the current (or specified) level's level scripting actor
    ##
    ## @param	OwnerLevel	the level to get the level scripting actor for.  Must correspond to one of the levels in GWorld's Levels array;
    ## 						Thus, only applicable when editing a multi-level map.  Defaults to the level currently being edited.
    ##
    ## @return	A pointer to the level scripting actor, if any, for the specified level, or NULL if no level scripting actor is available

  proc getWorldSettings(bCheckStreamingPesistent: bool = false; bChecked: bool = true): ptr AWorldSettings {.
      noSideEffect.}
    ## Returns the AWorldSettings actor associated with this world.
    ##
    ## @return AWorldSettings actor associated with this world

  proc getModel(): ptr UModel {.noSideEffect.}
    ## Returns the current levels BSP model.
    ##
    ## @return BSP UModel

  proc getGravityZ(): cfloat {.noSideEffect.}
    ## Returns the Z component of the current world gravity.
    ##
    ## @return Z component of current world gravity.

  proc getDefaultGravityZ(): cfloat {.noSideEffect.}
    ## Returns the Z component of the default world gravity.
    ##
    ## @return Z component of the default world gravity.

  proc getMapName(): FString {.noSideEffect.}
    ## Returns the name of the current map, taking into account using a dummy persistent world
    ## and loading levels into it via PrepareMapChange.
    ##
    ## @return	name of the current map

  proc requiresHitProxies(): bool {.noSideEffect.}
    ## Accessor for bRequiresHitProxies.

  proc addController(controller: ptr AController)
    ## Inserts the passed in controller at the front of the linked list of controllers.
    ##
    ## @param	Controller	Controller to insert, use NULL to clear list

  proc removeController(controller: ptr AController)
    ## Removes the passed in controller from the linked list of controllers.
    ##
    ## @param	Controller	Controller to remove

  proc addPawn(pawn: ptr APawn)
    ## Inserts the passed in pawn at the front of the linked list of pawns.
    ##
    ## @param	Pawn	Pawn to insert, use NULL to clear list

  proc removePawn(pawn: ptr APawn)
    ## Removes the passed in pawn from the linked list of pawns.
    ##
    ## @param	Pawn	Pawn to remove

  proc addNetworkActor(actor: ptr AActor)
    ## Adds the passed in actor to the special network actor list
    ## This list is used to specifically single out actors that are relevant for networking without having to scan the much large list
    ## @param	Actor	Actor to add

  proc removeNetworkActor(actor: ptr AActor)
    ## Removes the passed in actor to from special network actor list
    ## @param	Actor	Actor to remove

  # TODO: interface these
  # ## Add a listener for OnActorSpawned events

  # proc addOnActorSpawnedHandler(inHandler: FDelegate): FDelegateHandle
  # ## Remove a listener for OnActorSpawned events

  # proc removeOnActorSpawnedHandler(inHandle: FDelegateHandle)

  proc containsActor(actor: ptr AActor): bool
    ## Returns whether the passed in actor is part of any of the loaded levels actors array.
    ## Warning: Will return true for pending kill actors!
    ##
    ## @param	Actor	Actor to check whether it is contained by any level
    ##
    ## @return	true if actor is contained by any of the loaded levels, false otherwise

  proc allowAudioPlayback(): bool
    ## Returns whether audio playback is allowed for this scene.
    ##
    ## @return true if current world is GWorld, false otherwise

  proc clearWorldComponents()
    ## Clears all level components and world components like e.g. line batcher.

  proc updateWorldComponents(bRerunConstructionScripts: bool; bCurrentLevelOnly: bool)
    ## Updates world components like e.g. line batcher and all level components.
    ##
    ## @param	bRerunConstructionScripts	If we should rerun construction scripts on actors
    ## @param	bCurrentLevelOnly			If true, affect only the current level.

  proc updateCullDistanceVolumes(actorToUpdate: ptr AActor = nil; componentToUpdate: ptr UPrimitiveComponent = nil)
    ## Updates cull distance volumes for a specified component or a specified actor or all actors
    ##       @param ComponentToUpdate If specified just that Component will be updated
    ## @param ActorToUpdate If specified (and ComponentToUpdate is not specified), all Components owned by this Actor will be updated

  proc cleanupWorld(bSessionEnded: bool = true; bCleanupResources: bool = true;
                    newWorld: ptr UWorld = nil)
    ## Cleans up components, streaming data and assorted other intermediate data.
    ## @param bSessionEnded whether to notify the viewport that the game session has ended
    ## @param NewWorld Optional new world that will be loaded after this world is cleaned up. Specify a new world to prevent it and it's sublevels from being GCed during map transitions.

  proc invalidateModelGeometry(inLevel: ptr ULevel)
    ## Invalidates the cached data used to render the levels' UModel.
    ##
    ## @param	InLevel		Level to invalidate. If this is NULL it will affect ALL levels

  proc invalidateModelSurface(bCurrentLevelOnly: bool)
    ## Discards the cached data used to render the levels' UModel.  Assumes that the
    ## faces and vertex positions haven't changed, only the applied materials.
    ##
    ## @param	bCurrentLevelOnly		If true, affect only the current level.

  proc commitModelSurfaces()
    ## Commits changes made to the surfaces of the UModels of all levels.

  proc updateAllReflectionCaptures()
    ## Purges all reflection capture cached derived data and forces a re-render of captured scene data.

  proc updateAllSkyCaptures()
    ## Purges all sky capture cached derived data and forces a re-render of captured scene data.

  proc addToWorld(level: ptr ULevel; levelTransform: FTransform = identityTransform)
    ## Associates the passed in level with the world. The work to make the level visible is spread across several frames and this
    ## function has to be called till it returns true for the level to be visible/ associated with the world and no longer be in
    ## a limbo state.
    ##
    ## @param Level				Level object we should add
    ## @param LevelTransform	Transformation to apply to each actor in the level

  proc removeFromWorld(level: ptr ULevel)
    ## Dissociates the passed in level from the world. The removal is blocking.
    ##
    ## @param Level			Level object we should remove

  proc updateLevelStreaming()
    ## Updates sub-levels (load/unload/show/hide) using streaming levels current state

# public:

  proc flushLevelStreaming(flushType: EFlushLevelStreamingType = EFlushLevelStreamingType.Full)
    ## Flushes level streaming in blocking fashion and returns when all levels are loaded/ visible/ hidden
    ## so further calls to UpdateLevelStreaming won't do any work unless state changes. Basically blocks
    ## on all async operation like updating components.
    ##
    ## @param FlushType					Whether to only flush level visibility operations (optional)

  proc triggerStreamingDataRebuild()
    ## Triggers a call to ULevel::BuildStreamingData(this,NULL,NULL) within a few seconds.

  proc conditionallyBuildStreamingData()
    ## Calls ULevel::BuildStreamingData(this,NULL,NULL) if it has been triggered within the last few seconds.

  proc isVisibilityRequestPending(): bool {.noSideEffect.}
    ## @return whether there is at least one level with a pending visibility request

  proc areAlwaysLoadedLevelsLoaded(): bool {.noSideEffect.}
    ## Returns whether all the 'always loaded' levels are loaded.

  proc allowLevelLoadRequests(): bool
    ## Returns whether the level streaming code is allowed to issue load requests.
    ##
    ## @return true if level load requests are allowed, false otherwise.

  proc setupParameterCollectionInstances()
    ## Creates instances for each parameter collection in memory.  Called when a world is created.

  proc addParameterCollectionInstance(collection: ptr UMaterialParameterCollection;
                                      bUpdateScene: bool)
    ## Adds a new instance of the given collection, or overwrites an existing instance if there is one.

  proc getParameterCollectionInstance(collection: ptr UMaterialParameterCollection): ptr UMaterialParameterCollectionInstance
    ## Gets this world's instance for a given collection.

  proc updateParameterCollectionInstances(bUpdateInstanceUniformBuffers: bool)
    ## Updates this world's scene with the list of instances, and optionally updates each instance's uniform buffer.

  proc initWorld(ivs = initWorldInitializationValues())
    ## Initializes the world, associates the persistent level and sets the proper zones.


  proc initializeNewWorld(ivs = initWorldInitializationValues())
    ## Initializes a newly created world.

  proc createWorld(inWorldType: EWorldType; bInformEngineOfWorld: bool;
                   worldName: FName = NAME_None; inWorldPackage: ptr UPackage = nil;
                   bAddToRoot: bool = true;
                   inFeatureLevel: ERHIFeatureLevel = ERHIFeatureLevel.Num): ptr UWorld
    ## Static function that creates a new UWorld and returns a pointer to it

  proc destroyWorld(bInformEngineOfWorld: bool; newWorld: ptr UWorld = nil)
    ## Destroy this World instance. If destroying the world to load a different world, supply it here to prevent GC of the new world or it's sublevels.

  proc markObjectsPendingKill()
    ## Marks all objects that have this World as an Outer as pending kill

  proc performGarbageCollectionAndCleanupActors()
    ## Interface to allow WorldSettings to request immediate garbage collection

  proc delayGarbageCollection()
    ## Requests a one frame delay of Garbage Collection

  proc cleanupActors()
    ## 	Remove NULL entries from actor list. Only does so for dynamic actors to avoid resorting.
    ## 	In theory static actors shouldn't be deleted during gameplay.

# public:

  proc onTickDispatch(): var FOnNetTickEvent
    ## Get the event that broadcasts TickDispatch

  proc onTickFlush(): var FOnNetTickEvent
    ## Get the event that broadcasts TickFlush

  proc onPostTickFlush(): var FOnTickFlushEvent
    ## Get the event that broadcasts TickFlush

  proc tick(tickType: ELevelTick; deltaSeconds: cfloat)
    ## Update the level after a variable amount of time, DeltaSeconds, has passed.
    ## All child actors are ticked after their owners have been ticked.

  proc setupPhysicsTickFunctions(deltaSeconds: cfloat)
    ## Set up the physics tick function if they aren't already

  proc runTickGroup(group: ETickingGroup; bBlockTillComplete: bool)
    ## Run a tick group, ticking all actors and components
    ## @param Group - Ticking group to run
    ## @param bBlockTillComplete - if true, do not return until all ticks are complete

  proc markActorComponentForNeededEndOfFrameUpdate(component: ptr UActorComponent;
      bForceGameThread: bool)
    ## Mark a component as needing an end of frame update
    ## @param Component - Component to update at the end of the frame
    ## @param bForceGameThread - if true, force this to happen on the game thread

  proc updateActorComponentEndOfFrameUpdateState(component: ptr UActorComponent) {.
      noSideEffect.}
    ## Updates an ActorComponent's cached state of whether it has been marked for end of frame update based on the current
    ## state of the World's NeedsEndOfFrameUpdate arrays
    ## @param Component - Component to update the cached state of

  proc sendAllEndOfFrameUpdates()
    ## Send all render updates to the rendering thread.

  proc tickNetClient(deltaSeconds: cfloat)
    ## Do per frame tick behaviors related to the network driver

  proc processLevelStreamingVolumes(overrideViewLocation: ptr FVector = nil)
    ## Issues level streaming load/unload requests based on whether
    ## local players are inside/outside level streaming volumes.
    ##
    ## @param OverrideViewLocation Optional position used to override the location used to calculate current streaming volumes

  proc modifyLevel(level: ptr ULevel)
    ## Transacts the specified level -- the correct way to modify a level
    ## as opposed to calling Level->Modify.

  proc ensureCollisionTreeIsBuilt()
    ## Ensures that the collision detection tree is fully built. This should be called after the full level reload to make sure
    ## the first traces are not abysmally slow.

# when WITH_EDITOR:

  proc onSelectedLevelsChanged(): var FOnSelectedLevelsChangedEvent
    ## Returns the SelectedLevelsChangedEvent member.
  proc selectLevel(inLevel: ptr ULevel)
    ## Flag a level as selected.
  proc deSelectLevel(inLevel: ptr ULevel)
    ## Flag a level as not selected.
  proc isLevelSelected(inLevel: ptr ULevel): bool {.noSideEffect.}
    ## Query whether or not a level is selected.
  proc setSelectedLevels(inLevels: TArray[ptr ULevel])
    ## Set the selected levels from the given array (Clears existing selections)
  proc getNumSelectedLevels(): int32 {.noSideEffect.}
    ## Return the number of levels in this world.
  proc getSelectedLevel(inLevelIndex: int32): ptr ULevel {.noSideEffect.}
    ## Return the selected level with the given index.
  proc getSelectedLevels(): var TArray[ptr ULevel]
    ## Return the list of selected levels in this world.
  proc shrinkLevel()
    ## Shrink level elements to their minimum size.
# endwhen

  proc getLevel(inLevelIndex: int32): ptr ULevel {.noSideEffect.}
    ## Returns an iterator for the level list.

  proc containsLevel(inLevel: ptr ULevel): bool {.noSideEffect.}
    ## Does the level list contain the given level.

  proc getNumLevels(): int32 {.noSideEffect.}
    ## Return the number of levels in this world.

  proc getLevels(): var TArray[ptr ULevel] {.noSideEffect.}
    ## Return the list of levels in this world.

  proc addLevel(inLevel: ptr ULevel): bool
    ## Add a level to the level list.

  proc removeLevel(inLevel: ptr ULevel): bool
    ## Remove a level from the level list.

  proc exec(inWorld: ptr UWorld; cmd: wstring; ar: var FOutputDevice = gLog[]): bool
    ## Handle Exec/Console Commands related to the World

# public:

  proc destroyDemoNetDriver()
    ## Destroys the current demo net driver

  proc listen(inURL: var FURL): bool
    ## Start listening for connections.

  proc isClient(): bool
    ## @return true if this level is a client

  proc isServer(): bool
    ## @return true if this level is a server

  proc isPaused(): bool
    ## @return true if the world is in the paused state

  proc editorDestroyActor(actor: ptr AActor; bShouldModifyLevel: bool): bool
    ## Wrapper for DestroyActor() that should be called in the editor.
    ##
    ## @param	bShouldModifyLevel		If true, Modify() the level before removing the actor.

  proc destroyActor(actor: ptr AActor; bNetForce: bool = false;
                  bShouldModifyLevel: bool = true): bool
    ## Removes the actor from its level's actor list and generally cleans up the engine's internal state.
    ## What this function does not do, but is handled via garbage collection instead, is remove references
    ## to this actor from all other actors, and kill the actor's resources.  This function is set up so that
    ## no problems occur even if the actor is being destroyed inside its recursion stack.
    ##
    ## @param	ThisActor				Actor to remove.
    ## @param	bNetForce				[opt] Ignored unless called during play.  Default is false.
    ## @param	bShouldModifyLevel		[opt] If true, Modify() the level before removing the actor.  Default is true.
    ## @return							true if destroyed or already marked for destruction, false if actor couldn't be destroyed.

  proc removeActor(actor: ptr AActor; bShouldModifyLevel: bool)
    ## Removes the passed in actor from the actor lists. Please note that the code actually doesn't physically remove the
    ## index but rather clears it so other indices are still valid and the actors array size doesn't change.
    ##
    ## @param	Actor					Actor to remove.
    ## @param	bShouldModifyLevel		If true, Modify() the level before removing the actor if in the editor.

  proc spawnActor(inClass: ptr UClass; location: ptr FVector = nil;
                rotation: ptr FRotator = nil;
                spawnParameters = initFActorSpawnParameters()): ptr AActor
    ## Spawn Actors with given transform and SpawnParameters
    ##
    ## @param	Class					Class to Spawn
    ## @param	Location				Location To Spawn
    ## @param	Rotation				Rotation To Spawn
    ## @param	SpawnParameters			Spawn Parameters
    ##
    ## @return	Actor that just spawned

  proc spawnActor(class: ptr UClass; transform: ptr FTransform;
                spawnParameters = initFActorSpawnParameters()): ptr AActor
    ## Spawn Actors with given transform and SpawnParameters
    ##
    ## @param	Class					Class to Spawn
    ## @param	Transform				World Transform to spawn on
    ## @param	SpawnParameters			Spawn Parameters
    ##
    ## @return	Actor that just spawned

  proc spawnActorAbsolute(class: ptr UClass; absoluteTransform: FTransform;
      spawnParameters = initFActorSpawnParameters()): ptr AActor
    ## Spawn Actors with given absolute transform (override root component transform) and SpawnParameters
    ##
    ## @param	Class					Class to Spawn
    ## @param	AbsoluteTransform		World Transform to spawn on - without considering CDO's relative transform, thus Absolute
    ## @param	SpawnParameters			Spawn Parameters
    ##
    ## @return	Actor that just spawned

  proc getAuthGameMode[T](): ptr T {.cppname: "#.GetAuthGameMode<'*0>()"noSideEffect.}
    ## Returns the current GameMode instance cast to the template type.
    ## This can only return a valid pointer on the server. Will always return null on a client

  # proc getAuthGameMode(): ptr AGameMode {.noSideEffect.}
  #   ## Returns the current GameMode instance.
  #   ## This can only return a valid pointer on the server. Will always return null on a client

  proc getGameState[t](): ptr t {.noSideEffect.}
    ## Returns the current GameState instance cast to the template type.

  proc getGameState(): ptr AGameState {.noSideEffect.}
    ## Returns the current GameState instance.

  proc copyGameState(fromGameMode: ptr AGameMode; fromGameState: ptr AGameState)
    ## Copies GameState properties from the GameMode.

  proc spawnBrush(): ptr ABrush
    ## Spawns a Brush Actor in the World

  proc spawnPlayActor(player: ptr UPlayer; remoteRole: ENetRole; inURL: FURL;
                    uniqueId: TSharedPtr[FUniqueNetId]; error: var FString;
                    inNetPlayerIndex: uint8 = 0): ptr APlayerController
    ## Spawns a PlayerController and binds it to the passed in Player with the specified RemoteRole and options
    ##
    ## @param Player - the Player to set on the PlayerController
    ## @param RemoteRole - the RemoteRole to set on the PlayerController
    ## @param URL - URL containing player options (name, etc)
    ## @param UniqueId - unique net ID of the player (may be zeroed if no online subsystem or not logged in, e.g. a local game or LAN match)
    ## @param Error (out) - if set, indicates that there was an error - usually is set to a property from which the calling code can look up the actual message
    ## @param InNetPlayerIndex (optional) - the NetPlayerIndex to set on the PlayerController
    ## @return the PlayerController that was spawned (may fail and return NULL)

  proc findTeleportSpot(testActor: ptr AActor; placeLocation: var FVector;
                      placeRotation: FRotator): bool
    ## Try to find an acceptable position to place TestActor as close to possible to PlaceLocation.
    ## Expects PlaceLocation to be a valid location inside the level.

  proc encroachingBlockingGeometry(testActor: ptr AActor; testLocation: FVector;
                                  testRotation: FRotator;
                                  proposedAdjustment: ptr FVector = nil): bool
    ## @Return true if Actor would encroach at TestLocation on something that blocks it.
    ## Returns a ProposedAdjustment that might result in an unblocked TestLocation.

  proc startPhysicsSim()
    ## Begin physics simulation

  proc finishPhysicsSim()
    ## Waits for the physics scene to be done processing

  proc setGameMode(inURL: FURL): bool
    ## Spawns GameMode for the level.

  proc initializeActorsForPlay(inURL: FURL; bResetTime: bool = true)
    ## Initializes all actors and prepares them to start gameplay
    ## @param InURL commandline URL
    ## @param bResetTime (optional) whether the WorldSettings's TimeSeconds should be reset to zero

  proc beginPlay()
    ## Start gameplay. This will cause the game mode to transition to the correct state and call BeginPlay on all actors

  proc destroySwappedPC(connection: ptr UNetConnection): bool
    ## Looks for a PlayerController that was being swapped by the given NetConnection and, if found, destroys it
    ## (because the swap is complete or the connection was closed)
    ## @param Connection - the connection that performed the swap
    ## @return whether a PC waiting for a swap was found

  #~ Begin FNetworkNotify Interface

  # TODO: networking
  # proc notifyAcceptingConnection(): EAcceptConnection
  # proc notifyAcceptedConnection(connection: ptr UNetConnection)
  # proc notifyAcceptingChannel(channel: ptr UChannel): bool
  # proc notifyControlMessage(connection: ptr UNetConnection; messageType: uint8;
  #                         bunch: var FInBunch)
  #~ End FNetworkNotify Interface

  proc welcomePlayer(connection: ptr UNetConnection)
    ## Welcome a new player joining this server.

  proc getNetDriver(): ptr UNetDriver {.noSideEffect.}
    ## Used to get a net driver object by name. Default name is the game net driver
    ## @param NetDriverName the name of the net driver being asked for
    ## @return a pointer to the net driver or NULL if the named driver is not found

  proc getNetMode(): ENetMode {.noSideEffect.}
    ## Returns the net mode this world is running under
# when WITH_EDITOR:
  proc attemptDeriveFromPlayInSettings(): ENetMode {.noSideEffect.}
    ## Attempts to derive the net mode from PlayInSettings for PIE
# endwhen

  proc attemptDeriveFromURL(): ENetMode {.noSideEffect.}
    ## Attempts to derive the net mode from URL

  proc setNetDriver(newDriver: ptr UNetDriver)
    ## Sets the net driver to use for this world
    ## @param NewDriver the new net driver to use

  proc isRecordingClientReplay(): bool {.noSideEffect.}
    ## Returns true if the game net driver exists and is a client and the demo net driver exists and is a server.

  proc delayStreamingVolumeUpdates(inFrameDelay: int32)
    ## Sets the number of frames to delay Streaming Volume updating,
    ## useful if you preload a bunch of levels but the camera hasn't caught up yet

  proc transferBlueprintDebugReferences(newWorld: ptr UWorld)
    ## Transfers the set of Kismet / Blueprint objects being debugged to the new world that are not already present, and updates blueprints accordingly
    ## @param	NewWorld	The new world to find equivalent objects in

  proc notifyOfBlueprintDebuggingAssociation(blueprint: ptr UBlueprint;
                                             debugObject: ptr UObject)
    ## Notifies the world of a blueprint debugging reference
    ## @param	Blueprint	The blueprint the reference is for
    ## @param	DebugObject The associated debugging object (may be NULL)

  proc broadcastLevelsChanged()
    ## Broadcasts that the number of levels has changed.

  proc onLevelsChanged(): var FOnLevelsChangedEvent
    ## Returns the LevelsChangedEvent member.

  proc getProgressDenominator(): int32
    ## Returns the actor count.

  proc getActorCount(): int32
    ## Returns the actor count.

  proc getNetRelevantActorCount(): int32
    ## Returns the net relevant actor count.

# public:

  proc getAudioSettings(viewLocation: FVector;
                        outReverbSettings: ptr FReverbSettings;
                        outInteriorSettings: ptr FInteriorSettings): ptr AAudioVolume
    ## Finds the audio settings to use for a given view location, taking into account the world's default
    ## settings and the audio volumes in the world.
    ##
    ## @param	ViewLocation			Current view location.
    ## @param	OutReverbSettings		[out] Upon return, the reverb settings for a camera at ViewLocation.
    ## @param	OutInteriorSettings		[out] Upon return, the interior settings for a camera at ViewLocation.
    ## @return							If the settings came from an audio volume, the audio volume object is returned.

  proc setAudioDeviceHandle(inAudioDeviceHandle: uint32)
    ## Sets the audio device handle to the active audio device for this world.

  proc getAudioDevice(): ptr FAudioDevice
    ## Returns the audio device associated with this world, or returns the main audio device if there is none.
    ##
    ## @return Audio device to use with this world.

  proc getLocalURL(): FString {.noSideEffect.}
    ## Return the URL of this level on the local machine.

  proc isPlayInEditor(): bool {.noSideEffect.}
    ## Returns whether script is executing within the editor.

  proc isPlayInPreview(): bool {.noSideEffect.}
    ## Returns whether script is executing within a preview window

  proc isPlayInMobilePreview(): bool {.noSideEffect.}
    ## Returns whether script is executing within a mobile preview window

  proc isGameWorld(): bool {.noSideEffect.}
    ## Returns true if this world is any kind of game world (including PIE worlds)

  proc isPreviewWorld(): bool {.noSideEffect.}
    ## Returns true if this world is a preview game world (blueprint editor)

  proc usesGameHiddenFlags(): bool {.noSideEffect.}
    ## Returns true if this world should look at game hidden flags instead of editor hidden flags for the purposes of rendering

  proc getAddressURL(): FString {.noSideEffect.}
    ## Return the URL of this level, which may possibly
    ## exist on a remote machine.

  proc loadSecondaryLevels(bForce: bool = false;
                           cookedPackages: ptr TSet[FString] = nil)
    ## Called after GWorld has been set. Used to load, but not associate, all
    ## levels in the world in the Editor and at least create linkers in the game.
    ## Should only be called against GWorld::PersistentLevel's WorldSettings.
    ##
    ## @param bForce	If true, load the levels even is a commandlet

  proc getLevelStreamingForPackageName(packageName: FName): ptr ULevelStreaming
    ## Utility for returning the ULevelStreaming object for a particular sub-level, specified by package name
# when WITH_EDITOR:
  proc refreshStreamingLevels()
    ## Called when level property has changed
    ## It refreshes any streaming stuff
  proc refreshStreamingLevels(inLevelsToRefresh: TArray[ptr ULevelStreaming])
    ## Called when a specific set of streaming levels need to be refreshed
    ## @param LevelsToRefresh A TArray<ULevelStreaming*> containing pointers to the levels to refresh
# endwhen

  proc serverTravel(inURL: FString; bAbsolute: bool = false;
                    bShouldSkipGameNotify: bool = false)
    ## Jumps the server to new level.  If bAbsolute is true and we are using seemless traveling, we
    ## will do an absolute travel (URL will be flushed).
    ##
    ## @param URL the URL that we are traveling to
    ## @param bAbsolute whether we are using relative or absolute travel
    ## @param bShouldSkipGameNotify whether to notify the clients/game or not

  proc seamlessTravel(inURL: FString; bAbsolute: bool = false;
                      mapPackageGuid: FGuid = FGuid())
    ## Seamlessly travels to the given URL by first loading the entry level in the background,
    ## switching to it, and then loading the specified level. Does not disrupt network communication or disconnect clients.
    ## You may need to implement GameMode::GetSeamlessTravelActorList(), PlayerController::GetSeamlessTravelActorList(),
    ## GameMode::PostSeamlessTravel(), and/or GameMode::HandleSeamlessTravelPlayer() to handle preserving any information
    ## that should be maintained (player teams, etc)
    ## This codepath is designed for worlds that use little or no level streaming and GameModes where the game state
    ## is reset/reloaded when transitioning. (like UT)
    ## @param URL - the URL to travel to; must be on the same server as the current URL
    ## @param bAbsolute (opt) - if true, URL is absolute, otherwise relative
    ## @param MapPackageGuid (opt) - the GUID of the map package to travel to - this is used to find the file when it has been auto-downloaded,
    ## 				so it is only needed for clients

  proc isInSeamlessTravel(): bool
    ## @return whether we're currently in a seamless transition

  proc setSeamlessTravelMidpointPause(bNowPaused: bool)
    ## This function allows pausing the seamless travel in the middle,
    ## right before it starts loading the destination (i.e. while in the transition level)
    ## this gives the opportunity to perform any other loading tasks before the final transition
    ## this function has no effect if we have already started loading the destination (you will get a log warning if this is the case)
    ## @param bNowPaused - whether the transition should now be paused

  proc getDetailMode(): int32
    ## @return the current detail mode, like EDetailMode but can be outside of the range

  proc forceGarbageCollection(bFullPurge: bool = false)
    ## Updates the timer between garbage collection such that at the next opportunity garbage collection will be run.

  proc prepareMapChange(levelNames: TArray[FName])
    ## Asynchronously loads the given levels in preparation for a streaming map transition.
    ## This codepath is designed for worlds that heavily use level streaming and GameModes where the game state should
    ## be preserved through a transition.
    ## @param LevelNames the names of the level packages to load. LevelNames[0] will be the new persistent (primary) level

  proc isPreparingMapChange(): bool
    ## @return true if there's a map change currently in progress

  proc isMapChangeReady(): bool
    ## @return true if there is a map change being prepared, returns whether that change is ready to be committed, otherwise false

  proc cancelPendingMapChange()
    ## cancels pending map change (@note: we can't cancel pending async loads, so this won't immediately free the memory)

  proc commitMapChange()
    ## actually performs the map transition prepared by PrepareMapChange()
    ## it happens in the next tick to avoid GC issues
    ## if a map change is being prepared but isn't ready yet, the transition code will block until it is
    ## wait until IsMapChangeReady() returns true if this is undesired behavior

  proc setMapNeedsLightingFullyRebuilt(inNumLightingUnbuiltObjects: int32)
    ## Sets NumLightingUnbuiltObjects to the specified value.  Marks the worldsettings package dirty if the value changed.
    ## @param	InNumLightingUnbuiltObjects			The new value.

  proc getTimerManager(): ptr FTimerManager {.noSideEffect, cppname: "(& #.GetTimerManager(@))".}
    ## Returns TimerManager instance for this world.

  proc getLatentActionManager(): var FLatentActionManager
    ## Returns LatentActionManager instance, preferring the one allocated by the game instance if a game instance is associated with this.
    ##
    ## This pattern is a little bit of a kludge to allow UWorld clients (for instance, preview world in the Blueprint Editor
    ## to not worry about replacing features from GameInstance. Alternatively we could mandate that they implement a game instance
    ## for their scene.

  proc setGameInstance(newGI: ptr UGameInstance)
    ## Sets the owning game instance for this world

  proc getGameInstance(): ptr UGameInstance {.noSideEffect.}
    ## Returns the owning game instance for this world

  proc isNavigationRebuilt(): bool {.noSideEffect.}
    ## Retrieves information whether all navigation with this world has been rebuilt

  proc requestNewWorldOrigin(inNewOriginLocation: FIntVector)
    ## Request to translate world origin to specified position on next tick

  proc setNewWorldOrigin(inNewOriginLocation: FIntVector): bool
    ## Translate world origin to specified position

  proc navigateTo(inLocation: FIntVector)
    ## Sets world origin at specified position and stream-in all relevant levels

  proc getMatineeActors(outMatineeActors: var TArray[ptr AMatineeActor])
    ## Gets all matinee actors for the current level

  proc updateConstraintActors()
    ## Updates all physics constraint actor joint locations.

  proc getLightMapsAndShadowMaps(level: ptr ULevel; outLightMapsAndShadowMaps: var TArray[ptr UTexture2D])
    ## Gets all LightMaps and ShadowMaps associated with this world. Specify the level or leave null for persistent

  proc RenameToPIEWorld(PIEInstanceID: int32)
    ## Rename this world such that it has the prefix on names for the given PIE Instance ID
# public:
  ##
  ## 	/** Given a PackageName and a PIE Instance ID return the name of that Package when being run as a PIE world */
  ## 	static FString ConvertToPIEPackageName(const FString& PackageName, int32 PIEInstanceID);
  ## 	/** Given a PackageName and a prefix type, get back to the original package name (i.e. the saved map name) */
  ## 	static FString StripPIEPrefixFromPackageName(const FString& PackageName, const FString& Prefix);
  ## 	/** Return the prefix for PIE packages given a PIE Instance ID */
  ## 	static FString BuildPIEPackagePrefix(int32 PIEInstanceID);
  ## 	/** Given a loaded editor UWorld, duplicate it for play in editor purposes with OwningWorld as the world with the persistent level. */
  ## 	static UWorld* DuplicateWorldForPIE(const FString& PackageName, UWorld* OwningWorld);
  ## 	/** Given a string, return that string with any PIE prefix removed */
  ## 	static FString RemovePIEPrefix(const FString &Source);
  ## 	/** Given a package, locate the UWorld contained within if one exists */
  ## 	static UWorld* FindWorldInPackage(UPackage* Package);
  ## 	/** If the specified package contains a redirector to a UWorld, that UWorld is returned. Otherwise, nil is returned. */
  ## 	static UWorld* FollowWorldRedirectorInPackage(UPackage* Package, UObjectRedirector** OptionalOutRedirector = nil);

proc spawnActor*[T](world: ptr UWorld, spawnParameters = initFActorSpawnParameters()): ptr T {.importcpp: "#.SpawnActor<'*0>(@)", nodecl.}
  ## Templated version of SpawnActor that allows you to specify a class type via the template type


proc spawnActor*[T](world: ptr UWorld, location: FVector; rotation = zeroRotator; spawnParameters = initFActorSpawnParameters()): ptr T {.importcpp: "#.SpawnActor<'*0>(@)", nodecl.}
  ## Templated version of SpawnActor that allows you to specify location and rotation in addition to class type via the template type

proc spawnActor*[T](world: ptr UWorld, class: ptr UClass; spawnParameters = initFActorSpawnParameters()): ptr T {.importcpp: "#.SpawnActor<'*0>(@)", nodecl.}
  ## Templated version of SpawnActor that allows you to specify the class type via parameter while the return type is a parent class of that type

proc spawnActor*[T](world: ptr UWorld, class: ptr UClass; location: FVector; rotation: FRotator;
    spawnParameters = initFActorSpawnParameters()): ptr T {.importcpp: "#.SpawnActor<'*0>(@)", nodecl.}
  ## Templated version of SpawnActor that allows you to specify the rotation and location in addition
  ## class type via parameter while the return type is a parent class of that type

proc spawnActor*[T](world: ptr UWorld, class: ptr UClass; transform: FTransform; spawnParameters = initFActorSpawnParameters()): ptr T {.importcpp: "#.SpawnActor<'*0>(@)", nodecl.}
  ## Templated version of SpawnActor that allows you to specify whole Transform
  ## class type via parameter while the return type is a parent class of that type

proc spawnActorAbsolute*[T](world: ptr UWorld, absoluteLocation: FVector; absoluteRotation: FRotator;
    spawnParameters = initFActorSpawnParameters()): ptr T {.importcpp: "#.SpawnActorAbsolute<'*0>(@)", nodecl.}
  ## Templated version of SpawnActorAbsolute that allows you to specify absolute location and rotation in addition to class type via the template type

proc spawnActorAbsolute*[T](world: ptr UWorld, class: ptr UClass; transform: FTransform; spawnParameters = initFActorSpawnParameters()): ptr T {.importcpp: "#.SpawnActorAbsolute<'*0>(@)", nodecl.}
  ## Templated version of SpawnActorAbsolute that allows you to specify whole absolute Transform
  ## class type via parameter while the return type is a parent class of that type

proc spawnActorDeferred*[T](world: ptr UWorld;
                           class: ptr UClass;
                           transform: FTransform;
                           owner: ptr AActor = nil;
                           instigator: ptr APawn = nil;
                           collisionHandlingOverride: ESpawnActorCollisionHandlingMethod = ESpawnActorCollisionHandlingMethod.Undefined): ptr T  {.importcpp: "#.SpawnActorDeferred<'*0>(@)", nodecl.}
  ## Spawns given class and returns class T pointer, forcibly sets world transform (note this allows scale as well). WILL NOT run Construction Script of Blueprints
  ## to give caller an opportunity to set parameters beforehand.  Caller is responsible for invoking construction
  ## manually by calling UGameplayStatics::FinishSpawningActor (see AActor::OnConstruction).

proc getNonDefaultPhysicsVolumeIterator(world: ptr UWorld): TArrayConstIterator[TAutoWeakObjectPtr[APhysicsVolume]] {.importcpp: "GetNonDefaultPhysicsVolumeIterator", nodecl, noSideEffect.}
proc getLevelIterator(world: ptr UWorld): TArrayConstIterator[TAutoWeakObjectPtr[ULevel]] {.importcpp :"GetLevelIterator", nodecl, noSideEffect.}
proc getAutoActivateCameraIterator(world: ptr UWorld): TArrayConstIterator[TAutoWeakObjectPtr[ACameraActor]] {.importcpp: "GetAutoActivateCameraIterator", nodecl, noSideEffect.}
proc getPlayerControllerIterator(world: ptr UWorld): TArrayConstIterator[TAutoWeakObjectPtr[APlayerController]] {.importcpp: "GetPlayerControllerIterator", nodecl, noSideEffect.}
proc getPawnIterator(world: ptr UWorld): TArrayConstIterator[TAutoWeakObjectPtr[APawn]] {.importcpp: "GetPawnIterator", nodecl, noSideEffect.}
proc getControllerIterator(world: ptr UWorld): TArrayConstIterator[TAutoWeakObjectPtr[AController]] {.importcpp: "GetControllerIterator", nodecl, noSideEffect.}

iterator levels*(world: ptr UWorld): ptr ULevel =
  var it = getLevelIterator(world)
  while it.isValid:
    yield it.value()
    it.next()

iterator nonDefaultPhysicsVolumes*(world: ptr UWorld): ptr APhysicsVolume =
  ## Get an iterator for all PhysicsVolumes in the world that are not a DefaultPhysicsVolume.
  var it = getNonDefaultPhysicsVolumeIterator(world)
  while it.isValid:
    yield it.value()
    it.next()

iterator autoActivateCameras*(world: ptr UWorld): ptr ACameraActor =
  ## CameraActors that auto-activate for PlayerControllers.
  var it = getAutoActivateCameraIterator(world)
  while it.isValid:
    yield it.value()
    it.next()

iterator playerControllers*(world: ptr UWorld): ptr APlayerController =
  ## Iterator for the player controller list
  var it = getPlayerControllerIterator(world)
  while it.isValid:
    yield it.value()
    it.next()

iterator pawns*(world: ptr UWorld): ptr APawn =
  ## Iterator for the pawn list
  var it = getPawnIterator(world)
  while it.isValid:
    yield it.value()
    it.next()

iterator controllers*(world: ptr UWorld): ptr AController =
  ## Iterator for the controller list
  var it = getControllerIterator(world)
  while it.isValid:
    yield it.value()
    it.next()
