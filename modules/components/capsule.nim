# Copyright 2016 Xored Software, Inc.

proc initCapsuleSize*(capsule: ptr UCapsuleComponent, inRadius: float32, inHalfHeight: float32) {.
  header: "Components/CapsuleComponent.h", importcpp: "#.SetCapsuleSize(@)", nodecl.}

# TODO