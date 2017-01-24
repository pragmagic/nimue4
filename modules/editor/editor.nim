# Copyright 2016 Xored Software, Inc.

declareBuiltinDelegate(FOnPostSaveWorld, dkMulticast, "Editor.h", saveFlags: uint32, world: ptr UWorld, bSuccess: bool)

var postSaveWorld* {.header: "Editor.h", importcpp: "FEditorDelegates::PostSaveWorld".}: FOnPostSaveWorld

