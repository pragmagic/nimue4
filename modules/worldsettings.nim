# Copyright 2016 Xored Software, Inc.

type
  EVisibilityAggressiveness* {.importcpp, header: "GameFramework/WorldSettings.h".} = enum
    VIS_LeastAggressive,
    VIS_ModeratelyAggressive,
    VIS_MostAggressive,
    VIS_Max

  FGameModePrefix* {.importcpp: "FGameModePrefix", header: "GameFramework/WorldSettings.h".} = object
    ## Helper structure, used to associate GameModes for a map via its filename prefix.
    prefix* {.importcpp: "Prefix".}: FString
      ## map prefix, e.g. "DM"
    gameMode* {.importcpp: "GameMode".}: FString
      ## GameMode used if none specified on the URL

wclass(FLightmassWorldInfoSettings, header: "GameFramework/WorldSettings.h", bycopy):
  var staticLightingLevelScale: cfloat
    ## Warning: Setting this to less than 1 will greatly increase build times!
    ## Scale of the level relative to real world scale (1 Unreal Unit = 1 cm).
    ## All scale-dependent Lightmass setting defaults have been tweaked to work well with real world scale,
    ## Any levels with a different scale should use this scale to compensate.
    ## For large levels it can drastically reduce build times to set this to 2 or 4.
    ##
    ## UPROPERTY(EditAnywhere, Category=LightmassGeneral, AdvancedDisplay, meta=(UIMin = "1.0", UIMax = "4.0"))

  var numIndirectLightingBounces: int32
    ## Number of times light is allowed to bounce off of surfaces, starting from the light source.
    ## 0 is direct lighting only, 1 is one bounce, etc.
    ## Bounce 1 takes the most time to calculate and contributes the most to visual quality, followed by bounce 2.
    ## Successive bounces don't really affect build times, but have a much lower visual impact.
    ##
    ## UPROPERTY(EditAnywhere, Category=LightmassGeneral, meta=(UIMin = "1.0", UIMax = "4.0"))

  var indirectLightingQuality: cfloat
    ## Warning: Setting this higher than 1 will greatly increase build times!
    ## Can be used to increase the GI solver sample counts in order to get higher quality for levels that need it.
    ## It can be useful to reduce IndirectLightingSmoothness somewhat (~.75) when increasing quality to get defined indirect shadows.
    ## Note that this can't affect compression artifacts or other texture based artifacts.
    ##
    ## UPROPERTY(EditAnywhere, Category=LightmassGeneral, AdvancedDisplay, meta=(UIMin = "1.0", UIMax = "4.0"))

  var indirectLightingSmoothness: cfloat
    ## Smoothness factor to apply to indirect lighting.  This is useful in some lighting conditions when Lightmass cannot resolve accurate indirect lighting.
    ## 1 is default smoothness tweaked for a variety of lighting situations.
    ## Higher values like 3 smooth out the indirect lighting more, but at the cost of indirect shadows losing detail.
    ##
    ## UPROPERTY(EditAnywhere, Category=LightmassGeneral, AdvancedDisplay, meta=(UIMin = "0.5", UIMax = "6.0"))

  var environmentColor: FColor
    ## Represents a constant color light surrounding the upper hemisphere of the level, like a sky.
    ## This light source currently does not get bounced as indirect lighting.
    ##
    ## UPROPERTY(EditAnywhere, Category=LightmassGeneral)

  var environmentIntensity: cfloat
    ## Scales EnvironmentColor to allow independent color and brightness controls.
    ## UPROPERTY(EditAnywhere, Category=LightmassGeneral, meta=(UIMin = "0", UIMax = "10"))

  var emissiveBoost: cfloat
    ## Scales the emissive contribution of all materials in the scene.  Currently disabled and should be removed with mesh area lights.
    ## UPROPERTY()

  var diffuseBoost: cfloat
    ## Scales the diffuse contribution of all materials in the scene.
    ## UPROPERTY(EditAnywhere, Category=LightmassGeneral, meta=(UIMin = "0.1", UIMax = "6.0"))

  var bUseAmbientOcclusion: bool
    ## If true, AmbientOcclusion will be enabled.
    ## UPROPERTY(EditAnywhere, Category=LightmassOcclusion)

  var bGenerateAmbientOcclusionMaterialMask: bool
    ## Whether to generate textures storing the AO computed by Lightmass.
    ## These can be accessed through the PrecomputedAmbientOcclusion material node,
    ## Which is useful for blending between material layers on environment assets.
    ##
    ## UPROPERTY(EditAnywhere, Category=LightmassOcclusion)

  var directIlluminationOcclusionFraction: cfloat
    ## How much of the AO to apply to direct lighting.
    ## UPROPERTY(EditAnywhere, Category=LightmassOcclusion, meta=(UIMin = "0", UIMax = "1"))

  var indirectIlluminationOcclusionFraction: cfloat
    ## How much of the AO to apply to indirect lighting.
    ## UPROPERTY(EditAnywhere, Category=LightmassOcclusion, meta=(UIMin = "0", UIMax = "1"))

  var occlusionExponent: cfloat
    ## Higher exponents increase contrast.
    ## UPROPERTY(EditAnywhere, Category=LightmassOcclusion, meta=(UIMin = ".5", UIMax = "8"))

  var fullyOccludedSamplesFraction: cfloat
    ## Fraction of samples taken that must be occluded in order to reach full occlusion.
    ## UPROPERTY(EditAnywhere, Category=LightmassOcclusion, meta=(UIMin = "0", UIMax = "1"))

  var maxOcclusionDistance: cfloat
    ## Maximum distance for an object to cause occlusion on another object.
    ## UPROPERTY(EditAnywhere, Category=LightmassOcclusion)

  var bVisualizeMaterialDiffuse: bool
    ## If true, override normal direct and indirect lighting with just the exported diffuse term.
    ## UPROPERTY(EditAnywhere, Category=LightmassDebug, AdvancedDisplay)

  var bVisualizeAmbientOcclusion: bool
    ## If true, override normal direct and indirect lighting with just the AO term.
    ## UPROPERTY(EditAnywhere, Category=LightmassDebug, AdvancedDisplay)

  var volumeLightSamplePlacementScale: cfloat
    ## Scales the distances at which volume lighting samples are placed.  Volume lighting samples are computed by Lightmass and are used for GI on movable components.
    ## Using larger scales results in less sample memory usage and reduces Indirect Lighting Cache update times.
    ##
    ## UPROPERTY(EditAnywhere, Category=LightmassGeneral, AdvancedDisplay, meta=(UIMin = "0.1", UIMax = "100.0"))

  var bCompressLightmaps: bool
    ## Whether to compress lightmap textures.  Disabling lightmap texture compression will reduce artifacts but increase memory and disk size by 4x.
    ## Use caution when disabling this.
    ##
    ## UPROPERTY(EditAnywhere, Category=LightmassGeneral, AdvancedDisplay)

  proc initFLightmassWorldInfoSettings(): FLightmassWorldInfoSettings {.constructor.}

