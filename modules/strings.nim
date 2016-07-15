# Copyright 2016 Xored Software, Inc.

# Note: the conventions for working with strings are similar to Nim's
# stdlib and strutils, rather than UE4 library. Though for now we left
# comparison operators and hash functions to be case-insensitive for FString.
# We will see how well it's going to work.

type
  wchar* {.importcpp: "wchar_t", nodecl.} = object
  wstring* = ptr array[0 .. 10000000, wchar]

  FString* {.header: "Containers/UnrealString.h", importcpp: "FString", bycopy.} = object

  ESearchCase {.header: "Containers/UnrealString.h", importcpp: "ESearchCase::Type", pure.} = enum
    CaseSensitive,
    IgnoreCase

  ESearchDir {.header: "Containers/UnrealString.h", importcpp: "ESearchDir::Type", pure.} = enum
    FromStart,
    FromEnd

converter towchar*(c: char): wchar {.importc: "wchar_t", nodecl.}

# intentionally private:
proc toUtf8(s: wstring): cstring {.importc: "TCHAR_TO_UTF8", nodecl.}
proc toUtf8(s: ptr wchar): cstring {.importc: "TCHAR_TO_UTF8", nodecl.}

proc toWideString*(s: cstring): wstring {.importc: "UTF8_TO_TCHAR", nodecl.}
  ## use it ONLY as an argument in a call

# in C++ it's actually a macro that prepends "L" to the string literal, making it wide string literal
proc TEXT*(s: cstring{lit}): wstring {.noSideEffect, importc: "TEXT", nodecl.}
proc u16*(s: cstring{lit}): wstring {.noSideEffect, importc: "TEXT", nodecl.}
# proc u16*(s: string{lit}): wstring {.noSideEffect, importc: "TEXT", nodecl.}
proc u16*(s: string{sym|ident|call|lvalue|param}): FString {.noSideEffect, importcpp: "FString(UTF8_TO_TCHAR(@))", nodecl.}

proc initFString*(): FString {.importcpp: "'0(@)", nodecl, constructor.}
proc charArray*(s: FString): var TArray[wchar] {.importcpp: "#.GetCharArray(@)", nodecl.}
proc mid*(s: FString,
         start: Natural,
         count: Natural = high(int32)): FString {.noSideEffect, importcpp: "#.Mid(@)", nodecl.}

proc findInternal(s: FString;
                  subStr: FString or wstring;
                  searchCase: ESearchCase = ESearchCase.IgnoreCase;
                  searchDir: ESearchDir = ESearchDir.FromStart;
                  start: int32 = -1): int32 {.noSideEffect, importcpp: "#.Find(@)", nodecl.}
proc cmpInternal(x,y: FString;
                 searchCase: ESearchCase = ESearchCase.CaseSensitive): int32 {.
  noSideEffect, importcpp: "#.Compare(@)", nodecl.}

proc startsWithInternal(s, sub: FString;
                        searchCase: ESearchCase): bool {.noSideEffect, importcpp: "#.StartsWith(@)", nodecl.}

proc endsWithInternal(x: FString,
                      sub: FString,
                      searchCase: ESearchCase): bool {.noSideEffect, importcpp: "#.EndsWith(@)", nodecl.}
proc replaceInternal(s: FString; sub,by: wstring;
                     searchCase: ESearchCase): FString {.noSideEffect, importcpp:"#.Replace(@)", nodecl.}
proc trim(s: FString): FString {.noSideEffect, importcpp: "#.Trim(@)", nodecl.}
proc trimTrailing(s: FString): FString {.noSideEffect, importcpp: "#.TrimTrailing(@)", nodecl.}

proc len*(s: FString): int32 {.noSideEffect, importcpp: "#.Len(@)", nodecl.}

proc `&`*(c: wchar, s: FString): FString {.noSideEffect, importcpp: "(# + #)", nodecl.}
proc `&`*(s: FString, c: wchar): FString {.noSideEffect, importcpp: "(# + #)", nodecl.}
proc `&`*(s: FString, s2: wstring): FString {.noSideEffect, importcpp: "(# + #)", nodecl.}

