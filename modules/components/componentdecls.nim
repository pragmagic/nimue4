type
  UActorComponent* {.header: "Components/ActorComponent.h", importcpp.} = object of UObject
  UInputComponent* {.header: "Components/InputComponent.h", importcpp.} = object of UActorComponent
  UPawnNoiseEmitterComponent* {.header: "Components/PawnNoiseEmitterComponent.h", importcpp.} = object of UActorComponent

  USceneComponent* {.header: "Components/SceneComponent.h", importcpp.} = object of UActorComponent
  UPrimitiveComponent* {.header: "Components/PrimitiveComponent.h", importcpp.} = object of USceneComponent

  UShapeComponent* {.header: "Components/ShapeComponent.h", importcpp.} = object of UPrimitiveComponent
  UCapsuleComponent* {.header: "Components/CapsuleComponent.h", importcpp.} = object of UShapeComponent

  UBillboardComponent* {.header: "Components/BillboardComponent.h", importcpp.} = object of UPrimitiveComponent

  UBrushComponent* {.header: "Components/BrushComponent.h", importcpp.} = object of UPrimitiveComponent

  UPathFollowingComponent {.header: "Navigation/PathFollowingComponent.h", importcpp.} = object of UActorComponent

  UMovementComponent* {.header: "Components/MovementComponent.h", importcpp.} = object of UActorComponent
  UNavMovementComponent* {.header: "GameFramework/NavMovementComponent.h", importcpp.} = object of UMovementComponent
  UPawnMovementComponent* {.header: "GameFramework/PawnMovementComponent.h", importcpp.} = object of UNavMovementComponent
