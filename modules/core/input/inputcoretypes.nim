# Copyright 2016 Xored Software, Inc.

type ETouchType* {.header: "InputCoreTypes.h", importcpp, size: sizeof(cint), pure.} = enum
  Began,
  Moved,
  Stationary,
  Ended,

  NumTypes

wclass(FKey, header: "InputCoreTypes.h"):
  proc make(): FKey {.constructor.}
  proc makeFromName(inName: FName): FKey {.constructor.}
  proc makeFromUniString(inName: wstring): FKey {.constructor.}
  proc makeFromString(inName: cstring): FKey {.constructor.}

  proc isValid(): bool {.noSideEffect.}
  proc isModifierKey(): bool {.noSideEffect.}
  proc isGamepadKey(): bool {.noSideEffect.}
  proc isMouseButton(): bool {.noSideEffect.}
  proc isFloatAxis(): bool {.noSideEffect.}
  proc isVectorAxis(): bool {.noSideEffect.}
  proc isBindableInBlueprints(): bool {.noSideEffect.}
  proc shouldUpdateAxisWithoutSamples(): bool {.noSideEffect.}
  proc getDisplayName(): FText {.noSideEffect.}
  proc toString(): FString {.noSideEffect.}
  proc getFName(): FName {.noSideEffect.}
  proc getMenuCategory(): FName {.noSideEffect.}

  # bool SerializeFromMismatchedTag(struct FPropertyTag const& Tag, FArchive& Ar);
  proc exportTextItem(valueStr: FString, defaultValue: FKey, parent: ptr UObject, portFlags: int32, exportRootScope: ptr UObject): bool {.noSideEffect.}
  proc importTextItem(buffer: wstring, portFlags: int32, parent: ptr UObject, errorText: ptr FOutputDevice): bool
  proc postSerialize(ar: FArchive)

  proc `==`(other: FKey): bool {.noSideEffect.}
  proc `!=`(other: FKey): bool {.noSideEffect.}
  proc `<`(other: FKey): bool {.noSideEffect.}

proc hash*(key: FKey): uint32 {.noSideEffect, importc: "GetTypeHash", header: "InputCoreTypes.h".}

