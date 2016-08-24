# Copyright 2016 Xored Software, Inc.

wclass(FDynamicPropertyPath, header: "UMG.h", bycopy):
  proc initFDynamicPropertyPath(): FDynamicPropertyPath {.constructor.}

  proc initFDynamicPropertyPath(path: FString): FDynamicPropertyPath

  proc initFDynamicPropertyPath(propertyChain: TArray[FString]): FDynamicPropertyPath

  proc isValid(): bool {.noSideEffect.}

  proc getValue[T](inContainer: ptr UObject, outValue: var T): bool {.noSideEffect.}

  proc getValue[T](inContainer: ptr UObject, outValue: var T, outProperty: var ptr UProperty): bool {.noSideEffect.}

wclass(UPropertyBinding of UObject, header: "UMG.h"):
  method isSupportedSource(property: ptr UProperty): bool {.noSideEffect.}
  method isSupportedDestination(property: ptr UProperty): bool {.noSideEffect.}

  # method bindProperty(property: ptr UProperty, delegate: ptr FScriptDelegate)

  # public:
  var sourceObject: TWeakObjectPtr[UObject]
    ## The source object to use as the initial container to resolve the Source Property Path on.

  var sourcePath: FDynamicPropertyPath
    ## The property path to trace to resolve this binding on the Source Object

  var destinationProperty: FName
    ## Used to determine if a binding already exists on the object and if this binding can be safely removed.
