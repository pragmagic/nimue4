# Copyright 2016 Xored Software, Inc.

type
  UActorComponent* {.header: "Components/ActorComponent.h", importcpp.} = object of UObject
  UInputComponent* {.header: "Components/InputComponent.h", importcpp.} = object of UActorComponent
  UPawnNoiseEmitterComponent* {.header: "Components/PawnNoiseEmitterComponent.h", importcpp.} = object of UActorComponent

  USceneComponent* {.header: "Components/SceneComponent.h", importcpp.} = object of UActorComponent
  UCameraComponent* {.header: "Camera/CameraComponent.h", importcpp.} = object of USceneComponent
  USpringArmComponent* {.header: "GameFramework/SpringArmComponent.h", importcpp.} = object of USceneComponent
  UPrimitiveComponent* {.header: "Components/PrimitiveComponent.h", importcpp.} = object of USceneComponent
  UDrawFrustumComponent* {.header: "Components/DrawFrustumComponent.h", importcpp.} = object of UPrimitiveComponent

  UShapeComponent* {.header: "Components/ShapeComponent.h", importcpp.} = object of UPrimitiveComponent
  UCapsuleComponent* {.header: "Components/CapsuleComponent.h", importcpp.} = object of UShapeComponent
  USphereComponent* {.header: "Components/SphereComponents.h", importcpp.} = object of UShapeComponent

  UMeshComponent* {.header: "Components/MeshComponent.h", importcpp.} = object of UPrimitiveComponent
  UStaticMeshComponent* {.header: "Components/StaticMeshComponent.h", importcpp.} = object of UMeshComponent

  UBillboardComponent* {.header: "Components/BillboardComponent.h", importcpp.} = object of UPrimitiveComponent

  UBrushComponent* {.header: "Components/BrushComponent.h", importcpp.} = object of UPrimitiveComponent

  UPathFollowingComponent {.header: "Navigation/PathFollowingComponent.h", importcpp.} = object of UActorComponent

  UMovementComponent* {.header: "Components/MovementComponent.h", importcpp.} = object of UActorComponent
  UNavMovementComponent* {.header: "GameFramework/NavMovementComponent.h", importcpp.} = object of UMovementComponent
  UPawnMovementComponent* {.header: "GameFramework/PawnMovementComponent.h", importcpp.} = object of UNavMovementComponent
