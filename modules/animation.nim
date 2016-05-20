# Copyright 2016 Xored Software, Inc.

declareBuiltinDelegate(FOnMontageStarted, dkSimple, "Animation/AnimInstance.h", montage: ptr UAnimMontage)
declareBuiltinDelegate(FOnMontageEnded, dkSimple, "Animation/AnimInstance.h", montage: ptr UAnimMontage, bInterrupted: bool)
declareBuiltinDelegate(FOnMontageBlendingOutStarted, dkSimple, "Animation/AnimInstance.h", montage: ptr UAnimMontage, bInterrupted: bool)

declareBuiltinDelegate(FOnMontageStartedMCDelegate, dkDynamicMulticast, "Animation/AnimInstance.h",
                       montage: ptr UAnimMontage)
declareBuiltinDelegate(FOnMontageEndedMCDelegate, dkDynamicMulticast, "Animation/AnimInstance.h",
                       montage: ptr UAnimMontage, bInterrupted: bool)
declareBuiltinDelegate(FOnMontageBlendingOutStartedMCDelegate, dkDynamicMulticast, "Animation/AnimInstance.h",
                       montage: ptr UAnimMontage, bInterrupted: bool)

wclass(UAnimInstance of UObject, header: "Animation/AnimInstance.h", notypedef):
  proc montage_Play(montageToPlay: ptr UAnimMontage, inPlayRate: cfloat = 1.0'f32): cfloat {.discardable.}
    ## Plays an animation montage. Returns the length of the animation montage in seconds. Returns 0.f if failed to play.

  proc montage_Stop(inBlendOutTime: cfloat , montage: ptr UAnimMontage = nil)
    ## Stops the animation montage. If reference is NULL, it will stop ALL active montages.

  proc montage_Pause(montage: ptr UAnimMontage = nil)
    ## Pauses the animation montage. If reference is NULL, it will stop ALL active montages.

  proc montage_JumpToSection(sectionName: FName, montage: ptr UAnimMontage = nil)
    ## Makes a montage jump to a named section. If Montage reference is NULL, it will do that to all active montages.

  proc montage_JumpToSectionsEnd(sectionName: FName, montage: ptr UAnimMontage = nil)
    ## Makes a montage jump to the end of a named section. If Montage reference is NULL, it will do that to all active montages.

  proc montage_SetNextSection(sectionNameToChange: FName, nextSection: FName, montage: ptr UAnimMontage = nil)
    ## Relink new next section AFTER SectionNameToChange in run-time
    ##	You can link section order the way you like in editor, but in run-time if you'd like to change it dynamically,
    ##	use this function to relink the next section
    ##	For example, you can have Start->Loop->Loop->Loop.... but when you want it to end, you can relink
    ##	next section of Loop to be End to finish the montage, in which case, it stops looping by Loop->End.
    ## @param SectionNameToChange : This should be the name of the Montage Section after which you want to insert a new next section
    ## @param NextSection	: new next section

  proc montage_SetPlayRate(montage: ptr UAnimMontage, newPlayRate: cfloat = 1.0'f32)
    ## Change AnimMontage play rate. NewPlayRate = 1.0 is the default playback rate.

  proc montage_IsActive(montage: ptr UAnimMontage): bool
    ## Returns true if the animation montage is active. If the Montage reference is NULL, it will return true if any Montage is active.

  proc montage_IsPlaying(montage: ptr UAnimMontage): bool
    ## Returns true if the animation montage is currently active and playing.
    ## If reference is NULL, it will return true is ANY montage is currently active and playing.

  proc montage_GetCurrentSection(montage: ptr UAnimMontage): FName
    ## Returns the name of the current animation montage section.

  var onMontageBlendingOut: FOnMontageBlendingOutStartedMCDelegate
    ## Called when a montage starts blending out, whether interrupted or finished

  var onMontageStarted: FOnMontageStartedMCDelegate
    ## Called when a montage has started

  var onMontageEnded: FOnMontageEndedMCDelegate
    ## Called when a montage has ended, whether interrupted or finished

# TODO