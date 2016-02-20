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

include "modules/containers/array"
include "modules/containers/map"
include "modules/containers/set"
include modules/containers/enumasbyte
include modules/containers/weakptr
include modules/containers/sharedptr

include modules/strings
include modules/math

type
  FOutputDevice* {.header: "Misc/OutputDevice.h", importcpp.} = object
  FArchive* {.header: "Serialization/ArchiveBase.h", importcpp.} = object

# Have to declare many types here, because Nim doesn't support forward declaration
# and UE types have lots of inter-dependencies
type
  UObject* {.header: "UObject/UObject.h", importcpp, inheritable.} = object

  UProperty* {.header: "UObject/UnrealTypes.h", importcpp.} = object of UObject
  UClass* {.header: "UObject/Class.h", importcpp.} = object of UObject
  UField* {.header: "UObject/Class.h", importcpp.} = object of UObject
  UStruct* {.header: "UObject/Class.h", importcpp.} = object of UField
  UFunction* {.header: "UObject/Class.h", importcpp.} = object of UStruct
  UInterface* {.header: "Interface.h", importcpp.} = object of UObject

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
  FPlayerMuteList* {.header: "GameFramework/PlayerMuteList.h", importcpp: "FPlayerMuteList".} = object

  UNavigationSystem* {.header: "AI/Navigation/NavigationSystem.h", importcpp: "UNavigationSystem".} = object of UObject
  UNavArea* {.header: "AI/Navigation/NavAreas/NavArea.h", importcpp: "UNavArea".} = object of UObject

  UBodySetup* {.header: "PhysicsEngine/BodySetup.h", importcpp.} = object of UObject

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

  UTexture* {.header: "Engine/Texture.h", importcpp.} = object of UObject
  UTexture2D* {.header: "Engine/Texture2D.h", importcpp.} = object of UTexture

  UInterpGroup* {.header: "Matinee/InterpGroup.h", importcpp.} = object of UObject
  UInterpTrackInst* {.header: "Matinee/InterpTrackInst.h", importcpp.} = object of UObject
  UInterpTrackInstDirector* {.header: "Matinee/InterpTrackInstDirector.h", importcpp.} = object of UInterpTrackInst

  UCheatManager* {.header: "GameFramework/CheatManager.h", importcpp.} = object of UObject

  UMaterialInterface* {.header: "Materials/MaterialInterface.h", importcpp.} = object of UObject

  FPostProcessSettings* {.header: "Scene.h", importcpp.} = object

  UStaticMesh* {.header: "Engine/StaticMesh.h", importcpp.} = object of UObject

include modules/misc

include modules/components/componentdecls

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

  AMatineeActor* {.header: "GameFramework/MatineeActor.h", importcpp.} = object of AActor

  APlayerState* {.header: "GameFramework/PlayerState.h", importcpp.} = object of AInfo

  AHUD* {.header: "GameFramework/HUD.h", importcpp.} = object of AActor

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
  ACameraActor* {.header: "Camera/CameraActor.h", importcpp.} = object of AActor

  AEmitter* {.header: "Particles/Emitter.h", importcpp.} = object of AActor
  AEmitterCameraLensEffectBase* {.header: "Particles/EmitterCameraLensEffectBase.h", importcpp.} = object of AEmitter

include modules/containers/subclassof

include modules/enginetypes
include modules/physics/types

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

include modules/components/scene
include modules/components/springarm

include modules/components/movement
include modules/components/navmovement
include modules/components/pawnmovement

include modules/components/pawnnoiseemitter

include "modules/core/object"

include modules/input/inputcoretypes

include modules/playerinput

include modules/camera/types
include modules/camera/anim
include modules/camera/shake
include modules/components/camera

include modules/sound/base

include modules/net/connection
include modules/net/nettypes
include modules/net/serialization

include modules/touchinterface

# include modules/core/world
# include modules/core/level
# include modules/core/canvas

include modules/core/player
include modules/core/timermanager

include modules/actor

include modules/pawn
include modules/defaultpawn
include modules/spectatorpawn
# include modules/character
# include modules/matineeactor

# include modules/hud

include modules/info
include modules/gamemode
include modules/playerstate

include modules/controller
include modules/playercontroller

proc getNavigationSystem*(world: ptr UWorld): ptr UNavigationSystem {.header: "Engine/World.h", importcpp: "#.GetNavigationSystem(@)", nodecl.}

proc simpleMoveToLocation*(navSys: ptr UNavigationSystem, controller: ptr APlayerController, goal: FVector) {.header: "AI/Navigation/NavigationSystem.h", importcpp: "#.SimpleMoveToLocation(@)", nodecl.}
