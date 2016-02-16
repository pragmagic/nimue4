# Copyright 2016 Xored Software, Inc.

type
  DelegateKind* = enum
    dkSimple,
    dkMulticast,
    dkDynamic,
    dkDynamicMulticast,
    dkSimpleRetVal,
    dkMulticastRetVal,
    dkDynamicRetVal,
    dkDynamicMulticastRetVal

const RetValDelegates = {dkSimpleRetVal, dkMulticastRetVal, dkDynamicRetVal, dkDynamicMulticastRetVal}
const DynamicDelegates = {dkDynamic, dkDynamicMulticast, dkDynamicRetVal, dkDynamicMulticastRetVal}
const MulticastDelegates = {dkMulticast, dkMulticastRetVal, dkDynamicMulticast, dkDynamicMulticastRetVal}

proc declareDelegate(name: NimNode,
                     kind: DelegateKind,
                     header: string,
                     procParams: seq[NimNode] = @[],
                     retType: NimNode = newEmptyNode()): NimNode =
  let callbackParams = newNimNode(nnkFormalParams).add(retType, newIdentDefs(ident("t"), ident("T"))).add(procParams)
  let callbackType = newIdentDefs(ident("callback"), newNimNode(nnkProcTy).add(callbackParams, newEmptyNode()))

  let bindTemplateBodyStr = """{.emit: "$#.Bind(`$#`, & $#::$#);".format(
              expandObjReference(astToStr(delegate)), astToStr(objPtr),
              type(objPtr[]).name, astToStr(callback)).}
"""
  var bindTemplate = newProc(
    name = postfix(ident("bind"), "*"),
    params = @[newEmptyNode(), newIdentDefs(ident("delegate"), name),
               newIdentDefs(ident("objPtr"), newNimNode(nnkPtrTy).add(ident("T")))] & @[callbackType],
    body = newStmtList(parseExpr(bindTemplateBodyStr)),
    procType = nnkTemplateDef
  )
  bindTemplate[2] = newNimNode(nnkGenericParams).add(newIdentDefs(ident("T"), newEmptyNode()))
  var addTemplate = newProc(
    name = postfix(ident("add"), "*"),
    body = newStmtList(parseExpr(bindTemplateBodyStr.replace("Bind", "Add"))),
    procType = nnkTemplateDef
  )
  # copy params
  addTemplate[2] = bindTemplate[2].copyNimTree()
  addTemplate[3] = bindTemplate[3].copyNimTree()

  var executeProc = newProc(
    name = postfix(ident("execute"), "*"),
    body = newEmptyNode(),
    params = @[retType, newIdentDefs(ident("delegate"), name)] & @procParams
  )
  let headerPragma = newNimNode(nnkExprColonExpr).add(ident("header"), newStrLitNode(header))
  executeProc.pragma = newNimNode(nnkPragma)
  executeProc.pragma.add(headerPragma)

  var executeIfBoundProc = executeProc.copyNimTree()
  executeIfBoundProc.name = postfix(ident("executeIfBound"), "*")

  let importcppExecutePragma = newNimNode(nnkExprColonExpr).add(ident("importcpp"), newStrLitNode("#.Execute(@)"))
  executeProc.pragma.add(importcppExecutePragma)

  let importcppExecuteIfBoundPragma = newNimNode(nnkExprColonExpr).add(
    ident("importcpp"), newStrLitNode("#.ExecuteIfBound(@)"))
  executeIfBoundProc.pragma.add(importcppExecuteIfBoundPragma)

  result = parseStmt("""
type $1* {.importcpp: "$1", header: "$2".} = object
proc isBound*(delegate: $1) {.importcpp: "#.IsBound(@)", header: "$2".}
""".format($(name.ident), header))

  let dynamicProcs = parseStmt("""
proc bindDynamic*(delegate: $1, obj: ptr, methodName: string) {.importcpp: "BindDynamic", header: "$2".}
proc addDynamic*(delegate: $1, obj: ptr, methodName: string) {.importcpp: "AddDynamic", header: "$2".}
proc removeDynamic*(delegate: $1, obj: ptr, methodName: string) {.importcpp: "RemoveDynamic", header: "$2".}
""".format($(name.ident), header))

  if DynamicDelegates.contains(kind):
    for statement in dynamicProcs:
      result.add(statement)

  result.add(executeProc)
  result.add(executeIfBoundProc)
  result.add(bindTemplate)

  if MulticastDelegates.contains(kind):
    result.add(addTemplate)

