# Copyright 2016 Xored Software, Inc.

type
  EForceInit {.header: "CoreMiscDefines.h", importcpp: "EForceInit".} = enum
    ForceInit,
    ForceInitToZero

  ENoInit {.header: "CoreMiscDefines.h", importcpp: "ENoInit".} = enum
    NoInit

const INDEX_NONE = -1

converter intToInt32*(i: int): int32 =
  ## to avoid casting all the time when working with Nim arrays/seqs
  result = int32(i)

proc cnew*[T](): ptr T {.importcpp: "(new '*0#@)", nodecl.}

include "modules/containers/array"
include "modules/containers/map"
include "modules/containers/set"
include modules/containers/enumasbyte
include modules/containers/weakptr
include modules/containers/sharedptr

include modules/strings
include modules/math
include modules/logging

type
  FOutputDevice* {.header: "Misc/OutputDevice.h", importcpp, inheritable.} = object
  FOutputDeviceRedirector {.header: "HAL/OutputDevices.h", importcpp.} = object of FOutputDevice
  FExec* {.header: "Misc/OutputDevice.h", importcpp, inheritable.} = object
  FAudioDevice* {.header: "AudoDevice.h", importcpp.} = object of FExec

  FArchive* {.header: "Serialization/ArchiveBase.h", importcpp.} = object
  FSceneInterface* {.header: "SceneInterface.h", importcpp.} = object
  FReferenceCollector* {.header: "UObject/UObjectGlobals.h", importcpp.} = object

