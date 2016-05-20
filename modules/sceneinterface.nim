# Copyright 2016 Xored Software, Inc.

wclass(FSceneInterface, header: "Public/SceneInterface.h", notypedef):
  proc addPrimitive(primitive: ptr UPrimitiveComponent)
    ## Adds a new primitive component to the scene
    ##
    ## @param Primitive - primitive component to add

  proc removePrimitive(primitive: ptr UPrimitiveComponent)
    ## Removes a primitive component from the scene
    ##
    ## @param Primitive - primitive component to remove

  proc releasePrimitive(primitive: ptr UPrimitiveComponent)
    ## Called when a primitive is being unregistered and will not be immediately re-registered.

  proc updatePrimitiveTransform(primitive: ptr UPrimitiveComponent)
    ## Updates the transform of a primitive which has already been added to the scene.
    ##
    ## @param Primitive - primitive component to update

  proc updatePrimitiveAttachment(primitive: ptr UPrimitiveComponent)
    ## Updates primitive attachment state.

  proc addLight(light: ptr ULightComponent)
    ## Adds a new light component to the scene
    ##
    ## @param Light - light component to add

  proc removeLight(light: ptr ULightComponent)
    ## Removes a light component from the scene
    ##
    ## @param Light - light component to remove

  proc addInvisibleLight(light: ptr ULightComponent)
    ## Adds a new light component to the scene which is currently invisible, but needed for editor previewing
    ##
    ## @param Light - light component to add
  proc setSkyLight(light: ptr FSkyLightSceneProxy)
  proc disableSkyLight(light: ptr FSkyLightSceneProxy)

  proc addDecal(component: ptr UDecalComponent)
    ## Adds a new decal component to the scene
    ##
    ## @param Component - component to add

  proc removeDecal(component: ptr UDecalComponent)
    ## Removes a decal component from the scene
    ##
    ## @param Component - component to remove

  proc updateDecalTransform(component: ptr UDecalComponent)
    ## Updates the transform of a decal which has already been added to the scene.
    ##
    ## @param Decal - Decal component to update

  proc addReflectionCapture(component: ptr UReflectionCaptureComponent)
    ## Adds a reflection capture to the scene.

  proc removeReflectionCapture(component: ptr UReflectionCaptureComponent)
    ## Removes a reflection capture from the scene.

  proc getReflectionCaptureData(component: ptr UReflectionCaptureComponent;
      outDerivedData: var FReflectionCaptureFullHDRDerivedData)
    ## Reads back reflection capture data from the GPU.
    ## Very slow operation that blocks the GPU and rendering thread many times.

  proc updateReflectionCaptureTransform(component: ptr UReflectionCaptureComponent)
    ## Updates a reflection capture's transform, and then re-captures the scene.

  proc allocateReflectionCaptures(newCaptures: TArray[
      ptr UReflectionCaptureComponent])
    ## Allocates reflection captures in the scene's reflection cubemap array and updates them by recapturing the scene.
    ## Existing captures will only be updated.  Must be called from the game thread.
  proc releaseReflectionCubemap(captureComponent: ptr UReflectionCaptureComponent)

  proc updateSkyCaptureContents(captureComponent: ptr USkyLightComponent;
                              bCaptureEmissiveOnly: bool;
                              sourceCubemap: ptr UTextureCube;
                              outProcessedTexture: ptr FTexture;
                              outIrradianceEnvironmentMap: var FSHVectorRGB3)
    ## Updates the contents of the given sky capture by rendering the scene.
    ## This must be called on the game thread.

  proc updateSceneCaptureContents(captureComponent: ptr USceneCaptureComponent2D)
    ## Updates the contents of the given scene capture by rendering the scene.
    ## This must be called on the game thread.
  proc updateSceneCaptureContents(captureComponent: ptr USceneCaptureComponentCube)
  proc addPrecomputedLightVolume(volume: ptr FPrecomputedLightVolume)
  proc removePrecomputedLightVolume(volume: ptr FPrecomputedLightVolume)

  proc updateLightTransform(light: ptr ULightComponent)
    ## Updates the transform of a light which has already been added to the scene.
    ##
    ## @param Light - light component to update

  proc updateLightColorAndBrightness(light: ptr ULightComponent)
    ## Updates the color and brightness of a light which has already been added to the scene.
    ##
    ## @param Light - light component to update

  proc updateDynamicSkyLight(upperColor: FLinearColor; lowerColor: FLinearColor)
    ## Updates the scene's dynamic skylight.

  proc setPrecomputedVisibility(precomputedVisibilityHandler: ptr FPrecomputedVisibilityHandler)
    ## Sets the precomputed visibility handler for the scene, or NULL to clear the current one.

  proc setPrecomputedVolumeDistanceField(precomputedVolumeDistanceField: ptr FPrecomputedVolumeDistanceField)
    ## Sets the precomputed volume distance field for the scene, or NULL to clear the current one.

  proc setShaderMapsOnMaterialResources(materialsToUpdate: TMap[ptr FMaterial,
      ptr FMaterialShaderMap])
    ## Sets shader maps on the specified materials without blocking.

  proc updateStaticDrawListsForMaterials(materials: TArray[ptr FMaterial])
    ## Updates static draw lists for the given set of materials.

  proc addExponentialHeightFog(fogComponent: ptr UExponentialHeightFogComponent)
    ## Adds a new exponential height fog component to the scene
    ##
    ## @param FogComponent - fog component to add

  proc removeExponentialHeightFog(fogComponent: ptr UExponentialHeightFogComponent)
    ## Removes a exponential height fog component from the scene
    ##
    ## @param FogComponent - fog component to remove

  proc addAtmosphericFog(fogComponent: ptr UAtmosphericFogComponent)
    ## Adds a new atmospheric fog component to the scene
    ##
    ## @param FogComponent - fog component to add

  proc removeAtmosphericFog(fogComponent: ptr UAtmosphericFogComponent)
    ## Removes a atmospheric fog component from the scene
    ##
    ## @param FogComponent - fog component to remove

  proc removeAtmosphericFogResource_RenderThread(fogResource: ptr FRenderResource)
    ## Removes a atmospheric fog resource from the scene...this is just a double check to make sure we don't have stale stuff hanging around; should already be gone.
    ##
    ## @param FogResource - fog resource to remove

  proc getAtmosphericFogSceneInfo(): ptr FAtmosphericFogSceneInfo
    ## Returns the scene's FAtmosphericFogSceneInfo if it exists

  proc addWindSource(windComponent: ptr UWindDirectionalSourceComponent)
    ## Adds a wind source component to the scene.
    ## @param WindComponent - The component to add.

  proc removeWindSource(windComponent: ptr UWindDirectionalSourceComponent)
    ## Removes a wind source component from the scene.
    ## @param WindComponent - The component to remove.

  proc getWindSources_RenderThread(): var TArray[ptr FWindSourceSceneProxy] {.
      noSideEffect.}
    ## Accesses the wind source list.  Must be called in the rendering thread.
    ## @return The list of wind sources in the scene.

  proc getWindParameters(position: FVector; outDirection: var FVector;
                        outSpeed: var cfloat; outMinGustAmt: var cfloat;
                        outMaxGustAmt: var cfloat) {.noSideEffect.}
    ## Accesses wind parameters.  XYZ will contain wind direction * Strength, W contains wind speed.

  proc getDirectionalWindParameters(outDirection: var FVector; outSpeed: var cfloat;
                                  outMinGustAmt: var cfloat;
                                  outMaxGustAmt: var cfloat) {.noSideEffect.}
    ## Same as GetWindParameters, but ignores point wind sources.

  proc addSpeedTreeWind(vertexFactory: ptr FVertexFactory; staticMesh: ptr UStaticMesh)
    ## Adds a SpeedTree wind computation object to the scene.
    ## @param StaticMesh - The SpeedTree static mesh whose wind to add.

  proc removeSpeedTreeWind(vertexFactory: ptr FVertexFactory;
                          staticMesh: ptr UStaticMesh)
    ## Removes a SpeedTree wind computation object to the scene.
    ## @param StaticMesh - The SpeedTree static mesh whose wind to remove.
  proc removeSpeedTreeWind_RenderThread(vertexFactory: ptr FVertexFactory;
                                      staticMesh: ptr UStaticMesh)

  proc updateSpeedTreeWind(currentTime: cdouble)
    ## Ticks the SpeedTree wind object and updates the uniform buffer.

  proc getSpeedTreeUniformBuffer(vertexFactory: ptr FVertexFactory): FUniformBufferRHIParamRef
    ## Looks up the SpeedTree uniform buffer for the passed in vertex factory.
    ## @param VertexFactory - The vertex factory registered for SpeedTree.

  proc release()
    ## Release this scene and remove it from the rendering thread

  proc getRelevantLights(primitive: ptr UPrimitiveComponent;
                        relevantLights: ptr TArray[ptr ULightComponent]) {.
      noSideEffect.}
    ## Retrieves the lights interacting with the passed in primitive and adds them to the out array.
    ##
    ## @param	Primitive				Primitive to retrieve interacting lights for
    ## @param	RelevantLights	[out]	Array of lights interacting with primitive

  proc requiresHitProxies(): bool {.noSideEffect.}
    ## Indicates if hit proxies should be processed by this scene
    ##
    ## @return true if hit proxies should be rendered in this scene.

  proc getWorld(): ptr UWorld {.noSideEffect.}
    ## Get the optional UWorld that is associated with this scene
    ##
    ## @return UWorld instance used by this scene

  proc getRenderScene(): ptr FScene
    ## Return the scene to be used for rendering. Note that this can return NULL if rendering has
    ## been disabled!

  proc setFXSystem(inFXSystem: ptr FFXSystemInterface)
    ## Sets the FX system associated with the scene.

  proc getFXSystem(): ptr FFXSystemInterface
    ## Get the FX system associated with the scene.
  proc dumpUnbuiltLightIteractions(ar: var FOutputDevice) {.noSideEffect.}

  proc dumpStaticMeshDrawListStats() {.noSideEffect.}
    ## Dumps static mesh draw list stats to the log.

  proc setClearMotionBlurInfoGameThread()
    ## Request to clear the MB info. Game thread only

  proc updateParameterCollections(inParameterCollections: TArray[
      ptr FMaterialParameterCollectionInstanceResource])
    ## Updates the scene's list of parameter collection id's and their uniform buffers.

  proc `export`(ar: var FArchive) {.noSideEffect.}
    ## Exports the scene.
    ##
    ## @param	Ar		The Archive used for exporting.

  proc applyWorldOffset(inOffset: FVector)
    ## Shifts scene data by provided delta
    ## Called on world origin changes
    ##
    ## @param	InOffset	Delta to shift scene by

  proc onLevelAddedToWorld(inLevelName: FName)
    ## Notification that level was added to a world
    ##
    ## @param	InLevelName		Level name

  proc hasAnyLights(): bool {.noSideEffect.}
    ## @return True if there are any lights in the scene
  proc isEditorScene(): bool {.noSideEffect.}
  proc getFeatureLevel(): ERHIFeatureLevel
  proc getShaderPlatform(): EShaderPlatform {.noSideEffect.}
  proc shouldUseDeferredRenderer(): bool {.noSideEffect.}

  proc getScenePrimitiveComponentIds(): TArray[FPrimitiveComponentId] {.noSideEffect.}
    ## Returns the FPrimitiveComponentId for all primitives in the scene