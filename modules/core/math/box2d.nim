# Copyright 2016 Xored Software, Inc.

wclass(FBox2D, header: "Math/Box2D.h", bycopy):
  ## Implements a rectangular 2D Box.
  var min: FVector2D
    ## Holds the box's minimum point.

  var max: FVector2D
    ## Holds the box's maximum point.

  var bIsValid: bool
    ## Holds a flag indicating whether this box is valid.

  proc initFBox2D(forceInit: EForceInit): FBox2D {.constructor.}
    ## Creates and initializes a new box.
    ##
    ## The box extents are initialized to zero and the box is marked as invalid.
    ##
    ## @param EForceInit Force Init Enum.

  proc initFBox2D(inMin: FVector2D; inMax: FVector2D): FBox2D {.constructor.}
    ## Creates and initializes a new box from the specified parameters.
    ##
    ## @param InMin The box's minimum point.
    ## @param InMax The box's maximum point.

  proc initFBox2D(points: ptr FVector2D; count: int32): FBox2D {.constructor.}
    ## Creates and initializes a new box from the given set of points.
    ##
    ## @param Points Array of Points to create for the bounding volume.
    ## @param Count The number of points.

  proc initFBox2D(points: TArray[FVector2D]): FBox2D {.constructor.}
    ## Creates and initializes a new box from an array of points.
    ##
    ## @param Points Array of Points to create for the bounding volume.

  proc `==`(other: FBox2D): bool {.noSideEffect.}
    ## Compares two boxes for equality.
    ##
    ## @param Other The other box to compare with.
    ## @return true if the boxes are equal, false otherwise.

  proc `+=`(other: FVector2D)
    ## Adds to this bounding box to include a given point.
    ##
    ## @param Other The point to increase the bounding volume to.
    ## @return Reference to this bounding box after resizing to include the other point.

  proc `+`(other: FVector2D): FBox2D {.noSideEffect.}
    ## Gets the result of addition to this bounding volume.
    ##
    ## @param Other The other point to add to this.
    ## @return A new bounding volume.

  proc `+=`(other: FBox2D)
    ## Adds to this bounding box to include a new bounding volume.
    ##
    ## @param Other The bounding volume to increase the bounding volume to.
    ## @return Reference to this bounding volume after resizing to include the other bounding volume.

  proc `+`(other: FBox2D): FBox2D {.noSideEffect.}
    ## Gets the result of addition to this bounding volume.
    ##
    ## @param Other The other volume to add to this.
    ## @return A new bounding volume.

  proc `[]`(index: int32): var FVector2D
    ## Gets reference to the min or max of this bounding volume.
    ##
    ## @param Index The index into points of the bounding volume.
    ## @return A reference to a point of the bounding volume.

  proc computeSquaredDistanceToPoint(point: FVector2D): cfloat {.noSideEffect.}
    ## Calculates the distance of a point to this box.
    ##
    ## @param Point The point.
    ## @return The distance.

  proc expandBy(w: cfloat): FBox2D {.noSideEffect.}
    ## Increase the bounding box volume.
    ##
    ## @param W The size to increase volume by.
    ## @return A new bounding box increased in size.

  proc getArea(): cfloat {.noSideEffect.}
    ## Gets the box area.
    ##
    ## @return Box area.
    ## @see GetCenter, GetCenterAndExtents, GetExtent, GetSize

  proc getCenter(): FVector2D {.noSideEffect.}
    ## Gets the box's center point.
    ##
    ## @return Th center point.
    ## @see GetArea, GetCenterAndExtents, GetExtent, GetSize

  proc getCenterAndExtents(center: var FVector2D; extents: var FVector2D) {.noSideEffect.}
    ## Get the center and extents
    ##
    ## @param center[out] reference to center point
    ## @param Extents[out] reference to the extent around the center
    ## @see GetArea, GetCenter, GetExtent, GetSize

  proc getClosestPointTo(point: FVector2D): FVector2D {.noSideEffect.}
    ## Calculates the closest point on or inside the box to a given point in space.
    ##
    ## @param Point The point in space.
    ##
    ## @return The closest point on or inside the box.

  proc getExtent(): FVector2D {.noSideEffect.}
    ## Gets the box extents around the center.
    ##
    ## @return Box extents.
    ## @see GetArea, GetCenter, GetCenterAndExtents, GetSize

  proc getSize(): FVector2D {.noSideEffect.}
    ## Gets the box size.
    ##
    ## @return Box size.
    ## @see GetArea, GetCenter, GetCenterAndExtents, GetExtent

  proc init()
    ## Set the initial values of the bounding box to Zero.

  proc intersect(other: FBox2D): bool {.noSideEffect.}
    ## Checks whether the given box intersects this box.
    ##
    ## @param other bounding box to test intersection
    ## @return true if boxes intersect, false otherwise.

  proc isInside(testPoint: FVector2D): bool {.noSideEffect.}
    ## Checks whether the given point is inside this box.
    ##
    ## @param Point The point to test.
    ## @return true if the point is inside this box, otherwise false.

  proc isInside(other: FBox2D): bool {.noSideEffect.}
    ## Checks whether the given box is fully encapsulated by this box.
    ##
    ## @param Other The box to test for encapsulation within the bounding volume.
    ## @return true if box is inside this volume, false otherwise.

  proc shiftBy(offset: FVector2D): FBox2D {.noSideEffect.}
    ## Shift bounding box position.
    ##
    ## @param The offset vector to shift by.
    ## @return A new shifted bounding box.

  proc toString(): FString {.noSideEffect.}
    ## Get a textual representation of this box.
    ##
    ## @return A string describing the box.
