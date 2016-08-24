# Copyright 2016 Xored Software, Inc.

## PlayerInput
## Object within PlayerController that manages player input.
## Only spawned on client.

const theHeader = "GameFramework/PlayerInput.h"

wclass(FKeyBind, header: theHeader):
  ## Struct containing mappings for legacy method of binding keys to exec commands.
  var key: FKey ## The key to be bound to the command
  var command: FString ## The command to execute when the key is pressed/released
  var control: bool ## Whether the control key needs to be held when the key event occurs
  var shift: bool ## Whether the shift key needs to be held when the key event occurs
  var alt: bool ## Whether the alt key needs to be held when the key event occurs
  var cmd: bool ## Whether the command key needs to be held when the key event occurs
  var bIgnoreCtrl: bool ## Whether the control key must not be held when the key event occurs
  var bIgnoreShift: bool ## Whether the shift key must not be held when the key event occurs
  var bIgnoreAlt: bool ## Whether the alt key must not be held when the key event occurs
  var bIgnoreCmd: bool ## Whether the command key must not be held when the key event occurs

  proc makeFKeyBind(): FKeyBind {.constructor.}

wclass(FInputAxisProperties, header: theHeader):
  ## Configurable properties for control axes, used to transform raw input into game ready values.
  var deadZone: cfloat ## What the dead zone of the axis is.  For control axes such as analog sticks.
  var sensitivity: cfloat  ## Scaling factor to multiply raw value by.
  var exponent: cfloat ## For applying curves to [0..1] axes, e.g. analog sticks
  var bInvert: bool ## Inverts reported values for this axis

  proc makeFInputAxisProperties(): FInputAxisProperties {.constructor.}

wclass(FInputAxisConfigEntry, header: theHeader):
  ## Configurable properties for control axes.
  var axisKeyName: FName ## Axis Key these properties apply to
  var axisProperties: FInputAxisProperties ## Properties for the Axis Key

wclass(FInputActionKeyMapping, header: theHeader):
  ##  Defines a mapping between an action and key
  ##
  ##  @see https://docs.unrealengine.com/latest/INT/Gameplay/Input/index.html
  var actionName: FName
    ## Friendly name of action, e.g "jump"
  var key: FKey
    ## Key to bind it to.
  var bShift: bool
    ## true if one of the Shift keys must be down when the KeyEvent is received to be acknowledged
  var bCtrl: bool
    ## true if one of the Ctrl keys must be down when the KeyEvent is received to be acknowledged
  var bAlt: bool
    ## true if one of the Alt keys must be down when the KeyEvent is received to be acknowledged
  var bCmd: bool
    ## true if one of the Cmd keys must be down when the KeyEvent is received to be acknowledged

  proc `==`(other: FInputActionKeyMapping): bool {.noSideEffect.}
  proc `<`(other: FInputActionKeyMapping): bool {.noSideEffect.}

  proc makeFInputActionKeyMapping(inActionName: FName = NAME_None;
                                  inKey: FKey = EKeys.Invalid; bInShift: bool = false;
                                  bInCtrl: bool = false; bInAlt: bool = false;
                                  bInCmd: bool = false): FInputActionKeyMapping {.constructor.}

wclass(FInputAxisKeyMapping, header: theHeader):
  ##  Defines a mapping between an axis and key
  ##
  ##  @see https://docs.unrealengine.com/latest/INT/Gameplay/Input/index.html

  var axisName: FName ## Friendly name of axis, e.g "MoveForward"
  var key: FKey ## Key to bind it to.
  var scale: cfloat ## Multiplier to use for the mapping when accumulating the axis value

  proc `==`(other: FInputAxisKeyMapping): bool {.noSideEffect.}
  proc `<`(other: FInputAxisKeyMapping): bool {.noSideEffect.}
  proc makeFInputAxisKeyMapping(inAxisName: FName = NAME_None;
                                inKey: FKey = EKeys.Invalid; inScale: cfloat = 1.0): FInputAxisKeyMapping {.constructor.}

