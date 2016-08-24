# Copyright 2016 Xored Software, Inc.

wclass(FMargin, header: "SlateCore.h", bycopy):
  ## Describes the space around a Widget.
  var left: float32
    ## Holds the margin to the left.
  var top: float32
    ## Holds the margin to the top.
  var right: float32
    ## Holds the margin to the right.
  var bottom: float32
    ## Holds the margin to the bottom.

  proc initFMargin(): FMargin {.constructor.}
    ## Default constructor.
    ##
    ## The default margin size is zero on all four sides..

  proc initFMargin(unifromMargin: float32): FMargin {.constructor.}
    ## Construct a Margin with uniform space on all sides

  proc initFMargin(horizontal, vertical: float32): FMargin {.constructor.}
    ## Construct a Margin where Horizontal describes Left and Right spacing while Vertical describes Top and Bottom spacing

  proc initFMargin(inLeft, inTop, inRight, inBottom: float32): FMargin {.constructor.}
    ## Construct a Margin where the spacing on each side is individually specified.

  # provide versions with Nim-friendly names, too
  proc margin(): FMargin {.constructor.}
    ## Default constructor.
    ##
    ## The default margin size is zero on all four sides..

  proc margin(unifromMargin: float32): FMargin {.constructor.}
    ## Construct a Margin with uniform space on all sides

  proc margin(horizontal, vertical: float32): FMargin {.constructor.}
    ## Construct a Margin where Horizontal describes Left and Right spacing while Vertical describes Top and Bottom spacing

  proc margin(inLeft, inTop, inRight, inBottom: float32): FMargin {.constructor.}
    ## Construct a Margin where the spacing on each side is individually specified.

  proc `*`(scale: float32): FMargin {.noSideEffect.}
    ## Multiply the margin by a scalar.
    ##
    ## @param Scale How much to scale the margin.
    ## @return An FMargin where each value is scaled by Scale.

  proc `+`(inDelta: FMargin): FMargin {.noSideEffect.}
    ## Adds another margin to this margin.
    ##
    ## @param Other The margin to add.
    ## @return A margin that represents this margin plus the other margin.

  proc `-`(other: FMargin): FMargin {.noSideEffect.}
    ## Subtracts another margin from this margin.
    ##
    ## @param Other The margin to subtract.
    ## @return A margin that represents this margin minues the other margin.

  proc `==`(other: FMargin): bool {.noSideEffect.}
    ## Compares this margin with another for equality.
    ##
    ## @param Other The other margin.
    ## @return true if the two margins are equal, false otherwise.

  proc `!=`(other: FMargin): bool {.noSideEffect.}
    ## Compares this margin with another for inequality.
    ##
    ## @param Other The other margin.
    ## @return true if the two margins are not equal, false otherwise.

  proc getDesiredSize(): FVector2D {.noSideEffect.}
    ## Gets the margin's total size.
    ##
    ## @return Cumulative margin size.

  proc getTotalSpaceAlong(): float32 {.noSideEffect.}
    ## Gets the total horizontal or vertical margin.
    ##
    ## @return Cumulative horizontal margin.