# Have to declare many types here, because Nim doesn't support forward declaration
# and UE types have lots of inter-dependencies
type
  UObject* {.header: "UObject/UObject.h", importcpp, inheritable.} = object
  UPackage* {.header: "UObject/CoreObject.h", importcpp.} = object of UObject

  UProperty* {.header: "UObject/UnrealTypes.h", importcpp.} = object of UObject
  UClass* {.header: "UObject/Class.h", importcpp.} = object of UObject
  UField* {.header: "UObject/Class.h", importcpp.} = object of UObject
  UStruct* {.header: "UObject/Class.h", importcpp.} = object of UField
  UFunction* {.header: "UObject/Class.h", importcpp.} = object of UStruct
  UInterface* {.header: "Interface.h", importcpp.} = object of UObject

  UGameViewportClient* {.header: "Engine/GameViewportClient.h", importcpp.} = object of UObject

  IEngineLoop* {.header: "UnrealEngine.h", importcpp.} = object
  UEngine* {.header: "Engine/Engine.h", importcpp.} = object of UObject
    bSmoothFrameRate: bool
    smoothedFrameRateRange {.importcpp: "SmoothedFrameRateRange".}: FFloatRange
    bUseFixedFrameRate: bool
    fixedFrameRate {.importcpp: "FixedFrameRate".}: cfloat
    gameViewport {.importcpp: "GameViewport".}: ptr UGameViewportClient

  UGameEngine* {.header: "Engine/GameEngine.h", importcpp.} = object of UEngine

  UGameplayTagsManager* {.header: "GameplayTagsManager.h", importcpp.} = object of UObject

  UCanvas* {.header: "Engine/Canvas.h", importcpp.} = object of UObject
  UWorld* {.header: "Engine/World.h", importcpp.} = object of UObject
    bWorldWasLoadedThisTick*: bool
    bTriggerPostLoadMap*: bool
  ULevel* {.header: "Engine/Level.h", importcpp.} = object of UObject
  UGameInstance* {.header: "Engine/GameInstance.h", importcpp.} = object of UObject

  UModel* {.header: "Engine/Model.h", importcpp.} = object of UObject

  ULevelStreaming* {.header: "Engine/LevelStreaming.h", importcpp.} = object of UObject

  # TODO: move out
  FLatentActionInfo* {.header: "Engine/LatentActionManager.h", importcpp.} = object
  FActiveHapticFeedbackEffect* {.header: "GameFramework/HapticFeedbackEffect.h",
                                 importcpp.} = object
  UHapticFeedbackEffect* {.header: "GameFramework/HapticFeedbackEffect.h",
                           importcpp: "UHapticFeedbackEffect".} = object of UObject
  FActiveForceFeedbackEffect* {.header: "GameFramework/ForceFeedbackEffect.h",
                                importcpp.} = object
  UForceFeedbackEffect* {.header: "GameFramework/ForceFeedbackEffect.h",
                          importcpp.} = object of UObject
  FPlayerMuteList* {.header: "GameFramework/PlayerMuteList.h", importcpp.} = object

  UNavigationSystem* {.header: "AI/Navigation/NavigationSystem.h", importcpp.} = object of UObject
  UNavArea* {.header: "AI/Navigation/NavAreas/NavArea.h", importcpp.} = object of UObject
  UAISystemBase* {.header: "AI/AISystemBase.h", importcpp.} = object of UObject
  UAvoidanceManager* {.header :"AI/Navigation/AvoidanceManager.h", importcpp.} = object of UObject
  UNavigationDataChunk* {.header: "AI/Navigation/NavigationDataChunk.h", importcpp.} = object of UObject

  UBodySetup* {.header: "PhysicsEngine/BodySetup.h", importcpp.} = object of UObject
  UPhysicsCollisionHandler* {.header: "PhysicsEngine/PhysicsCollisionHandler.h", importcpp.} = object of UObject

  UDamageType* {.header: "GameFramework/DamageType.h", importcpp.} = object of UObject
    bCausedByWorld: bool
      ## True if this damagetype is caused by the world (falling off level, into lava, etc).
    bScaleMomentumByMass: bool
      ## True to scale imparted momentum by the receiving pawn's mass for pawns using character movement
    damageImpulse {.importcpp: "DamageImpulse".}: cfloat
      ## The magnitude of impulse to apply to the Actors damaged by this type.
    bRadialDamageVelChange: bool
      ## When applying radial impulses, whether to treat as impulse or velocity change.
    destructibleImpulse {.importcpp: "DestructibleImpulse".}: cfloat
      ## How large the impulse should be applied to destructible meshes
    destructibleDamageSpreadScale {.importcpp: "DestructibleDamageSpreadScale".}: cfloat
      ## How much the damage spreads on a destructible mesh
    damageFalloff {.importcpp: "DamageFalloff".}: cfloat
      ## Damage fall-off for radius damage (exponent).  Default 1.0=linear, 2.0=square of distance, etc.

  UNetDriver* {.header: "Engine/NetDriver.h", importcpp.} = object of UObject
  UDemoNetDriver* {.header: "Engine/DemoNetDriver.h", importcpp.} = object of UNetDriver

  UTexture* {.header: "Engine/Texture.h", importcpp.} = object of UObject
  UTexture2D* {.header: "Engine/Texture2D.h", importcpp.} = object of UTexture

  UInterpGroup* {.header: "Matinee/InterpGroup.h", importcpp.} = object of UObject
  UInterpTrackInst* {.header: "Matinee/InterpTrackInst.h", importcpp.} = object of UObject
  UInterpTrackInstDirector* {.header: "Matinee/InterpTrackInstDirector.h", importcpp.} = object of UInterpTrackInst

  UCheatManager* {.header: "GameFramework/CheatManager.h", importcpp.} = object of UObject

  UMaterialInterface* {.header: "Materials/MaterialInterface.h", importcpp.} = object of UObject
  UMaterialInstance* {.header: "Materials/MaterialInstance.h", importcpp.} = object of UMaterialInterface
  UMaterialInstanceDynamic* {.header: "Materials/MaterialInstanceDynamic.h", importcpp.} = object of UMaterialInstance
  UMaterialParameterCollectionInstance* {.header: "Materials/MaterialParameterCollectionInstance.h", importcpp.} = object of UObject
  UMaterialParameterCollection* {.header: "Materials/MaterialParameterCollection.h", importcpp.} = object of UObject

  UBlueprintCore* {.header: "Engine/BlueprintCore.h", importcpp.} = object of UObject
  UBlueprint* {.header: "Engine/Blueprint.h", importcpp.} = object of UBlueprintCore
  ULevelScriptBlueprint* {.header: "Engine/LevelScriptBlueprint.h", importcpp.} = object of UBlueprint

  FPostProcessSettings* {.header: "Scene.h", importcpp.} = object

  UStaticMesh* {.header: "Engine/StaticMesh.h", importcpp.} = object of UObject

  FRootMotionMovementParams* {.header: "Animation/AnimationAsset.h", importcpp.} = object
    bHasRootMotion*: bool
    blendWeight* {.importcpp: "BlendWeight".}: cfloat
    rootMotionTransform* {.importcpp: "RootMotionTransform".}: FTransform

  UAnimationAsset* {.header: "Animation/AnimationAsset.h", importcpp.} = object of UObject
  UAnimSequenceBase* {.header: "Animation/AnimSequenceBase.h", importcpp.} = object of UAnimationAsset
  UAnimCompositeBase* {.header: "Animation/AnimCompositeBase.h", importcpp.} = object of UAnimSequenceBase
  UAnimMontage* {.header: "Animation/AnimMontage.h", importcpp.} = object of UAnimCompositeBase
  FAnimMontageInstance* {.header: "Animation/AnimMontage.h", importcpp.} = object

