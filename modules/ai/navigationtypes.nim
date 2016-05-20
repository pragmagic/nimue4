# Copyright 2016 Xored Software, Inc.

wclass(FMovementProperties, header: "AI/Navigation/NavigationTypes.h", bycopy):
  var bCanCrouch: bool
    ## If true, this Pawn is capable of crouching.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MovementProperties)

  var bCanJump: bool
    ## If true, this Pawn is capable of jumping.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MovementProperties)

  var bCanWalk: bool
    ## If true, this Pawn is capable of walking or moving on the ground.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MovementProperties)

  var bCanSwim: bool
    ## If true, this Pawn is capable of swimming or moving through fluid volumes.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MovementProperties)

  var bCanFly: bool
    ## If true, this Pawn is capable of flying.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MovementProperties)

  proc makeFMovementProperties(): FMovementProperties {.constructor.}

wclass(FNavAgentProperties of FMovementProperties, header: "AI/Navigation/NavigationTypes.h", bycopy):
  ## Properties of representation of an 'agent' (or Pawn) used by AI navigation/pathfinding.

  var agentRadius: cfloat
    ## Radius of the capsule used for navigation/pathfinding.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MovementProperties, meta=(DisplayName="Nav Agent Radius"))

  var agentHeight: cfloat
    ## Total height of the capsule used for navigation/pathfinding.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MovementProperties, meta=(DisplayName="Nav Agent Height"))

  var agentStepHeight: cfloat
    ## Step height to use, or -1 for default value from navdata's config.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MovementProperties, meta=(DisplayName="Nav Agent Step Height"))

  var navWalkingSearchHeightScale: cfloat
    ## Scale factor to apply to height of bounds when searching for navmesh to project to when nav walking
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=MovementProperties)

  proc makeFNavAgentProperties(radius: cfloat = -1'f32, height: cfloat = -1'f32): FNavAgentProperties {.constructor.}

  proc updateWithCollisionComponent(collisionComponent: ptr UShapeComponent)

  proc isValid(): bool {.noSideEffect.}
  proc hasStepHeightOverride(): bool {.noSideEffect.}

  proc isEquivalent(other: var FNavAgentProperties, precision: cfloat = 5'f32): bool {.noSideEffect.}

  proc `==`(other: var FNavAgentProperties) {.noSideEffect.}

  proc getExtent(): FVector {.noSideEffect.}

  var defaultProperties {.isStatic.}: FNavAgentProperties

type NavNodeRef = uint64
  ## uniform identifier type for navigation data elements may it be a polygon or graph node

wclass(FNavLocation, header: "AI/Navigation/NavigationTypes.h", bycopy):
  ## Describes a point in navigation data
  var location: FVector
    ## location relative to path's base
  var nodeRef: NavNodeRef
    ## node reference in navigation data

  proc initFNavLocation(): FNavLocation {.constructor.}
  proc hasNodeRef(): bool {.noSideEffect.}
    ## checks if location has associated navigation node ref

# TODO: the rest