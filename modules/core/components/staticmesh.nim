# Copyright 2016 Xored Software, Inc.

wclass(UStaticMeshComponent of UMeshComponent, header: "Components/StaticMeshComponent.h", notypedef):
  proc setStaticMesh(mesh: ptr UStaticMesh)
