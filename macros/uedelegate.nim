# Copyright 2016 Xored Software, Inc.

import macros, strutils, ropes
import "../lib/macroutils"

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

proc copyDelegateTemplate(t: NimNode; tBody: string; oldName, newName: string): NimNode =
  result = newProc(
    name = postfix(ident(newName.toLower()), "*"),
    body = newStmtList(parseExpr(tBody.replace(oldName, newName))),
    procType = nnkTemplateDef
  )
  # copy params
  result[2] = t[2].copyNimTree()
  result[3] = t[3].copyNimTree()

proc declareDelegate(name: NimNode,
                     kind: DelegateKind,
                     header: NimNode,
                     procParams: seq[NimNode] = @[],
                     retType: NimNode = newEmptyNode(),
                     namespace: NimNode = newEmptyNode()): NimNode =
  let callbackParams = newNimNode(nnkFormalParams).add(retType, newIdentDefs(ident("t"), ident("T"))).add(procParams)
  let callbackType = newIdentDefs(ident("callback"), newNimNode(nnkProcTy).add(callbackParams, newEmptyNode()))

  let bindTemplateBodyStr = """{.emit: "$#.Bind(`$#`, & $#::$#);".format(
              expandObjReference(astToStr(delegate)), astToStr(objPtr),
              type(objPtr[]).name, astToStr(callback).capitalize()).}
"""
  var bindTemplate = newProc(
    name = postfix(ident("bind"), "*"),
    params = @[newEmptyNode(), newIdentDefs(ident("delegate"), name),
               newIdentDefs(ident("objPtr"), ident("T"))] & @[callbackType],
    body = newStmtList(parseExpr(bindTemplateBodyStr)),
    procType = nnkTemplateDef
  )
  bindTemplate[2] = newNimNode(nnkGenericParams).add(newIdentDefs(ident("T"), newEmptyNode()))

  var bindUObjectTemplate = copyDelegateTemplate(bindTemplate, bindTemplateBodyStr, "Bind", "BindUObject")
  var addTemplate = copyDelegateTemplate(bindTemplate, bindTemplateBodyStr, "Bind", "Add")
  var addUObjectTemplate = copyDelegateTemplate(bindTemplate, bindTemplateBodyStr, "Bind", "AddUObject")

  var bindDynamicTemplate = copyDelegateTemplate(bindTemplate, bindTemplateBodyStr, "Bind", "BindDynamic")
  var addDynamicTemplate = copyDelegateTemplate(bindTemplate, bindTemplateBodyStr, "Bind", "AddDynamic")
  var removeDynamicTemplate = copyDelegateTemplate(bindTemplate, bindTemplateBodyStr, "Bind", "RemoveDynamic")

  var executeProc = newProc(
    name = postfix(ident("execute"), "*"),
    body = newEmptyNode(),
    params = @[retType, newIdentDefs(ident("delegate"), name)] & @procParams
  )
  let headerPragma = newNimNode(nnkExprColonExpr).add(ident("header"), header)
  executeProc.pragma = newNimNode(nnkPragma)
  executeProc.pragma.add(headerPragma)

  var broadcastProc = executeProc.copyNimTree()
  broadcastProc.name = postfix(ident("broadcast"), "*")
  let importcppBroadcastPragma = newNimNode(nnkExprColonExpr).add(ident("importcpp"), newStrLitNode("#.Broadcast(@)"))
  broadcastProc.pragma.add(importcppBroadcastPragma)

  var executeIfBoundProc = executeProc.copyNimTree()
  executeIfBoundProc.name = postfix(ident("executeIfBound"), "*")

  let importcppExecutePragma = newNimNode(nnkExprColonExpr).add(ident("importcpp"), newStrLitNode("#.Execute(@)"))
  executeProc.pragma.add(importcppExecutePragma)

  let importcppExecuteIfBoundPragma = newNimNode(nnkExprColonExpr).add(
    ident("importcpp"), newStrLitNode("#.ExecuteIfBound(@)"))
  executeIfBoundProc.pragma.add(importcppExecuteIfBoundPragma)

  let cppName = if namespace == nil or namespace.kind == nnkEmpty: $(name.ident)
                else: $namespace & "::" & $(name.ident)
  result = parseStmt("""
type $1* {.importcpp: "$2", header: $3.} = object
proc isBound*(delegate: $1): bool {.importcpp: "#.IsBound(@)", header: $3.}
proc clear*(delegate: $1) {.importcpp: "#.Clear(@)", header: $3.}
""".format($(name.ident), cppName, header.toStrLit.strVal))

  if DynamicDelegates.contains(kind):
    result.add(removeDynamicTemplate)

  if not MulticastDelegates.contains(kind):
    result.add(executeProc)
    result.add(executeIfBoundProc)
    if DynamicDelegates.contains(kind):
      result.add(bindDynamicTemplate)
    else:
      result.add(bindTemplate)
      result.add(bindUObjectTemplate)
  else:
    result.add(broadcastProc)
    if DynamicDelegates.contains(kind):
      result.add(addDynamicTemplate)
    else:
      result.add(addTemplate)
      result.add(addUObjectTemplate)
    let multicastProcs = parseStmt("""
proc removeAll*(delegate: $1, obj: ptr UObject) {.importcpp: "RemoveAll", header: $2.}
""".format($(name.ident), header.toStrLit.strVal))
    result.add(multicastProcs)

