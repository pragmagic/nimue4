# Copyright 2016 Xored Software, Inc.

include "modules/containers/array"
include "modules/containers/map"
include modules/containers/enumasbyte
include modules/containers/weakptr
include modules/strings
include modules/math

type
  FOutputDevice* {.header: "Misc/OutputDevice.h", importcpp: "FOutputDevice".} = object
  FArchive* {.header: "Serialization/ArchiveBase.h", importcpp: "FArchive".} = object

type
  UObject* {.header: "UObject/UObject.h", importcpp: "UWorld", inheritable.} = object

include modules/enginetypes
include modules/components/actor
include modules/components/scene
include modules/components/primitive
include modules/components/input
include modules/components/capsule

type
  AActor* {.header: "GameFramework/Actor.h", importcpp: "AActor", inheritable.} = object of UObject

  APawn* {.header: "GameFramework/Pawn.h", importcpp: "APawn", inheritable.} = object of AActor
  ACharacter* {.header: "GameFramework/Character.h", importcpp: "ACharacter", inheritable.} = object of APawn

  AController* {.header: "GameFramework/Controller.h", importcpp: "AController", inheritable.} = object of AActor
  APlayerController* {.header: "GameFramework/PlayerController.h", importcpp: "APlayerController", inheritable.} = object of AController
    bShowMouseCursor: bool
    defaultMouseCursor {.importcpp: "DefaultMouseCursor".}: EMouseCursor
    currentClickTraceChannel {.importcpp: "CurrentClickTraceChannel".}: ECollisionChannel
    inputComponent {.importcpp: "InputComponent".}: ptr UInputComponent

  AInfo* {.header: "GameFramework/Info.h", importcpp: "AInfo", inheritable.} = object of AActor
  AWorldSettings* {.header: "GameFramework/WorldSettings.h", importcpp: "AWorldSettings", inheritable.} = object of AInfo

  AMatineeActor* {.header: "GameFramework/MatineeActor.h", importcpp: "AMatineeActor", inheritable.} = object of AActor

  UCanvas* {.header: "Engine/Canvas.h", importcpp: "UCanvas", inheritable.} = object of UObject
  UWorld* {.header: "Engine/World.h", importcpp: "UWorld", inheritable.} = object of UObject
    bWorldWasLoadedThisTick*: bool
    bTriggerPostLoadMap*: bool
  ULevel* {.header: "Engine/Level.h", importcpp: "ULevel", inheritable.} = object of UObject
  UGameInstance* {.header: "Engine/GameInstance.h", importcpp: "UGameInstance", inheritable.} = object of UObject

  UNavigationSystem* {.header: "AI/Navigation/NavigationSystem.h", importcpp: "UNavigationSystem", inheritable.} = object of UObject

  UDamageType* {.header: "GameFramework/DamageType.h", importcpp: "UDamageType", inheritable.} = object of UObject
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

  UNetDriver* {.header: "Engine/NetDriver.h", importcpp: "UNetDriver".} = object of UObject

include "modules/core/object"

include modules/camera/types

# include modules/core/world
# include modules/core/level
# include modules/core/canvas


include modules/core/player
include modules/core/timermanager

include modules/net/connection
include modules/physics/types

include modules/actor


# include modules/pawn
# include modules/character
# include modules/matineeactor

# include modules/controller
# include modules/playercontroller

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
  # have not found a better way to interface with method pointers...
  # this approach is extremely fragile.
  # but at least it is statically checked. any suggestions are welcome!
  {.emit: "$#->BindAction(`$#`, `$#`::$#, `$#`, & $#::$#);".format(
            expandObjReference(astToStr(inputComp)), astToStr(action), type(event).name, astToStr(event),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

template bindTouch*[T](inputComp: ptr UInputComponent, event: EInputEvent, objPtr: T, callback: proc(t: T, fingerIndex: ETouchIndex, loc: FVector)) =
  # have not found a better way to interface with method pointers...
  # this approach is extremely fragile.
  # but at least it is statically checked. any suggestions are welcome!
  {.emit: "$#->BindTouch(`$#`::$#, `$#`, & $#::$#);".format(
            expandObjReference(astToStr(inputComp)), type(event).name, astToStr(event),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

proc getActorLocation*(pawn: ptr APawn): FVector {.header: "GameFramework/Pawn.h", importcpp: "#.GetActorLocation(@)", nodecl.}

proc dist*(vector, other: FVector): float32 {.header: "Math/Vector.h", importcpp: "'1::Dist(@)", nodecl.}

proc getNavigationSystem*(world: ptr UWorld): ptr UNavigationSystem {.header: "Engine/World.h", importcpp: "#.GetNavigationSystem(@)", nodecl.}

proc simpleMoveToLocation*(navSys: ptr UNavigationSystem, controller: ptr APlayerController, goal: FVector) {.header: "AI/Navigation/NavigationSystem.h", importcpp: "#.SimpleMoveToLocation(@)", nodecl.}

proc to2D*(v: FVector): FVector2D {.header: "Math/Vector2D.h", importcpp: "'0(@)", constructor.}