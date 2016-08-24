# Copyright 2016 Xored Software, Inc.

type
  EAttachmentRule* {.importcpp, header: "Engine/EngineTypes.h", pure, size: sizeof(uint8).} = enum
      ## Rules for attaching components - needs to be kept synced to EDetachmentRule
    KeepRelative,
      ## Keeps current relative transform as the relative transform to the new parent.
    KeepWorld,
      ## Automatically calculates the relative transform such that the attached component maintains the same world transform.
    SnapToTarget
      ## Snaps transform to the attach point

  FAttachmentTransformRules* {.importcpp, header: "Engine/EngineTypes.h".} = object
    ## Rules for attaching components
    locationRule* {.importcpp: "LocationRule".}: EAttachmentRule
      ## The rule to apply to location when attaching
    rotationRule* {.importcpp: "RotationRule".}: EAttachmentRule
      ## The rule to apply to rotation when attaching
    scaleRule* {.importcpp: "ScaleRule".}: EAttachmentRule
      ## The rule to apply to scale when attaching
    bWeldSimulatedBodies*: bool
      ## Whether to weld simulated bodies together when attaching

  ECollisionChannel* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    ECC_WorldStatic,
    ECC_WorldDynamic,
    ECC_Pawn,
    ECC_Visibility,
    ECC_Camera,
    ECC_PhysicsBody,
    ECC_Vehicle,
    ECC_Destructible,

    ECC_EngineTraceChannel1,
    ECC_EngineTraceChannel2,
    ECC_EngineTraceChannel3,
    ECC_EngineTraceChannel4,
    ECC_EngineTraceChannel5,
    ECC_EngineTraceChannel6,

    ECC_GameTraceChannel1,
    ECC_GameTraceChannel2,
    ECC_GameTraceChannel3,
    ECC_GameTraceChannel4,
    ECC_GameTraceChannel5,
    ECC_GameTraceChannel6,
    ECC_GameTraceChannel7,
    ECC_GameTraceChannel8,
    ECC_GameTraceChannel9,
    ECC_GameTraceChannel10,
    ECC_GameTraceChannel12,
    ECC_GameTraceChannel13,
    ECC_GameTraceChannel14,
    ECC_GameTraceChannel15,
    ECC_GameTraceChannel16,
    ECC_GameTraceChannel17,
    ECC_GameTraceChannel18


  ECollisionResponse* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    ECR_Ignore,
    ECR_Overlap,
    ECR_Block,
    ECR_MAX

  ECollisionEnabled* {.header: "Engine/EngineTypes.h", importcpp: "ECollisionEnabled::Type", size: sizeof(cint).} = enum
    NoCollision, ## No collision is enabled for this body.
    QueryOnly,
      ## This body is used only for collision queries (raycasts, sweeps, and overlaps).
    PhysicsOnly,
      ## This body is used only for physics collision.
    QueryAndPhysics
      ## This body interacts with all collision (Query and Physics).

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
    ## see https:##docs.unrealengine.com/latest/INT/Gameplay/Networking/Replication/
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

  ESceneDepthPriorityGroup* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    ## A priority for sorting scene elements by depth.
    ## Elements with higher priority occlude elements with lower priority, disregarding distance.
    SDPG_World,
      ## World scene DPG.
    SDPG_Foreground,
      ## Foreground scene DPG.
    SDPG_MAX

  EIndirectLightingCacheQuality* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    ILCQ_Off,
      ## The indirect lighting cache will be disabled for this object, so no GI from stationary lights on movable objects.
    ILCQ_Point,
      ## A single indirect lighting sample computed at the bounds origin will be interpolated which fades over time to newer results.
    ILCQ_Volume
      ## The object will get a 5x5x5 stable volume of interpolated indirect lighting, which allows gradients of lighting intensity across the receiving object.

  EEndPlayReason* {.header: "Engine/EngineTypes.h", importcpp: "EEndPlayReason::Type", pure.} = enum
    Destroyed, ## When the Actor or Component is explicitly destroyed.
    LevelTransition, ## When the world is being unloaded for a level transition.
    EndPlayInEditor, ## When the world is being unloaded because PIE is ending.
    RemovedFromWorld, ## When the level it is a member of is streamed out.
    Quit ## When the application is being exited.

  EComponentMobility* {.header: "Engine/EngineTypes.h", importcpp: "EComponentMobility::Type", pure.} = enum
    ## Describes how often this component is allowed to move.
    Static,
      ## Static objects cannot be moved or changed in game.
      ## - Allows baked lighting
      ## - Fastest rendering
    Stationary,
      ## A stationary light will only have its shadowing and bounced lighting from static geometry
      ## baked by Lightmass, all other lighting will be dynamic.
      ## - Stationary only makes sense for light components
      ## - It can change color and intensity in game.
      ## - Can't move
      ## - Allows partial baked lighting
      ## - Dynamic shadows
    Movable
      ## Movable objects can be moved and changed in game.
      ## - Totally dynamic
      ## - Can cast dynamic shadows
      ## - Slowest rendering

  EComponentSocketType* {.header: "Engine/EngineTypes.h", importcpp: "EComponentSocketType::Type", pure, size: sizeof(cint).} = enum
    ## Type of a socket on a scene component.
    Invalid, ## Not a valid socket or bone name.
    Bone, ## Skeletal bone.
    Socket ## Socket.

  FComponentSocketDescription* {.header: "Engine/EngineTypes.h", importcpp.} = object
    ## Info about a socket on a scene component
    name* {.importcpp: "Name".}: FName
      ## Name of the socket
    kind* {.importcpp: "Type".}: EComponentSocketType
      ## Type of the socket

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

  ETrailWidthMode* {.importcpp, header: "Engine/EngineTypes.h".} = enum
    ## Controls the way that the width scale property affects animation trails.
    ETrailWidthMode_FromCentre,
    ETrailWidthMode_FromFirst,
    ETrailWidthMode_FromSecond

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

  EWalkableSlopeBehavior* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    ## Controls behavior of WalkableSlopeOverride, determining how to affect walkability of surfaces for Characters.
    ## @see FWalkableSlopeOverride
    ## @see UCharacterMovementComponent::GetWalkableFloorAngle(), UCharacterMovementComponent::SetWalkableFloorAngle()
    WalkableSlope_Default,
      ## Don't affect the walkable slope. Walkable slope angle will be ignored.
    WalkableSlope_Increase,
      ## Increase walkable slope.
      ## Makes it easier to walk up a surface, by allowing traversal over higher-than-usual angles.
      ## @see FWalkableSlopeOverride::WalkableSlopeAngle
    WalkableSlope_Decrease,
      ## Decrease walkable slope.
      ## Makes it harder to walk up a surface, by restricting traversal to lower-than-usual angles.
      ## @see FWalkableSlopeOverride::WalkableSlopeAngle
    WalkableSlope_Unwalkable,
      ## Make surface unwalkable.
      ## Note: WalkableSlopeAngle will be ignored.
    WalkableSlope_Max

  EMovementMode* {.importcpp, header: "Engine/EngineTypes.h", size: sizeof(cint).} = enum
    MOVE_None,
      ## None (movement is disabled).
    MOVE_Walking,
      ## Walking on a surface.
    MOVE_NavWalking,
      ## Simplified walking on navigation data (e.g. navmesh).
      ## If bGenerateOverlapEvents is true, then we will perform sweeps with each navmesh move.
      ## If bGenerateOverlapEvents is false then movement is cheaper but characters can overlap other objects without some extra process to repel/resolve their collisions.
    MOVE_Falling,
      ## Falling under the effects of gravity, such as after jumping or walking off the edge of a surface.
    MOVE_Swimming,
      ## Swimming through a fluid volume, under the effects of gravity and buoyancy.
    MOVE_Flying,
      ## Flying, ignoring the effects of gravity. Affected by the current physics volume's fluid friction.
    MOVE_Custom,
      ## User-defined custom movement mode, including many possible sub-modes.
    MOVE_MAX

  EFlushLevelStreamingType* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint), pure.} = enum
    None
    Full
      ## Allow multiple load requests
    Visibility
      ## Flush visibility only, do not allow load requests, flushes async loading as well

  EWorldType* {.header: "Engine/EngineTypes.h", importcpp: "EWorldType::Type", size: sizeof(cint), pure.} = enum
    None,
      ## An untyped world, in most cases this will be the vestigial worlds of streamed in sub-levels
    Game,
      ## The game world
    Editor,
      ## A world being edited in the editor
    PIE,
      ## A Play In Editor world
    Preview,
      ## A preview world for an editor tool
    Inactive
      ## An editor world that was loaded but not currently being edited in the level editor

  FResponseChannel* {.header: "Engine/EngineTypes.h", importcpp.} = object
    channel* {.importcpp: "Channel".}: FName
    response* {.importcpp: "Response".}: ECollisionResponse

  FDamageEvent* {.header: "Engine/EngineTypes.h", importcpp, inheritable, bycopy.} = object
  FRadialDamageEvent* {.header: "Engine/EngineTypes.h", importcpp.} = object of FDamageEvent
  FPointDamageEvent* {.header: "Engine/EngineTypes.h", importcpp.} = object of FDamageEvent

  FTickFunction* {.header: "Engine/EngineTypes.h", importcpp, inheritable.} = object
    bCanEverTick*: bool
      ## If false, this tick function will never be registered and will never tick. Only settable in defaults.
    bTickEvenWhenPaused*: bool
    bStartWithTickEnabled*: bool
      ## If true, this tick function will start enabled, but can be disabled later on.
    bAllowTickOnDedicatedServer*: bool
      ## If we allow this tick to run on a dedicated server
    bHighPriority*: bool
      ## Run this tick first within the tick group, presumably to start async tasks that
      ## must be completed with this tick group, hiding the latency.
    bRunOnAnyThread*: bool
      ## If false, this tick will run on the game thread, otherwise
      ## it will run on any thread in parallel with the game thread and in parallel with other "async ticks"
    tickInterval* {.importcpp: "TickInterval".}: cfloat
      ## The frequency in seconds at which this tick function will be executed.
      ## If less than or equal to 0 then it will tick every frame

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

  FOverlapResult* {.header: "Engine/EngineTypes.h", importcpp.} = object
    ## Structure containing information about one hit of an overlap test
    actor* {.importcpp: "Actor".}: TWeakObjectPtr[AActor]
      ## Actor that the check hit.
    component* {.importcpp: "Component".}: TWeakObjectPtr[UPrimitiveComponent]
      ## PrimitiveComponent that the check hit.
    itemIndex* {.importcpp: "ItemIndex".}: int32
      ## This is the index of the overlapping item.
      ## For DestructibleComponents, this is the ChunkInfo index.
      ## For SkeletalMeshComponents this is the Body index or INDEX_NONE for single body
    bBlockingHit*: bool
      ## Indicates if this hit was requesting a block - if false, was requesting a touch instead

  FWalkableSlopeOverride* {.header: "Engine/EngineTypes.h", importcpp.} = object
    ## Struct allowing control over "walkable" normals,
    ## by allowing a restriction or relaxation of what steepness is normally walkable.
    walkableSlopeBehavior {.importcpp: "WalkableSlopeBehavior".}: EWalkableSlopeBehavior
    walkableSlopeAngle {.importcpp: "WalkableSlopeAngle".}: cfloat

  FMTDResult* {.header: "Engine/EngineTypes.h", importcpp.} = object
    ## Structure containing information about minimum translation direction (MTD)
    direction* {.importcpp: "Direction".}: FVector
      ## Normalized direction of the minimum translation required to fix penetration.
    distance* {.importcpp: "Distance".}: cfloat
      ## Distance required to move along the MTD vector (Direction).

  EMaterialQualityLevel* {.header: "SceneTypes.h", importcpp: "EMaterialQualityLevel::Type", pure, size: sizeof(cint).} = enum
    ## Quality levels that a material can be compiled for.
    Low,
    High,
    Medium,
    Num

  ELightMapInteractionType* {.header: "SceneTypes.h", importcpp, size: sizeof(cint).} = enum
    ## The types of interactions between a light and a primitive.
    LMIT_None = 0,
    LMIT_Texture = 2,
    LMIT_NumBits = 3

  ESimpleElementBlendMode* {.header: "SceneTypes.h", importcpp, size: sizeof(cint).} = enum
    ## Blend modes supported for simple element rendering
    SE_BLEND_Opaque = 0,
    SE_BLEND_Masked,
    SE_BLEND_Translucent,
    SE_BLEND_Additive,
    SE_BLEND_Modulate,
    SE_BLEND_MaskedDistanceField,
    SE_BLEND_MaskedDistanceFieldShadowed,
    SE_BLEND_TranslucentDistanceField,
    SE_BLEND_TranslucentDistanceFieldShadowed,
    SE_BLEND_AlphaComposite,
    SE_BLEND_AlphaBlend,
      ## Like SE_BLEND_Translucent, but modifies destination alpha
    SE_BLEND_TranslucentAlphaOnly,
      ## Like SE_BLEND_Translucent, but reads from an alpha-only texture
    SE_BLEND_RGBA_MASK_START,
    SE_BLEND_RGBA_MASK_END = ord(SE_BLEND_RGBA_MASK_START) + 31,
      ## Using 5bit bit-field for red, green, blue, alpha and desaturation
    SE_BLEND_MAX

  EBlendMode* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    BLEND_Opaque,
    BLEND_Masked,
    BLEND_Translucent,
    BLEND_Additive,
    BLEND_Modulate,
    BLEND_MAX

  ENetworkSmoothingMode {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(uint8), pure.} = enum
    ## Smoothing approach used by network interpolation for Characters.
    Disabled,
      ## No smoothing, only change position as network position updates are received.
    Linear, ## Linear interpolation from source to target.
    Exponential ## Exponential. Faster as you are further from target.

  FRigidBodyState* {.header: "Engine/EngineTypes.h", importcpp.} = object
    ## TODO

  FRigidBodyErrorCorrection* {.header: "Engine/EngineTypes.h", importcpp.} = object
    ## Rigid body error correction data
    linearDeltaThresholdSq* {.importcpp: "LinearDeltaThresholdSq".}: cfloat
      ## max squared position difference to perform velocity adjustment
    linearInterpAlpha* {.importcpp: "LinearInterpAlpha".}: cfloat
      ## strength of snapping to desired linear velocity
    linearRecipFixTime* {.importcpp: "LinearRecipFixTime".}: cfloat
      ## inverted duration after which linear velocity adjustment will fix error
    angularDeltaThreshold* {.importcpp: "AngularDeltaThreshold".}: cfloat
      ## max squared angle difference (in radians) to perform velocity adjustment
    angularInterpAlpha* {.importcpp: "AngularInterpAlpha".}: cfloat
      ## strength of snapping to desired angular velocity
    angularRecipFixTime* {.importcpp: "AngularRecipFixTime".}: cfloat
      ## inverted duration after which angular velocity adjustment will fix error
    bodySpeedThresholdSq* {.importcpp: "BodySpeedThresholdSq".}: cfloat
      ## min squared body speed to perform velocity adjustment

  FURL* {.header: "Engine/EngineBaseTypes.h", importcpp.} = object
    protocol* {.importcpp: "Protocol".}: FString
      ## Protocol, i.e. "unreal" or "http".
    host* {.importcpp: "Host".}: FString
      ## Optional hostname, i.e. "204.157.115.40" or "unreal.epicgames.com", blank if local.
    port* {.importcpp: "Port".}: int32
      ## Optional host port.
    map* {.importcpp: "Map".}: FString
      ## Map name, i.e. "SkyCity", default is "Entry".
    redirectURL* {.importcpp: "RedirectURL".}: FString
      ## Optional place to download Map if client does not possess it
    op* {.importcpp: "Op".}: TArray[FString]
      ## Options.
    portal* {.importcpp: "Portal".}: FString
      ## Portal to enter through, default is "".
    valid* {.importcpp: "Valid".}: int32

  ETextureSizingType* {.header: "Engine/EngineTypes.h", importcpp, size: sizeof(cint).} = enum
    TextureSizingType_UseSingleTextureSize,
      ## Use TextureSize for all material properties
    TextureSizingType_UseAutomaticBiasedSizes,
      ## Use automatically biased texture sizes based on TextureSize
    TextureSizingType_UseManualOverrideTextureSize,
      ## Use per property manually overriden texture sizes
    TextureSizingType_UseSimplygonAutomaticSizing,
      ## Use Simplygon's automatic texture sizing
    TextureSizingType_MAX

  FCanvasUVTri* {.importcpp, header: "Engine/EngineTypes.h".} = object
    ## Simple 2d triangle with UVs
    v0Pos* {.importcpp: "V0_Pos".}: FVector2D
      ## Position of first vertex
      ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = CanvasUVTri)
    v0UV* {.importcpp: "V0_UV".}: FVector2D
      ## UV of first vertex
      ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = CanvasUVTri)
    v0Color* {.importcpp: "V0_Color".}: FLinearColor
      ## Color of first vertex
      ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = CanvasUVTri)
    v1Pos* {.importcpp: "V1_Pos".}: FVector2D
      ## Position of second vertex
      ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = CanvasUVTri)
    v1UV* {.importcpp: "V1_UV".}: FVector2D
      ## UV of second vertex
      ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = CanvasUVTri)
    v1Color* {.importcpp: "V1_Color".}: FLinearColor
      ## Color of second vertex
      ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = CanvasUVTri)
    v2Pos* {.importcpp: "V2_Pos".}: FVector2D
      ## Position of third vertex
      ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = CanvasUVTri)
    v2UV* {.importcpp: "V2_UV".}: FVector2D
      ## UV of third vertex
      ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = CanvasUVTri)
    v2Color* {.importcpp: "V2_Color".}: FLinearColor
      ## Color of third vertex
      ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = CanvasUVTri)

  ELightingBuildQuality* {.importcpp, header: "Engine/EngineTypes.h", size: sizeof(cint).} = enum
    ## Lighting build quality enumeration
    Quality_Preview,
    Quality_Medium,
    Quality_High,
    Quality_Production,
    Quality_MAX,

  ENamedThreads {.importcpp: "ENamedThreads::Type", header: "Async/TaskGraphInterfaces.h", pure, size: sizeof(cint).} = enum
    ## This is not properly interfaced as it depends on preprocessor macros
    UnusedAnchor = -1,
  FGraphEvent {.importcpp, header: "Async/TaskGraphInterfaces.h".} = object
  FGraphEventRef = TRefCountPtr[FGraphEvent]

