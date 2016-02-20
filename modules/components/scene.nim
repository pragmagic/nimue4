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

class(USceneComponent of UActorComponent, header: "Components/SceneComponent.h", notypedef):
  var bAbsoluteRotation: bool
    ## If RelativeRotation should be considered relative to the world, rather than the parent
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadWrite, ReplicatedUsing=OnRep_Transform, Category=Transform)

  var bAbsoluteScale: bool
    ## If RelativeScale3D should be considered relative to the world, rather than the parent
    ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadWrite, ReplicatedUsing=OnRep_Transform, Category=Transform)

  var bVisible: bool
    ## Whether to completely draw the primitive; if false, the primitive is not drawn, does not cast a shadow.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, ReplicatedUsing=OnRep_Visibility,  Category = Rendering)

  var bHiddenInGame: bool
    ## Whether to hide the primitive in game, if the primitive is Visible.
    ## UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category=Rendering)

  var bShouldUpdatePhysicsVolume: bool
    ## Whether or not the cached PhysicsVolume this component overlaps should be updated when the component is moved.
    ## @see GetPhysicsVolume()
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, AdvancedDisplay, Category=Physics)

  var bBoundsChangeTriggersStreamingDataRebuild: bool
    ## If true, a change in the bounds of the component will call trigger a streaming data rebuild
    ## UPROPERTY()

  var bUseAttachParentBound: bool
    ## If true, this component uses its parents bounds when attached.
    ## This can be a significant optimization with many components attached together.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, AdvancedDisplay, Category=Rendering)

  var relativeLocation: FVector
    ## Location of the component relative to its parent
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, ReplicatedUsing=OnRep_Transform, Category = Transform)

  var relativeRotation: FRotator
    ## Rotation of the component relative to its parent
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, ReplicatedUsing=OnRep_Transform, Category=Transform)

  proc attachTo(inParent: ptr USceneComponent;
                inSocketName: FName = NAME_None;
                attachType: EAttachLocation = EAttachLocation.KeepRelativeOffset;
                bWeldSimulatedBodies: bool = false)
    ## Attach this component to another scene component, optionally at a named socket. It is valid to call this on components whether or not they have been Registered.
    ## @param bMaintainWorldTransform	If true, update the relative location/rotation of the component to keep its world position the same

# TODO
