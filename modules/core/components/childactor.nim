# Copyright 2016 Xored Software, Inc.

wclass(UChildActorComponent of USceneComponent, header: "Components/ChildActorComponent.h"):
  proc createChildActor()
  proc getChildActor(): ptr AActor {.noSideEffect.}
  proc getChildActorTemplate(): ptr AActor {.noSideEffect.}
  proc getChildActorName(): FName {.noSideEffect.}
  proc destroyChildActor()
