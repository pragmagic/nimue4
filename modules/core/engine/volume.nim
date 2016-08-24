# Copyright 2016 Xored Software, Inc.

type
  AVolume {.header: "GameFramework/Volume.h", importcpp.} = object of ABrush

#if WITH_EDITOR
## Delegate used for notifications when a volumes initial shape changes
declareBuiltinDelegate(FOnVolumeShapeChanged, dkMulticast, "GameFramework/Volume.h", volume: var AVolume)
#endif

wclass(AVolume of ABrush, header: "GameFramework/Volume.h", notypedef):
  ## An editable 3D volume placed in a level. Different types of volumes perform different functions
  ## @see https://docs.unrealengine.com/latest/INT/Engine/Actors/Volumes
  ## UCLASS(showcategories=Collision, hidecategories=(Brush, Physics), abstract, ConversionRoot)

#if WITH_EDITOR
  proc getOnVolumeShapeChangedDelegate(): var FOnVolumeShapeChanged
    ## Function to get the 'Volume imported' delegate
#endif

  proc encompassesPoint(point: FVector, sphereRadius: cfloat, outDistanceToPoint: ptr cfloat): bool
    ## @returns true if a sphere/point (with optional radius CheckRadius) overlaps this volume