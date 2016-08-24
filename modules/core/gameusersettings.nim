# Copyright 2016 Xored Software, Inc.

wclass(FQualityLevels, cppname: "Scalability::FQualityLevels", header: "Scalability.h", bycopy):
  ## Structure for holding the state of the engine scalability groups
  ## Actual engine state you can get though GetQualityLevels().
  var resolutionQuality: int32
  var viewDistanceQuality: int32
  var antiAliasingQuality: int32
  var shadowQuality: int32
  var postProcessQuality: int32
  var textureQuality: int32
  var effectsQuality: int32

  proc initFQualityLevels(): FQualityLevels {.constructor.}

  proc `==`(other: FQualityLevels): bool {.noSideEffect.}
  proc `!=`(other: FQualityLevels): bool {.noSideEffect.}

  proc setFromSingleQualityLevel(value: int32)
    ## Sets all other settings based on an overall value
    ## @param Value 0:low, 1:medium, 2:high, 3:epic (gets clamped if needed)

  proc getSingleQualityLevel(): int32
    ## Returns the overall value if all settings are set to the same thing
    ## @param Value -1:custom, 0:low, 1:medium, 2:high, 3:epic

  proc setBenchmarkFallback()

  proc setDefaults()

wclass(UGameUserSettings of UObject, header: "GameFramework/GameUserSettings.h"):
  ## Stores user settings for a game (for example graphics and sound settings), with the ability to save and load to and from a file.
  proc applySettings(bCheckForCommandLineOverrides: bool)
    ## Applies all current user settings to the game and saves to permanent storage (e.g. file), optionally checking for command line overrides.
    ## UFUNCTION(BlueprintCallable, Category=Settings, meta=(bCheckForCommandLineOverrides=true))

  proc applyNonResolutionSettings()
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc applyResolutionSettings(bCheckForCommandLineOverrides: bool)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc getScreenResolution(): FIntPoint {.noSideEffect.}
    ## Returns the user setting for game screen resolution, in pixels.
    ## UFUNCTION(BlueprintPure, Category=Settings)

  proc getLastConfirmedScreenResolution(): FIntPoint {.noSideEffect.}
    ## Returns the last confirmed user setting for game screen resolution, in pixels.
    ## UFUNCTION(BlueprintPure, Category=Settings)

  proc setScreenResolution(resolution: FIntPoint)
    ## Sets the user setting for game screen resolution, in pixels.
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc getFullscreenMode(): EWindowMode {.noSideEffect.}
    ## Returns the user setting for game window fullscreen mode.
    ## UFUNCTION(BlueprintPure, Category=Settings)

  proc getLastConfirmedFullscreenMode(): EWindowMode {.noSideEffect.}
    ## Returns the last confirmed user setting for game window fullscreen mode.
    ## UFUNCTION(BlueprintPure, Category=Settings)

  proc setFullscreenMode(inFullscreenMode: EWindowMode)
    ## Sets the user setting for the game window fullscreen mode. See UGameUserSettings::FullscreenMode.
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc setVSyncEnabled(bEnable: bool)
    ## Sets the user setting for vsync. See UGameUserSettings::bUseVSync.
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc isVSyncEnabled(): bool {.noSideEffect.}
    ## Returns the user setting for vsync.
    ## UFUNCTION(BlueprintPure, Category=Settings)

  proc isScreenResolutionDirty(): bool {.noSideEffect.}
    ## Checks if the Screen Resolution user setting is different from current
    ## UFUNCTION(BlueprintPure, Category=Settings)

  proc isFullscreenModeDirty(): bool {.noSideEffect.}
    ## Checks if the FullscreenMode user setting is different from current
    ## UFUNCTION(BlueprintPure, Category=Settings)

  proc isVSyncDirty(): bool {.noSideEffect.}
    ## Checks if the vsync user setting is different from current system setting
    ## UFUNCTION(BlueprintPure, Category=Settings)

  proc confirmVideoMode()
    ## Mark current video mode settings (fullscreenmode/resolution) as being confirmed by the user
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc revertVideoMode()
    ## Revert video mode (fullscreenmode/resolution) back to the last user confirmed values
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc setBenchmarkFallbackValues()
    ## Set scalability settings to sensible fallback values, for use when the benchmark fails or potentially causes a crash
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc setAudioQualityLevel(qualityLevel: int32)
    ## Sets the user's audio quality level setting
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc getAudioQualityLevel(): int32 {.noSideEffect.}
    ## Returns the user's audio quality level setting
    ## UFUNCTION(BlueprintPure, Category=Settings)

  proc setFrameRateLimit(newLimit: cfloat)
    ## Sets the user's frame rate limit (0 will disable frame rate limiting)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc getFrameRateLimit(): cfloat {.noSideEffect.}
    ## Gets the user's frame rate limit (0 indiciates the frame rate limit is disabled)
    ## UFUNCTION(BlueprintPure, Category=Settings)

  proc setOverallScalabilityLevel(value: int32)
    ## Changes all scalability settings at once based on a single overall quality level
    ## @param Value 0:low, 1:medium, 2:high, 3:epic
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc getOverallScalabilityLevel(): int32 {.noSideEffect.}
    ## Returns the overall scalability level (can return -1 if the settings are custom)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc getResolutionScaleInformation(currentScaleNormalized: var cfloat;
                                     currentScaleValue: var int32;
                                     minScaleValue: var int32;
                                     maxScaleValue: var int32) {.noSideEffect.}
    ## Returns the current resolution scale and the range
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc setResolutionScaleValue(newScaleValue: int32)
    ## Sets the current resolution scale
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc setResolutionScaleNormalized(newScaleNormalized: cfloat)
    ## Sets the current resolution scale as a normalized 0..1 value between MinScaleValue and MaxScaleValue
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc setViewDistanceQuality(value: int32)
    ## Sets the view distance quality (0..3, higher is better)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc getViewDistanceQuality(): int32 {.noSideEffect.}
    ## Returns the view distance quality (0..3, higher is better)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc setShadowQuality(value: int32)
    ## Sets the shadow quality (0..3, higher is better)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc getShadowQuality(): int32 {.noSideEffect.}
    ## Returns the shadow quality (0..3, higher is better)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc setAntiAliasingQuality(value: int32)
    ## Sets the anti-aliasing quality (0..3, higher is better)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc getAntiAliasingQuality(): int32 {.noSideEffect.}
    ## Returns the anti-aliasing quality (0..3, higher is better)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc setTextureQuality(value: int32)
    ## Sets the texture quality (0..3, higher is better)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc getTextureQuality(): int32 {.noSideEffect.}
    ## Returns the texture quality (0..3, higher is better)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc setVisualEffectQuality(value: int32)
    ## Sets the visual effects quality (0..3, higher is better)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc getVisualEffectQuality(): int32 {.noSideEffect.}
    ## Returns the visual effects quality (0..3, higher is better)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc setPostProcessingQuality(value: int32)
    ## Sets the post-processing quality (0..3, higher is better)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc getPostProcessingQuality(): int32 {.noSideEffect.}
    ## Returns the post-processing quality (0..3, higher is better)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc isDirty(): bool {.noSideEffect.}
    ## Checks if any user settings is different from current
    ## UFUNCTION(BlueprintPure, Category=Settings)

  proc validateSettings()
    ## Validates and resets bad user settings to default. Deletes stale user settings file if necessary.
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc loadSettings(bForceReload: bool = false)
    ## Loads the user settings from persistent storage
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc saveSettings()
    ## Save the user settings to persistent storage (automatically happens as part of ApplySettings)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc resetToCurrentSettings()
    ## This function resets all settings to the current system settings
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc setWindowPosition(windowPosX: int32; windowPosY: int32)
  proc getWindowPosition(): FIntPoint

  proc setToDefaults()
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc preloadResolutionSettings() {.isStatic.}
    ## Loads the resolution settings before is object is available

  proc getDefaultResolution(): FIntPoint {.isStatic.}
    ## @return The default resolution when no resolution is set
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc getDefaultWindowPosition(): FIntPoint {.isStatic.}
    ## @return The default window position when no position is set
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc getDefaultWindowMode(): EWindowMode {.isStatic.}
    ## @return The default window mode when no mode is set
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  proc loadConfigIni(bForceReload: bool = false) {.isStatic.}
    ## Loads the user .ini settings into GConfig

  proc requestResolutionChange(inResolutionX: int32; inResolutionY: int32;
                               inWindowMode: EWindowMode; bInDoOverrides: bool = true) {.isStatic.}
    ## Request a change to the specified resolution and window mode. Optionally apply cmd line overrides.

  proc getGameUserSettings(): ptr UGameUserSettings {.isStatic.}
    ## Returns the game local machine settings (resolution, windowing mode, scalability settings, etc...)
    ## UFUNCTION(BlueprintCallable, Category=Settings)

  var bUseVSync: bool
    ## Whether to use VSync or not. (public to allow UI to connect to it)
    ## UPROPERTY(config)

  var scalabilityQuality: FQualityLevels
    ## cached for the UI, current state if stored in console variables

