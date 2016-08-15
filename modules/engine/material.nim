# Copyright 2016 Xored Software, Inc.

wclass(UMaterialInstanceDynamic of UMaterialInstance, header: "Materials/MaterialInstanceDynamic.h", notypedef):

  proc copyParameterOverrides(materialInstance: ptr UMaterialInstance) {.importcpp.}
    ## Copy parameter values from another material instance. This will copy only parameters explicitly overridden in that material instance!!
    ## @param materialInstance			material instance to copy parameters.
