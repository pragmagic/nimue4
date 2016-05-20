# Copyright 2016 Xored Software, Inc.

wclass(USpringArmComponent of USceneComponent, header: "GameFramework/SpringArmComponent.h", notypedef):
  ## This component tries to maintain its children at a fixed distance from the parent,
  ## but will retract the children if there is a collision, and spring back when there is no collision.
  ##
  ## Example: Use as a 'camera boom' to keep the follow camera for a player from colliding into the world.
  ##
  ## UCLASS(ClassGroup=Camera, meta=(BlueprintSpawnableComponent), hideCategories=(Mobility))

  var targetArmLength: cfloat
    ## Natural length of the spring arm when there are no collisions
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Camera)

  var socketOffset: FVector
    ## offset at end of spring arm; use this instead of the relative offset of the
    ## attached component to ensure the line trace works as desired
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Camera)

  var targetOffset: FVector
    ## Offset at start of spring, applied in world space.
    ## Use this if you want a world-space offset from the parent component instead of
    ##  the usual relative-space offset.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Camera)

  var probeSize: cfloat
    ## How big should the query probe sphere be (in unreal units)
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CameraCollision,
    ##           meta=(editcondition="bDoCollisionTest"))

  var probeChannel: ECollisionChannel
    ## Collision channel of the query probe (defaults to ECC_Camera)
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CameraCollision,
    ##           meta=(editcondition="bDoCollisionTest"))

  var bDoCollisionTest: bool
    ## If true, do a collision test using ProbeChannel and ProbeSize to prevent camera clipping into level.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CameraCollision)

  var bUsePawnControlRotation: bool
    ##  If this component is placed on a pawn, should it use the view/control rotation of the pawn where possible?
    ##  @see APawn::GetViewRotation()
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CameraSettings)

  var bInheritPitch: bool
    ## Should we inherit pitch from parent component. Does nothing if using Absolute Rotation.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CameraSettings)

  var bInheritYaw: bool
    ## Should we inherit yaw from parent component. Does nothing if using Absolute Rotation.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CameraSettings)

  var bInheritRoll: bool
    ## Should we inherit roll from parent component. Does nothing if using Absolute Rotation.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CameraSettings)

  var bEnableCameraLag: bool
    ## If true, camera lags behind target position to smooth its movement.
    ## @see CameraLagSpeed
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Lag)

  var bEnableCameraRotationLag: bool
    ## If true, camera lags behind target rotation to smooth its movement.
    ## @see CameraRotationLagSpeed
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Lag)

  var bUseCameraLagSubstepping: bool
    ## If bUseCameraLagSubstepping is true, sub-step camera damping so that
    ## it handles fluctuating frame rates well (though this comes at a cost).
    ## @see CameraLagMaxTimeStep
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = Lag, AdvancedDisplay)

  var bDrawDebugLagMarkers: bool
    ## If true and camera location lag is enabled, draws markers at the camera target (in green)
    ## and the lagged position (in yellow).
    ## A line is drawn between the two locations, in green normally but in red if
    ## the distance to the lag target has been clamped (by CameraLagMaxDistance).
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Lag)

  var cameraLagSpeed: cfloat
    ## If bEnableCameraLag is true, controls how quickly camera reaches target position.
    ## Low values are slower (more lag), high values are faster (less lag), while zero is instant (no lag).
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Lag,
    ##           meta=(editcondition="bEnableCameraLag", ClampMin="0.0", ClampMax="1000.0", UIMin = "0.0", UIMax = "1000.0"))

  var cameraRotationLagSpeed: cfloat
    ## If bEnableCameraRotationLag is true, controls how quickly camera reaches target position.
    ## Low values are slower (more lag), high values are faster (less lag), while zero is instant (no lag).
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Lag, meta=(editcondition = "bEnableCameraRotationLag", ClampMin="0.0", ClampMax="1000.0", UIMin = "0.0", UIMax = "1000.0"))

  var cameraLagMaxTimeStep: cfloat
    ## Max time step used when sub-stepping camera lag.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = Lag, AdvancedDisplay,
    ##           meta=(editcondition = "bUseCameraLagSubstepping", ClampMin="0.005", ClampMax="0.5", UIMin = "0.005", UIMax = "0.5"))

  var cameraLagMaxDistance: cfloat
    ## Max distance the camera target may lag behind the current location.
    ## If set to zero, no max distance is enforced.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Lag,
    ##           meta=(editcondition="bEnableCameraLag", ClampMin="0.0", UIMin = "0.0"))

  var previousDesiredLoc: FVector
    ## Temporary variables when using camera lag, to record previous camera position

  var previousArmOrigin: FVector

  var previousDesiredRot: FRotator
    ## Temporary variable for lagging camera rotation, for previous rotation

  var socketName {.isStatic.}: FName
    ## The name of the socket at the end of the spring arm (looking back towards the spring arm origin)

# protected:

  var relativeSocketLocation: FVector
    ## Cached component-space socket location

  var relativeSocketRotation: FQuat
    ## Cached component-space socket rotation

# protected:

  method updateDesiredArmLocation(bDoTrace: bool; bDoLocationLag: bool;
                                  bDoRotationLag: bool; deltaTime: cfloat)
    ## Updates the desired arm location, calling BlendLocations to do the actual blending if a trace is done

  method blendLocations(desiredArmLocation: FVector; traceHitLocation: FVector;
                        bHitSomething: bool; deltaTime: cfloat): FVector
    ## This function allows subclasses to blend the trace hit location with the desired arm location;
    ## by default it returns (if bHitSomething: traceHitLocation else: desiredArmLocation)