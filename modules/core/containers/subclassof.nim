# Copyright 2016 Xored Software, Inc.

type TSubclassOf* {.header: "CoreUObject.h", importcpp: "TSubclassOf"} [T] = object

converter toUClassPtr*(cont: TSubclassOf): ptr UClass {.header: "CoreUObject.h", importcpp: "#".}
