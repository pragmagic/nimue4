# Copyright 2016 Xored Software, Inc.

type
  TypeKind = enum
    tkClass,
    tkStruct,
    tkInterface,

  VarDeclaration = object
    name: string
    genName: string
    valueType: string
    defaultValue: NimNode

  ClassOpt = enum
    coExported
    coMinimalApi

  ClassMethod = object
    name: string
    genName: string
    isVirtual: bool
    isOverride: bool
    isConstructor: bool
    isExported: bool
    isCallSuper: bool
    isAbstract: bool
    isUFunction: bool
    args: seq[VarDeclaration]
    returnType: string
    uFunctionParamStr: string
    node: NimNode

  ClassField = object
    name: string
    valueType: string
    nimTypeNode: NimNode
    defaultValue: NimNode
    isUProperty: bool
    uPropertyParamStr: string

  ClassDefinition = object
    name: string
    parentName: string
    fields: seq[ClassField]
    methods: seq[ClassMethod]
    opts: set[ClassOpt]

# TODO: compare idents with eqIdent
var genNameCtr {.compileTime.} : uint64 = 0

proc toCppLiteral(nimLiteral: NimNode): string =
  # TODO: make this more compatible to C++ standards
  case nimLiteral.kind:
    of nnkStrLit..nnkTripleStrLit:
      result = repr(nimLiteral.strVal)
    of nnkFloatLit..nnkFloat64Lit:
      result = repr(nimLiteral.floatVal)
    of nnkCharLit:
      result = repr(chr(nimLiteral.intVal))
    of nnkIntLit..nnkUInt64Lit:
      result = $(nimLiteral.intVal)
    of nnkIdent:
      result = $(nimLiteral.ident)
    else:
      parseError(nimLiteral, "literal type expected, but got " & $(nimLiteral.kind))

proc toCppArgList(args: seq[VarDeclaration]): string {.compileTime.} =
  # have to do it this way, because of https://github.com/nim-lang/Nim/issues/3804
  var strArgs = newSeq[string](args.len)
  for i in 0 .. < args.len:
    let valueType = args[i].valueType
    let genName = args[i].genName
    strArgs[i] = valueType & " " & genName
  result = strArgs.join(", ")

proc toCppSignature(meth: ClassMethod, methodName: string): string {.compileTime.} =
  let virtualPrefix = if meth.isVirtual: "virtual " else: ""
  let overrideMarker = if meth.isOverride: " override" else: ""
  result = virtualPrefix & meth.returnType & " " & methodName & "(" & toCppArgList(meth.args) & ")" & overrideMarker

proc genName(name: string): string {.compileTime.} =
  result = name & "_" & $genNameCtr
  inc(genNameCtr)

proc extractParamString(callNode: NimNode): string =
  ## Extracts string in parens from an expression like
  ## CALL(param1, param2, param3 = value)
  assert(callNode.kind == nnkCall)

  var paramStrs: seq[string] = @[]
  for i in 1 .. callNode.len - 2:
    paramStrs.add(callNode[i].toStrLit.strVal)

  result = paramStrs.join(", ")

proc parseField(node: NimNode): ClassField =
  assert(node.kind == nnkCall)
  let fieldName = $(node[0])

  let valueNode = node[1][0]
  var valueType: string
  var defaultValue: NimNode
  var typeNode: NimNode
  if valueNode.kind == nnkAsgn:
    parseError(valueNode, "default values for fields are not supported for now") # TODO
    # has default value
    # typeNode = valueNode[0]
    # defaultValue = valueNode[1]
  else:
    typeNode = valueNode

  return ClassField(name: fieldName, valueType: toCppType(typeNode), nimTypeNode: typeNode, defaultValue: defaultValue)

proc parseUProperty(uPropertyNode: NimNode): ClassField =
  assert(uPropertyNode.kind == nnkCall and uPropertyNode[0].ident == !"UEProperty")

  if uPropertyNode[^1].kind != nnkStmtList or uPropertyNode[^1][0].kind != nnkCall:
    parseError(uPropertyNode, "expected field declaration after UEProperty")

  result = parseField(uPropertyNode[^1][0])
  result.isUProperty = true

  result.uPropertyParamStr = extractParamString(uPropertyNode)