proc `&=`*(s: var FString, c: FString or wstring or wchar) {.importcpp: "# += #", nodecl.}
proc add*(s: var FString, c: FString or wstring) {.importcpp: "# += #", nodecl.}
proc add*(s: FString, chr: wchar) {.noSideEffect, importcpp: "#.AppendChar(@)", nodecl.}

proc `&`*(x, y: FString): FString {.noSideEffect, importcpp: "(# + #)", nodecl.}

proc `/`*(x: FString, y: FString or wstring): FString {.noSideEffect, importcpp: "(# / #)", nodecl.}
proc `/=`*(x: var FString, y: FString or wstring) {.importcpp: "# /= #", nodecl.}

proc `[]`*(s: FString, i: Natural): wchar {.noSideEffect, importcpp: "#[#]", nodecl.}

proc toUpper*(s: FString): FString {.noSideEffect, importcpp: "#.ToUpper(@)", nodecl.}
proc toLower*(s: FString): FString {.noSideEffect, importcpp: "#.ToLower(@)", nodecl.}
proc isNumeric*(s: FString): bool {.noSideEffect, importcpp: "#.IsNumeric(@)", nodecl.}
proc align*(s: FString, count: Natural): FString {.noSideEffect, importcpp: "#.LeftPad(@)", nodecl.}
proc leftAlign*(s: FString, count: Natural): FString {.noSideEffect, importcpp: "#.RightPad(@)", nodecl.}
proc hash*(s: FString): uint32 {.noSideEffect, importcpp: "#.GetTypeHash(@)", nodecl.}

proc `[]`*(s: FString, r: Slice[Natural]): FString {.noSideEffect.} =
  result = s.mid(r.a, ord(r.b) - ord(r.a) + 1)

proc find*(s: FString; sub: FString or wstring; start: Natural = 0): int32 {.noSideEffect.} =
  result = s.find(sub, ESearchCase.CaseSensitive, ESearchDir.FromStart, start)
proc findIgnoreCase*(s: FString; sub: FString or wstring; start: Natural = 0): int32 {.noSideEffect.} =
  result = s.find(sub, ESearchCase.IgnoreCase, ESearchDir.FromStart, start)

proc rfind*(s: FString; sub: FString or wstring; start: Natural = 0): int32 {.noSideEffect.} =
  result = s.find(sub, ESearchCase.CaseSensitive, ESearchDir.FromEnd, start)
proc rfindIgnoreCase*(s: FString; sub: FString or wstring; start: Natural = 0): int32 {.noSideEffect.} =
  result = s.find(sub, ESearchCase.IgnoreCase, ESearchDir.FromEnd, start)

proc contains*(s: FString, sub: FString or wstring, isCaseSensitive: bool = true): bool {.noSideEffect.} =
  result = s.find(sub, 0, isCaseSensitive) != -1

proc cmp*(x, y: FString): int32 {.noSideEffect.} =
  result = cmpInternal(x, y)
proc cmpIgnoreCase*(x, y: FString): int32 {.noSideEffect.} =
  result = cmpInternal(x, y, ESearchCase.IgnoreCase)

proc startsWith*(s, sub: FString): bool {.noSideEffect.} =
  result = startsWithInternal(s, sub, ESearchCase.CaseSensitive)
proc startsWithIgnoreCase*(s, sub: FString): bool {.noSideEffect.} =
  result = startsWithInternal(s, sub, ESearchCase.IgnoreCase)

proc endsWith*(s, sub: FString): bool {.noSideEffect.} =
  result = endsWithInternal(s, sub, ESearchCase.CaseSensitive)
proc endsWithIgnoreCase*(s, sub: FString): bool {.noSideEffect.} =
  result = endsWithInternal(s, sub, ESearchCase.IgnoreCase)

proc replace*(s: FString; sub, by: wstring): FString {.noSideEffect.} =
  replaceInternal(s, sub, by, ESearchCase.CaseSensitive)
proc replaceIgnoreCase*(s: FString; sub,by: wstring): FString {.noSideEffect.} =
  replaceInternal(s, sub, by, ESearchCase.IgnoreCase)

proc strip*(s: FString; leading = true; trailing = true): FString {.noSideEffect.} =
  result = s
  if leading:
    result = trim(result)
  if trailing:
    result = trimTrailing(result)

