# Copyright 2016 Xored Software, Inc.

type
  FInputChord* {.header: "Framework/Commands/InputChord.h", importcpp.} = object # TODO
  FInputActionUnifiedDelegate* {.header: "Components/InputComponent.h", importcpp.} = object # TODO

  EControllerAnalogStick* {.header: "Components/InputComponent.h", importcpp, size: sizeof(cint).} = enum
    CAS_LeftStick,
    CAS_RightStick,
    CAS_MAX

  FInputBinding* {.header: "Components/InputComponent.h", importcpp, inheritable, bycopy.} = object
    ## Base class for the different binding types.
    bConsumeInput*: bool
    bExecuteWhenPaused*: bool

  FInputActionBinding* {.header: "Components/InputComponent.h", importcpp, bycopy.} = object of FInputBinding
    ## Binds a delegate to an action.
    actionName* {.importcpp: "ActionName".}: FName
      ## Friendly name of action, e.g "jump"
    keyEvent* {.importcpp: "KeyEvent".}: EInputEvent
      ## Key event to bind it to, e.g. pressed, released, double click
    bPaired*: bool
      ## Whether the binding is part of a paired (both pressed and released events bound) action
    actionDelegate* {.importcpp: "ActionDelegate".}: FInputActionUnifiedDelegate
      ## The delegate bound to the action

  FInputKeyBinding {.header: "Components/InputComponent.h", importcpp, bycopy.} = object of FInputBinding
    chord* {.importcpp: "Chord".}: FInputChord
      ## Input Chord to bind to
    keyEvent* {.importcpp: "KeyEvent".}: EInputEvent
      ## Key event to bind it to (e.g. pressed, released, double click)
    keyDelegate* {.importcpp: "KeyDelegate".}: FInputActionUnifiedDelegate
      ## The delegate bound to the key chord

wclass(UInputComponent of UActorComponent, header: "Components/InputComponent.h", notypedef):
  proc getAxisValue(axisName: FName): cfloat {.noSideEffect.}
    ## Gets the current value of the axis with the specified name.
    ##
    ## @param AxisName The name of the axis.
    ## @return Axis value.
    ## @see GetAxisKeyValue, GetVectorAxisValue

  proc getAxisKeyValue(axisKey: FKey): cfloat {.noSideEffect.}
    ## Gets the current value of the axis with the specified key.
    ##
    ## @param AxisKey The key of the axis.
    ## @return Axis value.
    ## @see GetAxisKeyValue, GetVectorAxisValue

  proc getVectorAxisValue(axisKey: FKey): FVector {.noSideEffect.}
    ## Gets the current vector value of the axis with the specified key.
    ##
    ## @param AxisKey The key of the axis.
    ## @return Axis value.
    ## @see GetAxisValue, GetAxisKeyValue

  proc hasBindings(): bool {.noSideEffect.}
    ## Checks whether this component has any input bindings.
    ##
    ## @return true if any bindings are set, false otherwise.

  proc addActionBinding(binding: FInputActionBinding): var FInputActionBinding
    ## Adds the specified action binding.
    ##
    ## @param Binding The binding to add.
    ## @return The last binding in the list.
    ## @see ClearActionBindings, GetActionBinding, GetNumActionBindings, RemoveActionBinding

  proc clearActionBindings()
    ## Removes all action bindings.
    ##
    ## @see AddActionBinding, GetActionBinding, GetNumActionBindings, RemoveActionBinding

  proc getActionBinding(bindingIndex: int32): var FInputActionBinding
    ## Gets the action binding with the specified index.
    ##
    ## @param BindingIndex The index of the binding to get.
    ## @see AddActionBinding, ClearActionBindings, GetNumActionBindings, RemoveActionBinding

  proc getNumActionBindings(): int32 {.noSideEffect.}
    ## Gets the number of action bindings.
    ##
    ## @return Number of bindings.
    ## @see AddActionBinding, ClearActionBindings, GetActionBinding, RemoveActionBinding

  proc removeActionBinding(bindingIndex: int32)
    ## Removes the action binding at the specified index.
    ##
    ## @param BindingIndex The index of the binding to remove.
    ## @see AddActionBinding, ClearActionBindings, GetActionBinding, GetNumActionBindings

  proc clearBindingValues()
    ## Clears all cached binding values.

template bindAction*[T](inputComp: ptr UInputComponent, action: static[string], event: EInputEvent, objPtr: T, callback: proc(t: T)) =
  ## Binds a delegate function to an Action defined in the project settings.
  {.emit: "$#->BindAction(`$#`, `$#`::$#, `$#`, & $#::$#);".format(
            expandObjReference(astToStr(inputComp)), astToStr(action), type(event).name, astToStr(event),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

template bindAxis*[T](inputComp: ptr UInputComponent, axisName: static[string], objPtr: T, callback: proc(t: T, val: cfloat)) =
  ## Binds a delegate function an Axis defined in the project settings.
  {.emit: "$#->BindAxis(`$#`, `$#`, & $#::$#);".format(
            expandObjReference(astToStr(inputComp)), astToStr(axisName),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

template bindAxisKey*[T](inputComp: ptr UInputComponent, axisKey: FKey, objPtr: T, callback: proc(t: T, val: cfloat)) =
  ## Binds a delegate function for an axis key (e.g. Mouse X).
  {.emit: "$#->BindAxisKey(`$#`, `$#`, & $#::$#);".format(
            expandObjReference(astToStr(inputComp)), astToStr(axisKey),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

template bindVectorAxis*[T](inputComp: ptr UInputComponent, axisKey: FKey, objPtr: T, callback: proc(t: T, val: cfloat)) =
  ## Binds a delegate function to a vector axis key (e.g. Tilt)
  {.emit: "$#->BindVectorAxis(`$#`, `$#`, & $#::$#);".format(
            expandObjReference(astToStr(inputComp)), astToStr(axisKey),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

template bindTouch*[T](inputComp: ptr UInputComponent, event: EInputEvent, objPtr: T, callback: proc(t: T, fingerIndex: ETouchIndex, loc: FVector)) =
  {.emit: "$#->BindTouch(`$#`::$#, `$#`, & $#::$#);".format(
            expandObjReference(astToStr(inputComp)), type(event).name, astToStr(event),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

template bindKey*[T](inputComp: ptr UInputComponent, key: FKey, event: EInputEvent, objPtr: T, callback: proc(t: T, fingerIndex: ETouchIndex, loc: FVector)) =
  {.emit: "$#->BindKey(`$#`, `$#`::$#, `$#`, & $#::$#);".format(
            expandObjReference(astToStr(inputComp)), astToStr(key), type(event).name, astToStr(event),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

template bindChord*[T](inputComp: ptr UInputComponent, chord: FInputChord, event: EInputEvent, objPtr: T, callback: proc(t: T, fingerIndex: ETouchIndex, loc: FVector)) =
  {.emit: "$#->BindKey(`$#`, `$#`::$#, `$#`, & $#::$#);".format(
            expandObjReference(astToStr(inputComp)), astToStr(chord), type(event).name, astToStr(event),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

template bindGesture*[T](inputComp: ptr UInputComponent, axisKey: FKey, objPtr: T, callback: proc(t: T, val: cfloat)) =
  ## Binds a gesture event to a delegate function.
  {.emit: "$#->BindAxisKey(`$#`, `$#`, & $#::$#);".format(
            expandObjReference(astToStr(inputComp)), astToStr(axisKey),
            astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}