wclass(EKeys, header: "InputCoreTypes.h"):
  var AnyKey {.isStatic.}: FKey

  var MouseX {.isStatic.}: FKey
  var MouseY {.isStatic.}: FKey
  var MouseScrollUp {.isStatic.}: FKey
  var MouseScrollDown {.isStatic.}: FKey
  var MouseWheelAxis {.isStatic.}: FKey

  var LeftMouseButton {.isStatic.}: FKey
  var RightMouseButton {.isStatic.}: FKey
  var MiddleMouseButton {.isStatic.}: FKey
  var ThumbMouseButton {.isStatic.}: FKey
  var ThumbMouseButton2 {.isStatic.}: FKey

  var BackSpace {.isStatic.}: FKey
  var Tab {.isStatic.}: FKey
  var Enter {.isStatic.}: FKey
  var Pause {.isStatic.}: FKey

  var CapsLock {.isStatic.}: FKey
  var Escape {.isStatic.}: FKey
  var SpaceBar {.isStatic.}: FKey
  var PageUp {.isStatic.}: FKey
  var PageDown {.isStatic.}: FKey
  var End {.isStatic.}: FKey
  var Home {.isStatic.}: FKey

  var Left {.isStatic.}: FKey
  var Up {.isStatic.}: FKey
  var Right {.isStatic.}: FKey
  var Down {.isStatic.}: FKey

  var Insert {.isStatic.}: FKey
  var Delete {.isStatic.}: FKey

  var Zero {.isStatic.}: FKey
  var One {.isStatic.}: FKey
  var Two {.isStatic.}: FKey
  var Three {.isStatic.}: FKey
  var Four {.isStatic.}: FKey
  var Five {.isStatic.}: FKey
  var Six {.isStatic.}: FKey
  var Seven {.isStatic.}: FKey
  var Eight {.isStatic.}: FKey
  var Nine {.isStatic.}: FKey

  var A {.isStatic.}: FKey
  var B {.isStatic.}: FKey
  var C {.isStatic.}: FKey
  var D {.isStatic.}: FKey
  var E {.isStatic.}: FKey
  var F {.isStatic.}: FKey
  var G {.isStatic.}: FKey
  var H {.isStatic.}: FKey
  var I {.isStatic.}: FKey
  var J {.isStatic.}: FKey
  var K {.isStatic.}: FKey
  var L {.isStatic.}: FKey
  var M {.isStatic.}: FKey
  var N {.isStatic.}: FKey
  var O {.isStatic.}: FKey
  var P {.isStatic.}: FKey
  var Q {.isStatic.}: FKey
  var R {.isStatic.}: FKey
  var S {.isStatic.}: FKey
  var T {.isStatic.}: FKey
  var U {.isStatic.}: FKey
  var V {.isStatic.}: FKey
  var W {.isStatic.}: FKey
  # var X {.isStatic.}: FKey
  # var Y {.isStatic.}: FKey
  # var Z {.isStatic.}: FKey

  var NumPadZero {.isStatic.}: FKey
  var NumPadOne {.isStatic.}: FKey
  var NumPadTwo {.isStatic.}: FKey
  var NumPadThree {.isStatic.}: FKey
  var NumPadFour {.isStatic.}: FKey
  var NumPadFive {.isStatic.}: FKey
  var NumPadSix {.isStatic.}: FKey
  var NumPadSeven {.isStatic.}: FKey
  var NumPadEight {.isStatic.}: FKey
  var NumPadNine {.isStatic.}: FKey

  var Multiply {.isStatic.}: FKey
  var Add {.isStatic.}: FKey
  var Subtract {.isStatic.}: FKey
  var Decimal {.isStatic.}: FKey
  var Divide {.isStatic.}: FKey

  var F1 {.isStatic.}: FKey
  var F2 {.isStatic.}: FKey
  var F3 {.isStatic.}: FKey
  var F4 {.isStatic.}: FKey
  var F5 {.isStatic.}: FKey
  var F6 {.isStatic.}: FKey
  var F7 {.isStatic.}: FKey
  var F8 {.isStatic.}: FKey
  var F9 {.isStatic.}: FKey
  var F10 {.isStatic.}: FKey
  var F11 {.isStatic.}: FKey
  var F12 {.isStatic.}: FKey

  var NumLock {.isStatic.}: FKey

  var ScrollLock {.isStatic.}: FKey

  var LeftShift {.isStatic.}: FKey
  var RightShift {.isStatic.}: FKey
  var LeftControl {.isStatic.}: FKey
  var RightControl {.isStatic.}: FKey
  var LeftAlt {.isStatic.}: FKey
  var RightAlt {.isStatic.}: FKey
  var LeftCommand {.isStatic.}: FKey
  var RightCommand {.isStatic.}: FKey

  var Semicolon {.isStatic.}: FKey
  var Equals {.isStatic.}: FKey
  var Comma {.isStatic.}: FKey
  var Underscore {.isStatic.}: FKey
  var Hyphen {.isStatic.}: FKey
  var Period {.isStatic.}: FKey
  var Slash {.isStatic.}: FKey
  var Tilde {.isStatic.}: FKey
  var LeftBracket {.isStatic.}: FKey
  var Backslash {.isStatic.}: FKey
  var RightBracket {.isStatic.}: FKey
  var Apostrophe {.isStatic.}: FKey

  var Ampersand {.isStatic.}: FKey
  var Asterix {.isStatic.}: FKey
  var Caret {.isStatic.}: FKey
  var Colon {.isStatic.}: FKey
  var Dollar {.isStatic.}: FKey
  var Exclamation {.isStatic.}: FKey
  var LeftParantheses {.isStatic.}: FKey
  var RightParantheses {.isStatic.}: FKey
  var Quote {.isStatic.}: FKey

  var A_AccentGrave {.isStatic.}: FKey
  var E_AccentGrave {.isStatic.}: FKey
  var E_AccentAigu {.isStatic.}: FKey
  var C_Cedille {.isStatic.}: FKey
  var Section {.isStatic.}: FKey

  # Platform Keys
  # These keys platform specific versions of keys that go by different names.
  # The delete key is a good example, on Windows Delete is the virtual key for Delete.
  # On Macs, the Delete key is the virtual key for BackSpace.
  var Platform_Delete {.isStatic.}: FKey

  # Gamepad Keys
  var Gamepad_LeftX {.isStatic.}: FKey
  var Gamepad_LeftY {.isStatic.}: FKey
  var Gamepad_RightX {.isStatic.}: FKey
  var Gamepad_RightY {.isStatic.}: FKey
  var Gamepad_LeftTriggerAxis {.isStatic.}: FKey
  var Gamepad_RightTriggerAxis {.isStatic.}: FKey

  var Gamepad_LeftThumbstick {.isStatic.}: FKey
  var Gamepad_RightThumbstick {.isStatic.}: FKey
  var Gamepad_Special_Left {.isStatic.}: FKey
  var Gamepad_Special_Right {.isStatic.}: FKey
  var Gamepad_FaceButton_Bottom {.isStatic.}: FKey
  var Gamepad_FaceButton_Right {.isStatic.}: FKey
  var Gamepad_FaceButton_Left {.isStatic.}: FKey
  var Gamepad_FaceButton_Top {.isStatic.}: FKey
  var Gamepad_LeftShoulder {.isStatic.}: FKey
  var Gamepad_RightShoulder {.isStatic.}: FKey
  var Gamepad_LeftTrigger {.isStatic.}: FKey
  var Gamepad_RightTrigger {.isStatic.}: FKey
  var Gamepad_DPad_Up {.isStatic.}: FKey
  var Gamepad_DPad_Down {.isStatic.}: FKey
  var Gamepad_DPad_Right {.isStatic.}: FKey
  var Gamepad_DPad_Left {.isStatic.}: FKey

  # Virtual key codes used for input axis button press/release emulation
  var Gamepad_LeftStick_Up {.isStatic.}: FKey
  var Gamepad_LeftStick_Down {.isStatic.}: FKey
  var Gamepad_LeftStick_Right {.isStatic.}: FKey
  var Gamepad_LeftStick_Left {.isStatic.}: FKey

  var Gamepad_RightStick_Up {.isStatic.}: FKey
  var Gamepad_RightStick_Down {.isStatic.}: FKey
  var Gamepad_RightStick_Right {.isStatic.}: FKey
  var Gamepad_RightStick_Left {.isStatic.}: FKey

  # static const FKey Vector axes (FVector; not float)
  var Tilt {.isStatic.}: FKey
  var RotationRate {.isStatic.}: FKey
  var Gravity {.isStatic.}: FKey
  var Acceleration {.isStatic.}: FKey

  # Gestures
  var Gesture_Pinch {.isStatic.}: FKey
  var Gesture_Flick {.isStatic.}: FKey

  # Motion Controllers
  #    Left Controller
  var MotionController_Left_FaceButton1 {.isStatic.}: FKey
  var MotionController_Left_FaceButton2 {.isStatic.}: FKey
  var MotionController_Left_FaceButton3 {.isStatic.}: FKey
  var MotionController_Left_FaceButton4 {.isStatic.}: FKey
  var MotionController_Left_FaceButton5 {.isStatic.}: FKey
  var MotionController_Left_FaceButton6 {.isStatic.}: FKey
  var MotionController_Left_FaceButton7 {.isStatic.}: FKey
  var MotionController_Left_FaceButton8 {.isStatic.}: FKey

  var MotionController_Left_Shoulder {.isStatic.}: FKey
  var MotionController_Left_Trigger {.isStatic.}: FKey

  var MotionController_Left_Grip1 {.isStatic.}: FKey
  var MotionController_Left_Grip2 {.isStatic.}: FKey

  var MotionController_Left_Thumbstick {.isStatic.}: FKey
  var MotionController_Left_Thumbstick_Up {.isStatic.}: FKey
  var MotionController_Left_Thumbstick_Down {.isStatic.}: FKey
  var MotionController_Left_Thumbstick_Left {.isStatic.}: FKey
  var MotionController_Left_Thumbstick_Right {.isStatic.}: FKey

  #    Right Controller
  var MotionController_Right_FaceButton1 {.isStatic.}: FKey
  var MotionController_Right_FaceButton2 {.isStatic.}: FKey
  var MotionController_Right_FaceButton3 {.isStatic.}: FKey
  var MotionController_Right_FaceButton4 {.isStatic.}: FKey
  var MotionController_Right_FaceButton5 {.isStatic.}: FKey
  var MotionController_Right_FaceButton6 {.isStatic.}: FKey
  var MotionController_Right_FaceButton7 {.isStatic.}: FKey
  var MotionController_Right_FaceButton8 {.isStatic.}: FKey

  var MotionController_Right_Shoulder {.isStatic.}: FKey
  var MotionController_Right_Trigger {.isStatic.}: FKey

  var MotionController_Right_Grip1 {.isStatic.}: FKey
  var MotionController_Right_Grip2 {.isStatic.}: FKey

  var MotionController_Right_Thumbstick {.isStatic.}: FKey
  var MotionController_Right_Thumbstick_Up {.isStatic.}: FKey
  var MotionController_Right_Thumbstick_Down {.isStatic.}: FKey
  var MotionController_Right_Thumbstick_Left {.isStatic.}: FKey
  var MotionController_Right_Thumbstick_Right {.isStatic.}: FKey
  #   Motion Controller Axes
  #    Left Controller
  var MotionController_Left_Thumbstick_X {.isStatic.}: FKey
  var MotionController_Left_Thumbstick_Y {.isStatic.}: FKey
  var MotionController_Left_TriggerAxis {.isStatic.}: FKey
  var MotionController_Left_Grip1Axis {.isStatic.}: FKey
  var MotionController_Left_Grip2Axis {.isStatic.}: FKey

  #    Right Controller
  var MotionController_Right_Thumbstick_X {.isStatic.}: FKey
  var MotionController_Right_Thumbstick_Y {.isStatic.}: FKey
  var MotionController_Right_TriggerAxis {.isStatic.}: FKey
  var MotionController_Right_Grip1Axis {.isStatic.}: FKey
  var MotionController_Right_Grip2Axis {.isStatic.}: FKey

  # PS4-specific
  var PS4_Special {.isStatic.}: FKey

  # Steam Controller Specific
  var Steam_Touch_0 {.isStatic.}: FKey
  var Steam_Touch_1 {.isStatic.}: FKey
  var Steam_Touch_2 {.isStatic.}: FKey
  var Steam_Touch_3 {.isStatic.}: FKey
  var Steam_Back_Left {.isStatic.}: FKey
  var Steam_Back_Right {.isStatic.}: FKey

  # Xbox One global speech commands
  var Global_Menu {.isStatic.}: FKey
  var Global_View {.isStatic.}: FKey
  var Global_Pause {.isStatic.}: FKey
  var Global_Play {.isStatic.}: FKey
  var Global_Back {.isStatic.}: FKey

  # Android-specific
  var Android_Back {.isStatic.}: FKey
  var Android_Volume_Up {.isStatic.}: FKey
  var Android_Volume_Down {.isStatic.}: FKey
  var Android_Menu {.isStatic.}: FKey

  var Invalid {.isStatic.}: FKey

  var NUM_TOUCH_KEYS {.isStatic.}: int32
  var touchKeys {.isStatic.}: ptr FKey

  # static EConsoleForGamepadLabels::Type ConsoleForGamepadLabels;

  var NAME_KeyboardCategory {.isStatic.}: FName
  var NAME_GamepadCategory {.isStatic.}: FName
  var NAME_MouseCategory {.isStatic.}: FName

  proc initialize() {.isStatic.}

  # AWARE
  # proc addKey(const FKeyDetails& KeyDetails) {.isStatic.}
  # static void GetAllKeys(TArray<FKey>& OutKeys);
  # static TSharedPtr<FKeyDetails> GetKeyDetails(const FKey Key);