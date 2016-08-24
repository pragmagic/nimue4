# Copyright 2016 Xored Software, Inc.

wclass(FScale2D, header: "Math/TransformCalculus2D.h", bycopy):
  ## Represents a 2D non-uniform scale (to disambiguate from an FVector2D, which is used for translation)
  proc initFScale2D(): FScale2D {.constructor.}
    ## Ctor. initialize to an identity scale, 1.0.
  proc initFScale2D(inScale: float32): FScale2D {.constructor.}
    ## Ctor. initialize from a uniform scale.
  proc initFScale2D(inScaleX, inScaleY: float32): FScale2D {.constructor.}
    ## Ctor. initialize from a non-uniform scale.
  proc initFScale2D(inScale: FVector2D): FScale2D {.constructor.}
    ## Ctor. initialize from an FVector defining the 3D scale.

  proc transformPoint(point: FVector2D): FVector2D {.noSideEffect.}
    ## Transform 2D Point
  proc transformVector(vector: FVector2D): FVector2D {.noSideEffect.}
    ## Transform 2D Vector

  proc concatenate(rhs: FScale2D): FScale2D {.noSideEffect.}
    ## Concatenate two scales.
  proc inverse(): FScale2D {.noSideEffect.}
    ## Invert the scale.

  proc `==`(other: FScale2D): bool {.noSideEffect.}
  proc `!=`(other: FScale2D): bool {.noSideEffect.}

  proc getVector(): FVector2D {.noSideEffect.}
    ## Access to the underlying FVector2D that stores the scale.

wclass(FShear2D, header: "Math/TransformCalculus2D.h", bycopy):
  ## Represents a 2D shear:
  ##   [1 YY]
  ##   [XX 1]
  ## XX represents a shear parallel to the X axis. YY represents a shear parallel to the Y axis.
  proc initFShear2D(): FShear2D
    ## Ctor. initialize to an identity.
  proc initFShear2D(shearX, shearY: float32): FShear2D
    ## Ctor. initialize from a set of shears parallel to the X and Y axis, respectively.
  proc initFShear2D(inShear: FVector2D): FShear2D
    ## Ctor. initialize from a 2D vector representing a set of shears parallel to the X and Y axis, respectively.

  proc transformPoint(point: FVector2D): FVector2D
    ## Transform 2D Point
    ## [X Y] * [1 YY] == [X+Y*XX Y+X*YY]
    ##         [XX 1]
  proc transformVector(vector: FVector2D): FVector2D
    ## Transform 2D Vector

  proc `==`(other: FShear2D): bool {.noSideEffect.}

  proc `!=`(other: FShear2D): bool {.noSideEffect.}

  proc getVector(): FVector2D
    ## Access to the underlying FVector2D that stores the scale.

proc initFShear2DFromShearAngles*(inShearAngles: FVector2D): FShear2D {.importcpp: "FShear2D::FromShearAngles(@)", header: "Math/TransformCalculus2D.h".}
  ## Generates a shear structure based on angles instead of slope.
  ## @param InShearAngles The angles of shear.
  ## @return the sheare structure.

wclass(FQuat2D, header: "Math/TransformCalculus2D.h", bycopy):
  ## Represents a 2D rotation as a complex number (analagous to quaternions).
  ##   Rot(theta) == cos(theta) + i * sin(theta)
  ##   General transformation follows complex number algebra from there.
  ## Does not use "spinor" notation using theta/2 as we don't need that decomposition for our purposes.
  ## This makes the implementation for straightforward and efficient for 2D.
  proc initFQuat2D(): FQuat2D {.constructor.}
    ## Ctor. initialize to an identity rotation.
  proc initFQuat2D(rotRadians: float32): FQuat2D {.constructor.}
    ## Ctor. initialize from a rotation in radians.
  proc initFQuat2D(inRot: FVector2D): FQuat2D {.constructor.}
    ## Ctor. initialize from an FVector2D, representing a complex number.

  proc transformPoint(point: FVector2D): FVector2D {.noSideEffect.}
    ## Transform a 2D point by the 2D complex number representing the rotation:
    ## In imaginary land: (x + yi) * (u + vi) == (xu - yv) + (xv + yu)i
    ##
    ## Looking at this as a matrix, x == cos(A), y == sin(A)
    ##
    ## [x y] * [ cosA  sinA] == [x y] * [ u v] == [xu-yv xv+yu]
    ##         [-sinA  cosA]            [-v u]
    ##
    ## Looking at the above results, we see the equivalence with matrix multiplication.

  proc transformVector(vector: FVector2D): FVector2D {.noSideEffect.}
    ## Vector rotation is equivalent to rotating a point.

  proc concatenate(rhs: FQuat2D): FQuat2D {.noSideEffect.}
    ## Transform 2 rotations defined by complex numbers:
    ## In imaginary land: (A + Bi) * (C + Di) == (AC - BD) + (AD + BC)i
    ##
    ## Looking at this as a matrix, A == cos(theta), B == sin(theta), C == cos(sigma), D == sin(sigma):
    ##
    ## [ A B] * [ C D] == [  AC-BD  AD+BC]
    ## [-B A]   [-D C]    [-(AD+BC) AC-BD]
    ##
    ## If you look at how the vector multiply works out: [X(AC-BD)+Y(-BC-AD)  X(AD+BC)+Y(-BD+AC)]
    ## you can see it follows the same form of the imaginary form. Indeed, check out how the matrix nicely works
    ## out to [ A B] for a visual proof of the results.
    ##        [-B A]

  proc inverse(): FQuat2D {.noSideEffect.}
    ## Invert the rotation  defined by complex numbers:
    ## In imaginary land, an inverse is a complex conjugate, which is equivalent to reflecting about the X axis:
    ## Conj(A + Bi) == A - Bi

  proc `==`(other: FQuat2D): bool {.noSideEffect.}
  proc `!=`(other: FQuat2D): bool {.noSideEffect.}

  proc getVector(): FVector2D {.noSideEffect.}
    ## Access to the underlying FVector2D that stores the complex number.

