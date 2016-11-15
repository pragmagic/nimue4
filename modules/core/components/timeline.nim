# Copyright 2016 Xored Software, Inc.

# Signature of function to handle a timeline 'event'
declareBuiltinDelegate(FOnTimelineEvent, dkDynamic, "Components/TimelineComponent.h")
# Signature of function to handle timeline float track
declareBuiltinDelegate(FOnTimelineFloat, dkDynamic, "Components/TimelineComponent.h", value: float32)
# Signature of function to handle timeline vector track
declareBuiltinDelegate(FOnTimelineVector, dkDynamic, "Components/TimelineComponent.h", value: FVector)
# Signature of function to handle linear color track
declareBuiltinDelegate(FOnTimelineLinearColor, dkDynamic, "Components/TimelineComponent.h", value: FLinearColor)

# Static version of delegate to handle a timeline 'event'
declareBuiltinDelegate(FOnTimelineEventStatic, dkSimple, "Components/TimelineComponent.h")
# Static version of timeline delegate for a float track
declareBuiltinDelegate(FOnTimelineFloatStatic, dkSimple, "Components/TimelineComponent.h", value: float)
# Static version of timeline delegate for a vector track
declareBuiltinDelegate(FOnTimelineVectorStatic, dkSimple, "Components/TimelineComponent.h", value: FVector)
# Static version of timeline delegate for a linear color track
declareBuiltinDelegate(FOnTimelineLinearColorStatic, dkSimple, "Components/TimelineComponent.h", value: FLinearColor)

wclass(UTimelineComponent of UActorComponent, header: "Components/TimelineComponent.h", notypedef):

  proc play()
    ## Start playback of timeline
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc playFromStart()
    ## Start playback of timeline from the start
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc reverse()
    ## Start playback of timeline in reverse
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc reverseFromEnd()
    ## Start playback of timeline in reverse from the end
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc stop()
    ## Stop playback of timeline
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc isPlaying(): bool {.noSideEffect.}
    ## Get whether this timeline is playing or not.
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc isReversing(): bool {.noSideEffect.}
    ## Get whether we are reversing or not
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc setPlaybackPosition(newPosition: cfloat; bFireEvents: bool;
                          bFireUpdate: bool = true)
    ## Jump to a position in the timeline.
    ## @param bFireEvents If true, event functions that are between current position and new playback position will fire.
    ## @param bFireUpdate If true, the update output exec will fire after setting the new playback position.
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline", meta=(AdvancedDisplay="bFireUpdate"))

  proc getPlaybackPosition(): cfloat {.noSideEffect.}
    ## Get the current playback position of the Timeline
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc setLooping(bNewLooping: bool)
    ## true means we whould loop, false means we should not.
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc isLooping(): bool {.noSideEffect.}
    ## Get whether we are looping or not
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc setPlayRate(newRate: cfloat)
    ## Sets the new play rate for this timeline
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc getPlayRate(): cfloat {.noSideEffect.}
    ## Get the current play rate for this timeline
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc setNewTime(newTime: cfloat)
    ## Set the new playback position time to use
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc getTimelineLength(): cfloat {.noSideEffect.}
    ## Get length of the timeline
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc setTimelineLength(newLength: cfloat)
    ## Set length of the timeline
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc setTimelineLengthMode(newLengthMode: ETimelineLengthMode)
    ## Sets the length mode of the timeline
    ## UFUNCTION(BlueprintCallable, Category="Components|Timeline")

  proc onRep_Timeline()
  ## UFUNCTION()

  proc getTimelineEventSignature(): ptr UFunction
    ## Get the signature function for Timeline event functions

  proc getTimelineFloatSignature(): ptr UFunction
    ## Get the signature function for Timeline float functions

  proc getTimelineVectorSignature(): ptr UFunction
    ## Get the signature function for Timeline vector functions

  proc getTimelineLinearColorSignature(): ptr UFunction
    ## Get the signature function for Timeline linear color functions

  proc addEvent(time: cfloat; eventFunc: FOnTimelineEvent)
    ## Add a callback event to the timeline

  proc addInterpVector(vectorCurve: ptr UCurveVector; interpFunc: FOnTimelineVector;
                      propertyName: FName = NAME_None)
    ## Add a vector interpolation to the timeline

  proc addInterpFloat(floatCurve: ptr UCurveFloat; interpFunc: FOnTimelineFloat;
                    propertyName: FName = NAME_None)
    ## Add a float interpolation to the timeline

  proc addInterpLinearColor(linearColorCurve: ptr UCurveLinearColor;
                          interpFunc: FOnTimelineLinearColor;
                          propertyName: FName = NAME_None)
    ## Add a linear color interpolation to the timeline

  proc setPropertySetObject(newPropertySetObject: ptr UObject)
    ## Optionally provide an object to automatically update properties on

  proc setTimelinePostUpdateFunc(newTimelinePostUpdateFunc: FOnTimelineEvent)
    ## Set the delegate to call after each timeline tick

  proc setTimelineFinishedFunc(newTimelineFinishedFunc: FOnTimelineEvent)
    ## Set the delegate to call when timeline is finished

  proc setDirectionPropertyName(directionPropertyName: FName)
    ## Set the delegate to call when timeline is finished

  proc getAllCurves(inOutCurves: var TSet[ptr UCurveBase]) {.noSideEffect.}
    ## Get all curves used by the Timeline
