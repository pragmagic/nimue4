# Copyright 2016 Xored Software, Inc.

type
  EFocusCause* {.importcpp, header: "SlateCore.h", size: sizeof(uint8), pure.} = enum
    ## Context for focus change
    Mouse,
      ## Focus was changed because of a mouse action.
    Navigation,
      ## Focus was changed in response to a navigation, such as the arrow keys, TAB key, controller DPad, ...
    SetDirectly,
      ## Focus was changed because someone asked the application to change it.
    Cleared,
      ## Focus was explicitly cleared via the escape key or other similar action.
    OtherWidgetLostFocus,
      ## Focus was changed because another widget lost focus, and focus moved to a new widget.
    WindowActivate
      ## Focus was set in response to the owning window being activated.

wclass(FFocusEvent, header: "SlateCore.h"):
  ## FFocusEvent is used when notifying widgets about keyboard focus changes
  ## It is passed to event handlers dealing with keyboard focus
  proc initFFocusEvent(): FFocusEvent {.constructor.}
    ## UStruct Constructor.  Not meant for normal usage.

  proc initFFocusEvent(inCause: EFocusCause, inUserIndex: uint32): FFocusEvent {.constructor.}
    ## Constructor.  Events are immutable once constructed.
    ##
    ## @param  InCause  The cause of the focus event

  proc getCause(): EFocusCause {.noSideEffect.}
    ## Queries the reason for the focus change
    ##
    ## @return  The cause of the focus change

  proc getUser(): uint32 {.noSideEffect.}
    ## Queries the user that is changing focus
    ##
    ## @return  The user that is changing focus

wclass(FVirtualPointerPosition, header: "SlateCore.h", bycopy):
  ## Represents the current and last cursor position in a "virtual window"
  ## for events that are routed to widgets transformed in a 3D scene.
  var currentCursorPosition: FVector2D
  var lastCursorPosition: FVector2D

  proc initFVirtualPointerPosition(): FVirtualPointerPosition {.constructor.}
  proc initFVirtualPointerPosition(inCurrentCursorPosition, inLastCursorPosition: FVector2D) {.constructor.}

wclass(FInputEvent, header: "SlateCore.h", bycopy):
  proc initFInputEvent(inModifierKeys: FModifierKeysState, inUserIndex: int32, bInIsRepeat: bool): FInputEvent {.constructor.}
    ## Constructor.  Events are immutable once constructed.
    ##
    ## @param  InModifierKeys  Modifier key state for this event
    ## @param  bInIsRepeat  True if this key is an auto-repeated keystroke

  proc isRepeat(): bool {.noSideEffect.}
    ## Returns whether or not this character is an auto-repeated keystroke
    ##
    ## @return  True if this character is a repeat

  proc isShiftDown(): bool {.noSideEffect.}
    ## Returns true if either shift key was down when this event occurred
    ##
    ## @return  True if shift is pressed

  proc isLeftShiftDown(): bool {.noSideEffect.}
    ## Returns true if left shift key was down when this event occurred
    ##
    ## @return True if left shift is pressed.

  proc isRightShiftDown(): bool {.noSideEffect.}
    ## Returns true if right shift key was down when this event occurred
    ##
    ## @return True if right shift is pressed.

  proc isControlDown(): bool {.noSideEffect.}
    ## Returns true if either control key was down when this event occurred
    ##
    ## @return  True if control is pressed

  proc isLeftControlDown(): bool {.noSideEffect.}
    ## Returns true if left control key was down when this event occurred
    ##
    ## @return  True if left control is pressed

  proc isRightControlDown(): bool {.noSideEffect.}
    ## Returns true if right control key was down when this event occurred
    ##
    ## @return  True if right control is pressed

  proc isAltDown(): bool {.noSideEffect.}
    ## Returns true if either alt key was down when this event occurred
    ##
    ## @return  True if alt is pressed

  proc isLeftAltDown(): bool {.noSideEffect.}
    ## Returns true if left alt key was down when this event occurred
    ##
    ## @return  True if left alt is pressed

  proc isRightAltDown(): bool {.noSideEffect.}
    ## Returns true if right alt key was down when this event occurred
    ##
    ## @return  True if right alt is pressed

  proc isCommandDown(): bool {.noSideEffect.}
    ## Returns true if either command key was down when this event occurred
    ##
    ## @return  True if command is pressed

  proc isLeftCommandDown(): bool {.noSideEffect.}
    ## Returns true if left command key was down when this event occurred
    ##
    ## @return  True if left command is pressed

  proc isRightCommandDown(): bool {.noSideEffect.}
    ## Returns true if right command key was down when this event occurred
    ##
    ## @return  True if right command is pressed

  proc areCapsLocked(): bool {.noSideEffect.}
    ## Returns true if caps lock was on when this event occurred
    ##
    ## @return True if caps lock is on

  proc getUserIndex(): uint32 {.noSideEffect.}
    ##  Returns the index of the user that generated this event.
    ##
    ##  @return The index of the user that caused the event

  proc findGeometry(widgetToFind: TSharedRef[SWidget]): FGeometry {.noSideEffect.}
    ## The event path provides additional context for handling
  proc getWindow(): TSharedRef[SWindow] {.noSideEffect.}

  proc setEventPath(inEventPath: FWidgetPath)
    ## Set the widget path along which this event will be routed
  proc getEventPath(): ptr FWidgetPath {.noSideEffect.}
  proc toText(): FText {.noSideEffect.}

  proc isPointerEvent(): bool {.noSideEffect.}
    ## Is this event a pointer event (touch or cursor).

