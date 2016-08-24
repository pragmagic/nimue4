# Copyright 2016 Xored Software, Inc.

wclass(FWidgetTransform, header: "UMG.h", bycopy):
  ## Describes the standard transformation of a widget

  var translation: FVector2D
    ## The amount to translate the widget in slate units
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Transform, meta=( Delta = "1" ))

  var scale: FVector2D
    ## The scale to apply to the widget
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Transform, meta=( UIMin = "-5", UIMax = "5", Delta = "0.05" ))

  var shear: FVector2D
    ## The amount to shear the widget in slate units
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Transform, meta=( UIMin = "-89", ClampMin = "-89", UIMax = "89", ClampMax = "89", Delta = "1" ))

  var angle: float32
    ## The angle in degrees to rotate
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Transform, meta=( UIMin = "-180", UIMax = "180", Delta = "1" ))

  proc initFWidgetTransform(): FWidgetTransform {.constructor.}
  proc initFWidgetTransform(inTranslation, inScale, inShear: FVector2D; inAngle: float32): FWidgetTransform {.constructor.}

  proc isIdentity(): bool {.noSideEffect.}

  proc `==`(other: FWidgetTransform): bool {.noSideEffect.}
  proc `!=`(other: FWidgetTransform): bool {.noSideEffect.}

  proc toSlateRenderTransform(): FSlateRenderTransform {.noSideEffect.}
