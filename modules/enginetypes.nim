# Copyright 2016 Xored Software, Inc.

type
  ECollisionChannel* {.header: "Engine/EngineTypes.h", importcpp: "ECollisionChannel".} = enum
    ECC_WorldStatic,
    ECC_WorldDynamic,
    ECC_Pawn,
    ECC_Visibility,
    ECC_Camera,
    ECC_PhysicsBody,
    ECC_Vehicle,
    ECC_Destructible

  ECollisionResponse* {.size: sizeof(cint), header: "Engine/EngineTypes.h", importcpp: "ECollisionResponse".} = enum
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

  EInputEvent* {.header:"Engine/EngineBaseTypes.h", importcpp: "EInputEvent", pure.} = enum
    IE_Pressed,
    IE_Released,
    IE_Repeat,
    IE_DoubleClick,
    IE_Axis,
    IE_MAX

  ETickingGroup* {.header: "Engine/EngineBaseTypes.h", importcpp: "ETickingGroup", pure.} = enum
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

  ETravelType* {.size: sizeof(cint), header: "Engine/EngineBaseTypes.h", importcpp: "ETickingGroup", pure.} = enum
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

  ENetRole* {.header: "Engine/EngineTypes.h", importcpp: "ENetRole".} = enum
    ROLE_None, ## No role at all.
    ROLE_SimulatedProxy, ## Locally simulated proxy of this actor.
    ROLE_AutonomousProxy, ## Locally autonomous proxy of this actor.
    ROLE_Authority, ## Authoritative control over the actor.
    ROLE_MAX

  ENetDormancy* {.size: sizeof(cint), header: "Engine/EngineTypes.h", importcpp: "ENetDormancy".} = enum
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

  ELevelTick* {.size: sizeof(cint), header: "Engine/EngineTypes.h", importcpp: "ELevelTick".} = enum
    ## Type of tick we wish to perform on the level
    LEVELTICK_TimeOnly = 0, ## Update the level time only.
    LEVELTICK_ViewportsOnly = 1, ## Update time and viewports.
    LEVELTICK_All = 2, ## Update all
    LEVELTICK_PauseTick = 3 ## Delta time is zero, we are paused. Components don't tick.

  ENetMode* {.size: sizeof(cint), header: "Engine/EngineTypes.h", importcpp: "ENetMode".} = enum
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

  EAutoReceiveInput* {.size: sizeof(cint), header: "Engine/EngineTypes.h", importcpp: "EAutoReceiveInput".} = enum
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

  EObjectTypeQuery* {.size: sizeof(cint), header: "Engine/EngineTypes.h", importcpp: "EObjectTypeQuery".} = enum
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

  ETraceTypeQuery* {.size: sizeof(cint), header: "Engine/EngineTypes.h", importcpp: "ETraceTypeQuery".} = enum
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

  FHitResult* {.header: "Engine/EngineTypes.h", importcpp: "FHitResult".} = object
    bBlockingHit*: bool
    bStartPenetrating*: float32
    Time*: float32
    Location*: FVector
    ImpactPoint*: FVector
    Normal*: FVector
    ImpactNormal*: FVector
    TraceStart*: FVector
    TraceEnd*: FVector
    Distance*: float32
    PenetrationDepth*: float32
    Item*: int32
    FaceIndex*: int32

  FDamageEvent* {.header: "Engine/EngineTypes.h", importcpp: "FDamageEvent", inheritable.} = object
  FRadialDamageEvent* {.header: "Engine/EngineTypes.h", importcpp: "FRadialDamageEvent".} = object of FDamageEvent
  FPointDamageEvent* {.header: "Engine/EngineTypes.h", importcpp: "FPointDamageEvent".} = object of FDamageEvent

  FTickFunction* {.header: "Engine/EngineTypes.h", importcpp: "FTickFunction", inheritable.} = object
  FActorComponentTickFunction* {.header: "Engine/EngineTypes.h", importcpp: "FActorComponentTickFunction".} = object of FTickFunction
  FActorTickFunction* {.header: "Engine/EngineTypes.h", importcpp: "FActorTickFunction".} = object of FTickFunction
  FCharacterMovementComponentPreClothTickFunction* {.
    header: "Engine/EngineTypes.h",
    importcpp: "FCharacterMovementComponentPreClothTickFunction".} = object of FTickFunction
  FEndClothSimulationFunction* {.header: "Engine/EngineTypes.h", importcpp: "FEndClothSimulationFunction".} = object of FTickFunction
  FEndPhysicsTickFunction* {.header: "Engine/EngineTypes.h", importcpp: "FEndPhysicsTickFunction".} = object of FTickFunction
  FPrimitiveComponentPostPhysicsTickFunction* {.header: "Engine/EngineTypes.h", importcpp: "FPrimitiveComponentPostPhysicsTickFunction".} = object of FTickFunction
  FSkeletalMeshComponentPreClothTickFunction* {.header: "Engine/EngineTypes.h", importcpp: "FSkeletalMeshComponentPreClothTickFunction".} = object of FTickFunction
  FStartClothSimulationFunction* {.header: "Engine/EngineTypes.h", importcpp: "FStartClothSimulationFunction".} = object of FTickFunction
  FStartPhysicsTickFunction* {.header: "Engine/EngineTypes.h", importcpp: "FStartPhysicsTickFunction".} = object of FTickFunction


  EControllerHand* {.size: sizeof(cint), header: "InputCoreTypes.h", importcpp: "EControllerHand::Type", pure.} = enum
    Left,
    Right

class(FRigidBodyContactInfo, header: "Engine/EngineTypes.h"):
  var contactPosition: FVector
  var contactNormal: FVector
  var contactPenetration: cfloat

  # var physMaterial: array[ptr UPhysicalMaterial]

  proc make(): FRigidBodyContactInfo {.constructor.}

  proc swapOrder()

class(FCollisionImpactData, header: "Engine/EngineTypes.h"):
  var contactInfos: TArray[FRigidBodyContactInfo]
    ## all the contact points in the collision
  var totalNormalImpulse: FVector
    ## the total impulse applied as the two objects push against each other
  var totalFrictionImpulse: FVector
    ## the total counterimpulse applied of the two objects sliding against each other

  proc make(): FCollisionImpactData {.constructor.}

  proc swapContactOrders()
    ## Iterate over ContactInfos array and swap order of information

class(FTimerHandle, header: "Engine/EngineTypes.h"):
  proc make(): FTimerHandle {.constructor.}
  proc isValid(): bool {.noSideEffect.}
  proc invalidate()
  proc makeValid()
  proc toString(): FString

  proc `==`(other: FTimerHandle): bool {.noSideEffect.}
  proc `!=`(other: FTimerHandle): bool {.noSideEffect.}

class(FPrimitiveComponentId, header: "SceneTypes.h"):
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

class(FForceFeedbackValues, header: "GenericPlatform/IInputInterface.h"):
  var leftLarge: cfloat
  var leftSmall: cfloat
  var rightLarge: cfloat
  var rightSmall: cfloat

  proc makeFForceFeedbackValues(): FForceFeedbackValues {.constructor.}

class(FHapticFeedbackValues, header: "GenericPlatform/IInputInterface.h"):
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