# protected:

  var modifierKeys: FModifierKeysState
    ## State of modifier keys when this event happened.

  var userIndex: uint32
    ## The index of the user that caused the event.

  var bIsRepeat: bool
    ## True if this key was auto-repeated.

  var eventPath: ptr FWidgetPath
    ## Events are sent along paths. See (GetEventPath).

wclass(FKeyEvent of FInputEvent, header: "SlateCore.h", bycopy):
  proc initFKeyEvent(inKey: FKey,
                     inModifierKeys: FModifierKeysState,
                     inUserIndex: uint32,
                     bInIsRepeat: bool,
                     inCharacterCode: uint32,
                     inKeyCode: uint32): FKeyEvent {.constructor.}
    ## Constructor.  Events are immutable once constructed.
    ##
    ## @param  InKeyName  Character name
    ## @param  InModifierKeys  Modifier key state for this event
    ## @param  bInIsRepeat  True if this key is an auto-repeated keystroke

  proc getKey(): FKey {.noSideEffect.}
    ## Returns the name of the key for this event
    ##
    ## @return  Key name

  proc getCharacter(): uint32 {.noSideEffect.}
    ## Returns the character code for this event.
    ##
    ## @return  Character code or 0 if this event was not a character key press

  proc getKeyCode(): uint32 {.noSideEffect.}
    ## Returns the key code received from hardware before any conversion/mapping.
    ##
    ## @return  Key code received from hardware

wclass(FAnalogInputEvent of FKeyEvent, header: "SlateCore.h", bycopy):
  ## FAnalogEvent describes a analog key value.
  ## It is passed to event handlers dealing with analog keys.
  proc initFAnalogInputEvent(inKey: FKey,
                             inModifierKeys: FModifierKeysState,
                             inUserIndex: uint32,
                             bInIsRepeat: bool,
                             inCharacterCode: uint32,
                             inKeyCode: uint32,
                             inAnalogValue: float): FAnalogInputEvent {.constructor.}
    ## Constructor.  Events are immutable once constructed.
    ##
    ## @param  InKeyName  Character name
    ## @param  InModifierKeys  Modifier key state for this event
    ## @param  bInIsRepeat  True if this key is an auto-repeated keystroke

  proc getAnalogValue(): float32 {.noSideEffect.}
    ## Returns the analog value between 0 and 1.
    ## 0 being not pressed at all, 1 being fully pressed.
    ## Non analog keys will only be 0 or 1.
    ##
    ## @return Analog value between 0 and 1.  1 being fully pressed, 0 being not pressed at all

wclass(FCharacterEvent of FInputEvent, header: "SlateCore.h", bycopy):
  ## FCharacterEvent describes a keyboard action where the utf-16 code is given.  Used for OnKeyChar messages

  proc initFCharacterEvent(inCharacter: wchar, inModifierKeys: FModifierKeysState,
                           inUserIndex: uint32, bInIsRepeat: bool): FCharacterEvent {.constructor.}

  proc getCharacter(): wchar {.noSideEffect.}
    ## Returns the character for this event
    ##
    ## @return  Character

wclass(FTouchKeySet of TSet[FKey], header: "SlateCore.h", bycopy):
  ## Helper class to auto-populate a set with the set of "keys" a touch represents

  proc initFTouchKeySet(key: FKey): FTouchKeySet {.constructor.}
    ## Creates and initializes a new instance with the specified key.
    ##
    ## @param Key The key to insert into the set.

# The standard set consists of just the left mouse button key.
var standardKeySet* {.importcpp: "FTouchKeySet::StandardSet", header: "SlateCore.h".}: FTouchKeySet
# The empty set contains no valid keys.
var emptyKeySet* {.importcpp: "FTouchKeySet::EmptySet", header: "SlateCore.h".}: FTouchKeySet

