# Copyright 2016 Xored Software, Inc.

type EMaxConcurrentResolutionRule {.size: sizeof(cint),
                                    header: "Sound/SoundBase.h",
                                    importcpp: "EMaxConcurrentResolutionRule::Type".} = enum
    PreventNew,
      ## When Max Concurrent sounds are active do not start a new sound.
    StopOldest,
      ## When Max Concurrent sounds are active stop the oldest and start a new one.
    StopFarthestThenPreventNew,
      ## When Max Concurrent sounds are active stop the furthest sound.  If all sounds are the same distance then do not start a new sound.
    StopFarthestThenOldest,
      ## When Max Concurrent sounds are active stop the furthest sound.  If all sounds are the same distance then stop the oldest.

wclass(USoundBase of UObject, header: "Sound/SoundBase.h", notypedef):
  var bDebug: bool
    ## When "stat sounds -debug" has been specified, draw this sound's attenuation shape when the sound is audible.
    ## For debugging purpose only.
    ## UPROPERTY(EditAnywhere, Category=Playback)

  var maxConcurrentResolutionRule: EMaxConcurrentResolutionRule
    ## If we try to play a new version of this sound when at the max concurrent count how should it be resolved.
    ## UPROPERTY(EditAnywhere, Category=Playback)

  var maxConcurrentPlayCount: int32
    ## Maximum number of times this sound can be played concurrently.
    ## UPROPERTY(EditAnywhere, Category=Playback)

  var duration: cfloat
    ## Duration of sound in seconds.
    ## UPROPERTY(Category=Info, AssetRegistrySearchable, VisibleAnywhere, BlueprintReadOnly)

  # AWARE: deps
  # var attenuationSettings: ptr USoundAttenuation
  #   ## Attenuation settings package for the sound
  #   ## UPROPERTY(EditAnywhere, Category=Attenuation)

  var currentPlayCount: int32
    ## Number of times this cue is currently being played.

  method isPlayable(): bool {.noSideEffect.}
    ## Returns whether the sound base is set up in a playable manner

  # AWARE: deps
  # method getAttenuationSettingsToApply(): ptr FAttenuationSettings {.noSideEffect.}
  #   ## Returns a pointer to the attenuation settings that are to be applied for this node

  proc isAudible(sourceLocation: FVector; listenerLocation: FVector;
                 sourceActor: ptr AActor; bIsOccluded: var bool; bCheckOcclusion: bool): bool
    ## Checks to see if a location is audible

  # AWARE: deps
  # proc isAudibleSimple(audioDevice: ptr FAudioDevice; location: FVector;
  #                      inAttenuationSettings: ptr USoundAttenuation = nil): bool
  #   ## Does a simple range check to all listeners to test hearability
  #   ##
  #   ## @param Location        Location to check against
  #   ## @param AttenuationSettings Optional Attenuation override if not using settings from the sound

  method getMaxAudibleDistance(): cfloat
    ## Returns the farthest distance at which the sound could be heard

  method getDuration(): cfloat
    ## Returns the length of the sound

  method getVolumeMultiplier(): cfloat
  method getPitchMultiplier(): cfloat

  # AWARE: deps
  # method parse(audioDevice: ptr FAudioDevice; NodeWaveInstanceHash: UPTRINT;
  #            activeSound: var FActiveSound; ParseParams: FSoundParseParameters;
  #            waveInstances: var TArray[ptr FWaveInstance])
  #   ## Parses the Sound to generate the WaveInstances to play

  # method getSoundClass(): ptr USoundClass {.noSideEffect.}
  #   ## Returns the SoundClass used for this sound