# Copyright 2016 Xored Software, Inc.

type
  EComponentCreationMethod* {.header: "Components/ActorComponent.h", importcpp:"EComponentCreationMethod", pure, size: sizeof(uint8).} = enum
    Native, ## A component that is part of a native class.
    SimpleConstructionScript,
      ## A component that is created from
      ## a template defined in the Components section of the Blueprint.
    UserConstructionScript,
      ## A dynamically created component, either from the UserConstructionScript
      ## or from a Add Component node in a Blueprint event graph.
    Instance
      ## A component added to a single Actor instance
      ## via the Component section of the Actor's details panel.

  ETeleportType* {.header: "Components/ActorComponent.h", importcpp, pure.} = enum
    None,
      ## Do not teleport physics body. This means velocity will reflect the
      ## movement between initial and final position, and collisions along the way will occur
    TeleportPhysics ## Teleport physics body so that velocity remains the same and no collision occurs

  ECacheApplyPhase* {.header: "ComponentInstanceDataCache.h", importcpp, pure.} = enum
    ## At what point in the rerun construction script process is ApplyToActor being called for
    PostSimpleConstructionScript, ## After the simple construction script has been run
    PostUserConstructionScript, ## After the user construction script has been run

wclass(FActorComponentInstanceData, header: "ComponentInstanceDataCache.h", bycopy):
  proc matchesComponent(component: ptr UActorComponent; ComponentTemplate: ptr UObject): bool {.noSideEffect.}
    ## Determines whether this component instance data matches the component

  method applyToComponent(component: ptr UActorComponent, cacheApplyPhase: ECacheApplyPhase)
    ## Applies this component instance data to the supplied component

  method findAndReplaceInstances(oldToNewInstanceMap: TMap[ptr UObject, ptr UObject])
    ## Replaces any references to old instances during Actor reinstancing

  method addReferencedObjects(collector: FReferenceCollector);

  proc ContainsSavedProperties(): bool {.noSideEffect.}

  proc getComponentClass(): ptr UClass {.noSideEffect.}

# protected:
  var sourceComponentTemplate: ptr UObject
    ## The template used to create the source component

  var sourceComponentTypeSerializedIndex: int32
    ## The index of the source component in its owner's serialized array
    ## when filtered to just that component type
  var sourceComponentCreationMethod: EComponentCreationMethod
    ## The method that was used to create the source component

  var savedProperties: TArray[uint8]

wclass(FComponentInstanceDataCache, header: "ComponentInstanceDataCache.h", bycopy):
  ## Cache for component instance data.
  ## Note, does not collect references for GC, so is not safe to GC if the cache is only reference to a UObject.

  proc applyToActor(actor: ptr AActor, cacheApplyPhase: ECacheApplyPhase) {.noSideEffect.}
    ## Iterates over an Actor's components and applies the stored component instance data to each

  proc findAndReplaceInstances(oldToNewInstanceMap: TMap[ptr UObject, ptr UObject])
    ## Iterates over components and replaces any object references with the reinstanced information

  proc hasInstanceData(): bool {.noSideEffect.}

  proc addReferencedObjects(collector: FReferenceCollector)

wclass(UActorComponent of UObject, header: "Components/ActorComponent.h", notypedef):
# public:
  var primaryComponentTick: FActorComponentTickFunction
    ## Main tick function for the Actor
    ## UPROPERTY(EditDefaultsOnly, Category="ComponentTick")

  var componentTags: TArray[FName]
    ## Array of tags that can be used for grouping and categorizing. Can also be accessed from scripting.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Tags)

# protected:

  var assetUserData: TArray[ptr UAssetUserData]
    ## Array of user data stored with the component
    ## UPROPERTY()

  var bRegistered: bool
    ## Indicates if this ActorComponent is currently registered with a scene.

  var bRenderStateCreated: bool
    ## If the render state is currently created for this component

  var bPhysicsStateCreated: bool
    ## If the physics state is currently created for this component

  var bReplicates: bool
    ## Is this component currently replicating? Should the network code consider it for replication? Owning Actor must be replicating first!
    ## UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Replicated, Category=ComponentReplication,meta=(DisplayName = "Component Replicates"))

  var bNetAddressable: bool
    ## Is this component safe to ID over the network by name?
    ## UPROPERTY()

