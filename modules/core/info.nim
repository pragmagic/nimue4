# Copyright 2016 Xored Software, Inc.

wclass(AInfo of AActor, header: "GameFramework/Info.h", notypedef):
  ## Info is the base class of an Actor that isn't meant to have a physical
  ## representation in the world, used primarily for "manager" type classes
  ## that hold settings data about the world, but might need to be an Actor
  ## for replication purposes.

  # when defined(WITH_EDITORONLY_DATA)
  proc getSpriteComponent(): ptr UBillboardComponent {.noSideEffect.}
    ## Returns SpriteComponent subobject
