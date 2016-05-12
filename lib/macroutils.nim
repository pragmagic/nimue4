# Copyright 2016 Xored Software, Inc.

import macros, strutils, ropes

type
  ParseError* = object of Exception

iterator pragmas*(node: NimNode): tuple[key: NimIdent, value: string, index: int] =
  assert node.kind in {nnkPragma, nnkEmpty}
  for index in countdown(node.len - 1, 0):
    if node[index].kind == nnkExprColonExpr:
      let val = $(node[index][1])
      yield (node[index][0].ident, val, index)
    elif node[index].kind == nnkIdent:
      yield (node[index].ident, nil, index)

proc removePragma*(statement: NimNode, pname: string): bool =
  ## Removes the pragma from the node and returns whether pragma was removed
  if not (RoutineNodes.contains(statement.kind) or statement.kind == nnkPragmaExpr):
    return false
  var pragmas = if RoutineNodes.contains(statement.kind): statement.pragma() else: statement[1]
  let pnameIdent = !pname
  for ident, val, i in pragmas(pragmas):
    if ident == pnameIdent:
      pragmas.del(i)
      return true

proc hasPragma*(statement: NimNode, pname: string): bool =
  ## Checks if the pragma is present in the `statement`
  if not (RoutineNodes.contains(statement.kind) or statement.kind == nnkPragmaExpr):
    return false
  var pragmas = if RoutineNodes.contains(statement.kind): statement.pragma() else: statement[1]
  let pnameIdent = !pname
  for ident, val, i in pragmas(pragmas):
    if ident == pnameIdent:
      return true

proc removeStrPragma*(statement: NimNode, pname: string): string =
  ## Removes the pragma from the node and returns value of the pragma
  ## Works for routine nodes or nnkPragmaExpr
  if not (RoutineNodes.contains(statement.kind) or statement.kind == nnkPragmaExpr):
    return nil

  result = nil
  var pragmas = if RoutineNodes.contains(statement.kind): statement.pragma() else: statement[1]
  let pnameIdent = !pname
  for ident, val, i in pragmas(pragmas):
    if ident == pnameIdent:
      pragmas.del(i)
      return (if val.isNil: "" else: val)

proc fileNameNoExt*(node: NimNode): string =
  ## Returns name of the file containing the `node` without extension
  ## For example, if the node is located in "mymodule.nim", this will return "mymodule"

  let info = lineinfo(node)
  let dotIndex = info.rfind('.')
  var slashIndex = info.rfind('/')
  if slashIndex == -1:
    slashIndex = info.rfind('\\')
  result = info[slashIndex + 1 .. <dotIndex]

proc numToWord*(num: Natural): string {.compileTime.} =
  ## Converts number to English phrase representing the number
  ## Used when code-generating UE's delegate macros (e.g. DECLARE_DELEGATE_EightParams)

  const nums = ["Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven",
                "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen",
                "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen",
                "Nineteen"]

  if num >= nums.len():
    raise newException(ValueError, "Sorry, I can only count up to 19")

  return nums[num]

template expandObjReference*(r: string): expr =
  ## Changes "this.something" into "this->something".
  ## Useful when interfacing with methods accepting method pointers

  const parts = r.split('.')
  const first = '`' & parts[0] & '`'
  # capitalize, because we expect all UE4 names to be uppercase
  const rest = parts[1..<parts.len].map(capitalize).join("->")
  "(" & first & (if rest.len > 0: "->" else: "") & rest & ")"

proc cppHeaderName*(node: NimNode): string =
  ## Returns C++ header name that should be used in code generated for the node
  result = fileNameNoExt(node) & ".h"

proc fromStr*[Enum](val: string): Enum {.compileTime.} =
  ## Gets enum value from its string representation
  ## Raises ValueError if there is no such value

  # is there a better way?
  for item in items(Enum):
    if $item == val:
      return item
  raise newException(ValueError, "Unknown enum value: " & val)

proc toCppType*(typeNode: NimNode; isUeSignature, isPrefixed: bool = false): Rope =
  ## Returns string representing C++ type corresponding to the specified Nim type
  ## Wraps non-primitive types in backtricks (`) for further use with .emit pragma

  case typeNode.kind:
  of nnkBracketExpr:
    var templateParams: Rope
    for i in 1 .. < typeNode.len:
      if templateParams.len != 0:
        templateParams.add(", ")
      templateParams.add(toCppType(typeNode[i]))
    result = rope($typeNode[0].ident) & "<" & templateParams & ">"
  of nnkVarTy:
    result = toCppType(typeNode[0], isUeSignature, true) & "&"
  of nnkPtrTy:
    result = toCppType(typeNode[0], isUeSignature, true) & "*"
  of nnkIdent:
    case $(typeNode.ident):
    of "float32", "cfloat":
      result = rope("float")
    of "float64", "cdouble":
      result = rope("double")
    of "float", "uint", "int":
      raise newException(ParseError, lineinfo(typeNode) &
        ": avoid using types of undefined size - use size-defined alternative instead (e.g. float32, int32)")
    of "bool", "uint8", "uint16", "uint32", "uint64", "int8", "int16", "int32", "int64":
      result = rope($(typeNode.ident))
    else:
      let typeName = $(typeNode.ident)
      if isUeSignature and not isPrefixed and
         typeName.len > 1 and typeName[0] == 'F' and typeName[1].isUpper:
        # sometimes UHT forcefully converts structure values to const references in signatures
        result = rope("const `") & typeName & "`&"
      else:
        result = rope("`") & $(typeNode.ident) & "`"
  else:
    raise newException(ParseError, lineinfo(typeNode) & ": type expected")

proc makeStrPragma*(name, val: string): NimNode {.compileTime.} =
  result = newNimNode(nnkExprColonExpr).add(ident(name), newStrLitNode(val))

template parseError*(node: NimNode, msg: string) =
  ## Shortcut to raise ParseError for specified `node` with specified message
  raise newException(ParseError, lineinfo(node) & ": " & msg)

proc extractIdent*(node: NimNode): NimNode =
  ## returns ident node
  case node.kind
  of nnkIdent:
    result = node
  of nnkPostfix:
    result = extractIdent(node[1])
  else:
    result = extractIdent(node[0])