# Various preset attachment rules. Note that these default rules do NOT by default weld simulated bodies
var keepRelativeTransform* {.
  importcpp: "FAttachmentTransformRules::KeepRelativeTransform",
  header: "Engine/EngineTypes.h".}: FAttachmentTransformRules
var keepWorldTransform* {.
  importcpp: "FAttachmentTransformRules::KeepWorldTransform",
  header: "Engine/EngineTypes.h".}: FAttachmentTransformRules
var snapToTargetNotIncludingScale* {.
  importcpp: "FAttachmentTransformRules::SnapToTargetNotIncludingScale",
  header: "Engine/EngineTypes.h".}: FAttachmentTransformRules
var snapToTargetIncludingScale* {.
  importcpp: "FAttachmentTransformRules::SnapToTargetIncludingScale",
  header: "Engine/EngineTypes.h".}: FAttachmentTransformRules

proc initFAttachmentTransformRules(inRule: EAttachmentRule, bInWeldSimulatedBodies: bool): FAttachmentTransformRules {.importcpp: "'0(@)", constructor.}
proc initFAttachmentTransformRules(inLocationRule: EAttachmentRule,
                                   inRotationRule: EAttachmentRule,
                                   inScaleRule: EAttachmentRule,
                                   bInWeldSimulatedBodies: bool): FAttachmentTransformRules {.importcpp: "'0(@)", constructor.}

