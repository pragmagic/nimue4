# Copyright 2016 Xored Software, Inc.

proc spawnSoundAttached*(sound: ptr USoundBase, attachToComponent: ptr USceneComponent,
                         attachPointName: FName = NAME_None, location: FVector = ForceInit,
                         rotation: FRotator = zeroRotator, locationType = EAttachLocation.KeepRelativeOffset,
                         bStopWhenAttachedToDestroyed = false, volumeMultiplier: cfloat  = 1.0'f32, pitchMultiplier: cfloat  = 1.0'f32,
                         startTime: cfloat = 0.0'f32, attenuationSettings: ptr USoundAttenuation = nil,
                         concurrencySettings: ptr USoundConcurrency = nil): ptr UAudioComponent {.
  header: "Kismet/GameplayStatics.h", importc: "UGameplayStatics::SpawnSoundAttached".}
  ## Plays a sound attached to and following the specified component. This is a fire and forget sound. Replication is also not handled at this point.
  ## @param Sound - sound to play
  ## @param AttachComponent - Component to attach to.
  ## @param AttachPointName - Optional named point within the AttachComponent to play the sound at
  ## @param Location - Depending on the value of Location Type this is either a relative offset from the attach component/point or an absolute world position that will be translated to a relative offset
  ## @param Rotation - Depending on the value of Location Type this is either a relative offset from the attach component/point or an absolute world rotation that will be translated to a relative offset
  ## @param LocationType - Specifies whether Location is a relative offset or an absolute world position
  ## @param bStopWhenAttachedToDestroyed - Specifies whether the sound should stop playing when the owner of the attach to component is destroyed.
  ## @param VolumeMultiplier - Volume multiplier
  ## @param PitchMultiplier - PitchMultiplier
  ## @param StartTime - How far in to the sound to begin playback at
  ## @param AttenuationSettings - Override attenuation settings package to play sound with
  ## @param ConcurrencySettings - Override concurrency settings package to play sound with
  ## @return An audio component to manipulate the spawned sound