proc wideString*(s: FString): wstring {.header: "Containers/UnrealString.h", importcpp: "(*#)".}

converter toFString*(s: wstring): FString {.
  header: "Containers/UnrealString.h", importcpp: "'0(@)", nodecl.}

proc toFString*(s: cstring{lit}): FString {.importcpp: "'0(TEXT(@))", nodecl, noSideEffect.}
proc toFString*(s: cstring): FString {.importcpp: "'0(UTF8_TO_TCHAR(@))", nodecl, noSideEffect.}
proc toFString*(s: string{sym|ident|call|lvalue|param}): FString {.noSideEffect.} =
  result = toFString(cstring(s))
proc toFString*(n: int8 or int16 or int32 or int64 or uint8 or uint16 or uint32 or uint64): FString {.
  importcpp: "'0::FromInt(@)", nodecl, noSideEffect.}
proc toFString*(f: float32): FString {.importcpp: "'0::SanitizeFloat(@)", nodecl, noSideEffect.}
proc toFString*(c: char): FString {.importcpp: "'0::Chr(@)", nodecl, noSideEffect.}

proc printfToFString*(formatString: wstring): FString {.
  noSideEffect, header: "Containers/UnrealString.h", importcpp: "'0::Printf(@)", varargs.}

proc hackToImportCstrToNimStr(s: cstring): string {.exportc.} =
  ## a hack to make compiler import "cstrToNimStr"
  ## used in the `$`
  result = $s

proc `$`*(s: FString): string =
  # couldn't otherwise force Nim compiler to use TCHAR_TO_UTF8 macro as an argument
  # without generating a temporary variable
  {.emit: "`result` = `cstrToNimstr`(TCHAR_TO_UTF8(*`s`));".}

# TODO: format, parseInt, parseBool, join, repeat for FString

wclass(FText, header: "Internationalization/Text.h", bycopy):
  proc initFText(): FText {.constructor.}
  proc isEmpty(): bool {.noSideEffect.}
  proc isEmptyOrWhitespace(): bool {.noSideEffect.}
  proc toString(): FString {.noSideEffect.}
  proc isIdenticalTo(other: FText): bool {.noSideEffect, cppname: "IdenticalTo".}
  proc strip(t: FText): FText {.noSideEffect, cppname: "TrimPrecedingAndTrailing".}
  proc cmp(other: FText): int32 {.noSideEffect, cppname: "CompareTo".}
  proc cmpIgnoreCase(other: FText): int32 {.noSideEffect, cppname: "CompareToCaseIgnored".}
  proc isNumeric(): bool {.noSideEffect.}
  proc isTransient(): bool {.noSideEffect.}
  proc isCultureInvariant(): bool {.noSideEffect.}
  proc shouldGatherForLocalization(): bool {.noSideEffect.}

proc findTextInternal(namespace: FString, key: FString, outText: var FText) {.importcpp: "FText::FindText(@)", nodecl.}
proc nsLocText*(ns, key: wstring): FText {.inline.} =
  findTextInternal(ns, key, result)

converter toFText*(s: wstring): FText {.
  header: "Internationalization/Text.h", importcpp: "'0::FromString(@)", nodecl.}

proc toText*(num: int8 or int16 or int32 or uint8 or uint16 or uint32): FText {.
  noSideEffect, header: "Internationalization/Text.h", importcpp: "'0::AsNumber(@)".}

proc nsLocText*(ns, key, text: cstring{lit}): FText {.noSideEffect, importc: "NSLOCTEXT", nodecl.}

# TODO: this can be made as macro that accepts and implicitly converts non-text types
proc textFormat*(formatString: FText): FText {.
  noSideEffect, header: "Internationalization/Text.h", importcpp: "'0::Format(@)", varargs.}

proc `&`*(x, y: FText): FText =
  # is there a more efficient way?
  textFormat(TEXT("{0}{1}"), x, y)

proc `$`*(t: FText): string =
  $t.toString()

# TODO: currency, date transformation to FText

