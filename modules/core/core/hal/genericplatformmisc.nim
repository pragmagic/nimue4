# Copyright 2016 Xored Software, Inc.

proc getUniqueDeviceId*(): FString {.importcpp: "FPlatformMisc::GetUniqueDeviceId(@)", header: "GenericPlatform/GenericPlatformMisc.h", nodecl.}

proc getDeviceId*(): FString {.importcpp: "FPlatformMisc::GetDeviceId(@)", header: "GenericPlatform/GenericPlatformMisc.h", nodecl.}

proc requestExit*(force: bool) {.importcpp: "FGenericPlatformMisc::RequestExit(@)", header: "GenericPlatform/GenericPlatformMisc.h".}