# public:

  var bAutoRegister: bool
    ## Does this component automatically register with its owner

  var bTickInEditor: bool
    ## Should this component be ticked in the editor

  var bNeverNeedsRenderUpdate: bool
    ## If true, this component never needs a render update.

  var bAllowConcurrentTick: bool
    ## Can we tick this concurrently on other threads?

  var bAllowAnyoneToDestroyMe: bool
    ## Can this component be destroyed (via K2_DestroyComponent) by any parent

  var bAutoActivate: bool
    ## Whether to the component is activated at creation or must be explicitly activated.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Activation)

  var bIsActive: bool
    ## Whether the component is currently active.
    ## UPROPERTY(transient, ReplicatedUsing=OnRep_IsActive)

  var bEditableWhenInherited: bool
    ## UPROPERTY(EditDefaultsOnly, Category="Variable")

  var bWantsInitializeComponent: bool
    ## If true, we call the virtual InitializeComponent

  var bWantsBeginPlay: bool
    ## If true, we call the virtual BeginPlay
    ## UPROPERTY()

  var creationMethod: EComponentCreationMethod
    ## UPROPERTY()

  proc getMarkedForEndOfFrameUpdateState(): uint32 {.noSideEffect.}
  proc determineUCSModifiedProperties()
  proc getUCSModifiedProperties(modifiedProperties: var TSet[ptr UProperty]) {.
      noSideEffect.}
  proc isEditableWhenInherited(): bool {.noSideEffect.}
  proc hasBeenCreated(): bool {.noSideEffect.}
  proc hasBeenInitialized(): bool {.noSideEffect.}
  proc hasBegunPlay(): bool {.noSideEffect.}

  proc isBeingDestroyed(): bool {.noSideEffect.}
    ## Returns whether the component is in the process of being destroyed.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components", meta=(DisplayName="Is Component Being Destroyed"))

  proc isCreatedByConstructionScript(): bool {.noSideEffect.}

  proc onRep_IsActive()
    ## UFUNCTION()

  proc getOwner(): ptr AActor {.noSideEffect.}
    ## Follow the Outer chain to get the  AActor  that 'Owns' this component
    ## UFUNCTION(BlueprintCallable, Category="Components", meta=(Keywords = "Actor Owning Parent"))

  proc getWorld(): ptr UWorld {.noSideEffect.}

  proc hasTag(tag: FName): bool {.noSideEffect, cppname: "ComponentHasTag".}
    ## See if this component contains the supplied tag
    ## UFUNCTION(BlueprintCallable, Category="Components")

# Trigger/Activation interface

  proc activate(bReset: bool = false)
    ## Activates the SceneComponent
    ## @param bReset - The value to assign to HiddenGame.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Activation")

  proc deactivate()
    ## Deactivates the SceneComponent.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Activation")

  proc setActive(bNewActive: bool; bReset: bool = false)
    ## Sets whether the component is active or not
    ## @param bNewActive - The new active state of the component
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Activation")

  proc toggleActive()
    ## Toggles the active state of the component
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Activation")

  proc isActive(): bool {.noSideEffect.}
    ## Returns whether the component is active or not
    ## @return - The active state of the component.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Activation")

  proc setTickableWhenPaused(bTickableWhenPaused: bool)
    ## Sets whether this component can tick when paused.
    ## UFUNCTION(BlueprintCallable, Category="Utilities")

  proc setNetAddressable()
    ## Networking
    ## This signifies the component can be ID'd by name over the network. This only needs to be called by engine code when constructing blueprint components.

  proc isNameStableForNetworking(): bool {.noSideEffect.}
    ## IsNameStableForNetworking means an object can be referred to its path name (relative to outer) over the network

  proc isSupportedForNetworking(): bool {.noSideEffect.}
    ## IsSupportedForNetworking means an object can be referenced over the network

  proc setIsReplicated(shouldReplicate: bool)
    ## Enable or disable replication. This is the equivelent of RemoteRole for actors (only a bool is required for components)
    ## UFUNCTION(BlueprintCallable, Category="Components")

  proc getIsReplicated(): bool {.noSideEffect.}
    ## Returns whether replication is enabled or not.

  # proc replicateSubobjects(channel: ptr UActorChannel; bunch: ptr FOutBunch;
  #                         repFlags: ptr FReplicationFlags): bool
  #   ## Allows a component to replicate other subobject on the actor

  # proc preReplication(changedPropertyTracker: var IRepChangedPropertyTracker)
  #   ## Called on the component right before replication occurs
  proc getComponentClassCanReplicate(): bool {.noSideEffect.}


  proc isEditorOnly(): bool {.noSideEffect.}
    ## Returns whether this component is an editor-only object or not

  proc isNetSimulating(): bool {.noSideEffect.}
    ## Returns neat role of the owning actor
    ## Returns true if we are replicating and not authorative
  proc getOwnerRole(): ENetRole {.noSideEffect.}
  proc getNetMode(): ENetMode {.noSideEffect.}

