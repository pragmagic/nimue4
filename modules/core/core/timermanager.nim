# Copyright 2016 Xored Software, Inc.

declareBuiltinDelegate(FTimerDelegate, dkSimple, "TimerManager.h")

wclass(FTimerUnifiedDelegate, header: "TimerManager.h", bycopy):
  ## Simple interface to wrap a timer delegate that can be either native or dynamic.
  var funcDelegate: FTimerDelegate
    ## Holds the delegate to call.
  var funcDynDelegate: FTimerDynamicDelegate
    ## Holds the dynamic delegate to call.

  proc initFTimerUnifiedDelegate(): FTimerUnifiedDelegate {.constructor.}
  proc initFTimerUnifiedDelegate(d: FTimerDelegate) {.constructor.}
  proc initFTimerUnifiedDelegate(d: FTimerDynamicDelegate) {.constructor.}

type
  ETimerStatus* {.importcpp, header: "TimerManager.h", pure, size: sizeof(uint8).} = enum
    Pending,
    Active,
    Paused,
    Executing

  FTimerData* {.importcpp, header: "TimerManager.h".} = object
    bLoop*: bool
      ## If true, this timer will loop indefinitely.  Otherwise, it will be destroyed when it expires.
    bRequiresDelegate*: bool
      ## If true, this timer was created with a delegate to call (which means if the delegate becomes invalid, we should invalidate the timer too).
    status* {.importcpp: "Status".}: ETimerStatus
      ## Timer Status
    rate* {.importcpp: "Rate".}: cfloat
      ## Time between set and fire, or repeat frequency if looping.
    expireTime {.importcpp: "ExpireTime".}: cdouble
      ## Time (on the FTimerManager's clock) that this timer should expire and fire its delegate.
      ## Note when a timer is paused, we re-base ExpireTime to be relative to 0 instead of the running clock,
      ## meaning ExpireTime contains the remaining time until fire.
    timerDelegate {.importcpp: "TimerDelegate".}: FTimerUnifiedDelegate
      ## Holds the delegate to call.
    timerHandle {.importcpp: "TimerHandle".}: FTimerHandle

proc `<`*(x, y: FTimerData): bool {.importcpp: "(# < #)", header: "TimerManager.h".}
  ## Operator less, used to sort the heap based on time until execution.
proc clear*(this: FTimerData) {.importcpp: "Clear", header: "TimerManager.h".}

wclass(FTimerManager of FNoncopyable, header: "TimerManager.h", bycopy):
  proc tick(deltaTime: cfloat)

  proc clearTimer(inHandle: FTimerHandle)
    ## Clears a previously set timer, identical to calling SetTimer() with a <= 0.f rate.
    ##
    ## @param InHandle The handle of the timer to clear.

  proc clearAllTimersForObject(obj: pointer)
    ## Clears all timers that are bound to functions on the given object.

  proc pauseTimer(inHandle: FTimerHandle)
    ## Pauses a previously set timer.
    ##
    ## @param InHandle The handle of the timer to pause.

  proc unPauseTimer(inHandle: FTimerHandle)
    ## Unpauses a previously set timer
    ##
    ## @param InHandle The handle of the timer to unpause.

  proc getTimerRate(inHandle: FTimerHandle): cfloat {.noSideEffect.}
    ## Gets the current rate (time between activations) for the specified timer.
    ##
    ## @param InHandle The handle of the timer to return the rate of.
    ## @return The current rate or -1.f if timer does not exist.

  proc isTimerActive(inHandle: FTimerHandle): bool {.noSideEffect.}
    ## Returns true if the specified timer exists and is not paused
    ##
    ## @param InHandle The handle of the timer to check for being active.
    ## @return true if the timer exists and is active, false otherwise.

  proc isTimerPaused(inHandle: FTimerHandle): bool
    ## Returns true if the specified timer exists and is paused
    ##
    ## @param InHandle The handle of the timer to check for being paused.
    ## @return true if the timer exists and is paused, false otherwise.

  proc isTimerPending(inHandle: FTimerHandle): bool
    ## Returns true if the specified timer exists and is pending
    ##
    ## @param InHandle The handle of the timer to check for being pending.
    ## @return true if the timer exists and is pending, false otherwise.

  proc timerExists(inHandle: FTimerHandle): bool
    ## Returns true if the specified timer exists
    ##
    ## @param InHandle The handle of the timer to check for existence.
    ## @return true if the timer exists, false otherwise.

  proc getTimerElapsed(inHandle: FTimerHandle): cfloat {.noSideEffect.}
    ## Gets the current elapsed time for the specified timer.
    ##
    ## @param InHandle The handle of the timer to check the elapsed time of.
    ## @return The current time elapsed or -1.f if the timer does not exist.

  proc getTimerRemaining(inHandle: FTimerHandle): cfloat {.noSideEffect.}
    ## Gets the time remaining before the specified timer is called
    ##
    ## @param InHandle The handle of the timer to check the remaining time of.
    ## @return	 The current time remaining, or -1.f if timer does not exist
  proc hasBeenTickedThisFrame(): bool {.noSideEffect.}

  proc listTimers()
    ## Debug command to output info on all timers curently set to the log.

