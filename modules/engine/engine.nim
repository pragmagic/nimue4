# Copyright 2016 Xored Software, Inc.

proc getWorldFromContextObject*(engine: ptr UEngine, obj: ptr UObject, bChecked: bool = true): ptr UWorld {.
  importcpp: "GetWorldFromContextObject", nodecl.}
  ## Obtain a world object pointer from an object with has a world context.
proc getFirstLocalPlayerController*(engine: ptr UEngine, inWorld: ptr UWorld): ptr APlayerController {.
  importcpp: "GetFirstLocalPlayerController", nodecl.}

# TODO: the rest