# Copyright 2016 Xored Software, Inc.

type
  ECollisionChannel* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    ECC_WorldStatic,
    ECC_WorldDynamic,
    ECC_Pawn,
    ECC_Visibility,
    ECC_Camera,
    ECC_PhysicsBody,
    ECC_Vehicle,
    ECC_Destructible

  ECollisionResponse* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    ECR_Ignore,
    ECR_Overlap,
    ECR_Block,
    ECR_MAX


  ETouchIndex* {.header: "InputCoreTypes.h", importcpp: "ETouchIndex::Type", pure.} = enum
    Touch1,
    Touch2,
    Touch3,
    Touch4,
    Touch5,
    Touch6,
    Touch7,
    Touch8,
    Touch9,
    Touch10

  EInputEvent* {.header:"Engine/EngineBaseTypes.h", importcpp, size: sizeof(cint).} = enum
    IE_Pressed,
    IE_Released,
    IE_Repeat,
    IE_DoubleClick,
    IE_Axis,
    IE_MAX

  ETickingGroup* {.header: "Engine/EngineBaseTypes.h", importcpp, size: sizeof(cint).} = enum
    TG_PrePhysics,    ## Any item that needs to be executed before physics simulation starts.
    TG_StartPhysics,  ## Special tick group that starts physics simulation.
    TG_DuringPhysics, ## Any item that can be run in parallel with our physics simulation work.
    TG_EndPhysics,    ## Special tick group that ends physics simulation.
    TG_PreCloth,      ## Any item that needs physics to be complete before being executed.
    TG_StartCloth,    ## Any item that needs to be updated after rigid body simulation is done, but before cloth is simulation is done.
    TG_PostPhysics,   ## Any item that needs rigid body and cloth simulation to be complete before being executed.
    TG_PostUpdateWork,## Any item that needs the update work to be done before being ticked.
    TG_EndCloth,      ## Special tick group that ends cloth simulation.
    TG_NewlySpawned,  ## Special tick group that is not actually a tick group. After every tick group this is repeatedly re-run until there are no more newly spawned items to run.
    TG_MAX

  ETravelType* {.header: "Engine/EngineBaseTypes.h", importcpp, size: sizeof(cint).} = enum
    TRAVEL_Absolute,
      ## Absolute URL.
    TRAVEL_Partial,
      ## Partial (carry name, reset server).
    TRAVEL_Relative,
      ## Relative URL.
    TRAVEL_MAX,

  EMouseCursor* {.header: "ICursor.h", importcpp: "EMouseCursor::Type", pure.} = enum
    None, ## Causes no mouse cursor to be visible
    Default, ## Default cursor (arrow)
    TextEditBeam, ## Text edit beam
    ResizeLeftRight, ## Resize horizontal
    ResizeUpDown, ## Resize vertical
    ResizeSouthEast, ## Resize diagonal
    ResizeSouthWest, ## Resize other diagonal
    CardinalCross, ## MoveItem
    Crosshairs, ## Target Cross
    Hand, ## Hand cursor
    GrabHand, ## Grab Hand cursor
    GrabHandClosed, ## Grab Hand cursor closed
    SlashedCircle, ## A circle with a diagonal line through it
    EyeDropper, ## Eye-dropper cursor for picking colors
    Custom, ## Custom cursor shape for platforms that support setting a native cursor shape. Same as specifying None if not set.
    TotalCursorCount ## Number of cursors supported

  ENetRole* {.header: "Engine/EngineTypes.h", importcpp.} = enum
    ROLE_None, ## No role at all.
    ROLE_SimulatedProxy, ## Locally simulated proxy of this actor.
    ROLE_AutonomousProxy, ## Locally autonomous proxy of this actor.
    ROLE_Authority, ## Authoritative control over the actor.
    ROLE_MAX

  ENetDormancy* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    DORM_Never, ## This actor can never go network dormant.
    DORM_Awake,
      ## This actor can go dormant, but is not currently dormant.
      ## Game code will tell it when it go dormant.
    DORM_DormantAll,
      ## This actor wants to go fully dormant for all connections.
    DORM_DormantPartial,
      ## This actor may want to go dormant for some connections,
      ## GetNetDormancy() will be called to find out which.
    DORM_Initial,
      ## This actor is initially dormant for all connection if it was placed in map.
    DORN_MAX,
      ## Yes, it's a typo, and it is present in UE4 code

  ELevelTick* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    ## Type of tick we wish to perform on the level
    LEVELTICK_TimeOnly = 0, ## Update the level time only.
    LEVELTICK_ViewportsOnly = 1, ## Update time and viewports.
    LEVELTICK_All = 2, ## Update all
    LEVELTICK_PauseTick = 3 ## Delta time is zero, we are paused. Components don't tick.

  ENetMode* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    ## The network mode the game is currently running.
    ## see https://docs.unrealengine.com/latest/INT/Gameplay/Networking/Replication/
    NM_Standalone,
      ## Standalone: a game without networking, with one or more local players.
      ## Still considered a server because it has all server functionality.
    NM_DedicatedServer,
      ## Dedicated server: server with no local players.
    NM_ListenServer,
      ## Listen server: a server that also has a local player who is
      ##  hosting the game, available to other players on the network.

    NM_Client,
      ## Network client: client connected to a remote server.
      ## Note that every mode less than this value is a kind of server,
      ## so checking NetMode < NM_Client is always some variety of server.

    NM_MAX

  EAutoReceiveInput* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    Disabled,
    Player0,
    Player1,
    Player2,
    Player3,
    Player4,
    Player5,
    Player6,
    Player7,

  ESpawnActorCollisionHandlingMethod* {.
      header: "Engine/EngineTypes.h",
      importcpp: "ESpawnActorCollisionHandlingMethod",
      pure.} = enum
    Undefined, ## Fall back to default settings.
    AlwaysSpawn, ## Actor will spawn in desired location, regardless of collisions.
    AdjustIfPossibleButAlwaysSpawn, ## Actor will try to find a nearby non-colliding location (based on shape components), but will always spawn even if one cannot be found.
    AdjustIfPossibleButDontSpawnIfColliding, ## Actor will try to find a nearby non-colliding location (based on shape components), but will NOT spawn unless one is found.
    DontSpawnIfColliding ## Actor will fail to spawn.

  EAttachLocation* {.header: "Engine/EngineTypes.h", importcpp: "EAttachLocation::Type", pure.} = enum
    KeepRelativeOffset, ## Keeps current relative transform as the relative transform to the new parent.
    KeepWorldPosition,
      ## Automatically calculates the relative transform such that
      ## the attached component maintains the same world transform.
    SnapToTarget,
      ## Snaps location and rotation to the attach point.
      ## Calculates the relative scale so that the final world scale of the component remains the same.
    SnapToTargetIncludingScale ## Snaps entire transform to target, including scale.

  EEndPlayReason* {.header: "Engine/EngineTypes.h", importcpp: "EEndPlayReason::Type", pure.} = enum
    Destroyed, ## When the Actor or Component is explicitly destroyed.
    LevelTransition, ## When the world is being unloaded for a level transition.
    EndPlayInEditor, ## When the world is being unloaded because PIE is ending.
    RemovedFromWorld, ## When the level it is a member of is streamed out.
    Quit ## When the application is being exited.

  EObjectTypeQuery* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    ObjectTypeQuery1,
    ObjectTypeQuery2,
    ObjectTypeQuery3,
    ObjectTypeQuery4,
    ObjectTypeQuery5,
    ObjectTypeQuery6,
    ObjectTypeQuery7,
    ObjectTypeQuery8,
    ObjectTypeQuery9,
    ObjectTypeQuery10,
    ObjectTypeQuery11,
    ObjectTypeQuery12,
    ObjectTypeQuery13,
    ObjectTypeQuery14,
    ObjectTypeQuery15,
    ObjectTypeQuery16,
    ObjectTypeQuery17,
    ObjectTypeQuery18,
    ObjectTypeQuery19,
    ObjectTypeQuery20,
    ObjectTypeQuery21,
    ObjectTypeQuery22,
    ObjectTypeQuery23,
    ObjectTypeQuery24,
    ObjectTypeQuery25,
    ObjectTypeQuery26,
    ObjectTypeQuery27,
    ObjectTypeQuery28,
    ObjectTypeQuery29,
    ObjectTypeQuery30,
    ObjectTypeQuery31,
    ObjectTypeQuery32,

    ObjectTypeQuery_MAX

  ETraceTypeQuery* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    TraceTypeQuery1,
    TraceTypeQuery2,
    TraceTypeQuery3,
    TraceTypeQuery4,
    TraceTypeQuery5,
    TraceTypeQuery6,
    TraceTypeQuery7,
    TraceTypeQuery8,
    TraceTypeQuery9,
    TraceTypeQuery10,
    TraceTypeQuery11,
    TraceTypeQuery12,
    TraceTypeQuery13,
    TraceTypeQuery14,
    TraceTypeQuery15,
    TraceTypeQuery16,
    TraceTypeQuery17,
    TraceTypeQuery18,
    TraceTypeQuery19,
    TraceTypeQuery20,
    TraceTypeQuery21,
    TraceTypeQuery22,
    TraceTypeQuery23,
    TraceTypeQuery24,
    TraceTypeQuery25,
    TraceTypeQuery26,
    TraceTypeQuery27,
    TraceTypeQuery28,
    TraceTypeQuery29,
    TraceTypeQuery30,
    TraceTypeQuery31,
    TraceTypeQuery32,

    TraceTypeQuery_MAX

  ERadialImpulseFalloff* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    ## Enum for controlling the falloff of strength of a radial impulse as a function of distance from Origin.
    RIF_Constant, ## Impulse is a constant strength, up to the limit of its range.
    RIF_Linear, ## Impulse should get linearly weaker the further from origin.
    RIF_MAX

  EAutoPossessAI* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(uint8), pure.} = enum
    Disabled, ## Feature is disabled (do not automatically possess AI).
    PlacedInWorld, ## Only possess by an AI Controller if Pawn is placed in the world.
    Spawned, ## Only possess by an AI Controller if Pawn is spawned after the world has loaded.
    PlacedInWorldOrSpawned, ## Pawn is automatically possessed by an AI Controller whenever it is created.

  FDamageEvent* {.header: "Engine/EngineTypes.h", importcpp, inheritable, bycopy.} = object
  FRadialDamageEvent* {.header: "Engine/EngineTypes.h", importcpp.} = object of FDamageEvent
  FPointDamageEvent* {.header: "Engine/EngineTypes.h", importcpp.} = object of FDamageEvent

  FTickFunction* {.header: "Engine/EngineTypes.h", importcpp, inheritable.} = object
  FActorComponentTickFunction* {.header: "Engine/EngineTypes.h", importcpp.} = object of FTickFunction
  FActorTickFunction* {.header: "Engine/EngineTypes.h", importcpp.} = object of FTickFunction
  FCharacterMovementComponentPreClothTickFunction* {.header: "Engine/EngineTypes.h", importcpp.} = object of FTickFunction
  FEndClothSimulationFunction* {.header: "Engine/EngineTypes.h", importcpp.} = object of FTickFunction
  FEndPhysicsTickFunction* {.header: "Engine/EngineTypes.h", importcpp.} = object of FTickFunction
  FPrimitiveComponentPostPhysicsTickFunction* {.header: "Engine/EngineTypes.h", importcpp.} = object of FTickFunction
  FSkeletalMeshComponentPreClothTickFunction* {.header: "Engine/EngineTypes.h", importcpp.} = object of FTickFunction
  FStartClothSimulationFunction* {.header: "Engine/EngineTypes.h", importcpp.} = object of FTickFunction
  FStartPhysicsTickFunction* {.header: "Engine/EngineTypes.h", importcpp.} = object of FTickFunction


  EControllerHand* {.header: "InputCoreTypes.h", importcpp: "EControllerHand::Type", size: sizeof(cint), pure.} = enum
    Left,
    Right

