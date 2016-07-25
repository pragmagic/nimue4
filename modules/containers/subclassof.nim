# Copyright 2016 Xored Software, Inc.

type TSubclassOf* {.header: "UObject/ObjectBase.h", importcpp: "TSubclassOf"} [T] = object

converter toUClassPtr*(cont: TSubclassOf): ptr UClass {.header: "UObject/ObjectBase.h", importcpp: "#".}
