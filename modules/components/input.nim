# Copyright 2016 Xored Software, Inc.
type EControllerAnalogStick {.header: "Components/InputComponent.h", importcpp, size: sizeof(cint).} = enum
  CAS_LeftStick,
  CAS_RightStick,
  CAS_MAX

type
  UInputComponent* {.header: "Components/InputComponent.h", importcpp.} = object of UActorComponent