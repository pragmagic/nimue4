# Copyright 2016 Xored Software, Inc.

wclass(UDrawFrustumComponent of UPrimitiveComponent, header:"Components/DrawFrustumComponent.h", notypedef):
  ## Utility component for drawing a view frustum.
  ## Origin is at the component location, frustum points down position X axis.
  ## UCLASS(collapsecategories, hidecategories=Object, editinlinenew, MinimalAPI)

  var frustumColor: FColor
    ## Color to draw the wireframe frustum.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=DrawFrustumComponent)

  var frustumAngle: cfloat
    ## Angle of longest dimension of view shape.
    ## If the angle is 0 then an orthographic projection is used
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=DrawFrustumComponent)

  var frustumAspectRatio: cfloat
    ## Ratio of horizontal size over vertical size.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=DrawFrustumComponent)

  var frustumStartDist: cfloat
    ## Distance from origin to start drawing the frustum.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=DrawFrustumComponent)

  var frustumEndDist: cfloat
    ## Distance from origin to stop drawing the frustum.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=DrawFrustumComponent)

  var texture: ptr UTexture
    ## optional texture to show on the near plane
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=DrawFrustumComponent)
