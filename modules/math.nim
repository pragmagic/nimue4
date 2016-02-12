# Copyright 2016 Xored Software, Inc.

type
  FVector* {.header: "Math/Vector.h", importcpp: "FVector".} = object
    X*: cfloat
    Y*: cfloat
    Z*: cfloat

  FVector2D* {.header: "Math/Vector2D.h", importcpp: "FVector2D".} = object
    X*: cfloat
    Y*: cfloat

  FQuat* {.header: "Math/Quat.h", importcpp: "FQuat".} = object
    X*: cfloat
    Y*: cfloat
    Z*: cfloat
    W*: cfloat

  FRotator* {.header: "Math/Rotator.h", importcpp: "FRotator".} = object
    Yaw*: cfloat
    Pitch*: cfloat
    Roll*: cfloat

  FTransform* {.header: "Math/TransformVectorized.h", importcpp: "FTransform".} = object

  FColor* {.header: "Math/Color.h", importcpp: "FColor".} = object
    A*: uint8
    R*: uint8
    G*: uint8
    B*: uint8

  FBox* {.header: "Math/Box.h", importcpp: "FBox".} = object
    Min*: FVector
    Max*: FVector
    IsValid*: bool

  FSphere* {.header: "Math/Sphere.h", importcpp: "FSphere".} = object
    Center*: FVector
    W*: cfloat

var WhiteColor* {.importc: "FColor::White", header: "Math/Color.h".}: FColor
var ZeroVector* {.importc: "FVector::ZeroVector", header: "Math/Vector.h".}: FVector
var IdentityTransform* {.importc: "FTransform::Identity", header: "Math/TransformVectorized.h".}: FTransform