# Copyright 2016 Xored Software, Inc.

wclass(FSlateLayoutTransform, header: "Rendering/SlateLayoutTransform.h", bycopy):
  ## Represents a 2D transformation in the following order: scale then translate.
  ## Used by FGeometry for it's layout transformations.
  ##
  ## Matrix form looks like:
  ##   [Vx Vy 1] * [ S   0   0 ]
  ##               [ 0   S   0 ]
  ##               [ Tx  Ty  1 ]
  ##
  proc initFSlateLayoutTransform(inScale: float32 = 1.0'f32, inTranslation = initFVector2D(ForceInit)): FSlateLayoutTransform {.constructor.}
    ## Ctor from a scale followed by translate. Shortcut to Concatenate(InScale, InTranslation).

  proc initFSlateLayoutTransform(inTranslation: FVector2D, inScale: float32 = 1.0'f32): FSlateLayoutTransform {.constructor.}
    ## Ctor from a 2D translation followed by a scale. Shortcut to Concatenate(InTranslation, InScale).
    ## While this is the opposite order we internally store them, we can represent this correctly.

  proc getTranslation(): FVector2D {.noSideEffect.}
    ## Access to the 2D translation

  proc getScale(): float32 {.noSideEffect.}
    ## Access to the scale.

  proc toMatrix(): FMatrix {.noSideEffect.}
    ## Support for converting to an FMatrix.

  proc transformPoint(point: FVector2D): FVector2D
    ## 2D transform support.

  proc transformVector(vector: FVector2D): FVector2D
    ## 2D transform support.

  proc concatenate(rhs: FSlateLayoutTransform): FSlateLayoutTransform {.noSideEffect.}
    ## This works by transforming the origin through LHS then RHS.
    ## In matrix form, looks like this:
    ## [ Sa  0   0 ]   [ Sb  0   0 ]
    ## [ 0   Sa  0 ] * [ 0   Sb  0 ]
    ## [ Tax Tay 1 ]   [ Tbx Tby 1 ]

  proc inverse(): FSlateLayoutTransform {.noSideEffect.}
    ## Invert the transform/scale.

  proc `==`(other: FSlateLayoutTransform): bool {.noSideEffect.}
  proc `!=`(other: FSlateLayoutTransform): bool {.noSideEffect.}