class(FHitResult, header: "Engine/EngineTypes.h", bycopy):
    var bBlockingHit: bool
    var bStartPenetrating: bool

    var time: cfloat
    var location: FVector
    var impactPoint: FVector
    var normal: FVector
    var impactNormal: FVector
    var traceStart: FVector
    var traceEnd: FVector
    var distance: cfloat
    var penetrationDepth: cfloat
    var item: int32
    var boneName: FName
    var faceIndex: int32

    var actor: TWeakObjectPtr[AActor]
    var component: TWeakObjectPtr[UPrimitiveComponent]
    # var physMaterial: TWeakObjectPtr[UPhysicalMaterial]

    proc makeFHitResult(): FHitResult {.constructor.}

    proc getActor(): ptr AActor {.noSideEffect.}
    proc getComponent(): ptr UPrimitiveComponent {.noSideEffect.}
    proc isValidBlockingHit(): bool {.noSideEffect.}

# depends on AActor, cannot put it in enginetypes module
class(FBasedPosition, header: "Engine/EngineTypes.h"):
  ## Struct for handling positions relative to a base actor, which is potentially moving
  var base: ptr AActor
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=BasedPosition)

  var position: FVector
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=BasedPosition)

  var cachedBaseLocation: FVector
  var cachedBaseRotation: FRotator
  var cachedTransPosition: FVector

  proc makeFBasedPosition(): FBasedPosition {.constructor.}
  proc makeFBasedPosition(inBase: ptr AActor, inPosition: var FVector): FBasedPosition {.constructor.}

  proc location(): FVector {.noSideEffect, importcpp: "*#".}
    ## Retrieve world location of this position

  proc set(inBase: ptr AActor; inPosition: var FVector)
  proc clear()

