# Copyright 2016 Xored Software, Inc.

type
  EMeshComponentUpdateFlag* {.importcpp: "EMeshComponentUpdateFlag::Type", header: "Components/SkinnedMeshComponent.h", pure, size: sizeof(cint).} = enum
    ## Skinned Mesh Update Flag based on rendered or not.
    AlwaysTickPoseAndRefreshBones,
      ## Always Tick and Refresh BoneTransforms whether rendered or not.
    AlwaysTickPose,
      ## Always Tick, but Refresh BoneTransforms only when rendered.
    OnlyTickPoseWhenRendered
      ## Tick only when rendered, and it will only RefreshBoneTransforms when rendered.

type
  USkeletalMesh* {.header: "Engine/SkeletalMesh.h", importcpp.} = object of UObject
    bounds* {.importcpp: "Bounds".}: FBoxSphereBounds

type
  UActorComponent* {.header: "Components/ActorComponent.h", importcpp.} = object of UObject
  UPawnNoiseEmitterComponent* {.header: "Components/PawnNoiseEmitterComponent.h", importcpp.} = object of UActorComponent

  USceneComponent* {.header: "Components/SceneComponent.h", importcpp.} = object of UActorComponent
  UCameraComponent* {.header: "Camera/CameraComponent.h", importcpp.} = object of USceneComponent
  USpringArmComponent* {.header: "GameFramework/SpringArmComponent.h", importcpp.} = object of USceneComponent
  UPrimitiveComponent* {.header: "Components/PrimitiveComponent.h", importcpp.} = object of USceneComponent
  UDrawFrustumComponent* {.header: "Components/DrawFrustumComponent.h", importcpp.} = object of UPrimitiveComponent

  ULineBatchComponent* {.header: "Components/LineBatchComponent.h", importcpp.} = object of UPrimitiveComponent

  UShapeComponent* {.header: "Components/ShapeComponent.h", importcpp.} = object of UPrimitiveComponent
  UCapsuleComponent* {.header: "Components/CapsuleComponent.h", importcpp.} = object of UShapeComponent
  USphereComponent* {.header: "Components/SphereComponents.h", importcpp.} = object of UShapeComponent

  UParticleSystemComponent* {.header: "Particles/ParticleSystemComponent.h", importcpp.} = object of UPrimitiveComponent

  UMeshComponent* {.header: "Components/MeshComponent.h", importcpp.} = object of UPrimitiveComponent
  UStaticMeshComponent* {.header: "Components/StaticMeshComponent.h", importcpp.} = object of UMeshComponent
    staticMesh* {.importcpp: "StaticMesh".}: ptr UStaticMesh
  USkinnedMeshComponent* {.header: "Components/SkinnedMeshComponent.h", importcpp.} = object of UMeshComponent
    skeletalMesh* {.importcpp: "SkeletalMesh".}: ptr USkeletalMesh

    meshComponentUpdateFlag* {.importcpp: "MeshComponentUpdateFlag".}: EMeshComponentUpdateFlag
      ## This is update frequency flag even when our Owner has not been rendered recently
      ##
      ## SMU_AlwaysTickPoseAndRefreshBones,			// Always Tick and Refresh BoneTransforms whether rendered or not
      ## SMU_AlwaysTickPose,							// Always Tick, but Refresh BoneTransforms only when rendered
      ## SMU_OnlyTickPoseWhenRendered,				// Tick only when rendered, and it will only RefreshBoneTransforms when rendered
      ## UPROPERTY(EditAnywhere, AdvancedDisplay, BlueprintReadWrite, Category=SkeletalMesh)

  UModelComponent* {.header: "Components/ModelComponent.h", importcpp.} = object of UPrimitiveComponent
    ## ModelComponents are PrimitiveComponents that represent elements of BSP geometry in a ULevel object.
    ## They are used exclusively by ULevel and are not intended as general-purpose components.

  USkeletalMeshComponent* {.header: "Components/SkeletalMeshComponent.h", importcpp.} = object of USkinnedMeshComponent

  UBillboardComponent* {.header: "Components/BillboardComponent.h", importcpp.} = object of UPrimitiveComponent

  UAudioComponent* {.header: "Components/AudioComponent.h", importcpp.} = object of USceneComponent

  UBrushComponent* {.header: "Components/BrushComponent.h", importcpp.} = object of UPrimitiveComponent

  UPathFollowingComponent {.header: "Navigation/PathFollowingComponent.h", importcpp.} = object of UActorComponent

  UMovementComponent* {.header: "GameFramework/MovementComponent.h", importcpp.} = object of UActorComponent
  UNavMovementComponent* {.header: "GameFramework/NavMovementComponent.h", importcpp.} = object of UMovementComponent
  UPawnMovementComponent* {.header: "GameFramework/PawnMovementComponent.h", importcpp.} = object of UNavMovementComponent
  UCharacterMovementComponent* {.header: "GameFramework/CharacterMovementComponent.h", importcpp.} = object of UPawnMovementComponent

  ULightComponentBase* {.header: "Components/LightComponentBase.h", importcpp.}  = object of USceneComponent
  ULightComponent* {.header: "Components/LightComponent.h", importcpp.} = object of ULightComponentBase

  UArrowComponent* {.header: "Components/ArrowComponent.h", importcpp.} = object of UPrimitiveComponent

