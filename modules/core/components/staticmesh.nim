# Copyright 2016 Xored Software, Inc.

wclass(UStaticMesh of UObject, header: "Engine/StaticMesh.h", notypedef):
  proc getBounds(): FBoxSphereBounds {.noSideEffect.}
    ## UFUNCTION( BlueprintPure, Category="StaticMesh" )

  proc getBoundingBox(): FBox {.noSideEffect.}
    ## UFUNCTION(BlueprintCallable, Category="StaticMesh")
    ## Returns the bounding box, in local space including bounds extension(s), of the StaticMesh asset

wclass(UStaticMeshComponent of UMeshComponent, header: "Components/StaticMeshComponent.h", notypedef):
  proc setStaticMesh(mesh: ptr UStaticMesh)
  proc getStaticMesh(): ptr UStaticMesh {.noSideEffect.}
