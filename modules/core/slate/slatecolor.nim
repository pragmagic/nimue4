# Copyright 2016 Xored Software, Inc.

type
  ESlateColorStylingMode* {.importcpp: "ESlateColorStylingMode::Type", header: "SlateCore.h", pure.} = enum
    ## Enumerates types of color values that can be held by Slate color.
    ##
    ## Should we use the specified color? If not, then which color from the style should we use.
    UseColor_Specified,
      ## Color value is stored in this Slate color.
    UseColor_Specified_Link,
      ## Color value is stored in the linked color.
    UseColor_Foreground,
      ## Use the widget's foreground color.
    UseColor_Foreground_Subdued
      ## Use the widget's subdued color.

wclass(FSlateColor, header: "SlateCore.h", bycopy):
  ## A Slate color can be a directly specified value, or the color can be pulled from a WidgetStyle.
  proc initFSlateColor(): FSlateColor {.constructor.}
    ## Default constructor.
    ##
    ## Uninitialized Slate colors are Fuchsia by default.
  proc initFSlateColor(inColor: FLinearColor): FSlateColor {.constructor.}
    ## Creates a new Slate color with the specified values.
    ##
    ## @param InColor The color value to assign.
  proc initFSlateColor(inColor: TSharedRef[FLinearColor]): FSlateColor {.constructor.}
    ## Creates a new Slate color that is linked to the given values.
    ##
    ## @param InColor The color value to assign.
  proc getColor(inWidgetStyle: FWidgetStyle): FLinearColor {.noSideEffect.}
    ## Gets the color value represented by this Slate color.
    ##
    ## @param InWidgetStyle The widget style to use when this color represents a foreground or subdued color.
    ## @return The color value.
    ## @see GetSpecifiedColor

  proc getSpecifiedColor(): FLinearColor {.noSideEffect.}
    ## Gets the specified color value.
    ##
    ## @return The specified color value.
    ## @see GetColor, IsColorSpecified

  proc isColorSpecified(): bool {.noSideEffect.}
    ## Checks whether the values for this color have been specified.
    ##
    ## @return true if specified, false otherwise.
    ## @see GetSpecifiedColor

  proc `==`(other: FSlateColor): bool {.noSideEffect.}
    ## Compares this color with another for equality.
    ##
    ## @param Other The other color.
    ##
    ## @return true if the two colors are equal, false otherwise.

  proc `!=`(other: FSlateColor): bool {.noSideEffect.}
    ## Compares this color with another for inequality.
    ##
    ## @param Other The other color.
    ##
    ## @return false if the two colors are equal, true otherwise.

  proc serializeFromMismatchedTag(tag: FPropertyTag, ar: var FArchive): bool
    ## Used to upgrade an FColor or FLinearColor property to an FSlateColor property

proc initUseForegroundColor*(): FSlateColor {.importcpp: "FSlateColor::UseForeground()", header: "SlateCore.h".}
  ## @returns an FSlateColor that is the widget's foreground.

proc initUseSubduedForeground*(): FSlateColor {.importcpp: "FSlateColor::UseSubduedForeground()", header: "SlateCore.h".}
  ## @returns an FSlateColor that is the subdued version of the widget's foreground.
