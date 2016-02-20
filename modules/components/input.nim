# Copyright 2016 Xored Software, Inc.

type EControllerAnalogStick {.header: "Components/InputComponent.h", importcpp, size: sizeof(cint).} = enum
  CAS_LeftStick,
  CAS_RightStick,
  CAS_MAX

template bindAction*[T](inputComp: ptr UInputComponent, action: static[string], event: EInputEvent, objPtr: T, callback: proc(t: T)) =
  {.emit: "$#->BindAction(`$#`, `$#`::$#, `$#`, & $#::$#);".format(
            expandObjReference(astToStr(inputComp)), astToStr(action), type(event).name, astToStr(event),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

template bindTouch*[T](inputComp: ptr UInputComponent, event: EInputEvent, objPtr: T, callback: proc(t: T, fingerIndex: ETouchIndex, loc: FVector)) =
  {.emit: "$#->BindTouch(`$#`::$#, `$#`, & $#::$#);".format(
            expandObjReference(astToStr(inputComp)), type(event).name, astToStr(event),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

# TODO