wclass(FMatrix2x2, header: "Math/TransformCalculus2D.h", bycopy):
  ## 2x2 generalized matrix. As FMatrix, we assume row vectors, row major storage:
  ##    [X Y] * [m00 m01]
  ##            [m10 m11]

  proc initFMatrix2x2(): FMatrix2x2 {.constructor.}
    ## Ctor. initialize to an identity.

  proc initFMatrix2x2(m00, m01, m10, m11: float32) {.constructor.}

  proc initFMatrix2x2(uniformScale: float32): FMatrix2x2 {.constructor.}
    ## Ctor. initialize from a scale.

  proc initFMatrix2x2(scale: FScale2D): FMatrix2x2 {.constructor.}
    ## Ctor. initialize from a scale.

  proc initFMatrix2x2(shear: FShear2D): FMatrix2x2 {.constructor.}
    ## Factory function. initialize from a 2D shear.

  proc initFMatrix2x2(rotation: FQuat2D): FMatrix2x2 {.constructor.}
    ## Ctor. initialize from a rotation.

  proc transformPoint(point: FVector2D): FVector2D {.noSideEffect.}
    ## Transform a 2D point
    ##    [X Y] * [m00 m01]
    ##            [m10 m11]

  proc transformVector(vector: FVector2D): FVector2D {.noSideEffect.}
    ## Vector transformation is equivalent to point transformation as our matrix is not homogeneous.

  proc concatenate(rhs: FMatrix2x2): FMatrix2x2 {.noSideEffect.}
    ## Concatenate 2 matrices:
    ## [A B] * [E F] == [AE+BG AF+BH]
    ## [C D]   [G H]    [CE+DG CF+DH]

  proc inverse(): FMatrix2x2 {.noSideEffect.}
    ## Invert the transform.

  proc `==`(rhs: FMatrix2x2): bool {.noSideEffect.}

  proc `!=`(other: FMatrix2x2): bool {.noSideEffect.}

  proc getMatrix(a, b, c, d: var float32)

  proc determinant(): float32 {.noSideEffect.}

  proc inverseDeterminant(): float32 {.noSideEffect.}

  proc getScaleSquared(): FScale2D {.noSideEffect.}
    ## Extracts the squared scale from the matrix (avoids sqrt).

  proc getScale(): FScale2D {.noSideEffect.}
    ## Gets the scale from the matrix.

  proc isIdentity(): bool {.noSideEffect.}
    ## Determines if the matrix is identity or not. Uses exact float comparison, so rounding error is not considered.

proc inverse(): FMatrix2x2 {.importcpp: "#.Inverse()", header: "Math/TransformCalculus2D.h".}
    ## Invert the shear. The result is NOT a shear, but must be represented by a generalized 2x2 transform.
    ## Defer the implementation until we can declare a 2x2 matrix.
    ## [1 YY]^-1  == 1/(1-YY*XX) * [1 -YY]
    ## [XX 1]                      [-XX 1]

