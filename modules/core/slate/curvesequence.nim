# Copyright 2016 Xored Software, Inc.

type
  ECurveEaseFunction* {.importcpp: "ECurveEaseFunction::Type", header: "SlateCore.h", pure.} = enum
    ## Types of easing functions for Slate animation curves.  These are used to smooth out animations.
    Linear,
      ##Linear interpolation, with no easing
    QuadIn,
      ## Quadratic ease in
    QuadOut,
      ## Quadratic ease out
    QuadInOut,
      ## Quadratic ease in, quadratic ease out
    CubicIn,
      ## Cubic ease in
    CubicOut,
      ## Cubic ease out
    CubicInOut
      ## Cubic ease in, cubic ease out
  FCurveHandle* {.importcpp, header: "SlateCore.h".} = object

wclass(FSlateCurve, header: "SlateCore.h", bycopy, cppname: "FCurveSequence::FSlateCurve"):
  ## A curve has a time offset and duration.
  proc initFSlateCurve(inStartTime, inDurationSeconds: float32, inEaseFunction: ECurveEaseFunction): FSlateCurve {.constructor.}

  var durationSeconds: float32
    ## Length of this animation in seconds

  var startTime: float32
    ## Start time for this animation

  var easeFunction: ECurveEaseFunction
    ## Type of easing function to use for this curve.
    ## Could be passed it at call site.

