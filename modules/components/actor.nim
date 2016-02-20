# Copyright 2016 Xored Software, Inc.

type
  EComponentCreationMethod* {.header: "Components/ActorComponent.h", importcpp:"EComponentCreationMethod", pure.} = enum
    Native, ## A component that is part of a native class.
    SimpleConstructionScript,
      ## A component that is created from
      ## a template defined in the Components section of the Blueprint.
    UserConstructionScript,
      ## A dynamically created component, either from the UserConstructionScript
      ## or from a Add Component node in a Blueprint event graph.
    Instance
      ## A component added to a single Actor instance
      ## via the Component section of the Actor's details panel.

  ETeleportType* {.header: "Components/ActorComponent.h", importcpp:"ETeleportType", pure.} = enum
    None,
      ## Do not teleport physics body. This means velocity will reflect the
      ## movement between initial and final position, and collisions along the way will occur
    TeleportPhysics ## Teleport physics body so that velocity remains the same and no collision occurs

class(UActorComponent of UObject, header: "Components/ActorComponent.h", notypedef):
  var primaryComponentTick: FActorComponentTickFunction
  var componentTags: TArray[FName]

# TODO