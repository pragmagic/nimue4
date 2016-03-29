# Copyright 2016 Xored Software, Inc.

proc gameContentDir*(): FString {.header: "Misc/Paths.h", importcpp:"FPaths::GameContentDir()".}
proc gameConfigDir*(): FString {.header: "Misc/Paths.h", importcpp:"FPaths::GameConfigDir()".}

# TODO