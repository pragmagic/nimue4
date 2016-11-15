# Copyright 2016 Xored Software, Inc.

wclass(UMaterialInstanceDynamic of UMaterialInstance, header: "Materials/MaterialInstanceDynamic.h", notypedef):

  proc k2_CopyMaterialInstanceParameters(source: ptr UMaterialInterface)
    ## Copies over parameters given a material interface (copy each instance following the hierarchy)
    ## Very slow implementation, avoid using at runtime. Hopefully we can replace ity later with something like CopyInterpParameters()
    ## The output is the object itself (this).

  proc copyInterpParameters(source: ptr UMaterialInterface)
    ## Copies over parameters given a material instance (only copy from the instance, not following the hierarchy)
    ## much faster than K2_CopyMaterialInstanceParameters(),
    ## The output is the object itself (this).
    ## @param Source ignores the call if 0

  proc copyParameterOverrides(materialInstance: ptr UMaterialInstance)
    ## Copy parameter values from another material instance. This will copy only parameters explicitly overridden in that material instance!!
    ## @param materialInstance			material instance to copy parameters.

  proc setScalarParameterValue(parameterName: FName, value: float32)
  proc setTextureParameterValue(parameterName: FName, value: ptr UTexture)
  proc setVectorParameterValue(parameterName: FName, value: FLinearColor)