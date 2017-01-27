# Copyright 2017 Xored Software, Inc.

import macros, strutils
import "../lib/macroutils"
import uetypes, uedelegate

macro blueprintAsync*(function: untyped): untyped =
  function.expectKind(nnkProcDef)
  let category = function.removeStrPragma("category")
  if category == nil:
    parseError(function, "blueprint function must have .category pragma")

  function.expectKind(nnkProcDef)
  function.params.expectMinLen(1)
  function.params[0].expectKind(nnkBracketExpr)
  if not function.params[0][0].eqIdent("Future"):
    parseError(function, "Return type must be Future[T]")

  let procName = $(extractIdent(function.name).ident)
  let returnType =  function.params[0][1]
  var procArgs = newSeq[(NimNode, NimNode)]()
    # will be seq of (argNameNode, argTypeNode)
  for node in function.params:
    if node.kind == nnkIdentDefs:
      let argType = node[^2]
      for i in 0..<node.len - 2:
        procArgs.add((node[i], argType))

  var upperCaseName = procName
  upperCaseName[0] = upperCaseName[0].toUpperAscii()
  let successDelegateType = ident("F" & upperCaseName & "SuccessDelegate")
  let failDelegateType = ident("F" & upperCaseName & "FailDelegate")
  let className = ident("U" & upperCaseName & "ActionProxy")
  let asyncProcName = ident(procName & "_async")

  result = newStmtList()

  var asyncProcDef = copy(function)
  asyncProcDef.name = asyncProcName
  result.add(asyncProcDef)

  result.add(
    newCall(bindSym"udelegate",
            successDelegateType,
            ident("dkDynamicMulticast"),
            newColonExpr(ident("returnValue"), returnType))
  )
    # udelegate(`successDelegateType`, dkDynamicMulticast, returnValue: `returnType`)

  result.add(
    newCall(bindSym"udelegate",
            failDelegateType,
            ident("dkDynamicMulticast"))
  )
    # udelegate(`failDelegateType`, dkDynamicMulticast)

  var uclassDef = newCall(
    bindSym"uclass",
    infix(className, "of", ident("UBlueprintAsyncActionBase")),
    ident("MinimalAPI")
  )
    # uclass(`className` of UBlueprintAsyncActionBase, MinimalAPI):

  var classBody = newStmtList()
  for argName, argType in procArgs.items:
    classBody.add(newNimNode(nnkVarSection).add(
      newIdentDefs(argName, argType)
      )
    )
    # var arg1: type1
    # var arg2: type2
    # ...

  let delegatesDef = newCall(
    ident("UProperty"),
    ident("BlueprintAssignable"),
    newStmtList(
      newNimNode(nnkVarSection).add(
        newIdentDefs(ident("onSuccess"), successDelegateType)
      ),
      newNimNode(nnkVarSection).add(
        newIdentDefs(ident("onFail"), failDelegateType)
      )
    )
  )
  classBody.add(delegatesDef)
    # UProperty(BlueprintAssignable):
    #   var onSuccess: `successDelegateType`
    #   var onFail: `failDelegateType`

  var asyncProcCall = newCall(asyncProcName)
  for argName, argType in procArgs.items:
    asyncProcCall.add(argName)
    # `asyncProcName`(arg1, arg2,...)

  let activateMethodDef = quote do:
    method activate*() {.override, callSuper.} =
      let cb = proc(fut: Future[`returnType`]) =
        if fut.failed:
          onFail.broadcast()
        else:
          onSuccess.broadcast(fut.read())
      let fut = `asyncProcCall`
      fut.callback = cb
  classBody.add(activateMethodDef[0])

  var syncProcDef = copy(function)
  syncProcDef[3][0] = newNimNode(nnkPtrTy).add(className)
  discard syncProcDef.removePragma("async")
  syncProcDef.addPragma(ident("isStatic"))
  var syncProcBody = newStmtList()
  syncProcBody.add(
    newAssignment(
      ident("result"),
      newCall(newNimNode(nnkBracketExpr).add(
        ident("ueNew"),
        className
        )
      )
    )
  )
  for argName, argType in procArgs.items:
    syncProcBody.add(
      newAssignment(newDotExpr(ident("result"), argName), argName)
    )
  syncProcDef.body = syncProcBody
    # proc `procName`(arg1, arg2,...): ptr `className` {.isStatic.} =
    #   result = ueNew[`className`]
    #   result.arg1 = arg1
    #   result.arg2 = arg2
    #   ...

  let syncProcUFunction = quote do:
    UFunction(BlueprintCallable, meta = (BlueprintInternalUseOnly = "true"), Category = `category`):
      `syncProcDef`
  classBody.add(syncProcUFunction[0])

  result.add(uclassDef.add(classBody))