class(FRigidBodyContactInfo, header: "Engine/EngineTypes.h", bycopy):
  var contactPosition: FVector
  var contactNormal: FVector
  var contactPenetration: cfloat

  # var physMaterial: array[ptr UPhysicalMaterial]

  proc make(): FRigidBodyContactInfo {.constructor.}

  proc swapOrder()

class(FCollisionImpactData, header: "Engine/EngineTypes.h", bycopy):
  var contactInfos: TArray[FRigidBodyContactInfo]
    ## all the contact points in the collision
  var totalNormalImpulse: FVector
    ## the total impulse applied as the two objects push against each other
  var totalFrictionImpulse: FVector
    ## the total counterimpulse applied of the two objects sliding against each other

  proc make(): FCollisionImpactData {.constructor.}

  proc swapContactOrders()
    ## Iterate over ContactInfos array and swap order of information

class(FTimerHandle, header: "Engine/EngineTypes.h", bycopy):
  proc make(): FTimerHandle {.constructor.}
  proc isValid(): bool {.noSideEffect.}
  proc invalidate()
  proc makeValid()
  proc toString(): FString

  proc `==`(other: FTimerHandle): bool {.noSideEffect.}
  proc `!=`(other: FTimerHandle): bool {.noSideEffect.}

class(FPrimitiveComponentId, header: "SceneTypes.h", bycopy):
  var primIDValue: uint32
  proc isValid(): bool {.noSideEffect.}
  proc `==`(other: var FPrimitiveComponentId): bool {.noSideEffect.}

