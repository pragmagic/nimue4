# Copyright 2016 Xored Software, Inc.

type
  ECameraProjectionMode {.header: "Camera/CameraTypes.h", importcpp: "ECameraProjectionMode::Type"} = enum
    Perspective,
    Orthographic

  ECameraAnimPlaySpace {.header: "Camera/CameraTypes.h", importcpp: "ECameraAnimPlaySpace".} = enum
    CameraLocal, ## This anim is applied in camera space.
    World, ## This anim is applied in world space.
    UserDefined, ## This anim is applied in a user-specified space (defined by UserPlaySpaceMatrix).

  FMinimalViewInfo {.header: "Camera/CameraTypes.h", importcpp: "FMinimalViewInfo".} = object

# TODO