proc parseArgs(node: NimNode): seq[VarDeclaration] =
  assert(node.kind == nnkFormalParams)

  result = @[]
  for i in 1 .. < node.len:
    let identDefs = node[i]
    if identDefs.kind != nnkIdentDefs:
      break
    if identDefs[^1].kind != nnkEmpty:
      parseError(identDefs, "default values for arguments are not supported for now") # TODO
    if identDefs[^2].kind == nnkEmpty:
      parseError(identDefs, "type inference is not supported for arguments") # TODO

    let argType = toCppType(identDefs[^2])
    for nameIndex in 0 .. < identDefs.len - 2:
      let name = $(identDefs[nameIndex].ident)
      let varDecl = VarDeclaration(
        name: name,
        genName: genName(name),
        valueType: argType,
        defaultValue: nil
      )
      result.add(varDecl)

proc parseMethod(className: string, node: NimNode): ClassMethod =
  assert(node.kind == nnkProcDef or node.kind == nnkMethodDef)

  if node[0].kind == nnkPostfix:
    raise newException(ParseError, lineinfo(node[0]) & ": proc markers (like asterisk) are not supported for now")
  if node[2].kind == nnkGenericParams:
    raise newException(ParseError, lineinfo(node[2]) & ": generic params are not supported for now")

  let name = $(node[0].ident)
  let isOverride = removePragma(node, "override")
  let isConstructor = removePragma(node, "constructor")
  let isAbstract = removePragma(node, "abstract")
  var returnType = ""
  if isConstructor:
    returnType = ""
  elif node[3][0].kind == nnkEmpty:
    returnType = "void"
  else:
    returnType = toCppType(node[3][0])

  var procNode = node
  if node.kind == nnkMethodDef:
    procNode = newNimNode(nnkProcDef)
    node.copyChildrenTo(procNode)
  result = ClassMethod(
    name: if isConstructor: className else: name,
    genName: className & "_" & genName(name),
    isAbstract: isAbstract,
    isOverride: isOverride,
    isVirtual: removePragma(node, "virtual") or (node.kind == nnkMethodDef) or isOverride or isAbstract,
    isConstructor: isConstructor,
    isCallSuper: removePragma(node, "callSuper"),
    isExported: true, # TODO
    args: parseArgs(node[3]),
    returnType: returnType,
    node: procNode
  )

  if result.isCallSuper and not (result.isOverride or result.isConstructor) :
    raise newException(ParseError, lineinfo(node) & ": can only call super from constructor or overriden methods")

  if result.isOverride and result.isAbstract:
    raise newException(ParseError, lineinfo(node) & ": cannot override abstract method")

proc parseUFunction(className: string, node: NimNode): ClassMethod =
  assert(node.kind == nnkCall and node[0].ident == !"UEFunction")

  const supportedRoutines = {nnkProcDef, nnkMethodDef}
  if node[^1].kind != nnkStmtList or not supportedRoutines.contains(node[^1][0].kind):
    raise newException(ParseError, lineinfo(node) & ": expected proc or mehtod declaration after `UEFunction`")

  result = parseMethod(className, node[^1][0])

  result.isUFunction = true
  result.uFunctionParamStr = extractParamString(node)

proc extractNames(kind: TypeKind, definition: NimNode): tuple[name: string, parentNames: seq[string]] =
  var name: string = nil
  var parentNames: seq[string] = @[]
  if definition.kind == nnkIdent:
    name = $(definition.ident)
  else:
    assert(definition.kind == nnkInfix and definition[0].ident == !"of")
    name = $(definition[1].ident)
    case definition[2].kind:
      of nnkIdent:
        parentNames.add($(definition[2].ident))
      of nnkPar:
        for id in definition[2]:
          assert(id.kind == nnkIdent, "identifier expected")
          parentNames.add($(id.ident))
      else:
        parseError(definition[2], "parent type(s) expected")

  # Verify UE type naming conventions
  assert(name.len > 2 and name[0].isUpper() and name[1].isUpper())
  case kind:
    of tkClass:
      assert(name.startsWith("F") or name.startsWith("A") or name.startsWith("U"))
    of tkStruct:
      assert(name.startsWith("F"))
    of tkInterface:
      assert(name.startsWith("I"))
      assert(parentNames.allIt(it.startsWith("I")))

  result = (name, parentNames)

