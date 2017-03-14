# Copyright 2016 Xored Software, Inc.

wclass(FSlateApplication, header: "Framework/Application/SlateApplication.h", bycopy):
  proc setAllUserFocusToGameViewport(reasonFocusIsChanging = EFocusCause.SetDirectly)
    ## Sets all users focus to the SWidget representing the currently active game viewport

  proc getDragTriggerDistance(): float32 {.noSideEffect.}
    ## @return the deadzone size for dragging in screen pixels (aka virtual desktop pixels)

  proc setDragTriggerDistance(screenPixels: float32)
    ## Set the size of the deadzone for dragging in screen pixels

proc getFSlateApplication*(): ptr FSlateApplication {.
  importcpp: "(& FSlateApplication::Get())", header: "Framework/Application/SlateApplication.h".}
  ## Returns the current instance of the application. The application should have been initialized before
  ## this method is called
  ##
  ## @return  Reference to the application