wclass(FMaterialProxySettings, header: "Engine/EngineTypes.h", bycopy):
  var textureSize: FIntPoint
    ## Size of generated BaseColor map
  var textureSizingType: ETextureSizingType
  var gutterSpace: cfloat
  var bNormalMap: bool
    ## Whether to generate normal map
  var bMetallicMap: bool
    ## Whether to generate metallic map
  var metallicConstant: cfloat
    ## Metallic constant
  var bRoughnessMap: bool
    ## Whether to generate roughness map
  var roughnessConstant: cfloat
    ## Roughness constant
  var bSpecularMap: bool
    ## Whether to generate specular map
  var specularConstant: cfloat
    ## Specular constant
  var bEmissiveMap: bool
    ## Whether to generate emissive map
  var bOpacityMap: bool
    ## Whether to generate opacity map
  var diffuseTextureSize: FIntPoint
    ## Override diffuse map size
  var normalTextureSize: FIntPoint
    ## Override normal map size
  var metallicTextureSize: FIntPoint
    ## Override metallic map size
  var roughnessTextureSize: FIntPoint
    ## Override roughness map size
  var specularTextureSize: FIntPoint
    ## Override specular map size
  var emissiveTextureSize: FIntPoint
    ## Override emissive map size
  var opacityTextureSize: FIntPoint
    ## Override opacity map size)