include modules/misc
include modules/paths

include modules/components/componentdecls
include modules/engine/texture

type
  AActor* {.header: "GameFramework/Actor.h", importcpp.} = object of UObject
    inputComponent {.importcpp: "InputComponent".}: ptr UInputComponent
      ## Component that handles input for this actor, if input is enabled.

  APawn* {.header: "GameFramework/Pawn.h", importcpp.} = object of AActor
  ADefaultPawn* {.header: "GameFramework/DefaultPawn.h", importcpp.} = object of APawn
  ASpectatorPawn* {.header: "GameFramework/SpectatorPawn.h", importcpp.} = object of ADefaultPawn
  ACharacter* {.header: "GameFramework/Character.h", importcpp.} = object of APawn

  AController* {.header: "GameFramework/Controller.h", importcpp.} = object of AActor
  APlayerController* {.header: "GameFramework/PlayerController.h", importcpp.} = object of AController
    # bShowMouseCursor: bool
    # defaultMouseCursor {.importcpp: "DefaultMouseCursor".}: EMouseCursor
    # currentClickTraceChannel {.importcpp: "CurrentClickTraceChannel".}: ECollisionChannel
    # inputComponent {.importcpp: "InputComponent".}: ptr UInputComponent

  AInfo* {.header: "GameFramework/Info.h", importcpp.} = object of AActor
  AGameSession* {.header: "GameFramework/GameSession.h", importcpp.} = object of AInfo
    ## Acts as a game-specific wrapper around the session interface.
    ## The game code makes calls to this when it needs to interact with the session interface.
    ## A game session exists only the server, while running an online game.
  AGameState* {.header: "GameFramework/GameState.h", importcpp.} = object of AInfo
    ## GameState is replicated and is valid on servers and clients.
  AWorldSettings* {.header: "GameFramework/WorldSettings.h", importcpp.} = object of AInfo
  AGameMode* {.header: "GameFramework/GameMode.h", importcpp.} = object of AInfo
  APlayerState* {.header: "GameFramework/PlayerState.h", importcpp.} = object of AInfo
  AGameNetworkManager* {.header: "GameFramework/GameNetworkManager.h", importcpp.} = object of AInfo

  AMatineeActor* {.header: "GameFramework/MatineeActor.h", importcpp.} = object of AActor

  AHUD* {.header: "GameFramework/HUD.h", importcpp.} = object of AActor

  ALevelScriptActor* {.header: "Engine/LevelScriptActor.h", importcpp.} = object of AActor
  ALevelBounds* {.header: "Engine/LevelBounds.h", importcpp.} = object of AActor

  ANavigationObjectBase* {.header: "NavigationObjectBase.h", importcpp.} = object of AActor

  # TODO: move out
  EViewTargetBlendFunction* {.header: "Camera/PlayerCameraManager.h", importcpp, size: sizeof(cint).} = enum
    ## Options that define how to blend when changing view targets.
    ## @see FViewTargetTransitionParams, SetViewTarget
    VTBlend_Linear,
      ## Camera does a simple linear interpolation.
    VTBlend_Cubic,
      ## Camera has a slight ease in and ease out, but amount of ease cannot be tweaked.
    VTBlend_EaseIn,
      ## Camera immediately accelerates, but smoothly decelerates into the target.  Ease amount controlled by BlendExp.
    VTBlend_EaseOut,
      ## Camera smoothly accelerates, but does not decelerate into the target.  Ease amount controlled by BlendExp.
    VTBlend_EaseInOut,
      ## Camera smoothly accelerates and decelerates.  Ease amount controlled by BlendExp.
    VTBlend_MAX,

  FViewTargetTransitionParams* {.header: "Camera/PlayerCameraManager.h", importcpp.} = object
  APlayerCameraManager* {.header: "Camera/PlayerCameraManager.h", importcpp.} = object of AActor
    PCOwner*: ptr APlayerController
  ACameraActor* {.header: "Camera/CameraActor.h", importcpp.} = object of AActor

  AEmitter* {.header: "Particles/Emitter.h", importcpp.} = object of AActor
  AEmitterCameraLensEffectBase* {.header: "Particles/EmitterCameraLensEffectBase.h", importcpp.} = object of AEmitter
  AParticleEventManager* {.header: "Particles/ParticleEventManager.h", importcpp.} = object of AActor

  AInstancedFoliageActor* {.header: "InstancedFoliageActor.h", importcpp.} = object of AActor

