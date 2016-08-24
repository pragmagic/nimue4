# Copyright 2016 Xored Software, Inc.

wclass(UCapsuleComponent of UShapeComponent, header: "Components/CapsuleComponent.h", notypedef):
  ## A capsule generally used for simple collision. Bounds are rendered as lines in the editor.
  proc setCapsuleSize(inRadius: cfloat; inHalfHeight: cfloat;
                      bUpdateOverlaps: bool = true)
    ## Change the capsule size. This is the unscaled size, before component scale is applied.
    ## @param	InRadius : radius of end-cap hemispheres and center cylinder.
    ## @param	InHalfHeight : half-height, from capsule center to end of top or bottom hemisphere.
    ## @param	bUpdateOverlaps: if true and this shape is registered and collides, updates touching array for owner actor.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Capsule")

  proc setCapsuleRadius(radius: cfloat; bUpdateOverlaps: bool = true)
    ## Set the capsule radius. This is the unscaled radius, before component scale is applied.
    ## If this capsule collides, updates touching array for owner actor.
    ## @param	Radius : radius of end-cap hemispheres and center cylinder.
    ## @param	bUpdateOverlaps: if true and this shape is registered and collides, updates touching array for owner actor.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Capsule")

  proc setCapsuleHalfHeight(halfHeight: cfloat; bUpdateOverlaps: bool = true)
    ## Set the capsule half-height. This is the unscaled half-height, before component scale is applied.
    ## If this capsule collides, updates touching array for owner actor.
    ## @param	HalfHeight : half-height, from capsule center to end of top or bottom hemisphere.
    ## @param	bUpdateOverlaps: if true and this shape is registered and collides, updates touching array for owner actor.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Capsule")

  proc getScaledCapsuleRadius(): cfloat {.noSideEffect.}
    ## @return the capsule radius scaled by the component scale.
    ## UFUNCTION(BlueprintCallable, Category="Components|Capsule")

  proc getScaledCapsuleHalfHeight(): cfloat {.noSideEffect.}
    ## @return the capsule half height scaled by the component scale.
    ## UFUNCTION(BlueprintCallable, Category="Components|Capsule")

  proc getScaledCapsuleSize(outRadius: var cfloat; outHalfHeight: var cfloat) {.
      noSideEffect.}
    ## @return the capsule radius and half height scaled by the component scale.
    ## UFUNCTION(BlueprintCallable, Category="Components|Capsule")

  proc getUnscaledCapsuleRadius(): cfloat {.noSideEffect.}
    ## @return the capsule radius, ignoring component scaling.
    ## UFUNCTION(BlueprintCallable, Category="Components|Capsule")

  proc getUnscaledCapsuleHalfHeight(): cfloat {.noSideEffect.}
    ## @return the capsule half height, ignoring component scaling.
    ## UFUNCTION(BlueprintCallable, Category="Components|Capsule")

  proc getUnscaledCapsuleSize(outRadius: var cfloat; outHalfHeight: var cfloat) {.
      noSideEffect.}
    ## @return the capsule radius and half height, ignoring component scaling.
    ## UFUNCTION(BlueprintCallable, Category="Components|Capsule")

  proc getShapeScale(): cfloat {.noSideEffect.}
    ## Get the scale used by this shape. This is a uniform scale that is the minimum of any non-uniform scaling.
    ## @return the scale used by this shape.
    ## UFUNCTION(BlueprintCallable, Category="Components|Capsule")

  proc initCapsuleSize(inRadius: cfloat; inHalfHeight: cfloat)
    ## Sets the capsule size without triggering a render or physics update.
    ## This is the preferred method when initializing a component in a class constructor.
