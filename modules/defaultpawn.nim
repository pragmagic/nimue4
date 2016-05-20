# Copyright 2016 Xored Software, Inc.

## =============================================================================
## DefaultPawns are simple pawns that can fly around the world.
## =============================================================================

wclass(ADefaultPawn of APawn, header: "GameFramework/DefaultPawn.h", notypedef):
  ## DefaultPawn implements a simple Pawn with spherical collision and built-in flying movement.
  ## @see UFloatingPawnMovement

  method moveForward(val: cfloat)
    ## Input callback to move forward in local space (or backward if Val is negative).
    ## @param Val Amount of movement in the forward direction (or backward if negative).
    ## @see APawn::AddMovementInput()
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  method moveRight(val: cfloat)
    ## Input callback to strafe right in local space (or left if Val is negative).
    ## @param Val Amount of movement in the right direction (or left if negative).
    ## @see APawn::AddMovementInput()
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  method moveUp_World(val: cfloat)
    ## Input callback to move up in world space (or down if Val is negative).
    ## @param Val Amount of movement in the world up direction (or down if negative).
    ## @see APawn::AddMovementInput()
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  proc turnAtRate(rate: cfloat)
    ## Called via input to turn at a given rate.
    ## @param Rate	This is a normalized rate, i.e. 1.0 means 100% of desired turn rate
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  proc lookUpAtRate(rate: cfloat)
    ## Called via input to look up at a given rate (or down if Rate is negative).
    ## @param Rate	This is a normalized rate, i.e. 1.0 means 100% of desired turn rate
    ##
    ## UFUNCTION(BlueprintCallable, Category="Pawn")

  var baseTurnRate: cfloat
    ## Base turn rate, in deg/sec. Other scaling may affect final turn rate.
    ## UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="Pawn")

  var baseLookUpRate: cfloat
    ## Base lookup rate, in deg/sec. Other scaling may affect final lookup rate.
    ## UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category="Pawn")

  var movementComponentName {.isStatic.}: FName
    ## Name of the MovementComponent.
    ## Use this name if you want to use a different class (with ObjectInitializer.SetDefaultSubobjectClass).

  var collisionComponentName {.isStatic.}: FName
    ## Name of the CollisionComponent.

  var meshComponentName {.isStatic.}: FName
    ## Name of the MeshComponent.
    ## Use this name if you want to prevent creation of
    ## the component (with ObjectInitializer.DoNotCreateDefaultSubobject).

  var bAddDefaultMovementBindings: bool
    ## If true, adds default input bindings for movement and camera look.
    ## UPROPERTY(Category=Pawn, EditAnywhere, BlueprintReadOnly)

  proc getCollisionComponent(): ptr USphereComponent {.noSideEffect.}
    ## Returns CollisionComponent subobject

  proc getMeshComponent(): ptr UStaticMeshComponent {.noSideEffect.}
    ## Returns MeshComponent subobject *