wclass(FPointerEvent of FInputEvent, header: "SlateCore.h", bycopy):
  ## FPointerEvent describes a mouse or touch action (e.g. Press, Release, Move, etc).
  ## It is passed to event handlers dealing with pointer-based input.
  proc initFPointerEvent(inPointerIndex: uint32;
                         inScreenSpacePosition, inLastScreenSpacePosition: FVector2D;
                         inPressedButtons: TSet[FKey]; inEffectingButton: FKey;
                         inWheelDelta: cfloat; inModifierKeys: FModifierKeysState): FPointerEvent {.constructor.}
    ## Events are immutable once constructed.

  proc initFPointerEvent(inPointerIndex: uint32;
                         inScreenSpacePosition, inLastScreenSpacePosition, inDelta: FVector2D;
                         inPressedButtons: TSet[FKey];
                         inModifierKeys: FModifierKeysState): FPointerEvent {.constructor.}
    ## A constructor for raw mouse events

  proc initFPointerEvent(inUserIndex, inPointerIndex: uint32;
                         inScreenSpacePosition, inLastScreenSpacePosition: FVector2D;
                         bPressLeftMouseButton: bool;
                         inModifierKeys: FModifierKeysState = initFModifierKeysState();
                         inTouchpadIndex: uint32 = 0): FPointerEvent {.constructor.}
    ## A constructor for touch events

  proc initFPointerEvent(inScreenSpacePosition, inLastScreenSpacePosition: FVector2D;
                         inPressedButtons: TSet[FKey];
                         inModifierKeys: FModifierKeysState;
                         inGestureType: EGestureEvent;
                         inGestureDelta: FVector2D;
                         bInIsDirectionInvertedFromDevice: bool): FPointerEvent {.constructor.}
    ## A constructor for gesture events

  proc getScreenSpacePosition(): var FVector2D {.noSideEffect.}
    ## @return The position of the cursor in screen space

  proc getLastScreenSpacePosition(): var FVector2D {.noSideEffect.}
    ## @return The position of the cursor in screen space last time we handled an input event

  proc getCursorDelta(): FVector2D {.noSideEffect.}
    ## @return the distance the mouse traveled since the last event was handled.

  proc isMouseButtonDown(mouseButton: FKey): bool {.noSideEffect.}
    ## Mouse buttons that are currently pressed

  proc getEffectingButton(): FKey {.noSideEffect.}
    ## Mouse button that caused this event to be raised (possibly EB_None)

  proc getWheelDelta(): cfloat {.noSideEffect.}
    ## How much did the mouse wheel turn since the last mouse event

  proc getUserIndex(): int32 {.noSideEffect.}
    ## @return The index of the user that caused the event

  proc getPointerIndex(): uint32 {.noSideEffect.}
    ## @return The unique identifier of the pointer (e.g., finger index)

  proc getTouchpadIndex(): uint32 {.noSideEffect.}
    ## @return The index of the touch pad that generated this event (for platforms with multiple touch pads per user)

  proc isTouchEvent(): bool {.noSideEffect.}
    ## @return Is this event a result from a touch (as opposed to a mouse)

  proc getGestureType(): EGestureEvent {.noSideEffect.}
    ## @return The type of touch gesture

  proc getGestureDelta(): FVector2D {.noSideEffect.}
    ## @return The change in gesture value since the last gesture event of the same type.

  proc isDirectionInvertedFromDevice(): bool {.noSideEffect.}
    ## @return Is the gesture delta inverted

proc makeTranslatedPointerEvent[PointerEventT](inPointerEvent: PointerEventT;
  virtualPosition: FVirtualPointerPosition): PointerEventT {.importcpp: "FPointerEvent::MakeTranslatedEvent(@)", header: "SlateCore.h".}


wclass(FMotionEvent of FInputEvent, header: "SlateCore.h"):
  ## FMotionEvent describes a touch pad action (press, move, lift)
  ## It is passed to event handlers dealing with touch input.

  proc initFMotionEvent(
    inUserIndex: uint32;
    inTilt, inRotationRate, inGravity, inAcceleration: FVector
  ): FMotionEvent {.constructor.}

  proc getUserIndex(): uint32
    ## @return The index of the user that caused the event

  proc getTilt(): FVector
    ## @return Current tilt of the device/controller

  proc getRotationRate(): FVector
    ## @return Rotation speed

  proc getGravity(): FVector
    ##@return Gravity vector (pointing down into the ground)

  proc getAcceleration(): FVector
    ## @return 3D acceleration of the device

wclass(FNavigationEvent of FInputEvent, header: "SlateCore.h"):
  ## FNavigationEvent describes a navigation action (Left, Right, Up, Down)
  ## It is passed to event handlers dealing with navigation.

  proc initFNavigationEvent(inUserIndex: uint32 , inNavigationType: EUINavigation): FNavigationEvent {.constructor.}

  proc getNavigationType(): EUINavigation
    ## @return the type of navigation request (Left, Right, Up, Down)

type
  EActivationType* {.importcpp: "FWindowActivateEvent::EActivationType", header: "SlateCore.h".} = enum
    EA_Activate,
    EA_ActivateByMouse,
    EA_Deactivate

wclass(FWindowActivateEvent of FInputEvent, header: "SlateCore.h"):
  ## FWindowActivateEvent describes a window being activated or deactivated.
  ## (i.e. brought to the foreground or moved to the background)
  ## This event is only passed to top level windows; most widgets are incapable
  ## of receiving this event.

  proc initFWindowActivateEvent(inActivationType: EActivationType,
                                inAffectedWindow: TSharedRef[SWindow]): FWindowActivateEvent

  proc getActivationType(): EActivationType {.noSideEffect.}
    ## Describes what actually happened to the window (e.g. Activated, Deactivated, Activated by a mouse click)

  proc getAffectedWindow(): TSharedRef[SWindow] {.noSideEffect.}
    ## The window that this activation/deactivation happened to
