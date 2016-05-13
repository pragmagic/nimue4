# Copyright 2016 Xored Software, Inc.

var gFrameCounter* {.importcpp: "GFrameCounter", header: "CoreGlobals.h".}: uint64
var gLog* {.importcpp: "GLog", header: "CoreGlobals.h".}: ptr FOutputDeviceRedirector
