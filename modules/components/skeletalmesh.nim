# Copyright 2016 Xored Software, Inc.

wclass(USkeletalMeshComponent of USkinnedMeshComponent, header: "Components/SkeletalMeshComponent.h", notypedef):
  var bounds: FBoxSphereBounds
  var animScriptInstance: ptr UAnimInstance

  method setSkeletalMesh(newMesh: ptr USkeletalMesh, bReinitPose:bool)
    ## Change the SkeletalMesh that is rendered for this Component. Will re-initialize the animation tree etc.
    ## @param newMesh - New mesh to set for this component
    ## @param bReinitPose - Whether we should keep current pose or reinitialize.

  method setAnimation(newAnimToPlay: ptr UAnimationAsset)
  method playAnimation(newAnimToPlay: ptr UAnimationAsset, bLooping: bool)

  method play(bLooping: bool)
  method stop()

# TODO