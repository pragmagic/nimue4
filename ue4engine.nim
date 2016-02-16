# Copyright 2016 Xored Software, Inc.

type
  EForceInit {.header: "CoreMiscDefines.h", importcpp: "EForceInit".} = enum
    ForceInit,
    ForceInitToZero

  ENoInit {.header: "CoreMiscDefines.h", importcpp: "ENoInit".} = enum
    NoInit

include "modules/containers/array"
include "modules/containers/map"
include "modules/containers/set"
include modules/containers/enumasbyte
include modules/containers/weakptr
include modules/containers/sharedptr

include modules/strings
include modules/math

include modules/misc

type
  FOutputDevice* {.header: "Misc/OutputDevice.h", importcpp: "FOutputDevice".} = object
  FArchive* {.header: "Serialization/ArchiveBase.h", importcpp: "FArchive".} = object

# Have to declare many types here, because Nim doesn't support forward declaration
# and UE types have lots of inter-dependencies
type
  UObject* {.header: "UObject/UObject.h", importcpp: "UWorld", inheritable.} = object

  UProperty* {.header: "UObject/UnrealTypes.h", importcpp: "UProperty".} = object of UObject
  UClass* {.header: "UObject/Class.h", importcpp: "UClass".} = object of UObject
  UField* {.header: "UObject/Class.h", importcpp: "UField".} = object of UObject
  UStruct* {.header: "UObject/Class.h", importcpp: "UStruct".} = object of UField
  UFunction* {.header: "UObject/Class.h", importcpp: "UFunction".} = object of UStruct
  UInterface* {.header: "Interface.h", importcpp: "UInterface".} = object of UObject

  UCanvas* {.header: "Engine/Canvas.h", importcpp: "UCanvas".} = object of UObject
  UWorld* {.header: "Engine/World.h", importcpp: "UWorld".} = object of UObject
    bWorldWasLoadedThisTick*: bool
    bTriggerPostLoadMap*: bool
  ULevel* {.header: "Engine/Level.h", importcpp: "ULevel".} = object of UObject
  UGameInstance* {.header: "Engine/GameInstance.h", importcpp: "UGameInstance".} = object of UObject

  ULevelStreaming* {.header: "Engine/LevelStreaming.h", importcpp: "ULevelStreaming".} = object of UObject

  UPlayerInput* {.header: "GameFramework/PlayerInput.h", importcpp: "UPlayerInput".} = object of UObject

  # TODO: move out
  FLatentActionInfo* {.header: "Engine/LatentActionManager.h", importcpp: "FLatentActionInfo".} = object
  FActiveHapticFeedbackEffect* {.header: "GameFramework/HapticFeedbackEffect.h",
                                 importcpp: "FActiveForceFeedbackEffect".} = object
  UHapticFeedbackEffect* {.header: "GameFramework/HapticFeedbackEffect.h",
                           importcpp: "UHapticFeedbackEffect".} = object of UObject
  FActiveForceFeedbackEffect* {.header: "GameFramework/ForceFeedbackEffect.h",
                                importcpp: "FActiveForceFeedbackEffect".} = object
  UForceFeedbackEffect* {.header: "GameFramework/ForceFeedbackEffect.h",
                          importcpp: "UForceFeedbackEffect".} = object of UObject
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


include modules/containers/subclassof

include modules/enginetypes
include modules/components/actor
include modules/components/scene
include modules/components/primitive
include modules/components/shape
include modules/components/input
include modules/components/capsule
include modules/components/billboard
include modules/components/pathfollowing

include modules/ai/navigationtypes

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

  AInfo* {.header: "GameFramework/Info.h", importcpp: "AInfo".} = object of AActor
  AWorldSettings* {.header: "GameFramework/WorldSettings.h", importcpp.} = object of AInfo
  AGameMode* {.header: "GameFramework/GameMode.h", importcpp.} = object of AInfo

  AMatineeActor* {.header: "GameFramework/MatineeActor.h", importcpp.} = object of AActor

  APlayerState* {.header: "GameFramework/PlayerState.h", importcpp.} = object of AInfo

  AHUD* {.header: "GameFramework/HUD.h", importcpp: "AHUD".} = object of AActor

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

