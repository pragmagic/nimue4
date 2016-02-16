# Copyright 2016 Xored Software, Inc.

class(FVector, header: "Math/Vector.h", bycopy):
  var x: cfloat
  var y: cfloat
  var z: cfloat

  proc `+`(other: FVector): FVector {.noSideEffect.}
  proc `+=`(other: FVector)
  proc `-`(other: FVector): FVector {.noSideEffect.}
  proc `-=`(other: FVector)

  proc size(): cfloat
  proc sizeSquared(): cfloat

  proc size2D(): cfloat
  proc sizeSquared2D(): cfloat

var ZeroVector* {.importc: "FVector::ZeroVector", header: "Math/Vector.h".}: FVector

class(FVector2D, header: "Math/Vector2D.h", bycopy):
  var x: cfloat
  var y: cfloat

  proc `+`(other: FVector2D): FVector2D {.noSideEffect.}
  proc `+=`(other: FVector2D)
  proc `-`(other: FVector2D): FVector2D {.noSideEffect.}
  proc `-=`(other: FVector2D)

  proc size(): cfloat
  proc sizeSquared(): cfloat

proc to2D*(v: FVector): FVector2D {.header: "Math/Vector2D.h", importcpp: "'0(@)", constructor.}

type
  FQuat* {.header: "Math/Quat.h", importcpp.} = object
    x* {.importcpp: "X".}: cfloat
    y* {.importcpp: "Y".}: cfloat
    z* {.importcpp: "Z".}: cfloat
    w* {.importcpp: "W".}: cfloat

  FRotator* {.header: "Math/Rotator.h", importcpp.} = object
    yaw* {.importcpp: "Yaw".}: cfloat
    pitch* {.importcpp: "Pitch".}: cfloat
    roll* {.importcpp: "Roll".}: cfloat

  FTransform* {.header: "Math/TransformVectorized.h", importcpp.} = object

  FColor* {.header: "Math/Color.h", importcpp.} = object
    a* {.importcpp: "A".}: uint8
    r* {.importcpp: "R".}: uint8
    g* {.importcpp: "G".}: uint8
    b* {.importcpp: "B".}: uint8

  FBox* {.header: "Math/Box.h", importcpp.} = object
    min* {.importcpp: "Min".}: FVector
    max* {.importcpp: "Max".}: FVector
    isValid* {.importcpp: "IsValid".}: bool

  FSphere* {.header: "Math/Sphere.h", importcpp.} = object
    center* {.importcpp: "Center".}: FVector
    w* {.importcpp: "W".}: cfloat

var WhiteColor* {.importc: "FColor::White", header: "Math/Color.h".}: FColor

var ZeroVector2D* {.importc: "FVector2D::ZeroVector", header: "Math/Vector2D.h".}: FVector2D
var ZeroRotator* {.importc: "FRotator::ZeroRotator", header: "Math/Rotator.h".}: FRotator
var IdentityTransform* {.importc: "FTransform::Identity", header: "Math/TransformVectorized.h".}: FTransform

converter vectorFromForceInit(f: EForceInit): FVector {.importcpp, constructor, header: "Math/Vector.h".}
converter colorFromForceInit(f: EForceInit): FColor {.importcpp, constructor, header: "Math/Color.h".}
converter vector2DFromForceInit(f: EForceInit): FVector2D {.importcpp, constructor, header: "Math/Vector2D.h".}

proc dist*(vector, other: FVector): cfloat {.header: "Math/Vector.h", importcpp: "'1::Dist(@)", nodecl.}
