# Copyright 2016 Xored Software, Inc.

type
  EPopupMethod* {.importcpp, header: "Input/PopupMethodReply.h", pure, size: sizeof(uint8).} = enum
    CreateNewWindow,
      ## Creating a new window allows us to place popups outside of the window in which the menu anchor resides.
    UseCurrentWindow
      ## Place the popup into the current window. Applications that intend to run in fullscreen cannot create new windows, so they must use this method..

  EShouldThrottle* {.importcpp, header: "Input/PopupMethodReply.h", pure, size: sizeof(uint8).} = enum
    No,
    Yes

wclass(FPopupMethodReply of TReplyBase[FPopupMethodReply], header: "Input/PopupMethodReply.h"):
  ## Reply informs Slate how it should express the popup: by creating a new window or by reusing the existing window.

  proc setShouldThrottle(inShouldThrottle: EShouldThrottle): var FPopupMethodReply {.discardable.}
    ## Specify whether we should throttle the engine ticking s.t. the UI is most responsive when this popup is up.

  proc getShouldThrottle(): EShouldThrottle
    ## Should we throttle the engine?

  proc GetPopupMethod(): EPopupMethod {.noSideEffect.}
    ## Which method to use for the popup: new window or reuse current window

  proc isSet(): bool
    ## Alias for IsEventHandled for situations where this is used as optional

  proc initFPopupMethodReply(): FPopupMethodReply {.constructor.}

proc unhandledFPopupMethodReply*(): FPopupMethodReply {.importcpp: "FPopupMethodReply::Unhandled()", header: "Input/PopupMethodReply.h".}
  ## Create a reply that signals not having an opinion about the popup method

proc useMethodReply*(withMethod: EPopupMethod): FPopupMethodReply{.importcpp: "FPopupMethodReply::UseMethod(@)", header: "Input/PopupMethodReply.h".}
  ## Create a reply that specifies how a popup should be handled.