proc genType(kind: TypeKind, definition: NimNode, callSite: NimNode): NimNode =
  let body = callSite[^1]
  let (name, parentNames) = extractNames(kind, definition)
  let primaryParentName: string = if parentNames.len > 0: parentNames[0] else: nil

  let headerName = cppHeaderName(definition)

  var opts: set[ClassOpt] = {}
  var paramStrs: seq[string] = @[]
  for i in 2 .. len(callSite) - 2:
    let optNode = callSite[i]
    if optNode.kind == nnkIdent and optNode.ident == !"exported":
      opts.incl(coExported)
    else:
      paramStrs.add(optNode.toStrLit.strVal)
  let paramString = paramStrs.join(", ")

  var methods: seq[ClassMethod] = @[]
  var fields: seq[ClassField] = @[]
  for statement in body:
    case statement.kind:
      of nnkCall:
        if statement[0].ident == !"UEProperty":
          assert(kind != tkInterface)
          fields.add(parseUProperty(statement))
        elif statement[0].ident == !"UEFunction":
          var meth = parseUFunction(name, statement)
          if kind == tkInterface:
            meth.isVirtual = true
            meth.isAbstract = true
          methods.add(meth)
        else:
          assert(kind != tkInterface)
          fields.add(parseField(statement))
      of nnkProcDef, nnkMethodDef:
        var meth = parseMethod(name, statement)
        if kind == tkInterface:
          meth.isVirtual = true
          meth.isAbstract = true
        methods.add(meth)
      else:
        raise newException(ParseError, lineinfo(statement) & ": Unexpected statement")

  let classDefinition = ClassDefinition(
    name: name,
    parentName: primaryParentName,
    fields: fields,
    methods: methods,
    opts: opts
  )
  # TODO: generate C++ "const" marker if `noSideEffect` pragma is provided

  # TODO: refactor this ugly piece of crap, use Ropes
  var fieldDeclarationCode = ""
  for field in classDefinition.fields:
    if field.isUProperty:
      fieldDeclarationCode &= "UPROPERTY($#)\n".format(field.uPropertyParamStr)
    let fieldName = field.name
    fieldDeclarationCode &= field.valueType & " " & fieldName
    var defaultValueCode = ""
    if field.defaultValue != nil:
      defaultValueCode = " = " & toCppLiteral(field.defaultValue)
    fieldDeclarationCode &= defaultValueCode & ";\n"

  var methodDeclarationCode = ""
  for meth in classDefinition.methods:
    var friendArgList = toCppArgList(meth.args)
    if friendArgList.strip() != "":
      friendArgList = ", " & friendArgList
    let returnType = if meth.isConstructor: "void" else: meth.returnType
    let friendSignature = "friend " & returnType & " `" & meth.genName & "`(" & classDefinition.name & "*" & friendArgList & ");\n"
    let methName = meth.name
    var invocationCode = ""
    for arg in meth.args:
      invocationCode &= ", " & arg.genName

    let superInvocation = "Super::" & methName.capitalize() & "(" & meth.args.mapIt(it.genName).join(", ") & ");\n";
    let signature = toCppSignature(meth, methName.capitalize())

    if not meth.isAbstract:
      methodDeclarationCode &= friendSignature
    if meth.isUFunction:
      methodDeclarationCode &= "UFUNCTION($#)\n".format(meth.uFunctionParamStr)

    methodDeclarationCode &= signature
    if meth.isAbstract:
      methodDeclarationCode &= " = 0;\n"
    else:
      methodDeclarationCode &= " {\n "
      if meth.isCallSuper:
        methodDeclarationCode &= superInvocation
      methodDeclarationCode &= "$# `$#`(this$#);\n".format(if meth.isConstructor or meth.returnType == "void": "" else: "return", meth.genName, invocationCode)
      methodDeclarationCode &= "}\n\n"

  let typeMacro = case kind:
    of tkClass: "UCLASS($#)" % paramString
    of tkStruct: "USTRUCT($#)" % paramString
    of tkInterface: ""

  let generatedBodyMacro = case kind:
    of tkClass: "GENERATED_BODY()"
    of tkStruct: "GENERATED_USTRUCT_BODY()"
    of tkInterface: "GENERATED_IINTERFACE_BODY()"

  let typeKind = case kind:
    of tkClass, tkInterface: "class"
    of tkStruct: "struct"

  let inheritanceExpr = if parentNames.len == 0: "" else: " : " & parentNames.mapIt("public `" & it & "`").join(", ")

  let interfaceHelperType = if kind != tkInterface: "" else: """
/*BEGIN_UNREAL_TYPE*/
UINTERFACE($1)
class $2 : public `UInterface`
{
  GENERATED_UINTERFACE_BODY()
};
/*END_UNREAL_TYPE*/
$2::$2(const `FObjectInitializer`& ObjectInitializer) : Super(ObjectInitializer)
{
}
""".format(paramString, "U" & name[1..^1])

  let exportPlaceholder = if classDefinition.opts.contains(coExported): "/*EXPORT_MACRO_PLACEHOLDER*/ " else: ""
  let codeToEmit = """/*TYPESECTION*/
$#
/*BEGIN_UNREAL_TYPE*/
$#
$# $#$#$# {
  $#
  protected:
$#
  public:
$#
};/*END_UNREAL_TYPE*/""".format(
    interfaceHelperType, typeMacro, typeKind, exportPlaceholder, name, inheritanceExpr,
    generatedBodyMacro, fieldDeclarationCode, methodDeclarationCode)

  var methDecls: seq[NimNode] = @[]
  var methDefs: seq[NimNode] = @[]
  for meth in classDefinition.methods:
    let thisDef = newNimNode(nnkIdentDefs).add(ident("this"), newNimNode(nnkPtrTy).add(ident(classDefinition.name)), newEmptyNode())
    meth.node[3].insert(1, thisDef)

    if not meth.isConstructor:
      var decl = meth.node.copy()
      decl[^1] = newEmptyNode() # remove body
      let cppName = meth.name.capitalize()
      decl.pragma = parseExpr("{.header: \"$#\", importcpp: \"#.$#(@)\", nodecl.}".format(headerName, cppName))
      methDecls.add(decl)

    meth.node[0] = ident(meth.genName)

    if not meth.isAbstract:
      if meth.node.pragma.kind == nnkEmpty:
        meth.node.pragma = newNimNode(nnkPragma)
      meth.node.pragma.add(ident("exportc"))

      methDefs.add(meth.node)

  let ofPostfix = if primaryParentName != nil : " of " & primaryParentName else: ""
  var typeDecl = parseStmt("""type $1* {.header: "$2", importcpp: "$1", inheritable.} = object$3""".format(classDefinition.name, headerName, ofPostfix))
  assert(typeDecl[0][0][2].kind == nnkObjectTy)
  var recList = newNimNode(nnkRecList)
  for field in classDefinition.fields:
    recList.add(newNimNode(nnkIdentDefs).add(ident(field.name), field.nimTypeNode, newEmptyNode()))
  typeDecl[0][0][2][2] = recList

  result = newStmtList()
  result.add(typeDecl)
  result.add(methDecls)
  result.add(methDefs)
  for nameInd in 1 .. < parentNames.len:
    # generate converter for each secondary parent type
    let parentName = parentNames[nameInd]
    var conv = newProc(
      name = ident("to" & parentName),
      params = [ident(parentName), newIdentDefs(ident("this"), ident(name))],
      body = newEmptyNode(),
      procType = nnkConverterDef
    )
    conv.pragma = newNimNode(nnkPragma)
    conv.pragma.add(makeStrPragma("importcpp", "#"))
    conv.pragma.add(ident("nodecl"))
  result.add(newNimNode(nnkPragma).add(
              newNimNode(nnkExprColonExpr).add(ident("emit"), newStrLitNode(codeToEmit))))

macro UEClass*(definition: expr, body: stmt): stmt {.immediate.} =
  result = genType(tkClass, definition, callsite())

macro UEStruct*(definition: expr, body: stmt): stmt {.immediate.} =
  result = genType(tkStruct, definition, callsite())

macro UEInterface*(definition: expr, body: stmt): stmt {.immediate.} =
  result = genType(tkInterface, definition, callsite())