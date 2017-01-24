# Copyright 2016 Xored Software, Inc.

var gFrameCounter* {.importcpp: "GFrameCounter", header: "CoreGlobals.h".}: uint64
var gLog* {.importcpp: "GLog", header: "CoreGlobals.h".}: ptr FOutputDeviceRedirector

var gEngine* {.importcpp: "GEngine", header: "EngineGlobals.h".}: ptr UEngine
  ## Global engine pointer. Can be 0 so don't use without checking.

var gWorld* {.importcpp: "GWorld", header: "Engine/World.h".}: ptr UWorld
  ## Global UWorld pointer. Use of this pointer should be avoided whenever possible.

var gDisallowNetworkTravel* {.importcpp: "GDisallowNetworkTravel", header: "EngineGlobals.h".}: bool
  ## when set, disallows all network travel (pending level rejects all client travel attempts)

var gGPUFrameTime* {.importcpp: "GGPUFrameTime", header: "EngineGlobals.h".}: uint32
  ## The GPU time taken to render the last frame. Same metric as FPlatformTime::Cycles().

var gGameplayTagsManager* {.importcpp: "GGPUFrameTime", header: "EngineGlobals.h".}: ptr UGameplayTagsManager
  ## A reference to the ability system so we do not need to get the module every time we access the tag manager.

declareBuiltinDelegate(FApplicationLifetimeDelegate, dkMulticast, "Misc/CoreDelegates.h")

var gApplicationHasEnteredForegroundDelegate* {.importcpp: "FCoreDelegates::ApplicationHasEnteredForegroundDelegate", header: "Misc/CoreDelegates.h".}: FApplicationLifetimeDelegate
  ## This is called when the application is being backgrounded (e.g., due to switching
  ## to another app or closing it via the home button)
  ## The game should release shared resources, save state, etc..., since it can be
  ## terminated from the background state without any further warning.

var gApplicationWillEnterBackgroundDelegate* {.importcpp: "FCoreDelegates::ApplicationWillEnterBackgroundDelegate", header: "Misc/CoreDelegates.h".}: FApplicationLifetimeDelegate
  ## Called when the application is returning to the foreground (reverse any processing done in the EnterBackground delegate)