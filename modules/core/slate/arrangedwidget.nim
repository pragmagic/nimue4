# Copyright 2016 Xored Software, Inc.

wclass(FArrangedWidget, header: "SlateCore.h", bycopy):
  ## A pair: Widget and its Geometry. Widgets populate an list of WidgetGeometries
  ## when they arrange their children. See SWidget::ArrangeChildren.

  proc initFArrangedWidget(inWidget: TSharedRef[SWidget], inGeometry: FGeometry): FArrangedWidget {.constructor.}

  proc toString(): FString {.noSideEffect.}
    ## Gets the string representation of the Widget and corresponding Geometry.
    ##
    ## @return String representation.

  proc `==`(other: FArrangedWidget): bool {.noSideEffect.}
    ## Compares this widget arrangement with another for equality.
    ##
    ## @param Other The other arrangement to compare with.
    ## @return true if the two arrangements are equal, false otherwise.

  var geometry: FGeometry
    ## The widget's geometry.

  var widget: TSharedRef[SWidget]
    ## The widget that is being arranged.

var nullArrangedWidget* {.importcpp: "FArrangedWidget::NullWidget", header: "SlateCore.h".}: FArrangedWidget

wclass(FWidgetAndPointer of FArrangedWidget, header: "SlateCore.h", bycopy):
  proc initFWidgetAndPointer(): FWidgetAndPointer {.constructor.}
  proc initFWidgetAndPointer(inWidget: FArrangedWidget, inPosition: TSharedPtr[FVirtualPointerPosition]): FWidgetAndPointer {.constructor.}

  var pointerPosition: TSharedPtr[FVirtualPointerPosition]
