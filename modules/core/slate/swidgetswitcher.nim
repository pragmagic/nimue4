# Copyright 2016 Xored Software, Inc.

wclass(FWidgetSwitcherSlot of TSlotBase[FWidgetSwitcherSlot], header: "SlateBasics.h", cppname: "SWidgetSwitcher::FSlot"):
  proc hAlign(inHAlignment: EHorizontalAlignment): var FWidgetSwitcherSlot {.discardable.}
  proc vAlign(inVAlignment: EVerticalAlignment): var FWidgetSwitcherSlot {.discardable.}

  proc padding(uniform: float32): var FWidgetSwitcherSlot {.discardable.}
  proc padding(horizontal, vertical: float32): var FWidgetSwitcherSlot {.discardable.}
  proc padding(left, top, right, bottom: float32): var FWidgetSwitcherSlot {.discardable.}
  proc padding(inPadding: TAttribute[FMargin]): var FWidgetSwitcherSlot {.discardable.}

  proc `[]`(inChildWidget: TSharedRef[SWidget]): var FWidgetSwitcherSlot

wclass(SWidgetSwitcher of SPanel, header: "SlateBasics.h"):
  ## Implements a widget switcher.
  ##
  ## A widget switcher is like a tab control, but without tabs. At most one widget is visible at time.
  proc addSlot(slotIndex: int32 = INDEX_NONE ): var FWidgetSwitcherSlot
    ## Adds a slot to the widget switcher at the specified location.
    ##
    ## @param SlotIndex The index at which to insert the slot, or INDEX_NONE to append.

  proc getActiveWidget(): TSharedPtr[SWidget] {.noSideEffect.}
    ## Gets the active widget.
    ##
    ## @return Active widget.

  proc getActiveWidgetIndex(): int32 {.noSideEffect.}
    ## Gets the slot index of the currently active widget.
    ##
    ## @return The slot index, or INDEX_NONE if no widget is active.

  proc getNumWidgets(): int32 {.noSideEffect.}
    ## Gets the number of widgets that this switcher manages.
    ##
    ## @return Number of widgets.

  proc getWidget(slotIndex: int32): TSharedPtr[SWidget] {.noSideEffect.}
    ## Gets the widget in the specified slot.
    ##
    ## @param SlotIndex The slot index of the widget to get.
    ## @return The widget, or nullptr if the slot does not exist.

  proc getWidgetIndex(widget: TSharedRef[SWidget]): int32 {.noSideEffect.}
    ## Gets the slot index of the specified widget.
    ##
    ## @param Widget The widget to get the index for.
    ## @return The slot index, or INDEX_NONE if the widget does not exist.

  proc removeSlot(widgetToRemove: TSharedRef[SWidget]): int32 {.discardable.}
    ## Removes a slot with the corresponding widget in it.
    ## Returns the index where the widget was found, otherwise -1.
    ##
    ## @param Widget The widget to find and remove.

  proc setActiveWidget(widget: TSharedRef[SWidget])
    ## Sets the active widget.
    ##
    ## @param Widget The widget to activate.

  proc setActiveWidgetIndex(index: int32)
    ## Activates the widget at the specified index.
    ##
    ## @param Index The slot index.

proc newFWidgetSwitcherSlot*(): ptr FWidgetSwitcherSlot {.importcpp: "(& SWidgetSwitcher::Slot())", header: "SlateBasics.h".}