# protected:

  var world: ptr UWorld
    ## Pointer to the world that this component is currently registered with.
    ## This is only non-NULL when the component is registered.

  proc shouldActivate(): bool {.noSideEffect.}
    ## "Trigger" related function. Return true if it should activate

  proc onRegister()
    ## Called when a component is registered, after Scene is set, but before CreateRenderState_Concurrent or CreatePhysicsState are called.

  proc onUnregister()
    ## Called when a component is unregistered.
    ## Called after DestroyRenderState_Concurrent and DestroyPhysicsState are called.

  proc shouldCreateRenderState(): bool {.noSideEffect.}
    ## Return true if CreateRenderState() should be called

  proc createRenderState_Concurrent()
    ## Used to create any rendering thread information for this component
    ##
    ## **Caution**, this is called concurrently on multiple threads (but never the same component concurrently)

  proc sendRenderTransform_Concurrent()
    ## Called to send a transform update for this component to the rendering thread
    ##
    ## **Caution**, this is called concurrently on multiple threads (but never the same component concurrently)

  proc sendRenderDynamicData_Concurrent()
    ## Called to send dynamic data for this component to the rendering thread

  proc destroyRenderState_Concurrent()
    ## Used to shut down any rendering thread structure for this component
    ##
    ## **Caution**, this is called concurrently on multiple threads (but never the same component concurrently)

  proc createPhysicsState()
    ## Used to create any physics engine information for this component

  proc destroyPhysicsState()
    ## Used to shut down and physics engine structure for this component

  proc shouldCreatePhysicsState(): bool {.noSideEffect.}
    ## Return true if CreatePhysicsState() should be called.
    ## Ideally CreatePhysicsState() should always succeed if this returns true, but this isn't currently the case

  proc hasValidPhysicsState(): bool {.noSideEffect.}
    ## Used to check that DestroyPhysicsState() is working correctly

  proc registerComponentTickFunctions(bRegister: bool)
    ## Virtual call chain to register all tick functions
    ## @param bRegister - true to register, false, to unregister