macro setTimer*[T](timerManager: ptr FTimerManager, inOutHandle: var FTimerHandle, objPtr: T, callback: proc(t: T),
                   inRate: cfloat, bLoop: bool = false, inFirstDelay: cfloat = -1'f32): stmt =
  ## Sets a timer to call the given function with the specified rate
  result = quote do:
    {.emit: "$#->SetTimer($#, `$#`, & $#::$#, $#, $#, $#);".format(
              expandObjReference(astToStr(`timerManager`)), expandObjReference(astToStr(`inOutHandle`)),
              astToStr(`objPtr`), type(`objPtr`).name.split(" ")[^1], astToStr(`callback`).capitalize(),
              toCppSubstitution(`inRate`), repr(`bLoop`), toCppSubstitution(`inFirstDelay`)).}

macro setTimer*[T](timerManager: ptr FTimerManager, inOutHandle: var FTimerHandle, delay: cfloat,
                   objPtr: T, callback: proc, args: varargs[expr]): stmt =
  # TODO: callback type safety
  var invocationStr = ""
  for arg in args:
    invocationStr.add(",")
    invocationStr.add("`" & $arg & "`")

  result = quote do:
    {.emit: "{FTimerDelegate nim_delegate = FTimerDelegate::CreateUObject(`$#`, & $#::$# $#); $#->SetTimer($#, nim_delegate, $#, false);}".format(
              astToStr(`objPtr`), type(`objPtr`).name.split(" ")[^1], astToStr(`callback`).capitalize(), `invocationStr`,
              expandObjReference(astToStr(`timerManager`)), expandObjReference(astToStr(`inOutHandle`)),
              toCppSubstitution(`delay`)).}

macro setInterval*[T](timerManager: ptr FTimerManager, inOutHandle: var FTimerHandle, initialDelay: cfloat, rate: cfloat,
                      objPtr: T, callback: proc, args: varargs[expr]): stmt =
  ## Sets a timer to invoke the given function on periodic interval
  # TODO: callback type safety
  var invocationStr = ""
  for arg in args:
    invocationStr.add(",")
    invocationStr.add("`" & $arg & "`")
  result = quote do:
    {.emit: "{FTimerDelegate nim_delegate = FTimerDelegate::CreateUObject(`$#`, & $#::$# $#); $#->SetTimer($#, nim_delegate, $#, true, $#);}".format(
              astToStr(`objPtr`), type(`objPtr`).name.split(" ")[^1], astToStr(`callback`).capitalize(), `invocationStr`,
              expandObjReference(astToStr(`timerManager`)), expandObjReference(astToStr(`inOutHandle`)),
              toCppSubstitution(`rate`), toCppSubstitution(`initialDelay`)).}

template setTimerForNextTick*[T](timerManager: ptr FTimerManager, objPtr: T, callback: proc(t: T)) =
  ## Sets a timer to call the given native function on the next tick.
  ##
  ## @param inObj					Object to call the timer function on.
  ## @param inTimerMethod			Method to call when timer fires.
  {.emit: "$#->SetTimerForNextTick(`$#`, & $#::$#);".format(
            expandObjReference(astToStr(timerManager)),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}