wclass(FHierarchicalSimplification, header: "GameFramework/WorldSettings.h", bycopy):
  var transitionScreenSize: cfloat
    ## #** The screen radius an mesh object should reach before swapping to the LOD actor, once one of parent displays, it won't draw any of children. */
    ## # UPROPERTY(Category = FHierarchicalSimplification, EditAnywhere, meta = (UIMin = "0.0000", ClampMin = "0.00000", UIMax = "1.0", ClampMax = "1.0"))

  var bSimplifyMesh: bool
    ## #* If this is true, it will simplify mesh but it is slower.
    ## #  If false, it will just merge actors but not simplify using the lower LOD if exists.
    ## #  For example if you build LOD 1, it will use LOD 1 of the mesh to merge actors if exists.
    ## #  If you merge material, it will reduce drawcalls.
    ## #
    ## # UPROPERTY(Category = FHierarchicalSimplification, EditAnywhere)

  var proxySetting: FMeshProxySettings
    ## #* Simplification Setting if bSimplifyMesh is true
    ## # UPROPERTY(Category = FHierarchicalSimplification, EditAnywhere, AdvancedDisplay)

  var mergeSetting: FMeshMergingSettings
    ## #* Merge Mesh Setting if bSimplifyMesh is false
    ## # UPROPERTY(Category = FHierarchicalSimplification, EditAnywhere, AdvancedDisplay)

  var desiredBoundRadius: cfloat
    ## #* Desired Bounding Radius for clustering - this is not guaranteed but used to calculate filling factor for auto clustering
    ## # UPROPERTY(EditAnywhere, Category=FHierarchicalSimplification, AdvancedDisplay, meta=(UIMin=10.f, ClampMin=10.f))

  var desiredFillingPercentage: cfloat
    ## #* Desired Filling Percentage for clustering - this is not guaranteed but used to calculate filling factor  for auto clustering
    ## # UPROPERTY(EditAnywhere, Category=FHierarchicalSimplification, AdvancedDisplay, meta=(ClampMin = "0", ClampMax = "100", UIMin = "0", UIMax = "100"))

  var minNumberOfActorsToBuild: int32
    ## #* Min number of actors to build LODActor
    ## # UPROPERTY(EditAnywhere, Category=FHierarchicalSimplification, AdvancedDisplay, meta=(ClampMin = "1", UIMin = "1"))

  proc initFHierarchicalSimplification(): FHierarchicalSimplification {.constructor.}

