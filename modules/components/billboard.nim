# Copyright 2016 Xored Software, Inc.

wclass(UBillboardComponent of UPrimitiveComponent, header: "Components/BillboardComponent.h", notypedef):
  ## A 2d texture that will be rendered always facing the camera.
  ## UCLASS(ClassGroup=Rendering, collapsecategories,
  ##        hidecategories=(Object,Activation,"Components|Activation",Physics,Collision,Lighting,Mesh,PhysicsVolume),
  ##        editinlinenew, meta=(BlueprintSpawnableComponent))

  var sprite: ptr UTexture2D
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Sprite)

  var bIsScreenSizeScaled: bool
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Sprite)

  var screenSize: cfloat
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Sprite)

  var U: cfloat
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Sprite)

  var UL: cfloat
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Sprite)

  var V: cfloat
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Sprite)

  var VL: cfloat
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Sprite)

#if WITH_EDITORONLY_DATA
  var spriteInfo: FSpriteCategoryInfo
    ## Sprite category information regarding the component
    ## UPROPERTY()

  var bUseInEditorScaling: bool
    ## Whether to use in-editor arrow scaling (i.e. to be affected by the global arrow scale)
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Sprite)
#endif // WITH_EDITORONLY_DATA


  method setSprite(newSprite: ptr UTexture2D)
    ## Change the sprite texture used by this component
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|Sprite")

  method setUV(newU, newUL, newV, newVL: int32)
    ## Change the sprite's UVs
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|Sprite")

  method setSpriteAndUV(newSprite: ptr UTexture2D; newU, newUL, newV, newVL: int32)
    ## Change the sprite texture and the UV's used by this component
    ## UFUNCTION(BlueprintCallable, Category="Rendering|Components|Sprite")

#if WITH_EDITORONLY_DATA
  proc setEditorScale(inEditorScale: cfloat) {.isStatic.}
    ## Set the scale that we use when rendering in-editor

  var EditorScale {.isStatic.}: cfloat
    ## The scale we use when rendering in-editor
#endif