# public:

  proc initializeComponent()
    ## Initializes the component.  Occurs at level startup. This is before BeginPlay (Actor or Component).
    ## All Components in the level will be Initialized on load before any Actor/Component gets BeginPlay
    ## Requires component to be registered, and bWantsInitializeComponent to be true.

  proc beginPlay()
    ## BeginsPlay for the component.  Occurs at level startup. This is before BeginPlay (Actor or Component).
    ## All Components (that want initialization) in the level will be Initialized on load before any
    ## Actor/Component gets BeginPlay.
    ## Requires component to be registered and initialized.

  proc receiveBeginPlay()
    ## Blueprint implementable event for when the component is beginning play, called before its Owner's BeginPlay on Actor BeginPlay
    ## or when the component is dynamically created if the Actor has already BegunPlay.
    ##
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "Begin Play"))

  proc endPlay(endPlayReason: EEndPlayReason)
    ## Ends gameplay for this component.
    ## Called from AActor::EndPlay only if bHasBegunPlay is true

  proc uninitializeComponent()
    ## Handle this component being Uninitialized.
    ## Called from AActor::EndPlay only if bHasBeenInitialized is true

  proc receiveEndPlay(endPlayReason: EEndPlayReason)
    ## Blueprint implementable event for when the component ends play, generally via destruction or its Actor's EndPlay.
    ## UFUNCTION(BlueprintImplementableEvent, meta=(Keywords = "delete", DisplayName = "End Play"))

  proc registerAllComponentTickFunctions(bRegister: bool)
    ## When called, will call the virtual call chain to register all of the tick functions
    ## Do not override this function or make it virtual
    ## @param bRegister - true to register, false, to unregister

  proc tickComponent(deltaTime: cfloat; tickType: ELevelTick;
                    thisTickFunction: ptr FActorComponentTickFunction)
    ## Function called every frame on this ActorComponent. Override this function to implement custom logic to be executed every frame.
    ## Only executes if the component is registered, and also PrimaryComponentTick.bCanEverTick must be set to true.
    ##
    ## @param DeltaTime - The time since the last tick.
    ## @param TickType - The kind of tick this is, for example, are we paused, or 'simulating' in the editor
    ## @param ThisTickFunction - Internal tick function struct that caused this to run

  proc setupActorComponentTickFunction(tickFunction: ptr FTickFunction): bool
    ## Set up a tick function for a component in the standard way.
    ## Tick after the actor. Don't tick if the actor is static, or if the actor is a template or if this is a "NeverTick" component.
    ## I tick while paused if only if my owner does.
    ## @param	TickFunction - structure holding the specific tick function
    ## @return  true if this component met the criteria for actually being ticked.

  proc setComponentTickEnabled(bEnabled: bool)
    ## Set this component's tick functions to be enabled or disabled. Only has an effect if the function is registered
    ##
    ## @param	bEnabled - Rather it should be enabled or not
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities")

  proc setComponentTickEnabledAsync(bEnabled: bool)
    ## Spawns a task on GameThread that will call SetComponentTickEnabled
    ##
    ## @param	bEnabled - Rather it should be enabled or not

  proc isComponentTickEnabled(): bool {.noSideEffect.}
    ## Returns whether this component has tick enabled or not
    ##
    ## UFUNCTION(BlueprintCallable, Category="Utilities")

  proc registerComponentWithWorld(inWorld: ptr UWorld)
    ## @param InWorld - The world to register the component with.

  proc conditionalTickComponent(deltaTime: cfloat; tickType: ELevelTick;
                              thisTickFunction: var FActorComponentTickFunction)
    ## Conditionally calls Tick if bRegistered == true and a bunch of other criteria are met
    ## @param DeltaTime - The time since the last tick.
    ## @param TickType - Type of tick that we are running
    ## @param ThisTickFunction - the tick function that we are running

  proc isOwnerSelected(): bool {.noSideEffect.}
    ## Returns whether the component's owner is selected.
  proc isRenderTransformDirty(): bool {.noSideEffect.}
  proc isRenderStateDirty(): bool {.noSideEffect.}

  proc invalidateLightingCache()
    ## Invalidate lighting cache with default options.

  proc invalidateLightingCacheDetailed(bInvalidateBuildEnqueuedLighting: bool;
                                      bTranslationOnly: bool)
    ## Called when this actor component has moved, allowing it to discard statically cached lighting information.
#if WITH_EDITOR:
  proc checkForErrors()
    ## Function that gets called from within Map_Check to allow this actor component to check itself
    ## for any potential errors and register them with map check dialog.
    ## @note Derived class implementations should call up to their parents.
