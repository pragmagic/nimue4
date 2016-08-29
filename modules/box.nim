# Copyright 2016 Xored Software, Inc.

wclass(FBox, header: "Math/Box.h", bycopy):
  ## Implements an axis-aligned box.
  ##
  ## Boxes describe an axis-aligned extent in three dimensions. They are used for many different things in the
  ## Engine and in games, such as bounding volumes, collision detection and visibility calculation.
  var min: FVector
    ## Holds the box's minimum point.

  var max: FVector
    ## Holds the box's maximum point.

  var isValid: bool
    ## Holds a flag indicating whether this box is valid.

  proc initFBox(a2: EForceInit): FBox {.constructor.}
    ## Creates and initializes a new box with zero extent and marks it as invalid.
    ##
    ## @param EForceInit Force Init Enum.

  proc initFBox(inMin: FVector; inMax: FVector): FBox {.constructor.}
    ## Creates and initializes a new box from the specified extents.
    ##
    ## @param InMin The box's minimum point.
    ## @param InMax The box's maximum point.

  proc initFBox(points: ptr FVector; count: int32): FBox {.constructor.}
    ## Creates and initializes a new box from the given set of points.
    ##
    ## @param Points Array of Points to create for the bounding volume.
    ## @param Count The number of points.

  proc initFBox(points: TArray[FVector]): FBox {.constructor.}
    ## Creates and initializes a new box from an array of points.
    ##
    ## @param Points Array of Points to create for the bounding volume.

  proc `==`(other: FBox): bool {.noSideEffect.}
    ## Compares two boxes for equality.
    ##
    ## @return true if the boxes are equal, false otherwise.

  proc `+=`(other: FVector)
    ## Adds to this bounding box to include a given point.
    ##
    ## @param Other the point to increase the bounding volume to.
    ## @return Reference to this bounding box after resizing to include the other point.

  proc `+`(other: FVector): FBox {.noSideEffect.}
    ## Gets the result of addition to this bounding volume.
    ##
    ## @param Other The other point to add to this.
    ## @return A new bounding volume.

  proc `+=`(other: FBox)
    ## Adds to this bounding box to include a new bounding volume.
    ##
    ## @param Other the bounding volume to increase the bounding volume to.
    ## @return Reference to this bounding volume after resizing to include the other bounding volume.

  proc `+`(other: FBox): FBox {.noSideEffect.}
    ## Gets the result of addition to this bounding volume.
    ##
    ## @param Other The other volume to add to this.
    ## @return A new bounding volume.

  proc `[]`(index: int32): var FVector
    ## Gets reference to the min or max of this bounding volume.
    ##
    ## @param Index the index into points of the bounding volume.
    ## @return a reference to a point of the bounding volume.

  proc computeSquaredDistanceToPoint(point: FVector): cfloat {.noSideEffect.}
    ## Calculates the distance of a point to this box.
    ##
    ## @param Point The point.
    ## @return The distance.

  proc expandBy(w: cfloat): FBox {.noSideEffect.}
    ## Increases the box size.
    ##
    ## @param W The size to increase the volume by.
    ## @return A new bounding box.

  proc expandBy(v: FVector): FBox {.noSideEffect.}
    ##  Increases the box size.
    ##
    ##  @param V The size to increase the volume by.
    ##  @return A new bounding box.

  proc expandBy(neg: FVector; pos: FVector): FBox {.noSideEffect.}
    ##  Increases the box size.
    ##
    ##  @param Neg The size to increase the volume by in the negative direction (positive values move the bounds outwards)
    ##  @param Pos The size to increase the volume by in the positive direction (positive values move the bounds outwards)
    ##  @return A new bounding box.

  proc shiftBy(offset: FVector): FBox {.noSideEffect.}
    ## Shifts the bounding box position.
    ##
    ## @param Offset The vector to shift the box by.
    ## @return A new bounding box.

  proc moveTo(destination: FVector): FBox {.noSideEffect.}
    ## Moves the center of bounding box to new destination.
    ##
    ## @param The destination point to move center of box to.
    ## @return A new bounding box.

  proc getCenter(): FVector {.noSideEffect.}
    ## Gets the center point of this box.
    ##
    ## @return The center point.
    ## @see GetCenterAndExtents, GetExtent, GetSize, GetVolume

  proc getCenterAndExtents(center: var FVector; extents: var FVector) {.noSideEffect.}
    ## Gets the center and extents of this box.
    ##
    ## @param center[out] Will contain the box center point.
    ## @param Extents[out] Will contain the extent around the center.
    ## @see GetCenter, GetExtent, GetSize, GetVolume

  proc getClosestPointTo(point: FVector): FVector {.noSideEffect.}
    ## Calculates the closest point on or inside the box to a given point in space.
    ##
    ## @param Point The point in space.
    ## @return The closest point on or inside the box.

  proc getExtent(): FVector {.noSideEffect.}
    ## Gets the extents of this box.
    ##
    ## @return The box extents.
    ## @see GetCenter, GetCenterAndExtents, GetSize, GetVolume

  proc getExtrema(pointIndex: cint): var FVector
    ## Gets a reference to the specified point of the bounding box.
    ##
    ## @param PointIndex The index of the extrema point to return.
    ## @return A reference to the point.

  proc getSize(): FVector {.noSideEffect.}
    ## Gets the size of this box.
    ##
    ## @return The box size.
    ## @see GetCenter, GetCenterAndExtents, GetExtent, GetVolume

  proc getVolume(): cfloat {.noSideEffect.}
    ## Gets the volume of this box.
    ##
    ## @return The box volume.
    ## @see GetCenter, GetCenterAndExtents, GetExtent, GetSize

  proc init()
    ## Set the initial values of the bounding box to Zero.

  proc intersect(other: FBox): bool {.noSideEffect.}
    ## Checks whether the given bounding box intersects this bounding box.
    ##
    ## @param Other The bounding box to intersect with.
    ## @return true if the boxes intersect, false otherwise.

  proc intersectXY(other: FBox): bool {.noSideEffect.}
    ## Checks whether the given bounding box intersects this bounding box in the XY plane.
    ##
    ## @param Other The bounding box to test intersection.
    ## @return true if the boxes intersect in the XY Plane, false otherwise.

  proc overlap(other: FBox): FBox {.noSideEffect.}
    ## Returns the overlap FBox of two box
    ##
    ## @param Other The bounding box to test overlap
    ## @return the overlap box. It can be 0 if they don't overlap

  proc inverseTransformBy(m: FTransform): FBox {.noSideEffect.}
    ##  Gets a bounding volume transformed by an inverted FTransform object.
    ##
    ##  @param M The transformation object to perform the inversely transform this box with.
    ##  @return	The transformed box.

  proc isInside(inVector: FVector): bool {.noSideEffect.}
    ## Checks whether the given location is inside this box.
    ##
    ## @param In The location to test for inside the bounding volume.
    ## @return true if location is inside this volume.
    ## @see IsInsideXY

  proc isInsideOrOn(inVector: FVector): bool {.noSideEffect.}
    ## Checks whether the given location is inside or on this box.
    ##
    ## @param In The location to test for inside the bounding volume.
    ## @return true if location is inside this volume.
    ## @see IsInsideXY

  proc isInside(other: FBox): bool {.noSideEffect.}
    ## Checks whether a given box is fully encapsulated by this box.
    ##
    ## @param Other The box to test for encapsulation within the bounding volume.
    ## @return true if box is inside this volume.

  proc isInsideXY(inVector: FVector): bool {.noSideEffect.}
    ## Checks whether the given location is inside this box in the XY plane.
    ##
    ## @param In The location to test for inside the bounding box.
    ## @return true if location is inside this box in the XY plane.
    ## @see IsInside

  proc isInsideXY(other: FBox): bool {.noSideEffect.}
    ## Checks whether the given box is fully encapsulated by this box in the XY plane.
    ##
    ## @param Other The box to test for encapsulation within the bounding box.
    ## @return true if box is inside this box in the XY plane.

  proc transformBy(m: FMatrix): FBox {.noSideEffect.}
    ## Gets a bounding volume transformed by a matrix.
    ##
    ## @param M The matrix to transform by.
    ## @return The transformed box.
    ## @see TransformProjectBy

  proc transformBy(m: FTransform): FBox {.noSideEffect.}
    ## Gets a bounding volume transformed by a FTransform object.
    ##
    ## @param M The transformation object.
    ## @return The transformed box.
    ## @see TransformProjectBy

  proc transformProjectBy(projM: FMatrix): FBox {.noSideEffect.}
    ## Transforms and projects a world bounding box to screen space
    ##
    ## @param ProjM The projection matrix.
    ## @return The transformed box.
    ## @see TransformBy

  proc toString(): FString {.noSideEffect.}
    ## Get a textual representation of this box.
    ##
    ## @return A string describing the box.

proc buildAABB*(origin, extent: FVector): FBox {.importcpp: "FBox::BuildAABB(@)", header: "Math/Box.h".}
  ## Utility function to build an AABB from Origin and Extent
  ##
  ## @param Origin The location of the bounding box.
  ## @param Extent Half size of the bounding box.
  ## @return A new axis-aligned bounding box.
