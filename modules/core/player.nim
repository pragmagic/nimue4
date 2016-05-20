# Copyright 2016 Xored Software, Inc.

wclass(UPlayer of UObject, header: "Engine/Player.h"):
  var playerController: ptr APlayerController
    ## The actor this player controls.
  var currentNetSpeed: int32
    ## The current speed of the connection
  var configuredInternetSpeed: int32
  var configuredLanSpeed: int32

  method exec(inWorld: ptr UWorld, cmd: wstring, ar: var FOutputDevice)
  method switchController(pc: ptr APlayerController)
    ## Dynamically assign Controller to Player and set viewport.
    ## `pc`: new player controller to assign to player

  method consoleCommand(cmd: FString, bWriteToLog: bool = true): FString {.discardable.}
    ## Executes the exec() command
    ##
    ## @param `cmd` command to execute (string of commands optionally separated by a | (pipe))
    ## @param `bWriteToLog` write out to the log

wclass(ULocalPlayer of UPlayer, header: "Engine/LocalPlayer.h"):
  discard

# TODO