#endif

  proc doDeferredRenderUpdates_Concurrent()
    ## Uses the bRenderStateDirty/bRenderTransformDirty to perform any necessary work on this component.
    ## Do not call this directly, call MarkRenderStateDirty, MarkRenderDynamicDataDirty,
    ##
    ## **Caution**, this is called concurrently on multiple threads (but never the same component concurrently)

  proc updateComponentToWorld(bSkipPhysicsMove: bool = false;
                            teleport: ETeleportType = ETeleportType.None)
    ## Recalculate the value of our component to world transform

  proc markRenderStateDirty()
    ## Mark the render state as dirty - will be sent to the render thread at the end of the frame.

  proc markRenderDynamicDataDirty()
    ## Indicate that dynamic data for this component needs to be sent at the end of the frame.

  proc markRenderTransformDirty()
    ## Marks the transform as dirty - will be sent to the render thread at the end of the frame

  proc markForNeededEndOfFrameUpdate()
    ## If we belong to a world, mark this for a deffered update, otherwise do it now.

  proc markForNeededEndOfFrameRecreate()
    ## If we belong to a world, mark this for a deffered update, otherwise do it now.

  proc requiresGameThreadEndOfFrameUpdates(): bool {.noSideEffect.}
    ## return true if this component requires end of frame updates to happen from the game thread.

  proc requiresGameThreadEndOfFrameRecreate(): bool {.noSideEffect.}
    ## return true if this component requires end of frame recreates to happen from the game thread.

  proc recreateRenderState_Concurrent()
    ## Recreate the render state right away. Generally you always want to call MarkRenderStateDirty instead.
    ##
    ## **Caution**, this is called concurrently on multiple threads (but never the same component concurrently)

  proc recreatePhysicsState()
    ## Recreate the physics state right way.

  proc isRenderStateCreated(): bool {.noSideEffect.}
    ## @return true if the render 'state' (e.g. scene proxy) is created for this component

  proc isPhysicsStateCreated(): bool {.noSideEffect.}
    ## @return true if the physics 'state' (e.g. physx bodies) are created for this component

  proc getScene(): ptr FSceneInterface {.noSideEffect.}

  proc getComponentLevel(): ptr ULevel {.noSideEffect.}
    ## Return the ULevel that this Component is part of.

  proc componentIsInLevel(testLevel: ptr ULevel): bool {.noSideEffect.}
    ## Returns true if this actor is contained by TestLevel.

  proc componentIsInPersistentLevel(bIncludeLevelStreamingPersistent: bool): bool {.
      noSideEffect.}
    ## See if this component is in the persistent level

  proc onActorEnableCollisionChanged()
    ## Called on each component when the Actor's bEnableCollisionChanged flag changes

  proc getReadableName(): FString {.noSideEffect.}
    ## Returns a readable name for this component, including the asset name if applicable
    ## By default this appends a space plus AdditionalStatObject()

  proc additionalStatObject(): ptr UObject {.noSideEffect.}
    ## Give a readable name for this component, including asset name if applicable

  proc preNetReceive()
    ## Always called immediately before properties are received from the remote.

  proc postNetReceive()
    ## Always called immediately after properties are received from the remote.

  proc getComponentInstanceData(): ptr FActorComponentInstanceData {.noSideEffect.}
    ## Called before we throw away components during RerunConstructionScripts, to cache any data we wish to persist across that operation

  proc isOwnerRunningUserConstructionScript(): bool {.noSideEffect.}
    ## See if the owning Actor is currently running the UCS

  proc isRegistered(): bool {.noSideEffect.}
    ## See if this component is currently registered

  proc registerComponent()
    ## Register this component, creating any rendering/physics state. Will also adds to outer Actor's Components array, if not already present.

  proc unregisterComponent()
    ## Unregister this component, destroying any rendering/physics state.

  proc destroyComponent(bPromoteChildren: bool = false)
    ## Unregister the component, remove it from its outer Actor's Components array and mark for pending kill.

  proc onComponentCreated()
    ## Called when a component is created (not loaded)

  proc onComponentDestroyed()
    ## Called when a component is destroyed

  proc k2_DestroyComponent(obj: ptr UObject)
    ## Unregister and mark for pending kill a component.  This may not be used to destroy a component is owned by an actor other than the one calling the function.

  proc reregisterComponent()
    ## UFUNCTION(BlueprintCallable, Category="Components", meta=(Keywords = "Delete", HidePin="Object", DefaultToSelf="Object", DisplayName = "DestroyComponent"))
    ## Unregisters and immediately re-registers component.  Handles bWillReregister properly.

  proc setTickGroup(newTickGroup: ETickingGroup)
    ## Changes the ticking group for this component
    ## UFUNCTION(BlueprintCallable, Category="Utilities", meta=(Keywords = "dependency"))

  proc addTickPrerequisiteActor(prerequisiteActor: ptr AActor)
    ## Make this component tick after PrerequisiteActor
    ## UFUNCTION(BlueprintCallable, Category="Utilities", meta=(Keywords = "dependency"))

  proc addTickPrerequisiteComponent(prerequisiteComponent: ptr UActorComponent)
    ## Make this component tick after PrerequisiteComponent.
    ## UFUNCTION(BlueprintCallable, Category="Utilities", meta=(Keywords = "dependency"))

  proc removeTickPrerequisiteActor(prerequisiteActor: ptr AActor)
    ## Remove tick dependency on PrerequisiteActor.
    ## UFUNCTION(BlueprintCallable, Category="Utilities", meta=(Keywords = "dependency"))

  proc removeTickPrerequisiteComponent(prerequisiteComponent: ptr UActorComponent)
    ## Remove tick dependency on PrerequisiteComponent.
    ## UFUNCTION(BlueprintCallable, Category="Utilities", meta=(Keywords = "dependency"))

  proc receiveTick(deltaSeconds: cfloat)
    ## Event called every frame
    ## UFUNCTION(BlueprintImplementableEvent, meta=(DisplayName = "Tick"))

  proc applyWorldOffset(inOffset: FVector; bWorldShift: bool)
    ## Called by owner actor on position shifting
    ## Component should update all relevant data structures to reflect new actor location
    ##
    ## @param InWorldOffset	 Offset vector the actor shifted by
    ## @param bWorldShift	 Whether this call is part of whole world shifting