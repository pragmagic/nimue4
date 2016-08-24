# Copyright 2016 Xored Software, Inc.

wclass(FAnchors, header: "Widgets/Layout/Anchors.h", bycopy):
  ## Describes how a widget is anchored.

  var minimum: FVector2D
    ##Holds the minimum anchors, left + top.

  var maximum: FVector2D
    ## Holds the maximum anchors, right + bottom.

  proc initFAnchors(): FAnchors {.constructor.}
    ## Default constructor.
    ##
    ## The default margin size is zero on all four sides..

  proc initFAnchors(unifromAnchors: float32): FAnchors {.constructor.}
    ## Construct a Anchors with uniform space on all sides

  proc initFAnchors(horizontal, vertical: float32): FAnchors {.constructor.}
    ## Construct a Anchors where Horizontal describes Left and Right spacing while Vertical describes Top and Bottom spacing

  proc initFAnchors(minX, minY, maxX, maxY: float32): FAnchors {.constructor.}
    ## Construct Anchors where the spacing on each side is individually specified.

  proc isStretchedVertical(): bool {.noSideEffect.}
    ## Returns true if the anchors represent a stretch along the vertical axis

  proc isStretchedHorizontal(): bool {.noSideEffect.}
    ## Returns true if the anchors represent a stretch along the horizontal axis
