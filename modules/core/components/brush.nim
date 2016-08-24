# Copyright 2016 Xored Software, Inc.

wclass(UBrushComponent of UPrimitiveComponent, header: "Components/BrushComponent.h", notypedef):
  ## A brush component defines a shape that can be modified within the editor. They are used both as part of BSP building, and for volumes.
  ## @see https://docs.unrealengine.com/latest/INT/Engine/Actors/Volumes
  ## @see https://docs.unrealengine.com/latest/INT/Engine/Actors/Brushes

  var brush: ptr UModel
  var brushBodySetup: ptr UBodySetup
    ## Description of collision

#if WITH_EDITOR
  proc requestUpdateBrushCollision()
    ## If the transform mirroring no longer reflects the body setup, request its recalculation
#endif

  proc buildSimpleBrushCollision()
    ## Create the AggGeom collection-of-convex-primitives from the Brush UModel data.
