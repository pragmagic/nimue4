# Copyright 2016 Xored Software, Inc.

type
  FHUDHitBox* {.header: "GameFramework/HUDHitBox.h", importcpp.} = object

wclass(AHUD, header: "GameFramework/HUD.h", notypedef):
  var playerOwner: ptr APlayerController
    ## PlayerController which owns this HUD.
  var canvas: ptr UCanvas
    ## Canvas to Draw HUD on.  Only valid during PostRender() event.
  var debugCanvas: ptr UCanvas
    ## 'Foreground' debug canvas, will draw in front of Slate UI.

  proc addHitBox(position, size: FVector2D; inName: FName, bConsumesInput: bool, priority: int32 = 0) {.importcpp.}
    ## Add a hitbox to the hud
    ## @param Position			Coordinates of the top left of the hit box.
    ## @param Size				Size of the hit box.
    ## @param Name				Name of the hit box.
    ## @param bConsumesInput	Whether click processing should continue if this hit box is clicked.
    ## @param Priority			The priority of the box used for layering. Larger values are considered first.  Equal values are considered in the order they were added.

proc getHitBoxAtCoordinates*(hud: ptr AHUD, inHitLocation: FVector2D, bConsumingInput: bool = false): ptr FHUDHitBox {.
  noSideEffect, importcpp: "(const_cast<FHUDHitBox*>(#.GetHitBoxAtCoordinates(@)))", header: "GameFramework/HUD.h".}
  ##  Find the first hitbox containing the given coordinates.
  ##    @param	InHitLocation		Coordinates to check
  ##    @param	bConsumingInput		If true will return the first hitbox that would consume input at this coordinate
  ##    @return	returns the hitbox at the given coordinates or NULL if none match.