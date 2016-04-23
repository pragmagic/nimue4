# Copyright 2016 Xored Software, Inc.

const smallNumber: cfloat = (1e-8'f32)
const kindaSmallNumber: cfloat = (1e-4'f32)

type
  FPlane* {.header: "Math/Plane.h", importcpp.} = object
    x* {.importcpp: "X".}: cfloat
    y* {.importcpp: "Y".}: cfloat
    z* {.importcpp: "Z".}: cfloat
    w* {.importcpp: "W".}: cfloat

  FMatrix* {.header: "Math/Matrix.h", importcpp.} = object
    m* {.importcpp: "M".}: array[0..15, cfloat]

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

  EAxis* {.header: "Math/Axis.h", importcpp: "EAxis::Type", size: sizeof(cint), pure.} = enum
    None,
    X,
    Y,
    Z

  FIntPoint* {.header: "Math/IntPoint.h", importcpp: "FIntPoint", bycopy.} = object
    x* {.importcpp: "X".}: int32
    y* {.importcpp: "Y".}: int32

proc initFIntPoint*(x,y: int32): FIntPoint {.header: "Math/IntPoint.h", importcpp: "FIntPoint(@)", constructor.}

class(FVector, header: "Math/Vector.h", bycopy):
  var x*: cfloat
  var y*: cfloat
  var z*: cfloat

  proc initFVector(x, y, z: cfloat): FVector {.constructor.}

  proc set(x, y, z: cfloat)

  proc getMax(): cfloat {.noSideEffect.}
  proc getAbsMax(): cfloat {.noSideEffect.}
  proc getMin(): cfloat {.noSideEffect.}
  proc getAbsMin(): cfloat {.noSideEffect.}

  proc getAbs(): FVector {.noSideEffect.}

  proc componentMin(other: FVector): FVector {.noSideEffect.}
    ## Gets the component-wise min of two vectors.
  proc componentMax(other: FVector): FVector {.noSideEffect.}
    ## Gets the component-wise max of two vectors.

  proc isNearlyZero(tolerance: cfloat = kindaSmallNumber): bool {.noSideEffect.}
    ## Checks whether vector is near to zero within a specified tolerance.

  proc isZero(): bool {.noSideEffect.}
    ## Checks whether all components of the vector are exactly zero.
  proc containsNaN(): bool {.noSideEffect.}

  proc normalize(tolerance: cfloat): bool
    ## Normalize this vector in-place if it is large enough, set it to (0,0,0) otherwise.
  proc isNormalized(): bool {.noSideEffect.}

  proc getSignVector(): FVector {.noSideEffect.}
    ## Get a copy of the vector as sign only.
    ## Each component is set to +1 or -1, with the sign of zero treated as +1.

  proc projection(): FVector {.noSideEffect.}
    ## Projects 2D components of vector based on Z.

  proc toString(): FString {.noSideEffect.}
    ## Get a textual representation of this vector.
  proc toText(): FText {.noSideEffect.}
    ## Get a locale aware textual representation of this vector.

  proc toCompactString(): FString {.noSideEffect.}
    ## Get a short textural representation of this vector, for compact readable logging.
  proc toCompactText(): FText {.noSideEffect.}
    ## Get a short locale aware textural representation of this vector, for compact readable logging.

  proc `+`(other: FVector): FVector {.noSideEffect.}
  proc `+=`(other: FVector)
  proc `-`(other: FVector): FVector {.noSideEffect.}
  proc `-=`(other: FVector)

  proc `*`(other: FVector): FVector {.noSideEffect.}
  proc `*=`(other: FVector)
  proc `/`(other: FVector): FVector {.noSideEffect.}
  proc `/=`(other: FVector)

  proc `==`(other: FVector): bool {.noSideEffect.}
  proc `!=`(other: FVector): bool {.noSideEffect.}

  proc `-`(bias: cfloat): FVector {.noSideEffect.}
    ## Gets the result of subtracting from each component of the vector.
  proc `+`(bias: cfloat): FVector {.noSideEffect.}
    ## Gets the result of adding to each component of the vector.
  proc `*`(scale: cfloat): FVector {.noSideEffect.}
    ## Gets the result of scaling the vector (multiplying each component by a value).
  proc `/`(scale: cfloat): FVector {.noSideEffect.}
    ## Gets the result of dividing each component of the vector by a value.

  proc `^`(other: FVector): FVector {.noSideEffect.}
    ## Cross product
  proc `|`(other: FVector): FVector {.noSideEffect.}
    ## Dot product

  proc size(): cfloat
  proc sizeSquared(): cfloat

  proc size2D(): cfloat
  proc sizeSquared2D(): cfloat

var ZeroVector* {.importc: "FVector::ZeroVector", header: "Math/Vector.h".}: FVector
  ## A zero vector (0,0,0)
var UpVector* {.importc: "FVector::UpVector", header: "Math/Vector.h".}: FVector
  ## World up vector (0,0,1)
var ForwardVector* {.importc: "FVector::ForwardVector", header: "Math/Vector.h".}: FVector
  ## World forward vector (1,0,0)
var RightVector* {.importc: "FVector::RightVector", header: "Math/Vector.h".}: FVector
  ## World right vector (0,1,0)

proc dist*(v1, v2: FVector): cfloat {.header: "Math/Vector.h", importcpp: "'1::Dist(@)", noSideEffect.}
proc distSquared*(v1, v2: FVector): cfloat {.header: "Math/Vector.h", importcpp: "'1::DistSquared(@)", noSideEffect.}
proc distSquaredXY*(v1, v2: FVector): cfloat {.header: "Math/Vector.h", importcpp: "'1::DistSquaredXY(@)", noSideEffect.}
  ## Squared distance between two points in the XY plane only.
proc boxPushOut*(normal, size: FVector): cfloat {.header: "Math/Vector.h", importcpp: "'1::DistSquaredXY(@)", noSideEffect.}
proc triple*(x, y, z: FVector): cfloat {.header: "Math/Vector.h", importcpp: "'1::Triple(@)", noSideEffect.}
  ## Triple product of three vectors: `x` dot (`y` cross `z`).

proc radiansToDegrees*(radVector: FVector): FVector {.header: "Math/Vector.h", importcpp: "'1::RadiansToDegrees(@)", noSideEffect.}
proc degreesToRadians*(degVector: FVector): FVector {.header: "Math/Vector.h", importcpp: "'1::DegreesToRadians(@)", noSideEffect.}

proc parallel*(normal1, normal2: FVector): bool {.header: "Math/Vector.h", importcpp: "'1::Parallel(@)", noSideEffect.}
  ## See if two normal vectors are nearly parallel, meaning the angle between them is close to 0 degrees.
proc coincident*(normal1, normal2: FVector): bool {.header: "Math/Vector.h", importcpp: "'1::Coincident(@)", noSideEffect.}
  ## See if two normal vectors are coincident (nearly parallel and point in the same direction).
proc orthogonal*(normal1, normal2: FVector): bool {.header: "Math/Vector.h", importcpp: "'1::Orthogonal(@)", noSideEffect.}
  ## See if two normal vectors are nearly orthogonal (perpendicular), meaning the angle between them is close to 90 degrees.
proc coplanar*(base1, normal1, base2, normal2: FVector): bool {.header: "Math/Vector.h", importcpp: "'1::Coplanar(@)", noSideEffect.}
  ## See if two planes are coplanar. They are coplanar if the normals are nearly parallel and the planes include the same set of points.

type
  FBox* {.header: "Math/Box.h", importcpp.} = object
    min* {.importcpp: "Min".}: FVector
    max* {.importcpp: "Max".}: FVector
    isValid* {.importcpp: "IsValid".}: bool

  FSphere* {.header: "Math/Sphere.h", importcpp.} = object
    center* {.importcpp: "Center".}: FVector
    w* {.importcpp: "W".}: cfloat

  FBoxSphereBounds* {.header: "Math/BoxSphereBounds.h", importcpp.} = object
    ## Structure for a combined axis aligned bounding box and bounding sphere with the same origin. (28 bytes).
    origin* {.importcpp: "Origin".}: FVector
      ## Holds the origin of the bounding box and sphere.
    boxExtent* {.importcpp: "BoxExtent".}: FVector
      ## Holds the extent of the bounding box.
    sphereRadius* {.importcpp: "SphereRadius".}: float
      ## Holds the radius of the bounding sphere.

class(FVector2D, header: "Math/Vector2D.h", bycopy):
  var x: cfloat
  var y: cfloat

  proc initFVector2D(x, y: cfloat): FVector2D {.constructor.}
  proc initFVector2D(vec3d: FVector): FVector2D {.constructor.}

  proc set(x,y: cfloat)

  proc size(): cfloat
  proc sizeSquared(): cfloat

  proc getRotated(angleDeg: cfloat): FVector2D {.noSideEffect.}
    ## Rotates around axis (0,0,1)

  proc getMax(): cfloat {.noSideEffect.}
  proc getAbsMax(): cfloat {.noSideEffect.}
  proc getMin(): cfloat {.noSideEffect.}

  proc getAbs(): FVector {.noSideEffect.}

  proc componentMin(other: FVector): FVector {.noSideEffect.}
    ## Gets the component-wise min of two vectors.
  proc componentMax(other: FVector): FVector {.noSideEffect.}
    ## Gets the component-wise max of two vectors.

  proc isNearlyZero(tolerance: cfloat = kindaSmallNumber): bool {.noSideEffect.}
    ## Checks whether vector is near to zero within a specified tolerance.

  proc isZero(): bool {.noSideEffect.}
    ## Checks whether all components of the vector are exactly zero.
  proc containsNaN(): bool {.noSideEffect.}

  proc normalize(tolerance: cfloat): bool
    ## Normalize this vector in-place if it is large enough, set it to (0,0,0) otherwise.

  proc getSignVector(): FVector2D {.noSideEffect.}
    ## Get a copy of the vector as sign only.
    ## Each component is set to +1 or -1, with the sign of zero treated as +1.

  proc toString(): FString {.noSideEffect.}
    ## Get a textual representation of this vector.

  proc `+`(other: FVector2D): FVector2D {.noSideEffect.}
  proc `+=`(other: FVector2D)
  proc `-`(other: FVector2D): FVector2D {.noSideEffect.}
  proc `-=`(other: FVector2D)

  proc `*`(other: FVector2D): FVector2D {.noSideEffect.}
  proc `*=`(other: FVector2D)
  proc `/`(other: FVector2D): FVector2D {.noSideEffect.}
  proc `/=`(other: FVector2D)

  proc `==`(other: FVector2D): bool {.noSideEffect.}
  proc `!=`(other: FVector2D): bool {.noSideEffect.}

  proc `-`(bias: cfloat): FVector2D {.noSideEffect.}
    ## Gets the result of subtracting from each component of the vector.
  proc `-=`(bias: cfloat)
  proc `+`(bias: cfloat): FVector2D {.noSideEffect.}
    ## Gets the result of adding to each component of the vector.
  proc `+=`(bias: cfloat)
  proc `*`(scale: cfloat): FVector2D {.noSideEffect.}
    ## Gets the result of scaling the vector (multiplying each component by a value).
  proc `*=`(scale: cfloat)
  proc `/`(scale: cfloat): FVector2D {.noSideEffect.}
    ## Gets the result of dividing each component of the vector by a value.
  proc `/=`(scale: cfloat)

  proc `^`(other: FVector2D): FVector2D {.noSideEffect.}
    ## Cross product
  proc `|`(other: FVector2D): FVector2D {.noSideEffect.}
    ## Dot product

proc to2D*(v: FVector): FVector2D {.header: "Math/Vector2D.h", importcpp: "'0(@)", constructor.}
var ZeroVector2D* {.importc: "FVector2D::ZeroVector", header: "Math/Vector2D.h".}: FVector2D
  ## A zero vector (0,0)
var UnitVector2D* {.importc: "FVector2D::UnitVector", header: "Math/Vector2D.h".}: FVector2D
  ## A unit vector (1,1)

class(FQuat, header: "Math/Quat.h", notypedef):
  proc initFQuat(inX, inY, inZ, inW: cfloat): FQuat {.constructor.}
  proc initFQuat(m: FMatrix): FQuat {.constructor.}
  proc initFQuat(r: FRotator): FQuat {.constructor.}

  proc `+`(other: FQuat): FQuat {.noSideEffect.}
  proc `+=`(other: FQuat)
  proc `-`(other: FQuat): FQuat {.noSideEffect.}
  proc `-=`(other: FQuat)

  proc `*`(other: FQuat): FQuat {.noSideEffect.}
  proc `*=`(other: FQuat)
  proc `/`(other: FQuat): FQuat {.noSideEffect.}
  proc `/=`(other: FQuat)
  proc `|`(v: FQuat): cfloat {.noSideEffect.}

  proc `==`(other: FQuat): bool {.noSideEffect.}
  proc `!=`(other: FQuat): bool {.noSideEffect.}

  proc `*`(scale: cfloat): FQuat {.noSideEffect.}
    ## Gets the result of scaling the vector (multiplying each component by a value).
  proc `*=`(scale: cfloat)
  proc `/`(scale: cfloat): FQuat {.noSideEffect.}
    ## Gets the result of dividing each component of the vector by a value.
  proc `/=`(scale: cfloat)

  proc `*`(v: FVector): FVector {.noSideEffect.}
  proc `*`(m: FMatrix): FMatrix {.noSideEffect.}

  proc euler(): FVector {.noSideEffect.}
    ## Convert a Quaternion into floating-point Euler angles (in degrees).

  proc normalize(tolerance: cfloat = smallNumber)
  proc getNormalized(tolerance: cfloat = smallNumber): FQuat {.noSideEffect.}

  proc isNormalized(): bool {.noSideEffect.}
  proc size(): cfloat {.noSideEffect.}
  proc sizeSquared(): cfloat {.noSideEffect.}
  proc toAxisAndAngle(axis: var FVector; angle: var cfloat)

  proc rotateVector(v: FVector): FVector {.noSideEffect.}
  proc unrotateVector(v: FVector): FVector {.noSideEffect.}

  proc log(): FQuat {.noSideEffect.}
    ## Returns quaternion with W=0 and V=theta*v.
  proc exp(): FQuat {.noSideEffect.}
    ## Exp should really only be used after Log.
    ## Assumes a quaternion with W=0 and V=theta*v (where |v| = 1).
    ## Exp(q) = (sin(theta)*v, cos(theta))
  proc inverse(): FQuat {.noSideEffect.}

  proc enforceShortestArcWith(otherQuat: FQuat)
    ## Enforce that the delta between this Quaternion and another one represents
    ## the shortest possible rotation angle

  proc getAxisX(): FVector {.noSideEffect.}
  proc getAxisY(): FVector {.noSideEffect.}
  proc getAxisZ(): FVector {.noSideEffect.}
  proc rotator(): FRotator {.noSideEffect.}
  proc getRotationAxis(): FVector {.noSideEffect.}

  proc containsNaN(): bool {.noSideEffect.}
  proc toString(): FString

proc findQuatBetween(vec1, vec2: FVector) {.header: "Math/Quat.h", importcpp: "FQuat::FindBetween(@)", noSideEffect.}
proc quatError(q1, q2: FQuat): cfloat {.header: "Math/Quat.h", importcpp: "FQuat::Error(@)", noSideEffect.}
  ## Error measure (angle) between two quaternions, ranged [0..1].
  ## Returns the hypersphere-angle between two quaternions; alignment shouldn't matter, though
proc quatErrorAutoNormalize(a,b: FQuat): cfloat {.
  header: "Math/Quat.h", importcpp: "FQuat::ErrorAutoNormalize(@)", noSideEffect.}
proc quatFastLerp(a, b: FQuat; alpha: cfloat): FQuat {.
  header: "Math/Quat.h", importcpp: "FQuat::FastLerp(@)", noSideEffect.}
proc quatFastBilerp(p00, p10, p01, p11: FQuat; fracX, fracY: cfloat): FQuat {.
  header: "Math/Quat.h", importcpp: "FQuat::FastBilerp(@)", noSideEffect.}
proc quatSlerp(quat1, quat2: FQuat; slerp: cfloat): FQuat {.
  header: "Math/Quat.h", importcpp: "FQuat::Slerp(@)", noSideEffect.}
proc quatSlerpFullPath(quat1, quat2: FQuat; alpha: cfloat): FQuat {.
  header: "Math/Quat.h", importcpp: "FQuat::SlerpFullPath(@)", noSideEffect.}

proc quatSquad(quat1, tang1, quat2, tang2: FQuat; alpha: cfloat): FQuat {.
  header: "Math/Quat.h", importcpp: "FQuat::QuatSquad(@)", noSideEffect.}
proc quatCalcTangents(prevP, p, nextP: FQuat; tension: cfloat; outTan: var FQuat) {.
  header: "Math/Quat.h", importcpp: "FQuat::CalcTangents(@)".}

class(FRotator, header: "Math/Rotator.h", notypedef):
  proc initFRotator(f: cfloat): FRotator {.constructor.}
  proc initFRotator(pitch, yaw, roll: cfloat): FRotator {.constructor.}
  proc initFRotator(quat: FQuat): FRotator {.constructor.}

  proc `+`(other: FRotator): FRotator {.noSideEffect.}
  proc `+=`(other: FRotator)
  proc `-`(other: FRotator): FRotator {.noSideEffect.}
  proc `-=`(other: FRotator)

  proc `*`(other: FRotator): FRotator {.noSideEffect.}
  proc `*=`(other: FRotator)

  proc `*`(scale: cfloat): FRotator {.noSideEffect.}
  proc `*=`(scale: cfloat)

  proc `==`(other: FRotator): bool {.noSideEffect.}
  proc `!=`(other: FRotator): bool {.noSideEffect.}

  proc isNearlyZero(tolerance: cfloat = kindaSmallNumber): bool {.noSideEffect.}
  proc isZero(): bool {.noSideEffect.}

  proc add(deltaPitch, deltaYaw, deltaRoll: cfloat): FRotator
    ## Adds to each component of the rotator, returning copy of rotator after addition
  proc getInverse(): FRotator {.noSideEffect.}
  proc gridSnap(rotGrid: FRotator): FRotator {.noSideEffect.}

  proc vector(): FVector {.noSideEffect.}
    ## Convert a rotation into a vector facing in its direction.
  proc quaternion(): FQuat {.noSideEffect.}
    ## Get Rotation as a quaternion.
  proc euler(): FVector {.noSideEffect.}
    ## Convert a Rotator into floating-point Euler angles (in degrees). Rotator now stored in degrees.

  proc rotateVector(v: FVector): FVector {.noSideEffect.}
  proc unrotateVector(v: FVector): FVector {.noSideEffect.}

  proc clamp(): FRotator {.noSideEffect.}
    ## Gets the rotation values so they fall within the range [0,360]
  proc getNormalized(): FRotator {.noSideEffect.}
    ## Create a copy of this rotator and normalize, removes all winding and creates the "shortest route" rotation.
  proc getDenormalized(): FRotator {.noSideEffect.}
    ## Create a copy of this rotator and denormalize, clamping each axis to 0 - 360.

  proc normalize()
    ## In-place normalize, removes all winding and creates the "shortest route" rotation.

  proc getWindingAndRemainder(winding, remainder: var FRotator)
    ## Decompose this Rotator into a Winding part (multiples of 360) and a Remainder part.
    ## Remainder will always be in [-180, 180] range.

  proc toString(): FString {.noSideEffect.}
  proc toCompactString(): FString {.noSideEffect.}

  proc initFromString(inSourceString: FString): bool
    ## Initialize this Rotator based on an FString. The String is expected to contain P=, Y=, R=.
    ## The FRotator will be bogus when InitFromString returns false.

  proc containsNaN(): bool {.noSideEffect.}

var ZeroRotator* {.importc: "FRotator::ZeroRotator", header: "Math/Rotator.h".}: FRotator

class(FPlane, header: "Math/Plane.h", notypedef):
  proc initFPlane(): FPlane {.constructor.}

  proc initFPlane(x, y, z, w: cfloat) {.constructor.}

  proc planeDot(p: FVector): float {.noSideEffect.}
    ## Calculates distance between plane and a point.

  proc flip(): FPlane {.noSideEffect.}
    ## Get a flipped version of the plane.

  proc transformBy(m: FMatrix): FPlane {.noSideEffect.}
    ## Get the result of transforming the plane by a Matrix.

  proc `+`(other: FPlane): FPlane {.noSideEffect.}
  proc `+=`(other: FPlane)
  proc `-`(other: FPlane): FPlane {.noSideEffect.}
  proc `-=`(other: FPlane)

  proc `*`(other: FPlane): FPlane {.noSideEffect.}
  proc `*=`(other: FPlane)
  proc `/`(other: FPlane): FPlane {.noSideEffect.}
  proc `/=`(other: FPlane)

  proc `==`(other: FPlane): bool {.noSideEffect.}
  proc `!=`(other: FPlane): bool {.noSideEffect.}

  proc `*`(scale: cfloat): FPlane {.noSideEffect.}
    ## Gets the result of scaling the vector (multiplying each component by a value).
  proc `*=`(scale: cfloat)
  proc `/`(scale: cfloat): FPlane {.noSideEffect.}
    ## Gets the result of dividing each component of the vector by a value.
  proc `/=`(scale: cfloat)

  proc `|`(other: FPlane): FPlane {.noSideEffect.}
    ## Dot product

class(FMatrix, header: "Math/Matrix.h", notypedef):
  proc initFMatrix(x,y,z,w: FPlane): FMatrix {.constructor.}
  proc initFMatrix(x,y,z,w: FVector): FMatrix {.constructor.}

  proc setIdentity()
    # Set this to identity matrix

  proc `+`(other: FMatrix): FMatrix {.noSideEffect.}
  proc `+=`(other: FMatrix)
  proc `-`(other: FMatrix): FMatrix {.noSideEffect.}
  proc `-=`(other: FMatrix)

  proc `*`(other: FMatrix): FMatrix {.noSideEffect.}
  proc `*=`(other: FMatrix)

  proc `==`(other: FMatrix): bool {.noSideEffect.}
  proc `!=`(other: FMatrix): bool {.noSideEffect.}

  proc getTransposed(): FMatrix {.noSideEffect.}

  proc determinant(): cfloat {.noSideEffect.}
  proc rotDeterminant(): cfloat {.noSideEffect.}
    ## The determinant of rotation 3x3 matrix

  proc inverseFast(): FMatrix {.noSideEffect.}
    ## Fast path, doesn't check for nil matrices in final release builds
  proc inverse(): FMatrix {.noSideEffect.}
    ## Fast path, and handles nil matrices
  proc transposeAdjoint(): FMatrix {.noSideEffect.}

  proc removeScaling(tolerance: cfloat = smallNumber)
  proc getMatrixWithoutScale(tolerance: cfloat = smallNumber): FMatrix {.noSideEffect.}
  proc extraScaling(tolerance: cfloat = smallNumber): FVector
  proc getScaleVector(tolerance: cfloat = smallNumber): FVector {.noSideEffect.}

  proc removeTranslation(): FMatrix {.noSideEffect.}
  proc concatTranslation(translation: FVector): FMatrix {.noSideEffect.}
  proc containsNaN(): bool {.noSideEffect.}
  proc scaleTranslation(scale3D: FVector) {.noSideEffect.}

  proc getMaximumAxisScale(): cfloat {.noSideEffect.}
  proc applyScale(scale: cfloat): FMatrix {.noSideEffect.}
  proc getOrigin(): FVector {.noSideEffect.}

  proc getScaledAxis(axis: EAxis): FVector {.noSideEffect.}
  proc getScaledAxes(x,y,z: var FVector)

  proc getUnitAxis(axis: EAxis): FVector {.noSideEffect.}
  proc getUnitAxes(x, y, z: var FVector)

  proc setAxis(i: int32, axis: FVector)
  proc setOrigin(newOrigin: FVector)

  proc setAxes(axis0, axis1, axis2, origin: ptr FVector = nil)

  proc getColumn(i: int32): FVector {.noSIdeEffect.}

  proc rotator(): FRotator {.noSideEffect.}

  proc toQuat(): FQuat {.noSideEffect.}

  proc getFrustumNearPlane(outPlane: var FPlane): bool
  proc getFrustumFarPlane(outPlane: var FPlane): bool
  proc getFrustumLeftPlane(outPlane: var FPlane): bool
  proc getFrustumRightPlane(outPlane: var FPlane): bool
  proc getFrustumTopPlane(outPlane: var FPlane): bool
  proc getFrustumBottomPlane(outPlane: var FPlane): bool

  proc mirror(mirrorAxis, flipAxis: EAxis)

  proc toString(): FString {.noSideEffect.}
  proc debugPrint() {.noSideEffect.}

proc colorFromHex(hexString: FString): FColor {.
  importcpp: "FColor::FromHex(@)", header: "Math/Color.h", noSideEffect.}

proc initFColor*(r,g,b,a: uint8): FColor {.importcpp: "FColor(@)", nodecl, constructor.}

class(FTransform, header: "Math/TransformVectorized.h", notypedef):
  proc getTranslation(): FVector {.noSideEffect.}
  proc getRotation(): FQuat {.noSideEffect.}
  proc getScale3D(): FVector {.noSideEffect.}

var WhiteColor* {.importc: "FColor::White", header: "Math/Color.h".}: FColor
var IdentityTransform* {.importc: "FTransform::Identity", header: "Math/TransformVectorized.h".}: FTransform

converter vectorFromForceInit(f: EForceInit): FVector {.importcpp, constructor, header: "Math/Vector.h".}
converter colorFromForceInit(f: EForceInit): FColor {.importcpp, constructor, header: "Math/Color.h".}
converter vector2DFromForceInit(f: EForceInit): FVector2D {.importcpp, constructor, header: "Math/Vector2D.h".}