type EName* {.header: "UObject/UnrealNames.h" importcpp: "EName".} = enum
  NAME_None = 0

  # Class property types (name indices are significant for serialization).
  NAME_ByteProperty = 1
  NAME_IntProperty = 2
  NAME_BoolProperty = 3
  NAME_FloatProperty = 4
  NAME_ObjectProperty = 5
  NAME_NameProperty = 6
  NAME_DelegateProperty = 7
  NAME_ClassProperty = 8
  NAME_ArrayProperty = 9
  NAME_StructProperty = 10
  NAME_VectorProperty = 11
  NAME_RotatorProperty = 12
  NAME_StrProperty = 13
  NAME_TextProperty = 14
  NAME_InterfaceProperty = 15
  NAME_MulticastDelegateProperty = 16
  NAME_WeakObjectProperty = 17
  NAME_LazyObjectProperty = 18
  NAME_AssetObjectProperty = 19
  NAME_UInt64Property = 20
  NAME_UInt32Property = 21
  NAME_UInt16Property = 22
  NAME_Int64Property = 23
  NAME_Int16Property = 25
  NAME_Int8Property = 26
  NAME_AssetSubclassOfProperty = 27

  # Special packages.
  NAME_Core = 30
  NAME_Engine = 31
  NAME_Editor = 32
  NAME_CoreUObject = 33

  # Special types.
  NAME_Cylinder = 50
  NAME_BoxSphereBounds = 51
  NAME_Sphere = 52
  NAME_Box = 53
  NAME_Vector2D = 54
  NAME_IntRect = 55
  NAME_IntPoint = 56
  NAME_Vector4 = 57
  NAME_Name = 58
  NAME_Vector = 59
  NAME_Rotator = 60
  NAME_SHVector = 61
  NAME_Color = 62
  NAME_Plane = 63
  NAME_Matrix = 64
  NAME_LinearColor = 65
  NAME_AdvanceFrame = 66
  NAME_Pointer = 67
  NAME_Double = 68
  NAME_Quat = 69
  NAME_Self = 70
  NAME_Transform = 71

  # Object class names.
  NAME_Object = 100
  NAME_Camera = 101
  NAME_Actor = 102
  NAME_ObjectRedirector = 103
  NAME_ObjectArchetype = 104
  NAME_Class = 105

  # Misc.
  NAME_State = 200
  NAME_TRUE = 201
  NAME_FALSE = 202
  NAME_Enum = 203
  NAME_Default = 204
  NAME_Skip = 205
  NAME_Input = 206
  NAME_Package = 207
  NAME_Groups = 208
  NAME_Interface = 209
  NAME_Components = 210
  NAME_Global = 211
  NAME_Super = 212
  NAME_Outer = 213
  NAME_Map = 214
  NAME_Role = 215
  NAME_RemoteRole = 216
  NAME_PersistentLevel = 217
  NAME_TheWorld = 218
  NAME_PackageMetaData = 219
  NAME_InitialState = 220
  NAME_Game = 221
  NAME_SelectionColor = 222
  NAME_UI = 223
  NAME_ExecuteUbergraph = 224
  NAME_DeviceID = 225
  NAME_RootStat = 226
  NAME_MoveActor = 227
  NAME_All = 230
  NAME_MeshEmitterVertexColor = 231
  NAME_TextureOffsetParameter = 232
  NAME_TextureScaleParameter = 233
  NAME_ImpactVel = 234
  NAME_SlideVel = 235
  NAME_TextureOffset1Parameter = 236
  NAME_MeshEmitterDynamicParameter = 237
  NAME_ExpressionInput = 238
  NAME_Untitled = 239
  NAME_Timer = 240
  NAME_Team = 241
  NAME_Low = 242
  NAME_High = 243
  NAME_NetworkGUID = 244
  NAME_GameThread = 245
  NAME_RenderThread = 246
  NAME_OtherChildren = 247
  NAME_Location = 248
  NAME_Rotation = 249
  NAME_BSP = 250
  NAME_EditorSettings = 251

  # Online
  NAME_DGram = 280
  NAME_Stream = 281
  NAME_GameNetDriver = 282
  NAME_PendingNetDriver = 283
  NAME_BeaconNetDriver = 284
  NAME_FlushNetDormancy = 285
  NAME_DemoNetDriver = 286

  # Texture settings.
  NAME_Linear = 300
  NAME_Point = 301
  NAME_Aniso = 302
  NAME_LightMapResolution = 303

  # Sound.
  # REGISTER_NAME(310,)
  NAME_UnGrouped = 311
  NAME_VoiceChat = 312

  # Optimized replication.
  NAME_Playing = 320
  NAME_Spectating = 322
  NAME_Inactive = 325

  # Log messages.
  NAME_PerfWarning = 350
  NAME_Info = 351
  NAME_Init = 352
  NAME_Exit = 353
  NAME_Cmd = 354
  NAME_Warning = 355
  NAME_Error = 356

  # File format backwards-compatibility.
  NAME_FontCharacter = 400
  NAME_InitChild2StartBone = 401
  NAME_SoundCueLocalized = 402
  NAME_SoundCue = 403
  NAME_RawDistributionFloat = 404
  NAME_RawDistributionVector = 405
  NAME_InterpCurveFloat = 406
  NAME_InterpCurveVector2D = 407
  NAME_InterpCurveVector = 408
  NAME_InterpCurveTwoVectors = 409
  NAME_InterpCurveQuat = 410

  NAME_AI = 450
  NAME_NavMesh = 451

  NAME_PerformanceCapture = 500

  # Special config names - not required to be consistent for network replication
  NAME_EditorLayout = 600
  NAME_EditorKeyBindings = 601

