# Copyright 2016 Xored Software, Inc.

wclass(FOverlaySlot of TSlotBase[FOverlaySlot], header: "SlateCore.h", cppname: "SOverlay::FOverlaySlot"):
  ## A slot that support alignment of content and padding and z-order
  proc initFOverlaySlot(): FOverlaySlot {.constructor.}

  proc hAlign(inHAlignment: EHorizontalAlignment): var FOverlaySlot {.discardable.}
  proc vAlign(inVAlignment: EVerticalAlignment): var FOverlaySlot {.discardable.}
  proc padding(uniform: float32): var FOverlaySlot {.discardable.}
  proc padding(horizontal, vertical: float32): var FOverlaySlot {.discardable.}
  proc padding(left, top, right, bottom: float32): var FOverlaySlot {.discardable.}
  proc padding(inPadding: TAttribute[FMargin]): var FOverlaySlot {.discardable.}

  var hAlignment: EHorizontalAlignment
    ## The child widget contained in this slot.
  var vAlignment: EVerticalAlignment
  var slotPadding: TAttribute[FMargin]

  var zOrder: int32
    ## Slots with larger ZOrder values will draw above slots with smaller ZOrder values.  Slots
    ## with the same ZOrder will simply draw in the order they were added.  Currently this only
    ## works for overlay slots that are added dynamically with AddWidget() and RemoveWidget()

  proc `[]`(inChildWidget: TSharedRef[SWidget]): var FOverlaySlot

wclass(SOverlay of SPanel, header: "SlateCore.h", notypedef):
  ## Implements an overlay widget.
  ##
  ## Overlay widgets allow for layering several widgets on top of each other.
  ## Each slot of an overlay represents a layer that can contain one widget.
  ## The slots will be rendered on top of each other in the order they are declared in code.
  ##
  ## Usage:
  ##		SNew(SOverlay)
  ##		+ SOverlay::Slot(SNew(SMyWidget1))
  ##		+ SOverlay::Slot(SNew(SMyWidget2))
  ##		+ SOverlay::Slot(SNew(SMyWidget3))
  ##
  ##		Note that SWidget3 will be drawn on top of SWidget2 and SWidget1.

  proc getNumWidgets(): int32 {.noSideEffect.}
    ## Returns the number of child widgets

  proc removeSlot(widget: TSharedRef[SWidget]): bool
    ## Removes a widget from this overlay.
    ##
    ## @param	Widget	The widget content to remove

  proc addSlot(zOrder: int32 = INDEX_NONE): var FOverlaySlot
    ## Adds a slot at the specified location (ignores Z-order)

  proc removeSlot(zOrder: int32 = INDEX_NONE)
    ## Removes a slot at the specified location

  proc clearChildren()
    ## Removes all children from the overlay

proc newFOverlaySlot(): ptr FOverlaySlot {.importcpp: "(& SOverlay::Slot())", header: "SlateCore.h".}
  ## @return a new slot. Slots contain children for SOverlay
