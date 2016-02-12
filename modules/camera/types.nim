# Copyright 2016 Xored Software, Inc.

const cameraTypesHeader = "Camera/CameraTypes.h"

type
  ECameraProjectionMode {.header: cameraTypesHeader, importcpp: "ECameraProjectionMode::Type"} = enum
    Perspective,
    Orthographic

  ECameraAnimPlaySpace {.header: cameraTypesHeader, importcpp: "ECameraAnimPlaySpace".} = enum
    CameraLocal, ## This anim is applied in camera space.
    World, ## This anim is applied in world space.
    UserDefined, ## This anim is applied in a user-specified space (defined by UserPlaySpaceMatrix).

  FMinimalViewInfo {.header: cameraTypesHeader, importcpp: "FMinimalViewInfo".} = object

# TODO