wclass(FNetViewer, header: "GameFramework/WorldSettings.h", bycopy):
  ## stores information on a viewer that actors need to be checked against for relevancy
  var inViewer: ptr AActor
    ## The "controlling net object" associated with this view (typically player controller)
  var viewTarget: ptr AActor
    ## The actor that is being directly viewed, usually a pawn.  Could also be the net actor of consequence
  var viewLocation: FVector
    ## Where the viewer is looking from
  var viewDir: FVector
    ## Direction the viewer is looking
  proc initFNetViewer(): FNetViewer {.constructor.}

  proc initFNetViewer(inConnection: ptr UNetConnection, deltaSeconds: cfloat): FNetViewer {.constructor.}

wclass(AWorldSettings of AInfo, header: "GameFramework/WorldSettings.h", notypedef):
# DEFAULT BASIC PHYSICS SETTINGS
  var bEnableWorldBoundsChecks: bool
    ## If true, enables CheckStillInWorld checks
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=World, AdvancedDisplay)

  var bEnableNavigationSystem: bool
    ## if set to false navigation system will not get created (and all navigation functionality won't be accessible)
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, config, Category=World, AdvancedDisplay)

  var bEnableWorldComposition: bool
    ## Enables tools for composing a tiled world.
    ## Level has to be saved and all sub-levels removed before enabling this option.
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=World)

  var bEnableWorldOriginRebasing: bool
    ## World origin will shift to a camera position when camera goes far away from current origin
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=World, AdvancedDisplay, meta=(editcondition = "bEnableWorldComposition"))

  var bWorldGravitySet: bool
    ## if set to true, when we call GetGravityZ we assume WorldGravityZ has already been initialized and skip the lookup of DefaultGravityZ and GlobalGravityZ
    ## UPROPERTY(transient)

  var bGlobalGravitySet: bool
    ## If set to true we will use GlobalGravityZ instead of project setting DefaultGravityZ
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, meta=(DisplayName = "Override World Gravity"), Category = Physics)

  var killZ: cfloat
    ## any actor falling below this level gets destroyed
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=World, meta=(editcondition = "bEnableWorldBoundsChecks"))

  var killZDamageType: TSubclassOf[UDamageType]
    ## The type of damage inflicted when a actor falls below KillZ
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=World, AdvancedDisplay, meta=(editcondition = "bEnableWorldBoundsChecks"))

  var worldGravityZ: cfloat
    ## current gravity actually being used
    ## UPROPERTY(transient, ReplicatedUsing=OnRep_WorldGravityZ)

  proc onRep_WorldGravityZ()
    ## UFUNCTION()

  var globalGravityZ: cfloat
    ## optional level specific gravity override set by level designer
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Physics, meta=(editcondition = "bGlobalGravitySet"))

  var defaultPhysicsVolumeClass: TSubclassOf[ADefaultPhysicsVolume]
    ## level specific default physics volume
    ## UPROPERTY(EditAnywhere, noclear, BlueprintReadOnly, Category=Physics, AdvancedDisplay)

  var physicsCollisionHandlerClass: TSubclassOf[UPhysicsCollisionHandler]
    ## optional level specific collision handler
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Physics, AdvancedDisplay)

