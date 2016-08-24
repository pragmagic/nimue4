# Copyright 2016 Xored Software, Inc.

wclass(UShapeComponent of UPrimitiveComponent, header: "Components/ShapeComponent.h", notypedef):
  ## ShapeComponent is a PrimitiveComponent that is represented by a simple geometrical shape (sphere, capsule, box, etc).
  ## UCLASS(abstract, hidecategories=(Object,LOD,Lighting,TextureStreaming,Activation,"Components|Activation"),
  ##        editinlinenew, meta=(BlueprintSpawnableComponent), showcategories=(Mobility))

  var shapeColor: FColor
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadOnly, Category=Shape)
    ## Color used to draw the shape.

  var shapeBodySetup: ptr UBodySetup
    ## Description of collision
    ## UPROPERTY(transient, duplicatetransient)

  var bDrawOnlyIfSelected: bool
    ## Only show this component if the actor is selected
    ## UPROPERTY()

  var bShouldCollideWhenPlacing: bool
    ## If true it allows Collision when placing even if collision is not enabled
    ## UPROPERTY()

  var bDynamicObstacle: bool
    ## If set, shape will be exported for navigation as dynamic modifier instead of using regular collision data
    ## UPROPERTY(EditAnywhere, Category = Navigation)

  var areaClass: ptr UClass
    ## Navigation area type (empty = default obstacle)
    ## UPROPERTY(EditAnywhere, Category = Navigation)

  method updateBodySetup()
    ## Update the body setup parameters based on shape information
