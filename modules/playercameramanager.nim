# Copyright 2016 Xored Software, Inc.

type
  FCameraCacheEntry* {.header: "Camera/PlayerCameraManager.h", importcpp, size: sizeof(cint).} = object
    ## Cached camera POV info, stored as optimization so we only
    ## need to do a full camera update once per tick.
    timeStamp* {.importcpp: "TimeStamp".}: cfloat
      ## World time this entry was created.
    POV*: FMinimalViewInfo
      ## Camera POV to cache.

wclass(FTViewTarget, header: "Camera/PlayerCameraManager.h", bycopy):
  ## A ViewTarget is the primary actor the camera is associated with.
  var target: ptr AActor
    ## Target Actor used to compute POV
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=TViewTarget)

  var POV: FMinimalViewInfo
    ## Computed point of view
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=TViewTarget)

  proc setNewTarget(newTarget: ptr AActor)

  proc getTargetPawn(): ptr APawn {.noSideEffect.}

  proc equal(otherTarget: FTViewTarget): bool {.noSideEffect.}

  proc checkViewTarget(owningController: ptr APlayerController)
    ## Make sure ViewTarget is valid

  # protected:
  var playerState: ptr APlayerState
    ## PlayerState (used to follow same player through pawn transitions, etc., when spectating)
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=TViewTarget)

wclass(FViewTargetTransitionParams, header: "Camera/PlayerCameraManager.h", bycopy, notypedef):
  proc getBlendAlpha(TimePct: cfloat): cfloat
    ## For a given linear blend value (blend percentage), return the final blend alpha with the requested function applied

# TODO: interface APlayerCameraManager itself