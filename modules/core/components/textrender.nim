# Copyright 2016 Xored Software, Inc.

wclass(UTextRenderComponent of UPrimitiveComponent, header: "Components/TextRenderComponent.h", notypedef):
  ## UCLASS(ClassGroup=Rendering, hidecategories=(Object,LOD,Physics,TextureStreaming,Activation,
  ##   "Components|Activation",Collision), editinlinenew, meta=(BlueprintSpawnableComponent = ""))

  var text: FText
    ## Text content, can be multi line using <br> as line separator
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Text, meta=(MultiLine=true))

  var textMaterial: ptr UMaterialInterface
    ## Text material
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Text)

  var font: ptr UFont
    ## Text font
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Text)

  var horizontalAlignment: TEnumAsByte[EHorizTextAligment]
    ## Horizontal text alignment
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Text, meta=(DisplayName = "Horizontal Alignment"))

  var verticalAlignment: TEnumAsByte[EVerticalTextAligment]
    ## Vertical text alignment
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Text, meta=(DisplayName = "Vertical Alignment"))

  var textRenderColor: FColor
    ## Color of the text, can be accessed as vertex color
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Text)

  var xScale: cfloat
    ## Horizontal scale, default is 1.0
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Text)

  var yScale: cfloat
    ## Vertical scale, default is 1.0
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Text)

  var worldSize: cfloat
    ## Vertical size of the fonts largest character in world units. Transform, XScale and YScale will affect final size.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category=Text)

  var invDefaultSize: cfloat
    ## The inverse of the Font's character height.
    ## UPROPERTY()

  var horizSpacingAdjust: cfloat
    ## Horizontal adjustment per character, default is 0.0
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, AdvancedDisplay, Category=Text)

  var vertSpacingAdjust: cfloat
    ## Vertical adjustment per character, default is 0.0
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, AdvancedDisplay, Category=Text)

  var bAlwaysRenderAsText: bool = true
    ## Allows text to draw unmodified when using debug visualization modes. *
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, AdvancedDisplay, Category=Rendering)

  proc setText(value: FString)
    ## Change the text value and signal the primitives to be rebuilt
    ## The FString variant is deprecated in favor of the FText variant
    ##
    ## DEPRECATED(4.8, "Passing text as FString is deprecated, please use FText instead (likely via a LOCTEXT).")
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|TextRender", meta=(DisplayName="Set Text (String)", DeprecatedFunction, DeprecationMessage="Use the SetText function taking an FText instead."))

  proc setText(value: FText)
    ## Change the text value and signal the primitives to be rebuilt

  proc k2_SetText(value: FText)
    ## Change the text value and signal the primitives to be rebuilt
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|TextRender", meta=(DisplayName="Set Text"))

  proc setTextMaterial(material: ptr UMaterialInterface)
    ## Change the text material and signal the primitives to be rebuilt
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|TextRender")

  proc setFont(value: ptr UFont)
    ## Change the font and signal the primitives to be rebuilt
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|TextRender")

  proc setHorizontalAlignment(value: EHorizTextAligment)
    ## Change the horizontal alignment and signal the primitives to be rebuilt
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|TextRender")

  proc setVerticalAlignment(value: EVerticalTextAligment)
    ## Change the vertical alignment and signal the primitives to be rebuilt
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|TextRender")

  proc setTextRenderColor(value: FColor)
    ## Change the text render color and signal the primitives to be rebuilt
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|TextRender")

  proc setXScale(value: cfloat)
    ## Change the text X scale and signal the primitives to be rebuilt
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|TextRender")

  proc setYScale(value: cfloat)
    ## Change the text Y scale and signal the primitives to be rebuilt
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|TextRender")

  proc setHorizSpacingAdjust(value: cfloat)
    ## Change the text horizontal spacing adjustment and signal the primitives to be rebuilt
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|TextRender")

  proc setVertSpacingAdjust(value: cfloat)
    ## Change the text vertical spacing adjustment and signal the primitives to be rebuilt
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|TextRender")

  proc setWorldSize(value: cfloat)
    ## Change the world size of the text and signal the primitives to be rebuilt
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|TextRender")

  proc getTextLocalSize(): FVector {.noSideEffect.}
    ## Get local size of text
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|TextRender")

  proc getTextWorldSize(): FVector {.noSideEffect.}
    ## Get world space size of text
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|TextRender")
