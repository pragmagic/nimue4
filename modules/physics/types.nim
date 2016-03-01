# Copyright 2016 Xored Software, Inc.

type
  FRigidBodyCollisionInfo* {.header: "PhysicsPublic.h", importcpp.} = object
  FCollisionQueryParams* {.header: "CollisionQueryParams.h", importcpp.} = object
  FCollisionResponseParams* {.header: "CollisionQueryParams.h", importcpp.} = object
  FCollisionObjectQueryParams* {.header: "CollisionQueryParams.h", importcpp.} = object
  FComponentQueryParams* {.header: "CollisionQueryParams.h", importcpp.} = object
  FCollisionShape* {.header: "WorldCollision.h", importcpp.} = object
  FBodyInstance* {.header: "PhysicsEngine/BodyInstance.h", importcpp.} = object

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

# TODO

var defaultObjectQueryParam {.
  header: "CollisionQueryParams.h",
  importcpp: "FCollisionObjectQueryParams::DefaultObjectQueryParam".}: FCollisionObjectQueryParams
