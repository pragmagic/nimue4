# Copyright 2016 Xored Software, Inc.

class(UPawnNoiseEmitterComponent of UActorComponent, header: "Components/PawnNoiseEmitterComponent.h", notypedef):
  ## PawnNoiseEmitterComponent tracks noise event data used by SensingComponents to hear a Pawn.
  ## This component is intended to exist on either a Pawn or its Controller. It does nothing on network clients.
  ## UCLASS(ClassGroup=AI, meta=(BlueprintSpawnableComponent))

  var bAIPerceptionSystemCompatibilityMode: bool
    ## If set to true (default value) will notify AIPerceptionSystem about noise events
    ## otherwise only PawnSensingComponents will be able to pick up noises generated by this component
    ## UPROPERTY(EditDefaultsOnly, Category = "AI|Perception", AdvancedDisplay)

  var lastRemoteNoisePosition: FVector
    ## Most recent noise made by this pawn not at its own location

  var noiseLifetime: cfloat
    ## After this amount of time, new sound events will overwrite previous sounds even if
    ## they are not louder (allows old sounds to decay)
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Noise Settings")

  method makeNoise(noiseMaker: ptr AActor; loudness: cfloat, noiseLocation: var FVector)
    ## Cache noises instigated by the owning pawn for AI sensing
    ## @param NoiseMaker - is the actual actor which made the noise
    ## @param Loudness - is the relative loudness of the noise (0.0 to 1.0)
    ## @param NoiseLocation - is the position of the noise
    ## UFUNCTION(BlueprintCallable, BlueprintAuthorityOnly, Category="Audio|Components|PawnNoiseEmitter")

  proc getLastNoiseVolume(bSourceWithinNoiseEmitter: bool): cfloat {.noSideEffect.}
  proc getLastNoiseTime(bSourceWithinNoiseEmitter: bool): cfloat {.noSideEffect.}