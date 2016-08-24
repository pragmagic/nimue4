# Copyright 2016 Xored Software, Inc.

wclass(SCompoundWidget of SWidget, header: "SlateCore.h", notypedef):
  ## A CompoundWidget is the base from which most non-primitive widgets should be built.
  ## CompoundWidgets have a protected member named ChildSlot.
  proc getContentScale(): FVector2D
    ## Returns the size scaling factor for this widget.
    ##
    ## @return Size scaling factor.

  proc setContentScale(inContentScale: TAttribute[FVector2D])
    ## Sets the content scale for this widget.
    ##
    ## @param InContentScale Content scaling factor.

  proc getColorAndOpacity(): FLinearColor
    ## Gets the widget's color.

  proc setColorAndOpacity(inColorAndOpacity: TAttribute[FLinearColor])
    ## Sets the widget's color.
    ##
    ## @param InColorAndOpacity The ColorAndOpacity to be applied to this widget and all its contents.

  proc setForegroundColor(inForegroundColor: TAttribute[FSlateColor])
    ## Sets the widget's foreground color.
    ##
    ## @param InColor The color to set.

# protected:

  var childSlot: FSimpleSlot
    ## The slot that contains this widget's descendants.

  var contentScale: TAttribute[FVector2D]
    ## The layout scale to apply to this widget's contents; useful for animation.

  var colorAndOpacity: TAttribute[FLinearColor]
    ## The color and opacity to apply to this widget and all its descendants.

  var foregroundColor: TAttribute[FSlateColor]
    ##Optional foreground color that will be inherited by all of this widget's contents