wclass(FMeshProxySettings, header: "Engine/EngineTypes.h", bycopy):
  var screenSize: int32
    ## Screen size of the resulting proxy mesh in pixel size
    ## UPROPERTY(EditAnywhere, Category=ProxySettings)

  var materialSettings: FMaterialProxySettings
    ## Material simplification
    ## UPROPERTY(EditAnywhere, Category = ProxySettings)

  var mergeDistance: cfloat
    ## Distance at which meshes should be merged together
    ## UPROPERTY(EditAnywhere, Category = ProxySettings)

  var hardAngleThreshold: cfloat
    ## Angle at which a hard edge is introduced between faces
    ## UPROPERTY(EditAnywhere, Category = ProxySettings, meta = (DisplayName = "Hard Edge Angle"))

  var lightMapResolution: int32
    ## Lightmap resolution
    ## UPROPERTY(EditAnywhere, Category=ProxySettings)

  var bRecalculateNormals: bool
    ## Whether Simplygon should recalculate normals, otherwise the normals channel will be sampled from the original mesh
    ## UPROPERTY(EditAnywhere, Category=ProxySettings)

  var bUseClippingPlane: bool
    ## Set to true to cap the mesh with a ground plane
    ## UPROPERTY(EditAnywhere, Category=ProxySettings)

  var clippingLevel: cfloat
    ## Ground plane level
    ## UPROPERTY(EditAnywhere, Category=ProxySettings)

  var axisIndex: int32
    ## Set the axis index for the ground plane (0:X-Axis, 1:Y-Axis, 2:Z-Axis)
    ## UPROPERTY(EditAnywhere, Category=ProxySettings)

  var bPlaneNegativeHalfspace: bool
    ## Set to true to use negative halfspace for model, and reject the positive halfspace
    ## UPROPERTY(EditAnywhere, Category=ProxySettings)

  proc initFMeshProxySettings(): FMeshProxySettings {.constructor.}
    ## Default settings.

