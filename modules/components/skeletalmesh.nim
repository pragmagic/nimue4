# Copyright 2016 Xored Software, Inc.

wclass(USkeletalMeshComponent, header: "Components/SkeletalMeshComponent.h", notypedef):
  var bounds: FBoxSphereBounds
  var animScriptInstance: ptr UAnimInstance

# TODO