proc exprListToParamList(callParams: NimNode, start: Natural, to: Natural): seq[NimNode] =
  ## Converts nnkExprColonExpr nodes to nnkIdentDefs
  result = @[]
  for i in start .. to:
    let opt = callParams[i]
    if opt.kind != nnkExprColonExpr:
      parseError(opt, "name and type expected, but found: " & opt.toStrLit.strVal)
    let paramDef = newIdentDefs(opt[0], opt[1])
    result.add(paramDef)

macro udelegate*(name: expr, kindNode: DelegateKind): stmt {.immediate.} =
  assert(name.kind == nnkIdent)
  assert(kindNode.kind == nnkIdent, "Delegate type expected")
  let kind = fromStr[DelegateKind]($(kindNode.ident))

  let isRetVal = RetValDelegates.contains(kind)
  let retValType = (if isRetVal: $toCppType(callsite()[3]) & ", " else: "")
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

  var typesAndNamesStr: Rope
  for param in procParams:
    typesAndNamesStr.add(", " & toCppType(param[1]))

    if DynamicDelegates.contains(kind):
      # the invocation is different for dynamic delegates - names are provided as arguments
      typesAndNamesStr.add(", " & $(param[0].ident))

  let codeToEmit = """/*TYPESECTION*/
/*BEGIN_UNREAL_TYPE*/
$#$#($#$#$#);
/*END_UNREAL_TYPE*/
""".format(delegateMacro, delegateMacroPostfix, retValType, $(name.ident), typesAndNamesStr)

  result = declareDelegate(name, kind, newStrLitNode(headerName), procParams, if isRetVal: callsite()[3] else: newEmptyNode())
  result.add(newNimNode(nnkPragma).add(
              newNimNode(nnkExprColonExpr).add(ident("emit"), newStrLitNode(codeToEmit))))

macro declareBuiltinDelegate*(name: expr, kindNode: DelegateKind, header: expr): stmt {.immediate.} =
  assert(name.kind == nnkIdent)
  let kind = fromStr[DelegateKind]($(kindNode.ident))

  let isRetVal = RetValDelegates.contains(kind)
  let procParams = exprListToParamList(callsite(), if isRetVal: 5 else: 4, len(callsite()) - 1)

  result = declareDelegate(name, kind, header, procParams, if isRetVal: callsite()[4] else: newEmptyNode())

macro declareBuiltinDelegateWithNs*(name: expr, kindNode: DelegateKind, header: expr, namespace: expr): stmt {.immediate.} =
  assert(name.kind == nnkIdent)
  let kind = fromStr[DelegateKind]($(kindNode.ident))

  let isRetVal = RetValDelegates.contains(kind)
  let procParams = exprListToParamList(callsite(), if isRetVal: 6 else: 5, len(callsite()) - 1)

  result = declareDelegate(name, kind, header, procParams, if isRetVal: callsite()[5] else: newEmptyNode(), namespace)
