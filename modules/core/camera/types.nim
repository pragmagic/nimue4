# Copyright 2016 Xored Software, Inc.

type
  ECameraProjectionMode {.header: "Camera/CameraTypes.h", importcpp: "ECameraProjectionMode::Type"} = enum
    Perspective,
    Orthographic

  ECameraAnimPlaySpace {.header: "Camera/CameraTypes.h", importcpp: "ECameraAnimPlaySpace".} = enum
    CameraLocal, ## This anim is applied in camera space.
    World, ## This anim is applied in world space.
    UserDefined, ## This anim is applied in a user-specified space (defined by UserPlaySpaceMatrix).

wclass(FMinimalViewInfo, header: "Camera/CameraTypes.h", bycopy):
  var location: FVector
    ## Location
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Camera)
  var rotation: FRotator
    ## Rotation
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Camera)
  var FOV: cfloat
    ## The field of view (in degrees) in perspective mode (ignored in Orthographic mode)
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Camera)
  var orthoWidth: cfloat
    ## The desired width (in world units) of the orthographic view (ignored in Perspective mode)
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Camera)
  var orthoNearClipPlane: cfloat
    ## The near plane distance of the orthographic view (in world units)
    ## UPROPERTY(Interp, EditAnywhere, BlueprintReadWrite, Category=Camera)
  var orthoFarClipPlane: cfloat
    ## The far plane distance of the orthographic view (in world units)
    ## UPROPERTY(Interp, EditAnywhere, BlueprintReadWrite, Category=Camera)
  var aspectRatio: cfloat
    ## Aspect Ratio (Width/Height); ignored unless bConstrainAspectRatio is true
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Camera)
  var bConstrainAspectRatio: bool
    ## If bConstrainAspectRatio is true, black bars will be added if the destination view has a different aspect ratio than this camera requested.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Camera)
  var bUseFieldOfViewForLOD: bool
    ## If true, account for the field of view angle when computing which level of detail to use for meshes.
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadWrite, Category=CameraSettings)
  var projectionMode: ECameraProjectionMode
    ## The type of camera
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Camera)
  var postProcessBlendWeight: cfloat
    ## Indicates if PostProcessSettings should be applied.
    ## UPROPERTY(BlueprintReadWrite, Category = Camera)
  var postProcessSettings: FPostProcessSettings
    ## Post-process settings to use if PostProcessBlendWeight is non-zero.
    ## UPROPERTY(BlueprintReadWrite, Category = Camera)

  proc equals(otherInfo: FMinimalViewInfo): bool {.noSideEffect.}
    ## Is this equivalent to the other one?

  proc blendViewInfo(otherInfo: FMinimalViewInfo, otherWeight: cfloat)
    ## Blends view information
    ## Note: booleans are orred together, instead of blending

  proc applyBlendWeight(weight: cfloat)
    ## Applies weighting to this view, in order to be blended with another one. Equals to this *= Weight.

  proc addWeightedViewInfo(otherView: FMinimalViewInfo, weight: cfloat)
    ## Combines this view with another one which will be weighted. Equals to this += OtherView * Weight.

# proc calculateProjectionMatrixGivenView*(viewInfo: FMinimalViewInfo, aspectRatioAxisConstraint: EAspectRatioAxisConstraint,
#                                          viewport: FViewport, inOutProjectionData: FSceneViewProjectionData)
#   ## Calculates the projection matrix (and potentially a constrained view rectangle) given a FMinimalViewInfo and partially configured projection data (must have the view rect already set)


# TODO
