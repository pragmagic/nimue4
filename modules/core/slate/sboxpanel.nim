# Copyright 2016 Xored Software, Inc.

wclass(FBoxPanelSlot of TSlotBase[FBoxPanelSlot], header: "SlateCore.h", cppname: "SBoxPanel::Slot"):
  var sizeParam: FSizeParam
    ## How much space this slot should occupy along panel's direction.
    ##   When SizeRule is SizeRule_Auto, the widget's DesiredSize will be used as the space required.
    ##   When SizeRule is SizeRule_Stretch, the available space will be distributed proportionately between
    ##   peer Widgets depending on the Value property. Available space is space remaining after all the
    ##   peers' SizeRule_Auto requirements have been satisfied.

  var hAlignment: EHorizontalAlignment
    ## Horizontal positioning of child within the allocated slot

  var vAlignment: EVerticalAlignment
    ## Vertical positioning of child within the allocated slot

  var slotPadding: TAttribute[FMargin]
    ## The padding to add around the child.

  var maxSize: TAttribute[float]
    ## The max size that this slot can be (0 if no max)

  proc `[]`(inChildWidget: TSharedRef[SWidget]): var FBoxPanelSlot

wclass(SBoxPanel of SPanel, header: "SlateCore.h"):
  ## A BoxPanel contains one child and describes how that child should be arranged on the screen.

  proc removeSlot[W: SWidget](slotWidget: TSharedRef[W]): int32
    ## Removes a slot from this box panel which contains the specified SWidget
    ##
    ## @param SlotWidget The widget to match when searching through the slots
    ## @returns The index in the children array where the slot was removed and -1 if no slot was found matching the widget

  proc clearChildren()
    ## Removes all children from the box.

wclass(FHorizontalBoxSlot of FBoxPanelSlot, header: "SlateCore.h", cppname: "SHorizontalBox::Slot"):
  proc initFHorizontalBoxSlot(): FHorizontalBoxSlot {.constructor.}

  proc autoWidth(): var FHorizontalBoxSlot {.discardable.}
  proc maxWidth(inMaxWidth: TAttribute[float32]): var FHorizontalBoxSlot {.discardable.}
  proc fillWidth(stretchCoefficient: TAttribute[float32]): var FHorizontalBoxSlot {.discardable.}

  proc hAlign(inHAlignment: EHorizontalAlignment): var FHorizontalBoxSlot {.discardable.}
  proc vAlign(inVAlignment: EVerticalAlignment): var FHorizontalBoxSlot {.discardable.}

  proc padding(uniform: float32): var FHorizontalBoxSlot {.discardable.}
  proc padding(horizontal, vertical: float32): var FHorizontalBoxSlot {.discardable.}
  proc padding(left, top, right, bottom: float32): var FHorizontalBoxSlot {.discardable.}
  proc padding(inPadding: TAttribute[FMargin]): var FHorizontalBoxSlot {.discardable.}

  proc `[]`(inWidget: TSharedRef[SWidget]): var FHorizontalBoxSlot {.discardable.}
  proc expose(outVarToInit: var ptr FHorizontalBoxSlot): var FHorizontalBoxSlot {.discardable.}

proc newFHorizontalBoxSlot*(): ptr FHorizontalBoxSlot {.importcpp: "(& SHorizontalBox::Slot())", header: "SlateCore.h".}

wclass(SHorizontalBox of SBoxPanel, header: "SlateCore.h"):
  ## A Horizontal Box Panel. See SBoxPanel for more info.

  var fVisibility {.cppname: "_Visibility".}: EVisibility

  proc visibility(visibility: EVisibility): var SHorizontalBox
    ## Sets visibility

  proc addSlot(): var FHorizontalBoxSlot
  proc insertSlot(index: int32 = INDEX_NONE): var FHorizontalBoxSlot
  proc numSlots(): int32 {.noSideEffect.}

wclass(FVerticalBoxSlot of FBoxPanelSlot, header: "SlateCore.h", cppname: "SHorizontalBox::Slot"):
  proc initFVerticalBoxSlot(): FVerticalBoxSlot {.constructor.}

  proc autoHeight(): var FVerticalBoxSlot {.discardable.}
  proc maxHeight(inMaxHeight: TAttribute[float32]): var FVerticalBoxSlot {.discardable.}
  proc fillHeight(stretchCoefficient: TAttribute[float32]): var FVerticalBoxSlot {.discardable.}

  proc hAlign(inHAlignment: EHorizontalAlignment): var FVerticalBoxSlot {.discardable.}
  proc vAlign(inVAlignment: EVerticalAlignment): var FVerticalBoxSlot {.discardable.}

  proc padding(uniform: float32): var FVerticalBoxSlot {.discardable.}
  proc padding(horizontal, vertical: float32): var FVerticalBoxSlot {.discardable.}
  proc padding(left, top, right, bottom: float32): var FVerticalBoxSlot {.discardable.}
  proc padding(inPadding: TAttribute[FMargin]): var FVerticalBoxSlot {.discardable.}

  proc `[]`(inWidget: TSharedRef[SWidget]): var FVerticalBoxSlot {.discardable.}
  proc expose(outVarToInit: var ptr FVerticalBoxSlot): var FVerticalBoxSlot {.discardable.}

proc newFVerticalBoxSlot*(): ptr FVerticalBoxSlot {.importcpp: "(& SVerticalBox::Slot())", header: "SlateCore.h".}

wclass(SVerticalBox of SBoxPanel, header: "SlateCore.h"):
  ## A Vertical Box Panel. See SBoxPanel for more info.
  var fVisibility {.cppname: "_Visibility".}: EVisibility
  proc visibility(visibility: EVisibility): var SHorizontalBox
    ## Sets visibility

  proc addSlot(): var FHorizontalBoxSlot
  proc insertSlot(index: int32 = INDEX_NONE): var FHorizontalBoxSlot
  proc numSlots(): int32 {.noSideEffect.}
