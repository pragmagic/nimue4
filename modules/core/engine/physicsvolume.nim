# Copyright 2016 Xored Software, Inc.

wclass(APhysicsVolume of AVolume, header: "GameFramework/PhysicsVolume.h"):
  ## PhysicsVolume: A bounding volume which affects actor physics.
  ## Each AActor is affected at any time by one PhysicsVolume.

  method postInitializeComponents()
  method destroyed()
  method endPlay(endPlayReason: EEndPlayReason)

  #======================================================================================
  # Character Movement related properties
  #======================================================================================

  var terminalVelocity: cfloat
    ## Terminal velocity of pawns using CharacterMovement when falling.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CharacterMovement)

  var priority: int32
    ## Determines which PhysicsVolume takes precedence if they overlap (higher number = higher priority).
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CharacterMovement)

  var fluidFriction: cfloat
    ## This property controls the amount of friction applied by the volume as pawns using CharacterMovement move through it. The higher this value, the harder it will feel to move through
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CharacterMovement)

  var bWaterVolume: bool
    ## True if this volume contains a fluid like water
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CharacterMovement)

  #======================================================================================
  # Physics related properties
  #======================================================================================

  var bPhysicsOnContact: bool
    ## By default, the origin of an AActor must be inside a PhysicsVolume for it to affect the actor. However if this flag is true, the other actor only has to touch the volume to be affected by it.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Volume)

  method getGravityZ(): cfloat {.noSideEffect.}
    ## @Returns the Z component of the current world gravity.

  method actorEnteredVolume(other: ptr AActor)
    ## Called when actor enters a volume

  method actorLeavingVolume(other: ptr AActor)
    ## Called when actor leaves a volume, Other can be NULL

  method isOverlapInVolume(testComponent: USceneComponent): bool {.noSideEffect.}
    ## Given a known overlap with the given component, validate that it meets the rules imposed by bPhysicsOnContact.

type
  ADefaultPhysicsVolume {.importcpp, header: "GameFramework/DefaultPhysicsVolume.h".} = object of APhysicsVolume
    ## DefaultPhysicsVolume determines the physical effects an actor will experience
    ## if they are not inside any user specified PhysicsVolume
