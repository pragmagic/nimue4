# Copyright 2016 Xored Software, Inc.

type
  EUINavigationRule* {.importcpp, header: "SlateCore.h", pure, size: sizeof(uint8).} = enum
    Escape,
      ## Allow the movement to continue in that direction, seeking the next navigable widget automatically.
    Explicit,
      ## Move to a specific widget.
    Wrap,
      ## Wrap movement inside this container, causing the movement to cycle around from the opposite side,
      ## if the navigation attempt would have escaped.
    Stop,
      ## Stops movement in this direction
    Custom,
      ## Custom navigation handled by user code.
    Invalid
      ## Invalid Rule

declareBuiltinDelegate(FNavigationDelegate, dkSimpleRetVal, "SlateCore.h", TSharedPtr[SWidget], nav: EUINavigation)

wclass(FNavigationReply, header: "SlateCore.h"):
  ## A FNavigationReply is something that a Slate navigation event returns to the system to notify it about the boundary rules for navigation.
  ## For example, a widget may handle an OnNavigate event by asking the system to wrap if it's boundary is hit.
  ## To do this, return FNavigationReply::Wrap().

  proc getHandler(): TSharedPtr[SWidget]
    ## The widget that ultimately specified the boundary rule for the navigation

  proc getBoundaryRule(): EUINavigationRule
    ## Get the navigation boundary rule.

  proc getFocusRecipient(): TSharedPtr[SWidget]
    ## If the event replied with a constant explicit boundary rule this returns the desired focus recipient.
    ## Otherwise returns an invalid pointer.

  proc getFocusDelegate(): FNavigationDelegate
    ## If the event replied with a delegate explicit boundary rule this returns the delegate to get the focus recipient.
    ## Delegate will be unbound if a constant widget was provided.

proc explicitNavigationReply*(inFocusRecipient: TSharedPtr[SWidget]): FNavigationReply {.importcpp: "FNavigationReply::Explicit(@)", header: "SlateCore.h".}
  ## An event should return a FNavigationReply::Explicit() to let the system know to navigate to an explicit widget at the bounds of this widget.

proc customNavigationReply*(inFocusDelegate: FNavigationDelegate): FNavigationReply {.importcpp: "FNavigationReply::Custom(@)", header: "SlateCore.h".}
  ## An event should return a FNavigationReply::Custom() to let the system know to call a custom delegate to get the widget to navigate to.
proc wrapNavigationReply*(): FNavigationReply {.importcpp: "FNavigationReply::Wrap(@)", header: "SlateCore.h".}
  ## An event should return a FNavigationReply::Wrap() to let the system know to wrap at the bounds of this widget.
proc stopNavigationReply*(): FNavigationReply {.importcpp: "FNavigationReply::Stop(@)", header: "SlateCore.h".}
  ## An event should return a FNavigationReply::Stop() to let the system know to stop at the bounds of this widget.
proc escapeNavigationReply*(): FNavigationReply {.importcpp: "FNavigationReply::Escape(@)", header: "SlateCore.h".}
  ## An event should return a FNavigationReply::Escape() to let the system know that a navigation can escape the bounds of this widget.
