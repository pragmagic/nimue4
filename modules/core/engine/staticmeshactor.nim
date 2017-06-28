# Copyright 2016 Xored Software, Inc.

wclass(AStaticMeshActor of AActor, header: "Engine/StaticMeshActor.h"):
  var bStaticMeshReplicateMovement: bool
  var navigationGeometryGatheringMode: ENavDataGatheringMode

  proc setMobility(inMobility: EComponentMobility)
  proc getStaticMeshComponent(): ptr UStaticMeshComponent {.noSideEffect.}
    ## Returns StaticMeshComponent subobject
