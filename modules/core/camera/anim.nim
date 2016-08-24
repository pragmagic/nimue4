# Copyright 2016 Xored Software, Inc.

wclass(UCameraAnim of UObject, header: "Camera/CameraAnim.h"):
  ## A predefined animation to be played on a camera
  var cameraInterpGroup: ptr UInterpGroup
    ## The UInterpGroup that holds our actual interpolation data.
#if WITH_EDITORONLY_DATA
  var previewInterpGroup: ptr UInterpGroup
    ## This is to preview and they only exists in editor
#endif
  var animLength: cfloat
    ## Length, in seconds.
  var boundingBox: FBox
    ## AABB in local space.

  var bRelativeToInitialTransform: bool
    ## If true, assume all transform keys are intended be offsets from the start of the animation. This allows the animation to be authored at any world location and be applied as a delta to the camera. 
    ## If false, assume all transform keys are authored relative to the world origin. Positions will be directly applied as deltas to the camera.

  var baseFOV: cfloat
    ## The FOV

  var basePostProcessSettings: FPostProcessSettings
    ## Default PP settings to put on the animated camera. For modifying PP without keyframes.

  var basePostProcessBlendWeight: cfloat
    ## Default PP blend weight to put on the animated camera. For modifying PP without keyframes.

  proc createFromInterpGroup(srcGroup: ptr UInterpGroup, inMatineeActor: ptr AMatineeActor): bool
    ## Construct a camera animation from an InterpGroup.  The InterpGroup must control a CameraActor.
    ## Used by the editor to "export" a camera animation from a normal Matinee scene.

  proc getAABB(baseLoc: FVector, baseRot: FRotator, scale: cfloat): FBox {.noSideEffect.}
    ## Gets AABB of the camera's path. Useful for rough testing if you can play an animation at a certain
    ## location in the world without penetrating geometry.
    ## @return Returns the local-space axis-aligned bounding box of the entire motion of this animation. 