proc concatenate(lhs, rhs: FShear2D): FMatrix2x2 {.importcpp: "#.Concatenate(@)", header: "Math/TransformCalculus2D.h".}
  ## Concatenate two shears. The result is NOT a shear, but must be represented by a generalized 2x2 transform.
  ## Defer the implementation until we can declare a 2x2 matrix.
  ## [1 YYA] * [1 YYB] == [1+YYA*XXB YYB*YYA]
  ## [XXA 1]   [XXB 1]    [XXA+XXB XXA*XXB+1]

wclass(FTransform2D, header: "Math/TransformCalculus2D.h", bycopy):
  ## Support for generalized 2D affine transforms.
  ## Implemented as a 2x2 transform followed by translation. In matrix form:
  ##   [A B 0]
  ##   [C D 0]
  ##   [X Y 1]
  proc initFTransform2D(translation: FVector2D = zeroVector2D): FTransform2D {.constructor.}
    ## Initialize the transform using an identity matrix and a translation.

  proc initFTransform2D(uniformScale: float32, translation: FVector2D = zeroVector2D): FTransform2D {.constructor.}
    ## Initialize the transform using a uniform scale and a translation.

  proc initFTransform2D(scale: FScale2D, translation: FVector2D = zeroVector2D): FTransform2D {.constructor.}
    ## Initialize the transform using a 2D scale and a translation.

  proc initFTransform2D(shear: FShear2D, translation: FVector2D = zeroVector2D): FTransform2D {.constructor.}
    ## Initialize the transform using a 2D shear and a translation.

  proc initFTransform2D(rot: FQuat2D, translation: FVector2D = zeroVector2D): FTransform2D {.constructor.}
    ## Initialize the transform using a 2D rotation and a translation.

  proc initFTransform2D(transform: FMatrix2x2, translation: FVector2D = zeroVector2D): FTransform2D {.constructor.}
    ## Initialize the transform using a general 2x2 transform and a translation.

  proc transformPoint(point: FVector2D): FVector2D {.noSideEffect.}
    ## 2D transformation of a point.

  proc transformVector(vector: FVector2D): FVector2D {.noSideEffect.}
    ## 2D transformation of a vector.

  proc concatenate(rhs: FTransform2D): FTransform2D {.noSideEffect.}
    ## Concatenates two transforms. Result is equivalent to transforming first by this, followed by RHS.
    ##  Concat(A,B) == (P * MA + TA) * MB + TB
    ##              == (P * MA * MB) + TA*MB + TB
    ##  NewM == MA * MB
    ##  NewT == TA * MB + TB

  proc inverse(): FTransform2D {.noSideEffect.}
    ## Inverts a transform. So a transform from space A to space B results in a transform from space B to space A.
    ## Since this class applies the 2x2 transform followed by translation, our inversion logic needs to be able to recast
    ## the result as a M * T. It does it using the following identity:
    ##   (M * T)^-1 == T^-1 * M^-1
    ##
    ## In homogeneous form, we represent our affine transform like so:
    ##      M    *    T
    ##   [A B 0]   [1 0 0]   [A B 0]
    ##   [C D 0] * [0 1 0] = [C D 0]. This class simply decomposes the 2x2 transform and translation.
    ##   [0 0 1]   [X Y 1]   [X Y 1]
    ##
    ## But if we were applying the transforms in reverse order (as we need to for the inverse identity above):
    ##    T^-1   *  M^-1
    ##   [1 0 0]   [A B 0]   [A  B  0]  where [X' Y'] = [X Y] * [A B]
    ##   [0 1 0] * [C D 0] = [C  D  0]                          [C D]
    ##   [X Y 1]   [0 0 1]   [X' Y' 1]
    ##
    ## This can be conceptualized by seeing that a translation effectively defines a new local origin for that
    ## frame of reference. Since there is a 2x2 transform AFTER that, the concatenated frame of reference has an origin
    ## that is the old origin transformed by the 2x2 transform.
    ##
    ## In the last equation:
    ## We know that [X Y] is the translation induced by inverting T, or -Translate.
    ## We know that [[A B][C D]] == Inverse(M), so we can represent T^-1 * M^-1 as M'* T' where:
    ##   M' == Inverse(M)
    ##   T' == Inverse(Translate) * Inverse(M)

  proc `==`(other: FTransform2D): bool {.noSideEffect.}

  proc `!=`(other: FTransform2D): bool {.noSideEffect.}

  proc getMatrix(): FMatrix2x2 {.noSideEffect.}
    ## Access to the 2x2 transform
  proc getTranslation(): FVector2D {.noSideEffect.}
    ## Access to the translation

  proc isIdentity(): bool {.noSideEffect.}
    ## Specialized function to determine if a transform is precisely the identity transform.
    ## Uses exact float comparison, so rounding error is not considered.