wclass(FMeshMergingSettings, header: "Engine/EngineTypes.h", bycopy):
  var bGenerateLightMapUV: bool
    ## Whether to generate lightmap UVs for a merged mesh
    ## UPROPERTY(EditAnywhere, Category=FMeshMergingSettings)

  var targetLightMapUVChannel: int32
    ## Target UV channel in a merged mesh for a lightmap
    ## UPROPERTY(EditAnywhere, Category=FMeshMergingSettings)

  var targetLightMapResolution: int32
    ## Target lightmap resolution
    ## UPROPERTY(EditAnywhere, Category=FMeshMergingSettings)

  var bPivotPointAtZero: bool
    ## Whether merged mesh should have pivot at world origin, or at first merged component otherwise
    ## UPROPERTY(EditAnywhere, Category=FMeshMergingSettings)

  var bMergePhysicsData: bool
    ## Whether to merge physics data (collision primitives)
    ## UPROPERTY(EditAnywhere, Category=FMeshMergingSettings)

  var bMergeMaterials: bool
    ## Whether to merge source materials into one flat material
    ## UPROPERTY(EditAnywhere, Category=MeshMerge)

  var materialSettings: FMaterialProxySettings
    ## Material simplification
    ## UPROPERTY(EditAnywhere, Category = MeshMerge, meta = (editcondition = "bMergeMaterials"))

  var bBakeVertexData: bool
    ## UPROPERTY(EditAnywhere, Category = MeshMerge)

  proc initFMeshMergingSettings(): FMeshMergingSettings {.constructor.}
    ## Default settings.

wclass(UBookMark of UObject, header: "Engine/BookMark.h"):
  ## A camera position the current level.
  var location: FVector
    ## Camera position
  var rotation: FRotator
    ## Camera rotation
  var hiddenLevels: TArray[FString]
    ## Array of levels that are hidden

declareBuiltinDelegate(FTimerDynamicDelegate, dkDynamic, "Engine/EngineTypes.h")

wclass(FHitResult, header: "Engine/EngineTypes.h", bycopy):
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
wclass(FBasedPosition, header: "Engine/EngineTypes.h"):
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

wclass(FSubtitleCue, header: "Engine/EngineTypes.h", bycopy):
  ## A line of subtitle text and the time at which it should be displayed.
  var text: FText
    ## The text to appear in the subtitle.

  var time: float32
    ## The time at which the subtitle is to be displayed, in seconds relative to the beginning of the line.

  proc initFSubtitleCue(): FSubtitleCue {.constructor.}

wclass(FRigidBodyContactInfo, header: "Engine/EngineTypes.h", bycopy):
  var contactPosition: FVector
  var contactNormal: FVector
  var contactPenetration: cfloat

  # var physMaterial: array[ptr UPhysicalMaterial]

  proc make(): FRigidBodyContactInfo {.constructor.}

  proc swapOrder()

