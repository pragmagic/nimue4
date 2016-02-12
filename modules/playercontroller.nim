# Copyright 2016 Xored Software, Inc.

type
  APlayerController* {.header: "GameFramework/PlayerController.h", importcpp: "APlayerController", nodecl, inheritable.} = object of AController
    bShowMouseCursor*: bool
    CurrentClickTraceChannel*: ECollisionChannel
    DefaultMouseCursor*: EMouseCursor
    InputComponent*: UInputComponent