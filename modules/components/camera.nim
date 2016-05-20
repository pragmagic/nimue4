# Copyright 2016 Xored Software, Inc.

wclass(UCameraComponent of USceneComponent, header: "Camera/CameraComponent.h", notypedef):
  ## Represents a camera viewpoint and settings, such as projection type, field of view, and post-process overrides.
  ## The default behavior for an actor used as the camera view target is
  ## to look for an attached camera component and use its location, rotation, and settings.
  var fieldOfView: cfloat
    ## The horizontal field of view (in degrees) in perspective mode (ignored in Orthographic mode)
    ## UPROPERTY(Interp, EditAnywhere, BlueprintReadWrite, Category=CameraSettings,
    ##           meta=(UIMin = "5.0", UIMax = "170", ClampMin = "0.001", ClampMax = "360.0"))

  var orthoWidth: cfloat
    ## The desired width (in world units) of the orthographic view (ignored in Perspective mode)
    ## UPROPERTY(Interp, EditAnywhere, BlueprintReadWrite, Category=CameraSettings)

  var orthoNearClipPlane: cfloat
    ## The near plane distance of the orthographic view (in world units)
    ## UPROPERTY(Interp, EditAnywhere, BlueprintReadWrite, Category=CameraSettings)

  var orthoFarClipPlane: cfloat
    ## The far plane distance of the orthographic view (in world units)
    ## UPROPERTY(Interp, EditAnywhere, BlueprintReadWrite, Category=CameraSettings)

  var aspectRatio: cfloat
    ## Aspect Ratio (Width/Height)
    ## UPROPERTY(Interp, EditAnywhere, BlueprintReadWrite, Category=CameraSettings,
    ##           meta=(ClampMin = "0.1", ClampMax = "100.0", EditCondition="bConstrainAspectRatio"))

  var bConstrainAspectRatio: bool
    ## If bConstrainAspectRatio is true, black bars will be added if the destination view has
    ##  a different aspect ratio than this camera requested.
    ## UPROPERTY(Interp, EditAnywhere, BlueprintReadWrite, Category=CameraSettings)

  var bUseFieldOfViewForLOD: bool
    ## If true, account for the field of view angle when computing which level of detail to use for meshes.
    ## UPROPERTY(Interp, EditAnywhere, AdvancedDisplay, BlueprintReadWrite, Category=CameraSettings)

  var bUsePawnControlRotation: bool
    ## If this camera component is placed on a pawn, should it use the view/control rotation of the pawn where possible?
    ## @see APawn::GetViewRotation()
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CameraSettings)

  var projectionMode: ECameraProjectionMode
    ## The type of camera
    ## UPROPERTY(Interp, EditAnywhere, BlueprintReadWrite, Category=CameraSettings)

  var postProcessBlendWeight: cfloat
    ## Indicates if PostProcessSettings should be used when using this Camera to view through.
    ## UPROPERTY(Interp, EditAnywhere, BlueprintReadWrite, Category=CameraSettings, meta=(UIMin = "0.0", UIMax = "1.0"))

  var postProcessSettings: FPostProcessSettings
    ## Post process settings to use for this camera. Don't forget to check the properties you want to override
    ## UPROPERTY(Interp, BlueprintReadWrite, Category=CameraSettings)

  proc getCameraView(deltaTime: cfloat; desiredView: var FMinimalViewInfo)
    ## Returns camera's Point of View.
    ## Called by Camera class. Subclass and postprocess to add any effects.
    ##
    ## UFUNCTION(BlueprintCallable, Category=Camera)

  proc addOrUpdateBlendable(inBlendableObject: ptr IBlendableInterface;
                            inWeight: cfloat = 1.0)
    ## Adds an Blendable (implements IBlendableInterface) to the array of Blendables (if it doesn't exist) and update the weight
    ## UFUNCTION(BlueprintCallable, Category="Rendering")

#protected:

#if WITH_EDITORONLY_DATA:
  var drawFrustum: ptr UDrawFrustumComponent
    ## The frustum component used to show visually where the camera field of view is
    ## UPROPERTY(transient)

  var cameraMesh: ptr UStaticMesh
    ## UPROPERTY(transient)
  var proxyMeshComponent: ptr UStaticMeshComponent
    ## The camera mesh to show visually where the camera is placed
    ## UPROPERTY(transient)

# public:
  proc setCameraMesh(mesh: ptr UStaticMesh)
#endif // WITH_EDITORONLY_DATA

#if WITH_EDITORONLY_DATA
  proc refreshVisualRepresentation()
    ## Refreshes the visual components to match the component state
  proc overrideFrustumColor(overrideColor: FColor)
  proc restoreFrustumColor()
#endif