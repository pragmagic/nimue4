import ue4, times

{.emit:"""/*TYPESECTION*/
N_NOINLINE(void, setStackBottom)(void* thestackbottom);
""".}

uclass(UNimGameEngine of UGameEngine, Config=Engine):
  var defaultRequiredFps {.config.}: cfloat = 60.0
  var maxFrameTime: cfloat = 0.016

  method init*(loop: ptr IEngineLoop) {.override, callSuperAfter.} =
    var stackTop {.volatile.}: pointer
    {.emit: "check(IsInGameThread()); setStackBottom((void*)(&`stackTop`));".}

    var requiredFps: cfloat = defaultRequiredFps
    if this.bSmoothFrameRate and this.smoothedFrameRateRange.hasLowerBound():
      requiredFps = this.smoothedFrameRateRange.getLowerBoundValue()
    elif this.bUseFixedFrameRate:
      requiredFps = this.fixedFrameRate
    this.maxFrameTime = 1.0 / requiredFps

  method tick*(delta: float32, isIdleMode: bool) {.override.} =
    var actualFrameTime = epochTime()
    # nimue4 currently doesn't allow calling super in the middle
    {.emit: "`this`->UGameEngine::Tick(`delta`, `isIdleMode`);".}
    actualFrameTime = epochTime() - actualFrameTime

    var allowedGcTime = max(0.001, min(this.maxFrameTime - actualFrameTime - 0.002, 0.006))
    GC_step(int(allowedGcTime * 1_000_000), false, 0)
