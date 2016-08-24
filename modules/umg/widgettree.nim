# Copyright 2016 Xored Software, Inc.

wclass(UWidgetTree of UObject, header: "UMG.h"):
  proc findWidget(name: FName): ptr UWidget {.noSideEffect.}
    ## Finds the widget in the tree by name.

  proc findWidget(inWidget: TSharedRef[SWidget]): ptr UWidget {.noSideEffect.}
    ## Finds a widget in the tree using the native widget as the key.

  proc findWidget[T: UWidget](name: FName): ptr T {.noSideEffect.}
    ## Finds the widget in the tree by name and casts the return to the desired type.

  proc removeWidget(widget: ptr UWidget): bool
    ## Removes the widget from the hierarchy and all sub widgets.

  proc findWidgetParent(widget: ptr UWidget, outChildIndex: int32): ptr UPanelWidget
    ## Gets the parent widget of a given widget, and potentially the child index.

  proc getAllWidgets(widgets: TArray[ptr UWidget]) {.noSideEffect.}
    ## Gathers all the widgets in the tree recursively

  proc constructWidget[T: UWidget](): ptr T
    ## Constructs the widget, and adds it to the tree.

  proc constructWidget[T: UWidget](widgetType: TSubclassOf[UWidget], widgetName: FName = NAME_None): ptr T
    ## Constructs the widget, and adds it to the tree.

proc getChildWidgets*(parent: ptr UWidget, widgets: var TArray[ptr UWidget]) {.importcpp: "UWidgetTree::GetChildWidgets(@)", header: "UMG.h".}
  ## Gathers descendant child widgets of a parent widget.
