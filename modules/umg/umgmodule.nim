# Copyright 2016 Xored Software, Inc.

import ue4

wclass(UVisual of UObject, header: "UMG.h"):
  method releaseSlateResources(bReleaseChildren: bool)

type
  UWidget* {.importcpp, header: "UMG.h".} = object of UVisual
  UPanelWidget* {.importcpp, header: "UMG.h".} = object of UWidget
  UUserWidget* {.importcpp, header: "UMG.h".} = object of UWidget

include slatewrappertypes
include widgettransform
include sobjectwidget
include propertybinding

include widgettree
include widgetnavigation

include anchors

include panelslot
include canvaspanelslot
include widget
include userwidget
include panelwidget
include contentwidget

include image
include button