wclass(UPlayerInput of UObject, header: theHeader):
  ## Object within PlayerController that processes player input.
  ## Only exists on the client in network games.
  ##
  ## @see https://docs.unrealengine.com/latest/INT/Gameplay/Input/index.html
  ## UCLASS(Within=PlayerController, config=Input, transient)

  var touches: array[11, FVector]
    ## NOTE: These touch vectors are calculated and set directly, they do not go through the .ini Bindings
    ## Touch locations, from 0..1 (0,0 is top left, 1,1 is bottom right), the Z component is > 0 if the touch is currently held down
    ## @todo: We have 10 touches to match the number of Touch* entries in EKeys (not easy to make this an enum or define or anything)
  var touchEventLocations: TMap[uint32, FVector]
    ## Used to store paired touch locations for event ids during the frame and flushed when processed.
  var zeroTime: array[2, cfloat]
    ## Mouse smoothing sample data
  var smoothedMouse: array[2, cfloat]
    ## How long received mouse movement has been zero.
  var mouseSamples: int32
    ## Current average mouse movement/sample
  var mouseSamplingTotal: cfloat
    ## Number of mouse samples since mouse movement has been zero
  var debugExecBindings: TArray[FKeyBind]
    ## DirectInput's mouse sampling total time
    ## Generic bindings of keys to Exec()-compatible strings for development purposes only
  var axisConfig: TArray[FInputAxisConfigEntry]
    ## This player's version of the Axis Properties
  var actionMappings: TArray[FInputActionKeyMapping]
    ## This player's version of the Action Mappings
  var axisMappings: TArray[FInputAxisKeyMapping]
    ## This player's version of Axis Mappings
  var invertedAxis: TArray[FName]
    ## List of Axis Mappings that have been inverted

  proc constructUPlayerInput(): UPlayerInput {.constructor.}

  proc getAxisProperties(axisKey: FKey;
                         axisProperties: var FInputAxisProperties): bool

  proc setAxisProperties(axisKey: FKey;
                         axisProperties: FInputAxisProperties)

  proc setMouseSensitivity(sensitivity: cfloat)

  proc setBind(bindName: FName; command: FString)

  proc getMouseSensitivity(): cfloat

  proc getInvertAxisKey(axisKey: FKey): bool

  proc getInvertAxis(axisName: FName): bool

  proc invertAxisKey(axisKey: FKey)

  proc invertAxis(axisName: FName)

  proc clearSmoothing()

  proc addActionMapping(keyMapping: FInputActionKeyMapping)

  proc removeActionMapping(keyMapping: FInputActionKeyMapping)

  proc addAxisMapping(keyMapping: FInputAxisKeyMapping)

  proc removeAxisMapping(keyMapping: FInputAxisKeyMapping)

  proc addEngineDefinedActionMapping(actionMapping: FInputActionKeyMapping)

  proc addEngineDefinedAxisMapping(axisMapping: FInputAxisKeyMapping)

  proc forceRebuildingKeyMaps(bRestoreDefaults: bool = false)

  method postInitProperties()

  method getWorld(): ptr UWorld {.noSideEffect.}

  proc flushPressedKeys()

  proc inputKey(key: FKey; event: EInputEvent;
                amountDepressed: cfloat; bGamepad: bool): bool

  proc inputAxis(key: FKey; delta: cfloat; deltaTime: cfloat;
                 numSamples: int32; bGamepad: bool): bool

  proc inputTouch(handle: uint32; `type`: ETouchType;
                  touchLocation: FVector2D; deviceTimestamp: FDateTime;
                  touchpadIndex: uint32): bool

  proc inputMotion(tilt: FVector; rotationRate: FVector;
                   gravity: FVector; acceleration: FVector): bool

  proc inputGesture(gesture: FKey; event: EInputEvent;
                    value: cfloat): bool

  proc tick(deltaTime: cfloat)

  proc processInputStack(inputComponentStack: TArray[ptr UInputComponent];
                        deltaTime: cfloat; bGamePaused: bool)

  proc discardPlayerInput()

  proc smoothMouse(aMouse: cfloat; deltaTime: cfloat;
                   sampleCount: var uint8; index: int32): cfloat

  proc accelMouse(key: FKey; rawValue: cfloat; deltaTime: cfloat): cfloat

  proc displayDebug(canvas: ptr UCanvas;
                    debugDisplay: FDebugDisplayInfo;
                    YL, YPos: var cfloat)

  proc isPressed(inKey: FKey): bool {.noSideEffect.}

  proc wasJustPressed(inKey: FKey): bool {.noSideEffect.}

  proc wasJustReleased(inKey: FKey): bool {.noSideEffect.}

  proc getTimeDown(inKey: FKey): cfloat {.noSideEffect.}

  proc getKeyValue(inKey: FKey): cfloat {.noSideEffect.}

  proc getRawKeyValue(inKey: FKey): cfloat {.noSideEffect.}

  proc getVectorKeyValue(inKey: FKey): FVector {.noSideEffect.}

  proc isAltPressed(): bool {.noSideEffect.}

  proc isCtrlPressed(): bool {.noSideEffect.}

  proc isShiftPressed(): bool {.noSideEffect.}

  proc isCmdPressed(): bool {.noSideEffect.}

  proc exec(uInWorld: ptr UWorld; cmd: wstring;
            ar: var FOutputDevice): bool

  proc getBind(key: FKey): FString

  proc getExecBind(execCommand: FString): FKeyBind

  proc execInputCommands(inWorld: ptr UWorld; cmd: wstring;
                         ar: var FOutputDevice): bool

  proc getKeysForAction(actionName: FName): TArray[FInputActionKeyMapping]