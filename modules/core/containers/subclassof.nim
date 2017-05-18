# Copyright 2016 Xored Software, Inc.

type TSubclassOf* {.header: "CoreUObject.h", importcpp: "TSubclassOf"} [out T] = object

converter toUClassPtr*(cont: TSubclassOf): ptr UClass {.header: "CoreUObject.h", importcpp: "#".}