# protected:

  var resolutionSizeX: uint32
    ## Game screen resolution width, in pixels.
    ## UPROPERTY(config)

  var resolutionSizeY: uint32
    ## Game screen resolution height, in pixels.
    ## UPROPERTY(config)

  var lastUserConfirmedResolutionSizeX: uint32
    ## Game screen resolution width, in pixels.
    ## UPROPERTY(config)

  var lastUserConfirmedResolutionSizeY: uint32
    ## Game screen resolution height, in pixels.
    ## UPROPERTY(config)

  var windowPosX: int32
    ## Window PosX
    ## UPROPERTY(config)

  var windowPosY: int32
    ## Window PosY
    ## UPROPERTY(config)

  var bUseDesktopResolutionForFullscreen: bool
    ## Whether or not to use the desktop resolution.
    ## This value only applies if ResolutionX and ResolutionY have not been set yet and only on desktop platforms
    ##
    ## UPROPERTY(config)

  var fullscreenMode: int32
    ## Game window fullscreen mode
    ## 	0 = Fullscreen
    ## 	1 = Windowed fullscreen
    ## 	2 = Windowed
    ## 	3 = WindowedMirror
    ##
    ## UPROPERTY(config)

  var lastConfirmedFullscreenMode: int32
    ## Last user confirmed fullscreen mode setting.
    ## UPROPERTY(config)

  var version: uint32
    ## All settings will be wiped and set to default if the serialized version differs from UE_GAMEUSERSETTINGS_VERSION.
    ## UPROPERTY(config)

  var audioQualityLevel: int32
    ## UPROPERTY(config)

  var frameRateLimit: cfloat
    ## Frame rate cap
    ## UPROPERTY(config)

  proc isVersionValid(): bool
    ## Check if the current version of the game user settings is valid. Sub-classes can override this to provide game-specific versioning as necessary.
    ## @return True if the current version is valid, false if it is not

  proc updateVersion()
    ## Update the version of the game user settings to the current version
