# Copyright 2016 Xored Software, Inc.

wclass(UNavMovementComponent of UMovementComponent, header: "GameFramework/NavMovementComponent.h", notypedef):
  ## NavMovementComponent defines base functionality for MovementComponents
  ## that move any 'agent' that may be involved in AI pathfinding.

  var navAgentProps: FNavAgentProperties
    ## Properties that define how the component can move.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Movement Capabilities", meta=(DisplayName="Movement Capabilities", Keywords="Nav Agent"))

  var bUpdateNavAgentWithOwnersCollision: bool
    ## If set to true NavAgentProps' radius and height will be updated with Owner's collision capsule size
    ## UPROPERTY(EditAnywhere, Category=MovementComponent)

  var movementState: FMovementProperties
    ## Expresses runtime state of character's movement. Put all temporal changes to movement properties here
    ## UPROPERTY()

  var pathFollowingComp: TWeakObjectPtr[UPathFollowingComponent]
    ## Associated path following component

  method stopActiveMovement()
    ## Stops applying further movement (usually zeros acceleration).
    ## UFUNCTION(BlueprintCallable, Category="Pawn|Components|PawnMovement")

  proc stopMovementKeepPathing()
    ## Stops movement immediately (reset velocity) but keeps following current path
    ## UFUNCTION(BlueprintCallable, Category="Components|Movement")

  proc setUpdateNavAgentWithOwnersCollisions(bUpdateWithOwner: bool)

  proc shouldUpdateNavAgentWithOwnersCollision(): bool {.noSideEffect.}
  proc updateNavAgent(inOwner: AActor)
  proc updateNavAgent(capsuleComponent: UCapsuleComponent)

  proc getActorLocation(): FVector {.noSideEffect.}
    ## @returns location of controlled actor - meaning center of collision bounding box

  proc getActorFeetLocation(): FVector {.noSideEffect.}
    ## @returns location of controlled actor's "feet" meaning center of bottom of collision bounding box

  proc getActorFeetLocationBased(): FBasedPosition {.noSideEffect.}
    ## @returns based location of controlled actor

  method getActorNavLocation(): FVector {.noSideEffect.}
    ## @returns navigation location of controlled actor

  method requestDirectMove(moveVelocity: FVector; bForceMaxSpeed: bool)
    ## Request direct movement

  method canStopPathFollowing(): bool {.noSideEffect.}
    ## Check if current move target can be reached right now if positions are matching
    ## (e.g. performing scripted move and can't stop)

  proc getNavAgentPropertiesRef(): var FNavAgentProperties
    ## @returns the NavAgentProps

  proc resetMoveState()
    ## Resets runtime movement state to character's movement capabilities

  method canStartPathFollowing(): bool {.noSideEffect.}
    ## @return true if path following can start

  proc canEverCrouch(): bool {.noSideEffect.}
    ## @return true if component can crouch

  proc canEverJump(): bool {.noSideEffect.}
    ## @return true if component can jump

  proc canEverMoveOnGround(): bool {.noSideEffect.}
    ## @return true if component can move along the ground (walk, drive, etc)

  proc canEverSwim(): bool {.noSideEffect.}
    ## @return true if component can swim

  proc canEverFly(): bool {.noSideEffect.}
    ## @return true if component can fly

  proc isJumpAllowed(): bool {.noSideEffect.}
    ## @return true if component is allowed to jump

  proc setJumpAllowed(bAllowed: bool)
    ## @param bAllowed true if component is allowed to jump

  method isCrouching(): bool {.noSideEffect.}
    ## @return true if currently crouching
    ## UFUNCTION(BlueprintCallable, Category="AI|Components|NavMovement")

  method isFalling(): bool {.noSideEffect.}
    ## @return true if currently falling (not flying, in a non-fluid volume, and not on the ground)
    ## UFUNCTION(BlueprintCallable, Category="AI|Components|NavMovement")

  method isMovingOnGround(): bool {.noSideEffect.}
    ## @return true if currently moving on the ground (e.g. walking or driving)
    ## UFUNCTION(BlueprintCallable, Category="AI|Components|NavMovement")

  method isSwimming(): bool {.noSideEffect.}
    ## @return true if currently swimming (moving through a fluid volume)
    ## UFUNCTION(BlueprintCallable, Category="AI|Components|NavMovement")

  method isFlying(): bool {.noSideEffect.}
    ## @return true if currently flying (moving through a non-fluid volume without resting on the ground)
    ## UFUNCTION(BlueprintCallable, Category="AI|Components|NavMovement")