#********************************
# GAMEMODE SETTINGS

  var defaultGameMode: TSubclassOf[AGameMode]
    ## The default GameMode to use when starting this map in the game. If this value is NULL, the INI setting for default game type is used.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=GameMode, meta=(DisplayName="GameMode Override"))

  var defaultMapPrefixes: TArray[FGameModePrefix]
    ## Used for loading appropriate game type if non-specified in URL
    ## UPROPERTY(config)

  var gameNetworkManagerClass: TSubclassOf[AGameNetworkManager]
    ## Class of GameNetworkManager to spawn for network games
    ## UPROPERTY()

#********************************
# RENDERING SETTINGS

  var packedLightAndShadowMapTextureSize: int32
    ## Maximum size of textures for packed light and shadow maps
    ## UPROPERTY(EditAnywhere, Category=Lightmass, AdvancedDisplay)

  var bMinimizeBSPSections: bool
    ## Causes the BSP build to generate as few sections as possible.
    ## This is useful when you need to reduce draw calls but can reduce texture streaming efficiency and effective lightmap resolution.
    ## Note - changes require a rebuild to propagate.  Also, be sure to select all surfaces and make sure they all have the same flags to minimize section count.
    ##
    ## UPROPERTY(EditAnywhere, Category=World, AdvancedDisplay)

  var defaultColorScale: FVector
    ## Default color scale for the level
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=World, AdvancedDisplay)

#**********************************
#* PRECOMPUTED VISIBILITY SETTINGS *

  var bPrecomputeVisibility: bool
    ## Whether to place visibility cells inside Precomputed Visibility Volumes and along camera tracks in this level.
    ## Precomputing visibility reduces rendering thread time at the cost of some runtime memory and somewhat increased lighting build times.
    ##
    ## UPROPERTY(EditAnywhere, Category=PrecomputedVisibility)

  var bPlaceCellsOnlyAlongCameraTracks: bool
    ## Whether to place visibility cells only along camera tracks or only above shadow casting surfaces.
    ##
    ## UPROPERTY(EditAnywhere, Category=PrecomputedVisibility, AdvancedDisplay)

  var visibilityCellSize: int32
    ## World space size of precomputed visibility cells in x and y.
    ## Smaller sizes produce more effective occlusion culling at the cost of increased runtime memory usage and lighting build times.
    ##
    ## UPROPERTY(EditAnywhere, Category=PrecomputedVisibility, AdvancedDisplay)

  var visibilityAggressiveness: EVisibilityAggressiveness
    ## Determines how aggressive precomputed visibility should be.
    ## More aggressive settings cull more objects but also cause more visibility errors like popping.
    ##
    ## UPROPERTY(EditAnywhere, Category=PrecomputedVisibility, AdvancedDisplay)

#**********************************
#* LIGHTMASS RELATED SETTINGS *

  var bForceNoPrecomputedLighting: bool
    ## Whether to force lightmaps and other precomputed lighting to not be created even when the engine thinks they are needed.
    ## This is useful for improving iteration in levels with fully dynamic lighting and shadowing.
    ## Note that any lighting and shadowing interactions that are usually precomputed will be lost if this is enabled.
    ##
    ## UPROPERTY(EditAnywhere, Category=Lightmass, AdvancedDisplay)

  var lightmassSettings: FLightmassWorldInfoSettings
    ## UPROPERTY(EditAnywhere, Category=Lightmass)

  var levelLightingQuality: ELightingBuildQuality
    ## The lighting quality the level was last built with
    ## UPROPERTY(Category=Lightmass, VisibleAnywhere)

  var defaultReverbSettings: FReverbSettings
    ##********************************
    ## AUDIO SETTINGS *
    ## Default reverb settings used by audio volumes.
    ## UPROPERTY(EditAnywhere, config, Category=Audio)

  var defaultAmbientZoneSettings: FInteriorSettings
    ## Default interior settings used by audio volumes.
    ## UPROPERTY(EditAnywhere, config, Category=Audio)

  var defaultBaseSoundMix: ptr USoundMix
    ## Default Base SoundMix.
    ## UPROPERTY(EditAnywhere, Category=Audio)

