# Copyright 2016 Xored Software, Inc.

type
  EFocusCause {.importcpp, header: "Input/Events.h", pure, size: sizeof(uint8).} = enum
    ## Context for focus change
    Mouse,
      ## Focus was changed because of a mouse action.
    Navigation,
      ## Focus was changed in response to a navigation, such as the arrow keys, TAB key, controller DPad, ...
    SetDirectly,
      ## Focus was changed because someone asked the application to change it.
    Cleared,
      ## Focus was explicitly cleared via the escape key or other similar action.
    OtherWidgetLostFocus,
      ## Focus was changed because another widget lost focus, and focus moved to a new widget.
    WindowActivate,
      ## Focus was set in response to the owning window being activated.

wclass(FSlateApplication, header: "Framework/Application/SlateApplication.h", bycopy):
  proc setAllUserFocusToGameViewport(reasonFocusIsChanging = EFocusCause.SetDirectly)
    ## Sets all users focus to the SWidget representing the currently active game viewport

proc getFSlateApplication*(): ptr FSlateApplication {.
  importcpp: "(& FSlateApplication::Get())", header: "Framework/Application/SlateApplication.h".}
  ## Returns the current instance of the application. The application should have been initialized before
  ## this method is called
  ##
  ## @return  Reference to the application
