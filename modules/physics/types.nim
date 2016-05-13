# Copyright 2016 Xored Software, Inc.

type
  FRigidBodyCollisionInfo* {.header: "PhysicsPublic.h", importcpp.} = object
  FCollisionQueryParams* {.header: "CollisionQueryParams.h", importcpp.} = object
  FCollisionResponseParams* {.header: "CollisionQueryParams.h", importcpp.} = object
  FCollisionObjectQueryParams* {.header: "CollisionQueryParams.h", importcpp.} = object
  FComponentQueryParams* {.header: "CollisionQueryParams.h", importcpp.} = object
  FBodyInstance* {.header: "PhysicsEngine/BodyInstance.h", importcpp.} = object

  FCollisionParameters* {.header: "WorldCollision.h", importcpp.} = object
    ## Sets of Collision Parameters to run the async trace
    ##
    ## It includes basic Query Parameter, Response Parameter, Object Query Parameter as well as Shape of collision testing
    ##
    collisionQueryParam {.importcpp: "CollisionQueryParam".}: FCollisionQueryParams
      ## Collision Trace Parameters
    responseParam {.importcpp: "ResponseParam".}: FCollisionResponseParams
    objectQueryParam {.importcpp: "ObjectQueryParam".}: FCollisionObjectQueryParams
    collisionShape {.importcpp: "CollisionShape".}: FCollisionShape
      ## Contains Collision Shape data including dimension of the shape

  FTraceHandle* {.header: "WorldCollision.h", importcpp.} = object
    frameNumber {.importcpp: "FrameNumber".}: uint32
    index {.importcpp: "FrameNumber".}: uint32

  FCollisionShape* {.header: "WorldCollision.h", importcpp.} = object
  FOverlapDatum* {.header: "WorldCollision.h", importcpp.} = object
    pos {.importcpp: "Pos".}: FVector
    rot {.importcpp: "Rot".}: FQuat
    outOverlaps {.importcpp: "OutOverlaps".}: TArray[FOverlapResult]
      ## Output of the overlap request. Filled up by worker thread

  FBaseTraceDatum* {.header: "WorldCollision.h", importcpp, inheritable, bycopy.} = object
    ## Base Async Trace Data Struct for both overlap and trace
    ##
    ## Contains basic data that will need for handling trace
    ## such as World, Collision parameters and so on.
    physWorld {.importcpp: "PhysWorld".}: ptr UWorld
      ## Physics World this trace will run in
    collisionParams {.importcpp: "CollisionParams".}: FCollisionParameters
      ## Collection of collision parameters
    traceChannel {.importcpp: "TraceChannel".}: ECollisionChannel
      ## Collsion Trace Channel that this trace is running
    frameNumber {.importcpp: "FrameNumber".}: uint32
      ## Framecount when requested is made
    userData {.importcpp: "UserData".}: uint32
      ## User data

  FTraceDatum* {.header: "WorldCollision.h", importcpp.} = object of FBaseTraceDatum
    ## Trace/Sweep Data structure for async trace
    ##
    ## This saves request information by main thread and result will be filled up by worker thread
    datumStart {.importcpp: "Start".}: FVector
    datumEnd {.importcpp: "End".}: FVector
    outHits {.importcpp: "OutHits".}: TArray[FHitResult]
      ## Output of the overlap request. Filled up by worker thread
    bIsMultiTrace: bool
      ## Single or multi trace

  EDOFMode* {.header: "PhysicsEngine/BodyInstance.h", importcpp: "EDOFMode::Type", pure, size: sizeof(cint).} = enum
    Default,
      ## Inherits the degrees of freedom from the project settings.
    SixDOF,
      ## Specifies which axis to freeze rotation and movement along.
    YZPlane,
      ## Allows 2D movement along the Y-Z plane.
    XZPlane,
      ## Allows 2D movement along the X-Z plane.
    XYPlane,
      ## Allows 2D movement along the X-Y plane.
    CustomPlane,
      ## Allows 2D movement along the plane of a given normal
    None
      ## No constraints.

  UPhysicalMaterial* {.header: "PhysicalMaterials/PhysicalMaterials.h", importcpp.} = object of UObject
  FPhysScene* {.header: "PhysicsPublic.h", importcpp.} = object

var defaultComponentQueryParams {.importcpp: "FComponentQueryParams::DefaultComponentQueryParams", nodecl.}: FComponentQueryParams
var defaultResponseParam {.importcpp: "FCollisionResponseParams::DefaultResponseParam", nodecl.}: FCollisionResponseParams
var defaultQueryParam {.importcpp: "FCollisionQueryParams::DefaultQueryParam", nodecl.}: FCollisionQueryParams

declareBuiltinDelegate(FOverlapDelegate, dkSimple, "WorldCollision.h", traceHandle: FTraceHandle, datum: FOverlapDatum)
declareBuiltinDelegate(FTraceDelegate, dkSimple, "WorldCollision.h", traceHandle: FTraceHandle, datum: FTraceDatum)
proc delegate(datum: FOverlapDatum): FOverlapDelegate {.importcpp: "#.Delegate", nodecl.}
proc delegate(datum: FTraceDatum): FTraceDelegate {.importcpp: "#.Delegate", nodecl.}
  ## Delegate to be set if you want Delegate to be called when the output is available. Filled up by requester (main thread)

var defaultObjectQueryParam {.
  header: "CollisionQueryParams.h",
  importcpp: "FCollisionObjectQueryParams::DefaultObjectQueryParam".}: FCollisionObjectQueryParams