# when WITH_EDITORONLY_DATA:
  ## if set to true, hierarchical LODs will be built, which will create hierarchical LODActors
  ## UPROPERTY(EditAnywhere, config, Category=LODSystem)
  var bEnableHierarchicalLODSystem: bool
  ## Hierarchical LOD Setup
  ## UPROPERTY(EditAnywhere, Category=LODSystem, meta=(editcondition = "bEnableHierarchicalLODSystem"))
  var hierarchicalLODSetup: TArray[FHierarchicalSimplification]
  ## UPROPERTY()
  var numHLODLevels: int32
# endwhen

#**********************************
#* DEFAULT SETTINGS *


  var worldToMeters: cfloat
    ## scale of 1uu to 1m in real world measurements, for HMD and other physically tracked devices (e.g. 1uu = 1cm would be 100.0)
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=VR)

#**********************************
#* EDITOR ONLY SETTINGS *
  var bookMarks: array[10, ptr UBookMark]
    ## Level Bookmarks: 10 should be MAX_BOOKMARK_NUMBER @fixmeconst
    ## UPROPERTY()

#**********************************

  var timeDilation: cfloat
    ## Normally 1 - scales real time passage.
    ## Warning - most use cases should use GetEffectiveTimeDilation() instead of reading from this directly
    ##
    ## UPROPERTY(transient, replicated)

  var matineeTimeDilation: cfloat
    ## Additional time dilation used by Matinee (or Sequencer) slomo track.  Transient because this is often
    ## temporarily modified by the editor when previewing slow motion effects, yet we don't want it saved or loaded from level packages.
    ## UPROPERTY(transient, replicated)

  var demoPlayTimeDilation: cfloat
    ## Additional TimeDilation used to control demo playback speed
    ## UPROPERTY(transient)

  var pauser: ptr APlayerState
    ## If paused, FName of person pausing the game.
    ## UPROPERTY(transient, replicated)

  var bHighPriorityLoading: bool
    ## when this flag is set, more time is allocated to background loading (replicated)
    ## UPROPERTY(replicated)

  var bHighPriorityLoadingLocal: bool
    ## copy of bHighPriorityLoading that is not replicated, for clientside-only loading operations
    ## UPROPERTY()

  var replicationViewers: TArray[FNetViewer]
    ## valid only during replication - information about the player(s) being replicated to
    ## (there could be more than one in the case of a splitscreen client)
    ##
    ## UPROPERTY()

# ************************************

# protected:
  var assetUserData: TArray[ptr UAssetUserData]
    ## Array of user data stored with the asset
    ## UPROPERTY()

# public:

  proc getGravityZ(): cfloat {.noSideEffect.}
    ## Returns the Z component of the current world gravity and initializes it to the default
    ## gravity if called for the first time.
    ##
    ## @return Z component of current world gravity.
  proc getEffectiveTimeDilation(): cfloat {.noSideEffect.}

  proc fixupDeltaSeconds(deltaSeconds: cfloat; realDeltaSeconds: cfloat): cfloat
    ## Returns the delta time to be used by the tick. Can be overridden if game specific logic is needed.

  proc notifyBeginPlay()
    ## Called by GameMode.HandleMatchIsWaitingToStart, calls BeginPlay on all actors

  proc notifyMatchStarted()
    ## Called by GameMode.HandleMatchHasStarted, used to notify native classes of match startup (such as level scripting)