wclass(FCurveSequence of TSharedFromThis[FCurveSequence], header: "SlateCore.h", bycopy):
  ## A sequence of curves that can be used to drive animations for slate widgets.
  ## Active timer registration is handled for the widget being animated when calling play.
  ##
  ## Each curve within the sequence has a time offset and a duration.
  ## This makes FCurveSequence convenient for crating staggered animations.
  ## e.g.
  ##   // We want to zoom in a widget, and then fade in its contents.
  ##   FCurveHandle ZoomCurve = Sequence.AddCurve( 0, 0.15f );
  ##   FCurveHandle FadeCurve = Sequence.AddCurve( 0.15f, 0.1f );
  ##	 Sequence.Play( this->AsShared() );

  proc initFCurveSequence(): FCurveSequence {.constructor.}
    ##Default constructor

  proc initFCurveSequence(inStartTimeSeconds, inDurationSeconds: float32; inEaseFunction: ECurveEaseFunction = ECurveEaseFunction.Linear): FCurveSequence {.constructor.}
    ## Construct by adding a single animation curve to this sequence.  Does not provide access to the curve though.
    ##
    ## @param InStartTimeSeconds   When to start this curve.
    ## @param InDurationSeconds    How long this curve lasts.
    ## @param InEaseFunction       Easing function to use for this curve.  Defaults to Linear.  Use this to smooth out your animation transitions.
    ## @return A FCurveHandle that can be used to get the value of this curve after the animation starts playing.

  proc addCurve(inStartTimeSeconds, inDurationSeconds: float32; inEaseFunction: ECurveEaseFunction = ECurveEaseFunction.Linear): FCurveHandle
    ## Add a new curve at a given time and offset.
    ##
    ## @param InStartTimeSeconds   When to start this curve.
    ## @param InDurationSeconds    How long this curve lasts.
    ## @param InEaseFunction       Easing function to use for this curve.  Defaults to Linear.  Use this to smooth out your animation transitions.
    ## @return A FCurveHandle that can be used to get the value of this curve after the animation starts playing.

  proc addCurveRelative(inOffset, inDurationSecond: float32; inEaseFunction: ECurveEaseFunction = ECurveEaseFunction.Linear ): FCurveHandle
    ## Add a new curve relative to the current end of the sequence. Makes stacking easier.
    ## e.g. doing
    ##     AddCurveRelative(0,5);
    ##     AddCurveRelative(0,3);
    ## Is equivalent to
    ##     AddCurve(0,5);
    ##     AddCurve(5,3)
    ##
    ## @param InOffset             Offset from the last curve in the sequence.
    ## @param InDurationSecond     How long this curve lasts.
    ## @param InEaseFunction       Easing function to use for this curve.  Defaults to Linear.  Use this to smooth out your animation transitions.

  proc play(inOwnerWidget: TSharedRef[SWidget], bPlayLooped: bool = false, startAtTime: float32 = 0.0'f32)
    ## Start playing this curve sequence. Registers an active timer with the widget being animated.
    ##
    ## @param InOwnerWidget The widget that is being animated by this sequence.
    ## @param bPlayLooped True if the curve sequence should play continually on a loop. Note that the active timer will persist until this sequence is paused or jumped to the start/end.
    ## @param StartAtTime The relative time within the animation at which to begin playing (i.e. 0.0f is the beginning).

  proc playReverse(inOwnerWidget: TSharedRef[SWidget], bPlayLooped: bool = false, startAtTime: float32 = 0.0'f32)
    ## Start playing this curve sequence in reverse. Registers an active timer for the widget using the sequence.
    ##
    ## @param InOwnerWidget The widget that is being animated by this sequence.
    ## @param bPlayLooped True if the curve sequence should play continually on a loop. Note that the active timer will persist until this sequence is paused or jumped to the start/end.
    ## @param StartAtTime The relative time within the animation at which to begin playing (i.e. 0.0f is the beginning).

  proc reverse()
    ## Reverse the direction of an in-progress animation

  proc pause()
    ## Pause this curve sequence.

  proc resume()
    ## Unpause this curve sequence to resume play.

  proc isPlaying(): bool {.noSideEffect.}
    ## Checks whether the sequence is currently playing.
    ##
    ## @return true if playing, false otherwise.

  proc getSequenceTime(): float32 {.noSideEffect.}
    ## @return the current time relative to the beginning of the sequence.

  proc isInReverse(): bool {.noSideEffect.}
    ## @return true if the animation is in reverse

  proc isForward(): bool {.noSideEffect.}
    ## @return true if the animation is in forward gear

  proc jumpToStart()
    ## Jumps immediately to the beginning of the animation sequence

  proc jumpToEnd()
    ## Jumps immediately to the end of the animation sequence

  proc isAtStart(): bool {.noSideEffect.}
    ## Is the sequence at the start?

  proc isAtEnd(): bool {.noSideEffect.}
    ## Is the sequence at the end?
  proc isLooping(): bool {.noSideEffect.}
    ## Is the sequence looping?

  proc getLerp(): float32
    ## For single-curve animations, returns the interpolation alpha for the animation.  If you call this function
    ## on a sequence with multiple curves, an assertion will trigger.
    ##
    ## @return A linearly interpolated value between 0 and 1 for this curve.

  proc getCurve(curveIndex: int32): FSlateCurve {.noSideEffect.}
    ## @param CurveIndex  Index of a curve in the curves array.
    ##
    ## @return A curve given the index into the curves array

# protected:
  proc setStartTime(inStartTime: float64)
    ## @param InStartTime  when this curve sequence started playing

wclass(FCurveHandle, header: "SlateCore.h", bycopy, notypedef):
  ## A handle to curve within a curve sequence.
  proc initFCurveHandle(inOwnerSequence: ptr FCurveSequence = nil, inCurveIndex: int32 = 0'i32): FCurveHandle {.constructor.}
    ## Creates and initializes a curve handle.
    ##
    ## @param InOwnerSequence The curve sequence that owns this handle.
    ## @param InCurveIndex The index of this handle.

  proc getLerp(): float32 {.noSideEffect.}
    ## Gets the linearly interpolated value between 0 and 1 for this curve.
    ##
    ## @return Lerp value.
    ## @see GetLerpLooping

  proc isInitialized(): bool {.noSideEffect.}
    ## Checks whether this handle is initialized.
    ##
    ## A curve handle is considered initialized if it has an owner sequence.
    ## @return true if initialized, false otherwise.

proc applyAnimationEasing*(time: float32, easeType: ECurveEaseFunction): float32 {.importcpp: "FCurveHandle::ApplyEasing(@)", header: "SlateCore.h".}
  ## Applies animation easing to lerp value