include modules/core/globals

include modules/engine/engine

include modules/containers/subclassof

include modules/enginetypes
include modules/physics/types
include modules/input/inputcoretypes

include modules/components/actor
include modules/components/input

include modules/components/primitive
include modules/components/drawfrustum
include modules/components/brush
include modules/components/shape
include modules/components/capsule
include modules/components/billboard

include modules/components/pathfollowing

include modules/ai/navigationtypes

include modules/engine/brush
include modules/engine/volume
include modules/engine/physicsvolume

type
  AAudioVolume* {.header: "Sound/AudioVolume.h", importcpp.} = object of AVolume
    priority {.importcpp: "Priority".}: cfloat
    bEnabled: bool

  UReverbEffect* {.header: "Sound/ReverbEffect.h", importcpp.} = object of UObject
    density* {.importcpp: "Density".}: cfloat
      ## Density - 0.0 < 1.0 < 1.0 - Coloration of the late reverb - lower value is more
      ## UPROPERTY(Category=ReverbParameters, meta=(ClampMin = "0.0", ClampMax = "1.0"), EditAnywhere)
    diffusion* {.importcpp: "Diffusion".}: cfloat
      ## Diffusion - 0.0 < 1.0 < 1.0 - Echo density in the reverberation decay - lower is more grainy
      ## UPROPERTY(Category=ReverbParameters, meta=(ClampMin = "0.0", ClampMax = "1.0"), EditAnywhere)
    gain* {.importcpp: "Gain".}: cfloat
      ## Reverb Gain - 0.0 < 0.32 < 1.0 - overall reverb gain - master volume control
      ## UPROPERTY(Category=ReverbParameters, meta=(ClampMin = "0.0", ClampMax = "1.0"), EditAnywhere)
    gainHF* {.importcpp: "GainHF".}: cfloat
      ## Reverb Gain High Frequency - 0.0 < 0.89 < 1.0 - attenuates the high frequency reflected sound
      ## UPROPERTY(Category=ReverbParameters, meta=(ClampMin = "0.0", ClampMax = "1.0"), EditAnywhere)
    decayTime* {.importcpp: "DecayTime".}: cfloat
      ## Decay Time - 0.1 < 1.49 < 20.0 Seconds - larger is more reverb
      ## UPROPERTY(Category=ReverbParameters, meta=(ClampMin = "0.1", ClampMax = "20.0"), EditAnywhere)
    decayHFRatio* {.importcpp: "DecayHFRatio".}: cfloat
      ## Decay High Frequency Ratio - 0.1 < 0.83 < 2.0 - how much the quicker or slower the high frequencies decay relative to the lower frequencies.
      ## UPROPERTY(Category=ReverbParameters, meta=(ClampMin = "0.1", ClampMax = "2.0"), EditAnywhere)
    reflectionsGain* {.importcpp: "ReflectionsGain".}: cfloat
      ## Reflections Gain - 0.0 < 0.05 < 3.16 - controls the amount of initial reflections
      ## UPROPERTY(Category=ReverbParameters, meta=(ClampMin = "0.0", ClampMax = "3.16"), EditAnywhere)
    reflectionsDelay* {.importcpp: "ReflectionsDelay".}: cfloat
      ## Reflections Delay - 0.0 < 0.007 < 0.3 Seconds - the time between the listener receiving the direct path sound and the first reflection
      ## UPROPERTY(Category=ReverbParameters, meta=(ClampMin = "0.0", ClampMax = "0.3"), EditAnywhere)
    lateGain* {.importcpp: "LateGain".}: cfloat
      ## Late Reverb Gain - 0.0 < 1.26 < 10.0 - gain of the late reverb
      ## UPROPERTY(Category=ReverbParameters, meta=(ClampMin = "0.0", ClampMax = "10.0"), EditAnywhere)
    lateDelay* {.importcpp: "LateDelay".}: cfloat
      ## Late Reverb Delay - 0.0 < 0.011 < 0.1 Seconds - time difference between late reverb and first reflections
      ## UPROPERTY(Category=ReverbParameters, meta=(ClampMin = "0.0", ClampMax = "0.1"), EditAnywhere)
    airAbsorptionGainHF* {.importcpp: "AirAbsorptionGainHF".}: cfloat
      ## Air Absorption - 0.892 < 0.994 < 1.0 - lower value means more absorption
      ## UPROPERTY(Category=ReverbParameters, meta=(ClampMin = "0.892", ClampMax = "1.0"), EditAnywhere)
    roomRolloffFactor* {.importcpp: "RoomRolloffFactor".}: cfloat
      ## Room Rolloff - 0.0 < 0.0 < 10.0 - multiplies the attenuation due to distance
      ## UPROPERTY(Category=ReverbParameters, meta=(ClampMin = "0.0", ClampMax = "10.0"), EditAnywhere)

  FReverbSettings* {.header: "Sound/AudioVolume.h", importcpp.} = object
    bApplyReverb*: bool
      ## Whether to apply the reverb settings below.
    reverbEffect* {.importcpp: "ReverbEffect".}: ptr UReverbEffect
      ## The reverb asset to employ.
    volume* {.importcpp: "Volume".}: cfloat
      ## Volume level of the reverb affect.
    fadeTime* {.importcpp: "FadeTime".}: cfloat
      ## Time to fade from the current reverb settings into this setting, in seconds.

  FInteriorSettings* {.header: "Sound/AudioVolume.h", importcpp.} = object
    bIsWorldSettings*: bool
      ## Whether these interior settings are the default values for the world
    exteriorVolume* {.importcpp: "ExteriorVolume".}: cfloat
      ## The desired volume of sounds outside the volume when the player is inside the volume
    exteriorTime* {.importcpp: "ExteriorTime".}: cfloat
      ## The time over which to interpolate from the current volume to the desired volume of sounds outside the volume when the player enters the volume
    exteriorLPF* {.importcpp: "ExteriorLPF".}: cfloat
      ## The desired LPF frequency cutoff in hertz of sounds outside the volume when the player is inside the volume
    exteriorLPFTime* {.importcpp: "ExteriorLPFTime".}: cfloat
      ## The time over which to interpolate from the current LPF to the desired LPF of sounds outside the volume when the player enters the volume
    interiorVolume* {.importcpp: "InteriorVolume".}: cfloat
      ## The desired volume of sounds inside the volume when the player is outside the volume
    interiorTime* {.importcpp: "InteriorTime".}: cfloat
      ## The time over which to interpolate from the current volume to the desired volume of sounds inside the volume when the player enters the volume
    interiorLPF* {.importcpp: "InteriorLPF".}: cfloat
      ## The desired LPF frequency cutoff in hertz of sounds inside  the volume when the player is outside the volume
    interiorLPFTime* {.importcpp: "InteriorLPFTime".}: cfloat
      ## The time over which to interpolate from the current LPF to the desired LPF of sounds inside the volume when the player enters the volume

include modules/components/scene
include modules/components/springarm

include modules/components/movement
include modules/components/navmovement
include modules/components/pawnmovement

include modules/components/pawnnoiseemitter

include "modules/core/object"

include modules/playerinput

include modules/camera/types
include modules/camera/anim
include modules/camera/shake
include modules/components/camera

include modules/sound/base

include modules/net/connection
include modules/net/nettypes

include modules/touchinterface

# include modules/core/canvas

include modules/core/player
include modules/core/timermanager
include modules/core/hal/genericplatformfile
include modules/core/hal/platformfilemanager

include modules/actor

include modules/pawn
include modules/defaultpawn
include modules/spectatorpawn
include modules/character
# include modules/matineeactor

include modules/info
include modules/gamemode
include modules/playerstate
include modules/gamestate

include modules/controller
include modules/playercontroller

include modules/level
include modules/world

include modules/engine/hud

include modules/umg/widgets

proc simpleMoveToLocation*(navSys: ptr UNavigationSystem, controller: ptr APlayerController, goal: FVector) {.header: "AI/Navigation/NavigationSystem.h", importcpp: "#.SimpleMoveToLocation(@)", nodecl.}
