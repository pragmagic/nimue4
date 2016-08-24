# Copyright 2016 Xored Software, Inc.

wclass(USphereComponent of UShapeComponent, header: "Components/SphereComponents.h", notypedef):
  ## A sphere generally used for simple collision.
  ## Bounds are rendered as lines in the editor.
  ##
  ## UCLASS(ClassGroup="Collision", editinlinenew, hidecategories=(Object,LOD,Lighting,TextureStreaming),
  ##        meta=(DisplayName="Sphere Collision", BlueprintSpawnableComponent))

  proc setSphereRadius(inSphereRadius: cfloat; bUpdateOverlaps: bool = true)
    ## Change the sphere radius. This is the unscaled radius, before component scale is applied.
    ## @param	InSphereRadius: the new sphere radius
    ## @param	bUpdateOverlaps: if true and this shape is registered and collides,
    ##        updates touching array for owner actor.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Components|Sphere")

  proc getScaledSphereRadius(): cfloat {.noSideEffect.}
    ## @return the radius of the sphere, with component scale applied.
    ## UFUNCTION(BlueprintCallable, Category="Components|Sphere")

  proc getUnscaledSphereRadius(): cfloat {.noSideEffect.}
    ## @return the radius of the sphere, ignoring component scale.
    ## UFUNCTION(BlueprintCallable, Category="Components|Sphere")

  proc getShapeScale(): cfloat {.noSideEffect.}
    ## Get the scale used by this shape.
    ## This is a uniform scale that is the minimum of any non-uniform scaling.
    ## @return the scale used by this shape.
    ## UFUNCTION(BlueprintCallable, Category="Components|Sphere")

  proc initSphereRadius(inSphereRadius: cfloat)
    ## Sets the sphere radius without triggering a render or physics update.