wclass(FCollisionResponseContainer, header: "Engine/EngineTypes.h", bycopy):
  var worldStatic: ECollisionResponse ## 0
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="WorldStatic"))

  var worldDynamic: ECollisionResponse ## 1
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="WorldDynamic"))

  var pawn: ECollisionResponse ## 2
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="Pawn"))

  var visibility: ECollisionResponse ## 3
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="Visibility"))

  var camera: ECollisionResponse ## 4
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="Camera"))

  var physicsBody: ECollisionResponse ## 5
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="PhysicsBody"))

  var vehicle: ECollisionResponse ## 6
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="Vehicle"))

  var destructible: ECollisionResponse ## 7
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=CollisionResponseContainer, meta=(DisplayName="Destructible"))

  #
  # Unspecified Engine Trace Channels
  #
  var engineTraceChannel1: ECollisionResponse ## 8

  var engineTraceChannel2: ECollisionResponse ## 9

  var engineTraceChannel3: ECollisionResponse ## 10

  var engineTraceChannel4: ECollisionResponse ## 11

  var engineTraceChannel5: ECollisionResponse ## 12

  var engineTraceChannel6: ECollisionResponse ## 13

  # in order to use this custom channels
  # we recommend to define in your local file
  # - i.e. #define COLLISION_WEAPON ECC_GameTraceChannel1
  # and make sure you customize these it in INI file by
  #
  # in DefaultEngine.ini
  #
  # [/Script/Engine.CollisionProfile]
  # GameTraceChannel1="Weapon"
  #
  # also in the INI file, you can override collision profiles that are defined by simply redefining
  # note that Weapon isn't defined in the BaseEngine.ini file, but "Trigger" is defined in Engine
  # +Profiles=(Name="Trigger",CollisionEnabled=QueryOnly,ObjectTypeName=WorldDynamic, DefaultResponse=ECR_Overlap, CustomResponses=((Channel=Visibility, Response=ECR_Ignore), (Channel=Weapon, Response=ECR_Ignore)))

  var gameTraceChannel1: ECollisionResponse ## 14

  var gameTraceChannel2: ECollisionResponse ## 15

  var gameTraceChannel3: ECollisionResponse ## 16

  var gameTraceChannel4: ECollisionResponse ## 17

  var gameTraceChannel5: ECollisionResponse ## 18

  var gameTraceChannel6: ECollisionResponse ## 19

  var gameTraceChannel7: ECollisionResponse ## 20

  var gameTraceChannel8: ECollisionResponse ## 21

  var gameTraceChannel9: ECollisionResponse ## 22

  var gameTraceChannel10: ECollisionResponse ## 23

  var gameTraceChannel11: ECollisionResponse ## 24

  var gameTraceChannel12: ECollisionResponse ## 25

  var gameTraceChannel13: ECollisionResponse ## 26

  var gameTraceChannel14: ECollisionResponse ## 27

  var gameTraceChannel15: ECollisionResponse ## 28

  var gameTraceChannel16: ECollisionResponse ## 28

  var gameTraceChannel17: ECollisionResponse ## 30

  var gameTraceChannel18: ECollisionResponse

  proc makeFCollisionResponseContainer() {.constructor.}
    ## This constructor will set all channels to ECR_Block
  proc makeFCollisionResponseContainer(defaultResponse: ECollisionResponse) {.constructor.}

  proc setResponse(channel: ECollisionChannel; newResponse: ECollisionResponse)
    ## Set the response of a particular channel in the structure.

  proc setAllChannels(newResponse: ECollisionResponse)
    ## Set all channels to the specified response

  proc replaceChannels(oldResponse, newResponse: ECollisionResponse)
    ## Replace the channels matching the old response with the new response

  proc getResponse(channel: ECollisionChannel): ECollisionResponse {.noSideEffect.}
    ## Returns the response set on the specified channel

  proc updateResponsesFromArray(channelResponses: var TArray[FResponseChannel])
    ## Set all channels from ChannelResponse Array
  proc fillArrayFromResponses(channelResponses: var TArray[FResponseChannel]): int32

  proc createMinContainer(a, b: FCollisionResponseContainer): FCollisionResponseContainer {.isStatic.}
    ## Take two response containers and create a new container where each element
    ## is the 'min' of the two inputs (ie Ignore and Block results in Ignore)

  proc getDefaultResponseContainer(): FCollisionResponseContainer {.isStatic.}

wclass(FCollisionImpactData, header: "Engine/EngineTypes.h", bycopy):
  var contactInfos: TArray[FRigidBodyContactInfo]
    ## all the contact points in the collision
  var totalNormalImpulse: FVector
    ## the total impulse applied as the two objects push against each other
  var totalFrictionImpulse: FVector
    ## the total counterimpulse applied of the two objects sliding against each other

  proc make(): FCollisionImpactData {.constructor.}

  proc swapContactOrders()
    ## Iterate over ContactInfos array and swap order of information

wclass(FTimerHandle, header: "Engine/EngineTypes.h", bycopy):
  proc make(): FTimerHandle {.constructor.}
  proc isValid(): bool {.noSideEffect.}
  proc invalidate()
  proc makeValid()
  proc toString(): FString

  proc `==`(other: FTimerHandle): bool {.noSideEffect.}
  proc `!=`(other: FTimerHandle): bool {.noSideEffect.}

wclass(FPrimitiveComponentId, header: "SceneTypes.h", bycopy):
  var primIDValue: uint32
  proc isValid(): bool {.noSideEffect.}
  proc `==`(other: var FPrimitiveComponentId): bool {.noSideEffect.}

proc hash(id: FPrimitiveComponentId): uint32 {.noSideEffect, header: "SceneTypes.h", importc: "GetTypeHash".}