wclass(FName, header: "UObject/NameTypes.h", bycopy):
  proc initFName(): FName {.constructor, noSideEffect.}
  proc initFName(s: cstring): FName {.constructor, noSideEffect.}
  proc initFName(s: wstring): FName {.constructor, noSideEffect.}
  proc initFName(s: wstring or cstring, number: int32): FName {.constructor, noSideEffect.}
  proc fromEName(name: EName): FName {.constructor, noSideEffect.}

  proc cmp(other: FName): int32 {.noSideEffect.}
  proc toString(): FString {.noSideEffect.}
  proc isNone(): bool {.noSideEffect.}
  proc isValid(): bool {.noSideEffect.}
  proc getNumber(): int32 {.noSideEffect.}
  proc getPlainNameString(): FString {.noSideEffect.}
    ## Returns the pure name string without any trailing numbers

proc `<`*[T: FString|FName](x, y: T): bool {.noSideEffect, importcpp: "(# < #)", nodecl.}
proc `<=`*[T: FString|FName](x, y: T): bool {.noSideEffect, importcpp: "(# <= #)", nodecl.}
proc `==`*(x, y: FString): bool {.noSideEffect, importcpp: "(# == #)", nodecl.}
proc `==`*(x, y: FName): bool {.noSideEffect, importcpp: "(# == #)", nodecl.}

proc `==`*(x: FName, y: cstring or wstring): bool {.noSideEffect, importcpp: "(# == #)", nodecl.}
proc `==`*(x: FName, y: string not nil): bool {.noSideEffect, importcpp: "(# == #->data)", nodecl.}

converter toFName*(s: wstring): FName {.
  header: "UObject/NameTypes.h", importcpp: "'0(@)", nodecl.}
proc toFName*(s: cstring{lit}): FName {.importcpp: "'0(TEXT(@))", nodecl.}
proc toFName*(s: cstring): FName {.importcpp: "'0(UTF8_TO_TCHAR(@))", nodecl.}
proc toFName*(s: string{sym|ident|call|lvalue|param}): FName =
  result = toFName(cstring(s))

proc toText*(s: FString): FText {.
  noSideEffect, header: "Internationalization/Text.h", importcpp: "'0::FromString(@)".}

proc toText*(s: FName): FText {.
  noSideEffect, header: "Internationalization/Text.h", importcpp: "'0::FromName(@)".}

proc toText*(s: string): FText {.inline.} =
  result = s.toFString().toText()

proc toText*(s: wstring): FText {.inline.} =
  result = s.toFString().toText()

converter toFName*(num: EName): FName =
  result = fromEName(num)

proc `==`*(x: FString, y: string): bool {.noSideEffect, inline.} =
  result = x == y.toFString()
proc `==`*(x: string, y: FString): bool {.noSideEffect, inline.} =
  result = x.toFString() == y

