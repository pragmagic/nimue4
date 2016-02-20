# Copyright 2016 Xored Software, Inc.

type
  EDetailMode {.size: sizeof(cint), header: "Components/SceneComponent.h", importcpp.} = enum
    ## Detail mode for scene component rendering.
    DM_Low,
    DM_Medium,
    DM_High,
    DM_MAX

  ERelativeTransformSpace {.size: sizeof(cint), header: "Components/SceneComponent.h", importcpp.} = enum
    ## The space for the transform
    RTS_World,
      ## World space transform.
    RTS_Actor,
      ## Actor space transform.
    RTS_Component
      ## Component space transform.

  EMoveComponentFlags {.size: sizeof(cint), header: "Components/SceneComponent.h", importcpp.} = enum
    ## MoveComponent options.
    MOVECOMP_NoFlags = 0x0000,  ## No flags
    MOVECOMP_IgnoreBases = 0x0001,  ## Ignore collisions with things the Actor is based on
    MOVECOMP_SkipPhysicsMove = 0x0002,
      ## When moving this component, do not move the physics representation.
      ## Used internally to avoid looping updates when syncing with physics.
    MOVECOMP_NeverIgnoreBlockingOverlaps= 0x0004,
      ## Never ignore initial blocking overlaps during movement, which are usually ignored when moving out of an object.
      ## MOVECOMP_IgnoreBases is still respected.

const compHeader = "Components/SceneComponent.h"

proc `|`(arg1: EMoveComponentFlags, arg2: EMoveComponentFlags): EMoveComponentFlags {.header: compHeader, importcpp: "#|#", noSideEffect.}
proc `&`(arg1: EMoveComponentFlags, arg2: EMoveComponentFlags): EMoveComponentFlags {.header: compHeader, importcpp: "#&#", noSideEffect.}
proc `|=`(arg1: var EMoveComponentFlags, arg2: EMoveComponentFlags) {.header: compHeader, importcpp: "#|=#".}
proc `&=`(arg1: var EMoveComponentFlags, arg2: EMoveComponentFlags) {.header: compHeader, importcpp: "#&=#".}

declareBuiltinDelegate(FPhysicsVolumeChanged, dkDynamicMulticast, "Components/SceneComponent.h", newVolume: ptr APhysicsVolume)

# TODO
