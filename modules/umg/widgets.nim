# Copyright 2016 Xored Software, Inc.

type
  UVisual* {.header: "Components/Visual.h", importcpp.} = object of UObject
  UWidget* {.header: "Components/Widget.h", importcpp.} = object of UVisual
  UUserWidget* {.header: "Blueprint/UserWidget.h", importcpp.} = object of UWidget