proc hash(id: FPrimitiveComponentId): uint32 {.noSideEffect, header: "SceneTypes.h", importc: "GetTypeHash".}

type FForceFeedbackChannelType {.size: sizeof(cint),
                                 importcpp: "FForceFeedbackChannelType",
                                 header: "GenericPlatform/IInputInterface.h", pure.} = enum
  ## General identifiers for potential force feedback channels. These will be mapped according to the
  ## platform specific implementation.
  ## For example, the PS4 only listens to the XXX_LARGE channels and ignores the rest, while the XBox One could
  ## map the XXX_LARGE to the handle motors and XXX_SMALL to the trigger motors. And iOS can map LEFT_SMALL to
  ## its single motor.
  LEFT_LARGE,
  LEFT_SMALL,
  RIGHT_LARGE,
  RIGHT_SMALL

class(FForceFeedbackValues, header: "GenericPlatform/IInputInterface.h", bycopy):
  var leftLarge: cfloat
  var leftSmall: cfloat
  var rightLarge: cfloat
  var rightSmall: cfloat

  proc makeFForceFeedbackValues(): FForceFeedbackValues {.constructor.}

class(FHapticFeedbackValues, header: "GenericPlatform/IInputInterface.h", bycopy):
  var frequency: cfloat
  var amplitude: cfloat

  proc makeFHapticFeedbackValues(): FHapticFeedbackValues {.constructor.}

  proc makeFHapticFeedbackValues(inFrequency, inAmplitude: cfloat): FHapticFeedbackValues {.constructor.}

class(IInputInterface, header: "GenericPlatform/IInputInterface.h"):
  method setHapticFeedbackValues(controllerId: int32; hand: int32; values: var FHapticFeedbackValues)
    ## Sets the frequency and amplitude of haptic feedback channels for a given controller id.
    ## Some devices / platforms may support just haptics, or just force feedback.
    ##
    ## @param ControllerId ID of the controller to issue haptic feedback for
    ## @param HandId     Which hand id (e.g. left or right) to issue the feedback for.  These usually correspond to EControllerHands
    ## @param Values     Frequency and amplitude to haptics at

  method setLightColor(controllerId: int32; color: FColor)
    ## Sets the controller for the given controller.  Ignored if controller does not support a color.

class(FClientReceiveData, header: "GameFramework/LocalMessage.h", bycopy):
  var localPC: ptr APlayerController
  var messageType: FName
  var messageIndex: int32
  var messageString: FString
  var relatedPlayerState_1: ptr APlayerState
  var relatedPlayerState_2: ptr APlayerState
  var optionalObject: ptr UObject
  proc makeFClientReceiveData(): FClientReceiveData {.constructor.}

class(ULocalMessage of UObject, header: "GameFramework/LocalMessage.h"):
  method clientReceive(clientData: var FClientReceiveData) {.noSideEffect.}
    ## Send message to client