type
  FForceFeedbackChannelType {.size: sizeof(cint),
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

  EWindowMode* {.importcpp: "EWindowMode::Type", header: "GenericPlatform/GenericWindow.h", pure, size: sizeof(cint).} = enum
    ## Supported windowing modes (mirrored from GenericWindow.h)
    Fullscreen,
      ## The window is in true fullscreen mode
    WindowedFullscreen,
      ## The window has no border and takes up the entire area of the screen
    Windowed,
      ## The window has a border and may not take up the entire screen area
    WindowedMirror
      ## Pseudo-fullscreen mode for devices like HMDs

  FGenericWindow* {.importcpp, header: "GenericPlatform/GenericWindow.h".} = object

wclass(FWindowSizeLimits, header: "GenericPlatform/GenericApplicationMessageHandler.h", bycopy):
  ## Defines the minimum and maximum dimensions that a window can take on.
  proc setMinWidth(inValue: TOptional[float32]): var FWindowSizeLimits
  proc getMinWidth(): TOptional[float32] {.noSideEffect.}

  proc setMinHeight(inValue: TOptional[float32]): var FWindowSizeLimits
  proc getMinHeight(): TOptional[float32] {.noSideEffect.}

  proc setMaxWidth(inValue: TOptional[float32]): var FWindowSizeLimits
  proc getMaxWidth(): TOptional[float32] {.noSideEffect.}

  proc setMaxHeight(inValue: TOptional[float32]): var FWindowSizeLimits
  proc getMaxHeight(): TOptional[float32] {.noSideEffect.}

wclass(FForceFeedbackValues, header: "GenericPlatform/IInputInterface.h", bycopy):
  var leftLarge: cfloat
  var leftSmall: cfloat
  var rightLarge: cfloat
  var rightSmall: cfloat

  proc makeFForceFeedbackValues(): FForceFeedbackValues {.constructor.}

wclass(FHapticFeedbackValues, header: "GenericPlatform/IInputInterface.h", bycopy):
  var frequency: cfloat
  var amplitude: cfloat

  proc makeFHapticFeedbackValues(): FHapticFeedbackValues {.constructor.}

  proc makeFHapticFeedbackValues(inFrequency, inAmplitude: cfloat): FHapticFeedbackValues {.constructor.}

wclass(IInputInterface, header: "GenericPlatform/IInputInterface.h"):
  method setHapticFeedbackValues(controllerId: int32; hand: int32; values: var FHapticFeedbackValues)
    ## Sets the frequency and amplitude of haptic feedback channels for a given controller id.
    ## Some devices / platforms may support just haptics, or just force feedback.
    ##
    ## @param ControllerId ID of the controller to issue haptic feedback for
    ## @param HandId     Which hand id (e.g. left or right) to issue the feedback for.  These usually correspond to EControllerHands
    ## @param Values     Frequency and amplitude to haptics at

  method setLightColor(controllerId: int32; color: FColor)
    ## Sets the controller for the given controller.  Ignored if controller does not support a color.

wclass(FClientReceiveData, header: "GameFramework/LocalMessage.h", bycopy):
  var localPC: ptr APlayerController
  var messageType: FName
  var messageIndex: int32
  var messageString: FString
  var relatedPlayerState_1: ptr APlayerState
  var relatedPlayerState_2: ptr APlayerState
  var optionalObject: ptr UObject
  proc makeFClientReceiveData(): FClientReceiveData {.constructor.}

wclass(ULocalMessage of UObject, header: "GameFramework/LocalMessage.h"):
  method clientReceive(clientData: var FClientReceiveData) {.noSideEffect.}
    ## Send message to client

wclass(FDepthFieldGlowInfo, header: "Engine/EngineTypes.h", bycopy):
  ## info for glow when using depth field rendering
  var bEnableGlow: bool
    ## whether to turn on the outline glow (depth field fonts only)
    ## UPROPERTY(BlueprintReadWrite, Category="Glow")
  var glowColor: FLinearColor
    ## base color to use for the glow
    ## UPROPERTY(BlueprintReadWrite, Category="Glow")
  var glowOuterRadius: FVector2D
    ## if bEnableGlow, outline glow outer radius (0 to 1, 0.5 is edge of character silhouette)
    ## glow influence will be 0 at GlowOuterRadius.X and 1 at GlowOuterRadius.Y
    ## UPROPERTY(BlueprintReadWrite, Category="Glow")
  var glowInnerRadius: FVector2D
    ## if bEnableGlow, outline glow inner radius (0 to 1, 0.5 is edge of character silhouette)
    ## glow influence will be 1 at GlowInnerRadius.X and 0 at GlowInnerRadius.Y
    ## UPROPERTY(BlueprintReadWrite, Category="Glow")

  proc initFDepthFieldGlowInfo(): FDepthFieldGlowInfo {.constructor.}
  proc `==`(other: FDepthFieldGlowInfo): bool {.noSideEffect.}
  proc `!=`(other: FDepthFieldGlowInfo): bool {.noSideEffect.}

type
  FFontRenderInfo* {.importcpp, header: "Engine/EngineTypes.h".} = object
    ## information used in font rendering
    bClipText*: bool
      ## whether to clip text
      ## UPROPERTY(BlueprintReadWrite, Category="FontInfo")
    bEnableShadow*: bool
      ## whether to turn on shadowing
      ## UPROPERTY(BlueprintReadWrite, Category="FontInfo")
    glowInfo* {.importcpp: "GlowInfo".}: FDepthFieldGlowInfo
      ## depth field glow parameters (only usable if font was imported with a depth field)
      ## UPROPERTY(BlueprintReadWrite, Category="FontInfo")

type
  EModifierKey {.importcpp: "EModifierKey::Type", header:"GenericPlatform/GenericApplication.h".} = distinct uint8
    ## Enumerates available modifier keys for input gestures.
const modifierNone: EModifierKey = 0.EModifierKey
const modifierControl: EModifierKey = 1.EModifierKey
  ## Ctrl key (Command key on Mac, Control key on Windows).
const modifierAlt: EModifierKey = 2.EModifierKey
  ## Alt key.
const modifierShift: EModifierKey = 4.EModifierKey
  ## Shift key.
const modifierCommand: EModifierKey = 8.EModifierKey
  ## Cmd key (Control key on Mac, Win key on Windows)

wclass(FModifierKeysState, header: "GenericPlatform/GenericApplication.h", bycopy):
  ## FModifierKeysState stores the pressed state of keys that are commonly used as modifiers
  proc initFModifierKeysState(bInIsLeftShiftDown,
                     bInIsRightShiftDown,
                     bInIsLeftControlDown,
                     bInIsRightControlDown,
                     bInIsLeftAltDown,
                     bInIsRightAltDown,
                     bInIsLeftCommandDown,
                     bInIsRightCommandDown,
                     bInAreCapsLocked: bool): FModifierKeysState {.constructor.}
    ## Constructor.  Events are immutable once constructed.

  proc initFModifierKeysState(): FModifierKeysState {.constructor.}


  proc isShiftDown(): bool {.noSideEffect.}
    ## Returns true if either shift key was down when this event occurred
    ##
    ## @return  True if shift is pressed

  proc isLeftShiftDown(): bool {.noSideEffect.}
    ## Returns true if left shift key was down when this event occurred
    ##
    ## @return  True if left shift is pressed

  proc isRightShiftDown(): bool {.noSideEffect.}
    ## Returns true if right shift key was down when this event occurred
    ##
    ## @return  True if right shift is pressed

  proc isControlDown(): bool {.noSideEffect.}
    ## Returns true if either control key was down when this event occurred
    ##
    ## @return  True if control is pressed

  proc isLeftControlDown(): bool {.noSideEffect.}
    ## Returns true if left control key was down when this event occurred
    ##
    ## @return  True if left control is pressed

  proc isRightControlDown(): bool {.noSideEffect.}
    ## Returns true if right control key was down when this event occurred
    ##
    ## @return  True if right control is pressed

  proc isAltDown(): bool {.noSideEffect.}
    ## Returns true if either alt key was down when this event occurred
    ##
    ## @return  True if alt is pressed

  proc isLeftAltDown(): bool {.noSideEffect.}
    ## Returns true if left alt key was down when this event occurred
    ##
    ## @return  True if left alt is pressed

  proc isRightAltDown(): bool {.noSideEffect.}
    ## Returns true if right alt key was down when this event occurred
    ##
    ## @return  True if right alt is pressed

  proc isCommandDown(): bool {.noSideEffect.}
    ## Returns true if either command key was down when this event occurred
    ##
    ## @return  True if command is pressed

  proc IsLeftCommandDown(): bool {.noSideEffect.}
    ## Returns true if left command key was down when this event occurred
    ##
    ## @return  True if left command is pressed

  proc isRightCommandDown(): bool {.noSideEffect.}
    ## Returns true if right command key was down when this event occurred
    ##
    ## @return  True if right command is pressed

  proc areCapsLocked(): bool {.noSideEffect.}
    ## @return  true if the Caps Lock key has been toggled to the enabled state.

  proc areModifersDown(modiferKeys: EModifierKey): bool
    ## @param ModifierKeys the modifier keys to test to see if they are pressed.  Returns true if no modifiers are specified.
    ## @return true if all modifier keys are pressed specified in the modifier keys.

type
  EWindowActivation* {.importcpp: "EWindowActivation::Type", header: "GenericPlatform/GenericApplicationMessageHandler.h", pure.} = enum
    Activate,
    ActivateByMouse,
    Deactivate

  EWindowType* {.importcpp: "EWindowType", header: "GenericPlatform/GenericApplicationMessageHandler.h", pure.} = enum
    ## Enumeration to specify different window types for SWindows
    Normal, ## Value indicating that this is a standard, general-purpose window
    Menu, ## Value indicating that this is a window used for a popup menu
    ToolTip, ## Value indicating that this is a window used for a tooltip
    Notification, ## Value indicating that this is a window used for a notification toast
    CursorDecorator ## Value indicating that this is a window used for a cursor decorator

  EWindowTransparency* {.importcpp: "EWindowTransparency", header: "GenericPlatform/GenericApplicationMessageHandler.h", pure.} = enum
    ## Enumeration to specify different transparency options for SWindows
    None,
      ## Value indicating that a window does not support transparency
    PerWindow,
        ## Value indicating that a window supports transparency at the window level (one opacity applies to the entire window)
    #if ALPHA_BLENDED_WINDOWS
    PerPixel
      ## Value indicating that a window supports per-pixel alpha blended transparency
    #endif

  EWindowZone* {.importcpp: "EWindowZone::Type", header: "GenericPlatform/GenericApplicationMessageHandler.h", pure.} = enum
    ## The Window Zone is the window area we are currently over to send back to the operating system
    ## for operating system compliance.
    NotInWindow = 0,
    TopLeftBorder  = 1,
    TopBorder = 2,
    TopRightBorder = 3,
    LeftBorder = 4,
    ClientArea = 5,
    RightBorder = 6,
    BottomLeftBorder = 7,
    BottomBorder = 8,
    BottomRightBorder = 9,
    TitleBar = 10,
    MinimizeButton = 11,
    MaximizeButton = 12,
    CloseButton = 13,
    SysMenu = 14,

  EWindowAction* {.importcpp: "EWindowAction::Type", header: "GenericPlatform/GenericApplicationMessageHandler.h", pure.} = enum
    ClickedNonClientArea = 1,
    Maximize = 2,
    Restore = 3,
    WindowMenu = 4

  EDropEffect* {.importcpp: "EDropEffect::Type", header: "GenericPlatform/GenericApplicationMessageHandler.h", pure.} = enum
    None, Copy, Move, Link

  EGestureEvent* {.importcpp: "EGestureEvent::Type", header: "GenericPlatform/GenericApplicationMessageHandler.h", pure.} = enum
    None, Scroll, Magnify, Swipe, Rotate, Count

## static methods from class UEngineTypes
proc convertToCollisionChannel*(traceType: ETraceTypeQuery): ECollisionChannel {.
  importcpp: "UEngineTypes::ConvertToCollisionChannel(@)", header: "Engine/EngineTypes.h", noSideEffect.}

proc convertToCollisionChannel*(collisionChannel: EObjectTypeQuery): ECollisionChannel {.
  importcpp: "UEngineTypes::ConvertToCollisionChannel(@)", header: "Engine/EngineTypes.h", noSideEffect.}

proc convertToObjectType*(collisionChannel: ECollisionChannel): EObjectTypeQuery {.
  importcpp: "UEngineTypes::ConvertToObjectType(@)", header: "Engine/EngineTypes.h", noSideEffect.}

proc convertToTraceType*(collisionChannel: ECollisionChannel): ETraceTypeQuery {.
  importcpp: "UEngineTypes::ConvertToTraceType(@)", header: "Engine/EngineTypes.h", noSideEffect.}
## end class UEngineTypes
