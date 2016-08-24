# Copyright 2016 Xored Software, Inc.

wclass(UImage of UWidget, header: "UMG.h"):
  ## The image widget allows you to display a Slate Brush, or texture or material in the UI.
  ##
  ## * No Children

  var brush: FSlateBrush
    ## Image to draw
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Appearance)

  var brushDelegate: FGetSlateBrush
    ## A bindable delegate for the Image.

  var colorAndOpacity: FLinearColor
    ## Color and opacity
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Appearance, meta=( sRGB="true") )

  var colorAndOpacityDelegate: FGetLinearColor
    ## A bindable delegate for the ColorAndOpacity.

  var onMouseButtonDownEvent: FOnPointerEvent
    ## UPROPERTY(EditAnywhere, Category=Events, meta=( IsBindableEvent="True" ))

  proc setColorAndOpacity(inColorAndOpacity: FLinearColor )
    ## UFUNCTION(BlueprintCallable, Category="Appearance")

  proc setOpacity(inOpacity: float32)
    ## UFUNCTION(BlueprintCallable, Category="Appearance")

  proc setBrush(inBrush: FSlateBrush)
    ## UFUNCTION(BlueprintCallable, Category="Appearance")

  proc setBrushFromTexture(texture: ptr UTexture2D, bMatchSize: bool = false)
    ## UFUNCTION(BlueprintCallable, Category="Appearance")

  proc setBrushFromMaterial(material: ptr UMaterialInterface)
    ## UFUNCTION(BlueprintCallable, Category="Appearance")

  proc getDynamicMaterial(): ptr UMaterialInstanceDynamic
    ## UFUNCTION(BlueprintCallable, Category="Appearance")