include "modules/core/object"

include modules/input/inputcoretypes

include modules/camera/types
include modules/camera/anim
include modules/camera/shake

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

include modules/physics/types

include modules/actor

# include modules/pawn
# include modules/character
# include modules/matineeactor

# include modules/hud

include modules/info
include modules/localmessage
include modules/playerstate
include modules/controller
include modules/playercontroller

proc setupInputComponent*(controller: ptr APlayerController) {.header: "GameFramework/PlayerController.h", importcpp: "#.SetupInputComponent(@)", nodecl.}
proc playerTick*(controller: ptr APlayerController) {.header: "GameFramework/PlayerController.h", importcpp: "#.SetupInputComponent(@)", nodecl.}
proc getPawn*(controller: ptr APlayerController): ptr APawn {.header: "GameFramework/PlayerController.h", importcpp: "#.GetPawn(@)", nodecl.}
proc getHitResultUnderCursor*(controller: ptr APlayerController, collChannel: ECollisionChannel, bTraceComplex: bool, hitResult: var FHitResult): bool {.
  header: "GameFramework/PlayerController.h", importcpp: "#.GetHitResultUnderCursor(@)", nodecl, discardable.}
proc getHitResultAtScreenPosition*(controller: ptr APlayerController, location: FVector2D, collChannel: ECollisionChannel, bTraceComplex: bool, hitResult: var FHitResult): bool {.
  header: "GameFramework/PlayerController.h", importcpp: "#.GetHitResultAtScreenPosition(@)", nodecl, discardable.}
proc setNewMoveDestination*(controller: ptr APlayerController, dest: FVector) {.header: "GameFramework/PlayerController.h", importcpp: "#.SetNewMoveDestination(@)", nodecl.}
proc getWorld*(controller: ptr APlayerController): ptr UWorld {.header: "GameFramework/PlayerController.h", importcpp: "#.GetWorld(@)", nodecl.}

proc initCapsuleSize*(capsule: ptr UCapsuleComponent, inRadius: float32, inHalfHeight: float32) {.
  header: "Components/CapsuleComponent.h", importcpp: "#.SetCapsuleSize(@)", nodecl.}

template bindAction*[T](inputComp: ptr UInputComponent, action: static[string], event: EInputEvent, objPtr: T, callback: proc(t: T)) =
  {.emit: "$#->BindAction(`$#`, `$#`::$#, `$#`, & $#::$#);".format(
            expandObjReference(astToStr(inputComp)), astToStr(action), type(event).name, astToStr(event),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

template bindTouch*[T](inputComp: ptr UInputComponent, event: EInputEvent, objPtr: T, callback: proc(t: T, fingerIndex: ETouchIndex, loc: FVector)) =
  {.emit: "$#->BindTouch(`$#`::$#, `$#`, & $#::$#);".format(
            expandObjReference(astToStr(inputComp)), type(event).name, astToStr(event),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

proc getActorLocation*(pawn: ptr APawn): FVector {.header: "GameFramework/Pawn.h", importcpp: "#.GetActorLocation(@)", nodecl.}

proc dist*(vector, other: FVector): float32 {.header: "Math/Vector.h", importcpp: "'1::Dist(@)", nodecl.}

proc getNavigationSystem*(world: ptr UWorld): ptr UNavigationSystem {.header: "Engine/World.h", importcpp: "#.GetNavigationSystem(@)", nodecl.}

proc simpleMoveToLocation*(navSys: ptr UNavigationSystem, controller: ptr APlayerController, goal: FVector) {.header: "AI/Navigation/NavigationSystem.h", importcpp: "#.SimpleMoveToLocation(@)", nodecl.}

proc to2D*(v: FVector): FVector2D {.header: "Math/Vector2D.h", importcpp: "'0(@)", constructor.}