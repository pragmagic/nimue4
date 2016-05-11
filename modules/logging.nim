# Copyright 2016 Xored Software, Inc.

proc ueFatal*(s: string) {.importcpp: "UE_LOG(LogTemp, Fatal, TEXT(\"%s\"), UTF8_TO_TCHAR((#)->data))", nodecl.}
proc ueError*(s: string) {.importcpp: "UE_LOG(LogTemp, Error, TEXT(\"%s\"), UTF8_TO_TCHAR((#)->data))", nodecl.}
proc ueWarning*(s: string) {.importcpp: "UE_LOG(LogTemp, Warning, TEXT(\"%s\"), UTF8_TO_TCHAR((#)->data))", nodecl.}
proc ueDisplay*(s: string) {.importcpp: "UE_LOG(LogTemp, Display, TEXT(\"%s\"), UTF8_TO_TCHAR((#)->data))", nodecl.}
proc ueLog*(s: string) {.importcpp: "UE_LOG(LogTemp, Log, TEXT(\"%s\"), UTF8_TO_TCHAR((#)->data))", nodecl.}
proc ueVerbose*(s: string) {.importcpp: "UE_LOG(LogTemp, Verbose, TEXT(\"%s\"), UTF8_TO_TCHAR((#)->data))", nodecl.}
proc ueVeryVerbose*(s: string) {.importcpp: "UE_LOG(LogTemp, VeryVerbose, TEXT(\"%s\"), UTF8_TO_TCHAR((#)->data))", nodecl.}
