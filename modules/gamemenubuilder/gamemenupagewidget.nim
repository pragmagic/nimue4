# Copyright 2016 Xored Software, Inc.

type
  EPanelState {.importcpp: "EPanelState::Type", header: "GameMenuBuilder.h".} = enum
    Opening,
      ## Menu is opening.
    Open,
      ## Menu is open.
    Closing,
      ## Menu is closing.
    Closed
      ## Menu is closed.

declareBuiltinDelegate(FPanelStateChanged, dkSimple, "GameMenuBuilder.h", state: bool)

wclass(FMenuPanel, header: "GameMenuBuilder.h", bycopy):
  ## Simple class to contain the menu panels/animations
  proc initFMenuPanel(): FMenuPanel {.constructor.}

  proc tick(delta: float)

  # proc closePanel(ownerWidget: TSharedRef[SWidget])
  #   ## Close the panel

  # proc openPanel(ownerWidget: TSharedRef[SWidget])
  #   ## Open the panel

  proc forcePanelOpen()
    ## Force the panel to be fully open.

  proc forcePanelClosed()
    ## Force the panel to be fully closed.

  # proc setStyle(inStyle: ptr FGameMenuStyle)

  var onStateChanged: FPanelStateChanged
    ## Delegate called when the panel becomes open or closed.

  # var animationHandle: FCurveHandle
  #   ## Animation curve/handle for panel animation.

  var currentState: EPanelState
    ## The current state of the panel.

wclass(SGameMenuPageWidget, header: "GameMenuBuilder.h", notypedef):
  proc onMainPanelStateChange(bWasOpened: bool)
    ## Callback handler for when the state of the main panel changes.
    ##
    ## @param bWasOpened	whether the panel was opened or closed. is TRUE if panel opened.

  proc onSubPanelStateChange(bWasOpened: bool)
    ##  Callback handler for when the state of the sub panel changes.b
    ##
    ## @param bWasOpened	whether the panel was opened or closed. is TRUE if panel opened.

  proc setupAnimations()
    ## Setups misc animation sequences.

  proc enterSubMenu(inSubMenu: TSharedPtr[FGameMenuPage])
    ## Make the currently selected menu sub menu new main menu if valid.

  proc menuGoBack(bIsCancel: bool = false)
    ## Go back the the previous menu.
    ##
    ## @param	bIsCancel	if true will be treated as CANCEL (IE escape pressed).

  proc confirmMenuItem()
    ## Confirms current menu item and performs an action. Will also play selection sound.

  proc buildAndShowMenu(inMenu: TSharedPtr[FGameMenuPage])
    ## Show the given menu and make it the current menu.
    ##
    ## @param InMenu	The menu to show and set as the current menu. If this is NULL Current menu will be used if valid.

  proc hideMenu()
    ## Hide the menu.

  proc updateArrows(inMenuItem: TSharedPtr[FGameMenuItem])
    ## Updates arrows visibility for multi-choice menu item.
    ##
    ## @param	InMenuItem The item to update.

  proc changeOption(inMoveBy: int32)
    ## Change the currently selection option of the currently selected menu item.
    ##
    ## @param	InMoveBy		Number to change the option by.

  proc lockControls(bEnable: bool)
    ## disable/enable moving around menu.

  proc openMainPanel(inMenu: TSharedPtr[FGameMenuPage])
    ## Set the current menu and 'open' it as the main panel.
    ##
    ## @param InMenu	The menu to open and set as current.

  proc selectItem(inSelection: int32): bool
    ## Select a given item from an index
    ##
    ## @param InSelection	The index of the item to select
    ## @returns true if selection changed.

  proc resetMenu()

  var myGameViewport: TWeakObjectPtr[UGameViewportClient]
    ## The viewport I am attached to.

  proc getCurrentMenu(): TSharedPtr[FGameMenuPage]
