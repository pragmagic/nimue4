# Copyright 2016 Xored Software, Inc.

import macros, strutils

type
  ParseError* = object of Exception

proc removePragma*(statement: NimNode, pname: string): bool =
  ## Removes the pragma from the node and returns whether pragma was removed
  var pragmas = statement.pragma()
  let pname = !pname
  for index in 0 .. < pragmas.len:
    if pragmas[index].kind == nnkIdent and pragmas[index].ident == pname:
      pragmas.del(index)
      return true

proc hasPragma*(statement: NimNode, pname: string): bool =
  ## Checks if the pragma is present in the `statement`
  var pragmas = statement.pragma()
  let pname = !pname
  for index in 0 .. < pragmas.len:
    if pragmas[index].kind == nnkIdent and pragmas[index].ident == pname:
      return true

proc removeStrPragma*(statement: NimNode, pname: string): string =
  ## Removes the pragma from the node and returns value of the pragma
  result = nil
  var pragmas = statement.pragma()
  let pname = !pname
  for index in 0 .. < pragmas.len:
    if pragmas[index].kind == nnkExprColonExpr and pragmas[index][0].ident == pname:
      let val = $(pragmas[index][1])
      pragmas.del(index)
      return val

proc fileNameNoExt*(node: NimNode): string =
  ## Returns name of the file containing the `node` without extension
  ## For example, if the node is located in "mymodule.nim", this will return "mymodule"

  let info = lineinfo(node)
  let dotIndex = info.rfind('.')
  result = info[0..<dotIndex]

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

proc toCppType*(typeNode: NimNode): string =
  ## Returns string representing C++ type corresponding to the specified Nim type
  ## Wraps non-primitive types in backtricks (`) for further use with .emit pragma

  case typeNode.kind:
  of nnkBracketExpr:
    var templateTypes: seq[string] = @[]
    for i in 1 .. < typeNode.len:
      templateTypes.add(toCppType(typeNode[i]))
    result = $(typeNode[0].ident) & "<" & templateTypes.join(", ") & ">"
  of nnkVarTy:
    result = toCppType(typeNode[0]) & "&"
  of nnkPtrTy:
    result = toCppType(typeNode[0]) & "*"
  of nnkIdent:
    case $(typeNode.ident):
    of "float32", "cfloat":
      result = "float"
    of "float64", "cdouble":
      result = "double"
    of "float", "uint", "int":
      raise newException(ParseError, lineinfo(typeNode) &
        ": avoid using types of undefined size - use size-defined alternative instead (e.g. float32, int32)")
    of "bool", "uint8", "uint16", "uint32", "uint64", "int8", "int16", "int32", "int64":
      result = $(typeNode.ident)
    else:
      result = "`" & $(typeNode.ident) & "`"
  else:
    raise newException(ParseError, lineinfo(typeNode) & ": type expected")

proc makeStrPragma*(name, val: string): NimNode {.compileTime.} =
  result = newNimNode(nnkExprColonExpr).add(ident(name), newStrLitNode(val))

template parseError*(node: NimNode, msg: string) =
  ## Shortcut to raise ParseError for specified `node` with specified message
  raise newException(ParseError, lineinfo(node) & ": " & msg)