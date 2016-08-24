# Copyright 2016 Xored Software, Inc.

wclass(FSlateWidgetStyle, header: "SlateCore.h", bycopy):
  ## Base structure for widget styles.
  proc initFSlateWidgetStyle(): FSlateWidgetStyle {.constructor.}
    ## Default constructor.

  method getResources(outBrushes: var TArray[ptr FSlateBrush]) {.noSideEffect.}
    ## Gets the brush resources associated with this style.
    ##
    ## This method must be implemented by inherited structures.
    ##
    ## @param OutBrushes The brush resources.

  method getTypeName(): FName {.noSideEffect.}
    ## Gets the name of this style.
    ##
    ## This method must be implemented by inherited structures.
    ##
    ## @return Widget style name.
