# Copyright 2016 Xored Software, Inc.

proc getUniqueDeviceId*(): FString {.importcpp: "FPlatformMisc::GetUniqueDeviceId(@)", header: "GenericPlatform/GenericPlatformMisc.h", nodecl.}