# Copyright 2016 Xored Software, Inc.

proc gameContentDir*(): FString {.header: "Misc/Paths.h", importcpp:"FPaths::GameContentDir()".}
proc gameConfigDir*(): FString {.header: "Misc/Paths.h", importcpp:"FPaths::GameConfigDir()".}
proc gameLogDir*(): FString {.header: "Misc/Paths.h", importcpp:"FPaths::GameLogDir()".}
proc gameUserDir*(): FString {.header: "Misc/Paths.h", importcpp:"FPaths::GameUserDir()".}

# TODO: the rest

var gEngineIni* {.nodecl, importcpp: "GGameIni".}: FString ## Engine ini filename
var gEditorIni* {.nodecl importcpp: "GEditorIni".}: FString ## Editor ini filename
var gEditorKeyBindingsIni* {.nodecl, importcpp: "GEditorKeyBindingsIni".}: FString ## Editor Key Bindings ini file
var gEditorLayoutIni* {.nodecl, importcpp: "GEditorLayoutIni".}: FString ## Editor UI Layout ini filename
var gEditorSettingsIni* {.nodecl, importcpp: "GEditorSettingsIni".}: FString ## Editor Settings ini filename

# Editor per-project ini files - stored per project.
var gEditorPerProjectIni* {.nodecl, importcpp: "GEditorPerProjectIni".}: FString ## Editor User Settings ini filename

var gCompatIni* {.nodecl, importcpp: "GCompatIni".}: FString
var gLightmassIni* {.nodecl, importcpp: "GLightmassIni".}: FString ## Lightmass settings ini filename
var gScalabilityIni* {.nodecl, importcpp: "GScalabilityIni".}: FString ## Scalability settings ini filename
var gInputIni* {.nodecl, importcpp: "GInputIni".}: FString ## Input ini filename
var gGameIni* {.nodecl, importcpp: "GGameIni".}: FString ## Game ini filename
var gGameUserSettingsIni* {.nodecl, importcpp: "GGameUserSettingsIni".}: FString ## User Game Settings ini filename
