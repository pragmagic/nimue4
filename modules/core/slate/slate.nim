# Copyright 2016 Xored Software, Inc.

type
  ISlateMetaData* {.header: "SlateCore.h", importcpp, inheritable.} = object
  FNavigationMetaData* {.header: "SlateCore.h", importcpp.} = object of ISlateMetaData
  FPaintArgs* {.header: "SlateCore.h", importcpp, bycopy.} = object

  FSlotBase* {.header: "SlateCore.h", importcpp, inheritable, bycopy.} = object
  FArrangedChildren* {.header: "SlateCore.h", importcpp.} = object
  FWidgetPath* {.header: "SlateCore.h", importcpp, bycopy.} = object
  FChildren* {.header: "SlateCore.h", importcpp.} = object
  FGeometry* {.header: "SlateCore.h", importcpp.} = object
  FSlateRect* {.header: "SlateCore.h", importcpp, bycopy.} = object
  FSimpleSlot* {.header: "SlateCore.h", importcpp, bycopy.} = object

  FDragDropEvent* {.header: "SlateCore.h", importcpp, bycopy.} = object
  FDragDropOperation* {.importcpp, header: "SlateCore.h", importcpp, bycopy.} = object

  FSlateWindowElementList* {.header: "SlateCore.h", importcpp, bycopy.} = object
  FWidgetStyle* {.header: "SlateCore.h", importcpp, bycopy.} = object
  FSlateBrush* {.header: "SlateCore.h", importcpp.} = object
  FSlateFontInfo* {.header: "SlateCore.h", importcpp, bycopy.} = object

  FCachedWidgetNode* {.header: "Layout/WidgetCaching.h", importcpp, bycopy.} = object
  FWeakWidgetPath* {.header: "SlateCore.h", importcpp, bycopy.} = object
  FWindowStyle* {.header: "SlateCore.h", importcpp, bycopy.} = object

  FSlateSound* {.header: "SlateCore.h", importcpp, bycopy.} = object

  FSlateRenderTransform* = FTransform2D

type
  SWidget* {.header: "SlateCore.h", importcpp, inheritable.} = object

  SLeafWidget* {.header: "SlateCore.h", importcpp, inheritable.} = object of SWidget
  SCompoundWidget* {.header: "SlateCore.h", importcpp, inheritable.} = object of SWidget
  SWindow* {.header: "SlateCore.h", importcpp, inheritable.} = object of SCompoundWidget
  SUserWidget* {.header: "SlateCore.h", importcpp, inheritable.} = object of SCompoundWidget

  SPanel* {.header: "SlateCore.h", importcpp, inheritable.} = object of SWidget
    # panel is not wrapped on purpose - it only overrides SWidget methods,
    # not providing anything new

  SOverlay* {.header: "SlateCore.h", importcpp, inheritable.} = object of SPanel

type
  ISlateViewport* {.header: "SlateCore.h", importcpp, inheritable.} = object
  # TODO

var nullWidget* {.importcpp: "SNullWidget::NullWidget", header: "SlateCore.h".}: TSharedRef[SWidget]

proc slateNew*[W: SWidget](): TSharedRef[W] {.importcpp: "SNew('*0)", header: "SlateCore.h".}

include visibility
include slatecolor
include enums
include structs
include margin
include slatewidgetstyle
include slatetypes
include itooltip
include slatelayouttransform

declareBuiltinDelegate(FWidgetActiveTimerDelegate, dkSimpleRetVal, "SlateCore.h",
                       EActiveTimerReturnType, inCurrentTime: float64, inDeltaTime: float32)

include events
include virtualkeyboardentry

include curvesequence

# replies
include replybase
include reply
include cursorreply
include popupmethodreply
include navigationreply

include slateapplicationbase
include slateapplication

include arrangedwidget
include widget
include slotbase
include soverlay
include hittestgrid

include scompoundwidget
include sboxpanel
include swindow

include swidgetswitcher

# TODO: many classes not wrapped