proc exprListToParamList(callParams: NimNode, start: Natural, to: Natural): seq[NimNode] =
  ## Converts nnkExprColonExpr nodes to nnkIdentDefs
  result = @[]
  for i in start .. to:
    let opt = callParams[i]
    if opt.kind != nnkExprColonExpr:
      parseError(opt, "name and type expected, but found: " & opt.toStrLit.strVal)
    let paramDef = newIdentDefs(opt[0], opt[1])
    result.add(paramDef)

macro UEDelegate*(name: expr, kindNode: DelegateKind): stmt {.immediate.} =
  assert(name.kind == nnkIdent)
  let kind = fromStr[DelegateKind]($(kindNode.ident))

  let isRetVal = RetValDelegates.contains(kind)
  let retValType = (if isRetVal: $(callsite()[3]) & ", " else: "")
  let procParams = exprListToParamList(callsite(), if isRetVal: 4 else: 3, len(callsite()) - 1)
  let headerName = cppHeaderName(name)

  let delegateMacro = case kind:
    of dkSimple: "DECLARE_DELEGATE"
    of dkMulticast: "DECLARE_MULTICAST_DELEGATE"
    of dkDynamic: "DECLARE_DYNAMIC_DELEGATE"
    of dkDynamicMulticast: "DECLARE_DYNAMIC_MULTICAST_DELEGATE"
    of dkSimpleRetVal: "DECLARE_DELEGATE_RetVal"
    of dkMulticastRetVal: "DECLARE_MULTICAST_DELEGATE_RetVal"
    of dkDynamicRetVal: "DECLARE_DYNAMIC_DELEGATE_RetVal"
    of dkDynamicMulticastRetVal: "DECLARE_DYNAMIC_MULTICAST_DELEGATE_RetVal"

  let delegateMacroPostfix = case procParams.len:
    of 0: ""
    of 1: "_OneParam"
    else: "_" & numToWord(procParams.len) & "Params"

  var typesAndNamesStr = ""
  for param in procParams:
    typesAndNamesStr &= ", " & toCppType(param[1])

    if DynamicDelegates.contains(kind):
      # the invocation is different for dynamic delegates - names are provided as arguments
      typesAndNamesStr &= ", " & $(param[0].ident)

  let codeToEmit = """/*TYPESECTION*/
/*BEGIN_UNREAL_TYPE*/
$#$#($#$#$#);
/*END_UNREAL_TYPE*/
""".format(delegateMacro, delegateMacroPostfix, retValType, $(name.ident), typesAndNamesStr)

  result = declareDelegate(name, kind, headerName, procParams, if isRetVal: callsite()[3] else: newEmptyNode())
  result.add(newNimNode(nnkPragma).add(
              newNimNode(nnkExprColonExpr).add(ident("emit"), newStrLitNode(codeToEmit))))

macro declareBuiltinDelegate(name: expr, kindNode: DelegateKind, header: static[string]): stmt {.immediate.} =
  assert(name.kind == nnkIdent)
  let kind = fromStr[DelegateKind]($(kindNode.ident))

  let isRetVal = RetValDelegates.contains(kind)
  let retValType = (if isRetVal: $(callsite()[4]) & ", " else: "")
  let procParams = exprListToParamList(callsite(), if isRetVal: 5 else: 4, len(callsite()) - 1)

  result = declareDelegate(name, kind, header, procParams, if isRetVal: callsite()[4] else: newEmptyNode())