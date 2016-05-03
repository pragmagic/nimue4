# Copyright 2016 Xored Software, Inc.

type
  FHUDHitBox* {.header: "GameFramework/HUDHitBox.h", importcpp.} = object

# class(AHUD, header: "GameFramework/HUD.h", notypedef):

proc getHitBoxAtCoordinates*(hud: ptr AHUD, inHitLocation: FVector2D, bConsumingInput: bool = false): ptr FHUDHitBox {.
  noSideEffect, importcpp: "(const_cast<FHUDHitBox*>(#.GetHitBoxAtCoordinates(@)))", header: "GameFramework/HUD.h".}
  ##  Find the first hitbox containing the given coordinates.
  ##    @param	InHitLocation		Coordinates to check
  ##    @param	bConsumingInput		If true will return the first hitbox that would consume input at this coordinate
  ##    @return	returns the hitbox at the given coordinates or NULL if none match.