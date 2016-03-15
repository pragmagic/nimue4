# Copyright 2016 Xored Software, Inc.
import ropes

type
  TypeKind = enum
    tkClass,
    tkStruct,
    tkInterface,
    tkEnum

  VarDeclaration = ref object
    name: Rope
    genName: Rope
    valueType: Rope
    defaultValue: NimNode

  TypeOpt = enum
    coExported

  TypeMethod = ref object
    name: Rope
    genName: Rope
    isVirtual: bool
    isOverride: bool
    isConstructor: bool
    isExported: bool
    isCallSuper: bool
    isAbstract: bool
    isUFunction: bool
    args: seq[VarDeclaration]
    returnType: Rope
    uFunctionParamStr: Rope
    node: NimNode

  TypeField = ref object
    name: Rope
    nameNode: NimNode
    valueType: Rope
    nimTypeNode: NimNode
    defaultValueNode: NimNode
    isUProperty: bool
    uPropertyParamStr: Rope

  TypeDefinition = ref object
    node: NimNode
    name: Rope
    kind: TypeKind
    paramStr: Rope
    parentNames: seq[string]
    fields: seq[TypeField]
    methods: seq[TypeMethod]
    opts: set[TypeOpt]

var genNameCtr {.compileTime.} : uint64 = 0

proc isBlueprintNative(meth: TypeMethod): bool =
  result = meth.isUFunction and ($meth.uFunctionParamStr).contains("BlueprintNativeEvent")

proc isImplementationNeeded(meth: TypeMethod): bool =
  result = not (meth.isAbstract or meth.isBlueprintNative())

proc toCppLiteral(nimLiteral: NimNode): Rope =
  # TODO: make this more compatible to C++ standards
  case nimLiteral.kind:
    of nnkStrLit..nnkTripleStrLit:
      result = rope(repr(nimLiteral.strVal))
    of nnkFloatLit..nnkFloat64Lit:
      result = rope(repr(nimLiteral.floatVal))
    of nnkCharLit:
      result = rope(repr(chr(nimLiteral.intVal)))
    of nnkIntLit..nnkUInt64Lit:
      result = rope($(nimLiteral.intVal))
    of nnkIdent:
      result = rope($(nimLiteral.ident))
    else:
      parseError(nimLiteral, "literal type expected, but got " & $(nimLiteral.kind))

proc toCppArgList(args: seq[VarDeclaration]): Rope {.compileTime.} =
  for i in 0 .. < args.len:
    if result.len != 0:
      result.add(", ")
    # have to declare separate variables because of https://github.com/nim-lang/Nim/issues/3804
    let valueType = args[i].valueType
    let genName = args[i].genName
    result.add(valueType & " " & genName)

proc toCppSignature(meth: TypeMethod, methodName: Rope): Rope {.compileTime.} =
  result.add(if meth.isVirtual: "virtual " else: nil)
  result.add(meth.returnType & " " & methodName & "(" & toCppArgList(meth.args) & ")")
  result.add(if meth.isOverride: " override" else: nil)

proc toCppFieldName(name: string, valueType: string): Rope {.compileTime.} =
  if valueType == "bool":
    result = rope(name)
  else:
    result = rope(name.capitalize())

proc genName(name: string): Rope {.compileTime.} =
  result = rope(name) & "_" & $genNameCtr
  inc(genNameCtr)

proc extractParamString(callNode: NimNode): Rope =
  ## Extracts string in parens from an expression like
  ## CALL(param1, param2, param3 = value)
  assert(callNode.kind == nnkCall)

  for i in 1 .. callNode.len - 2:
    if result.len != 0:
      result.add(", ")
    result.add(callNode[i].toStrLit.strVal)

proc parseField(node: NimNode): TypeField =
  assert(node.kind == nnkVarSection)

  let identDefs = node[0]
  let nameNode = identDefs[0]
  let fieldName = $nameNode.baseName.ident

  let typeNode = identDefs[1]
  let defaultValueNode = identDefs[2]
  if defaultValueNode.kind != nnkEmpty:
    parseError(defaultValueNode, "default values for fields are not supported for now") # TODO

  result = TypeField(name: rope(fieldName),
                     nameNode: nameNode,
                     valueType: toCppType(typeNode),
                     nimTypeNode: typeNode,
                     defaultValueNode: defaultValueNode)

proc parseUProperty(typeKind: TypeKind, uPropertyNode: NimNode): TypeField =
  assert(uPropertyNode.kind == nnkCall and uPropertyNode[0].ident == !"UEProperty")

  if uPropertyNode[^1].kind != nnkStmtList or uPropertyNode[^1][0].kind != nnkVarSection:
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
      parseError(identDefs, "type inference is not supported for arguments")

    let argType = toCppType(identDefs[^2])
    for nameIndex in 0 .. < identDefs.len - 2:
      let name = $(identDefs[nameIndex].ident)
      let varDecl = VarDeclaration(
        name: rope(name),
        genName: genName(name),
        valueType: argType,
        defaultValue: nil
      )
      result.add(varDecl)

proc parseMethod(className: string, node: NimNode): TypeMethod =
  assert(node.kind == nnkProcDef or node.kind == nnkMethodDef)

  if node[2].kind == nnkGenericParams:
    raise newException(ParseError, lineinfo(node[2]) & ": generic params are not supported for now")

  let name = $(node[0].basename.ident)
  let isOverride = removePragma(node, "override")
  let isConstructor = removePragma(node, "constructor")
  let isAbstract = removePragma(node, "abstract")
  let isVirtual = removePragma(node, "virtual") or (node.kind == nnkMethodDef) or isOverride or isAbstract
  let isCallSuper = removePragma(node, "callSuper")
  var returnType: Rope
  if isConstructor:
    returnType = nil
  elif node[3][0].kind == nnkEmpty:
    returnType = rope("void")
  else:
    returnType = toCppType(node[3][0])

  var procNode = node
  if node.kind == nnkMethodDef:
    procNode = newNimNode(nnkProcDef)
    node.copyChildrenTo(procNode)

  let methName = rope(if isConstructor: className else: name)
  result = TypeMethod(
    name: methName,
    genName: rope(className) & "_" & genName(name),
    isAbstract: isAbstract,
    isOverride: isOverride,
    isVirtual: isVirtual,
    isConstructor: isConstructor,
    isCallSuper: isCallSuper,
    isExported: true, # TODO
    args: parseArgs(node[3]),
    returnType: returnType,
    node: procNode
  )

  if result.isCallSuper and not (result.isOverride or result.isConstructor) :
    raise newException(ParseError, lineinfo(node) & ": can only call super from constructor or overriden methods")

  if result.isOverride and result.isAbstract:
    raise newException(ParseError, lineinfo(node) & ": cannot override abstract method")

proc parseUFunction(className: string, node: NimNode): TypeMethod =
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
    of tkEnum:
      assert(name.startsWith("E"))

  result = (name, parentNames)

proc genCppFields(typeDef: TypeDefinition): Rope {.compileTime.} =
  for field in typeDef.fields:
    if field.isUProperty:
      result.add("UPROPERTY(" & field.uPropertyParamStr & ")\n")
    if typeDef.kind == tkEnum:
      result.add(field.name)
      result.add(",\n")
    else:
      result.add(field.valueType)
      result.add(" ")
      result.add(toCppFieldName($field.name, $field.valueType))
      if field.defaultValueNode != nil and field.defaultValueNode.kind != nnkEmpty:
        result.add(" = " & toCppLiteral(field.defaultValueNode))
      result.add(";\n")

proc genCppMethods(typeDef: TypeDefinition): Rope {.compileTime.} =
  for meth in typeDef.methods:
    var friendArgList = toCppArgList(meth.args)
    if friendArgList.len != 0:
      friendArgList = rope(", ") & friendArgList
    let returnType = if meth.isConstructor: rope("void") else: meth.returnType
    let friendSignature = rope("friend ") & returnType & " `" & meth.genName &
      "`(" & typeDef.name & "*" & friendArgList & ");\n"

    var invocationCode: Rope
    for arg in meth.args:
      invocationCode.add(rope(", ") & arg.genName)

    let methNameCapitalized = rope(($meth.name).capitalize())
    let signature = toCppSignature(meth, methNameCapitalized)

    if meth.isImplementationNeeded():
      # friend declaration is needed so that Nim procs have access to
      # private/protected fields
      result.add(friendSignature)
    if meth.isUFunction:
      result.add("UFUNCTION($#)\n".format(meth.uFunctionParamStr))

    result.add(signature)
    if meth.isAbstract:
      result.add(" = 0;\n")
    elif not meth.isImplementationNeeded():
      result.add(";\n")
    else:
      # append body that calls Nim procedure
      result.add(" {\n ")

      if meth.isCallSuper:
        let superInvocation = rope("Super::") & methNameCapitalized &
          "(" & meth.args.mapIt($(it.genName)).join(", ") & ");\n"
        result.add(superInvocation)
      let returnOrNothing = rope(if meth.isConstructor or $(meth.returnType) == "void": "" else: "return")
      result.addf("$# `$#`(this$#);\n",
                  [returnOrNothing, meth.genName, invocationCode])

      result.add("}\n\n")

proc genCppCode(typeDef: TypeDefinition): string {.compileTime.} =
  let typeMacro = case typeDef.kind:
    of tkClass: "UCLASS($#)\n" % $typeDef.paramStr
    of tkStruct: "USTRUCT($#)\n" % $typeDef.paramStr
    of tkEnum: "UENUM($#)\n" % $typeDef.paramStr
    of tkInterface: ""

  let generatedBodyMacro = case typeDef.kind:
    of tkClass: "GENERATED_BODY()\n"
    of tkStruct: "GENERATED_USTRUCT_BODY()\n"
    of tkInterface: "GENERATED_IINTERFACE_BODY()\n"
    of tkEnum: ""

  let typeKindStr = case typeDef.kind:
    of tkClass, tkInterface: "class"
    of tkStruct: "struct"
    of tkEnum: "enum class"

  let inheritanceExpr = if typeDef.parentNames.len == 0: nil
    else: rope(" : ") & typeDef.parentNames.mapIt("public `" & it & "`").join(", ") & " "

  let interfaceHelperType = if typeDef.kind != tkInterface: "" else: """
/*BEGIN_UNREAL_TYPE*/
UINTERFACE($1)
class $2 : public `UInterface`
{
  GENERATED_UINTERFACE_BODY()
};
/*END_UNREAL_TYPE*/
$2::$2(const `FObjectInitializer`& ObjectInitializer): Super(ObjectInitializer)
{
}
""".format($typeDef.paramStr, "U" & ($typeDef.name)[1..^1])

  var code = rope("/*TYPESECTION*/\n")
  code.add(interfaceHelperType)
  code.add("/*BEGIN_UNREAL_TYPE*/\n")

  code.add(typeMacro)

  code.add(typeKindStr & " ")
  let exportPlaceholder = if typeDef.opts.contains(coExported): "/*EXPORT_MACRO_PLACEHOLDER*/ " else: ""
  code.add(exportPlaceHolder)
  code.add(typeDef.name & " ")
  code.add(inheritanceExpr)
  code.add("{\n")

  code.add(generatedBodyMacro)

  if typeDef.kind != tkEnum:
    code.add("public:\n")

  code.add(genCppFields(typeDef))
  code.add(genCppMethods(typeDef))

  code.add("};/*END_UNREAL_TYPE*/\n")

  result = $code

proc genType(typeDef: TypeDefinition): NimNode {.compileTime.} =
  # TODO: generate C++ "const" marker if `noSideEffect` pragma is provided

  let codeToEmit = genCppCode(typeDef)
  let headerName = cppHeaderName(typeDef.node)

  var methDecls: seq[NimNode] = @[]
  var methDefs: seq[NimNode] = @[]
  for meth in typeDef.methods:
    let thisDef = newNimNode(nnkIdentDefs).add(
      ident("this"), newNimNode(nnkPtrTy).add(ident($typeDef.name)), newEmptyNode())
    meth.node[3].insert(1, thisDef)

    if not meth.isConstructor:
      var decl = meth.node.copy()
      decl[^1] = newEmptyNode() # remove body
      let cppName = ($meth.name).capitalize()
      decl.pragma = parseExpr("{.header: \"$#\", importcpp: \"#.$#(@)\", nodecl.}".format(headerName, cppName))
      methDecls.add(decl)

    meth.node[0] = ident($meth.genName)

    if meth.isImplementationNeeded():
      if meth.node.pragma.kind == nnkEmpty:
        meth.node.pragma = newNimNode(nnkPragma)
      meth.node.pragma.add(ident("exportc"))

      methDefs.add(meth.node)

  if typeDef.kind != tkEnum:
    let staticClassMeth = parseStmt("""
    proc staticClass*(ty: typedesc[$1]): TSubclassOf[$1] {.header: "$2", importc: "$1::StaticClass".}
""".format(typeDef.name, headerName))
    methDecls.add(staticClassMeth)

  let primaryParentName: string = if typeDef.parentNames.len > 0: typeDef.parentNames[0] else: nil
  let ofPostfix = if primaryParentName != nil : " of " & primaryParentName else: ""
  let additionalPragmas = case typeDef.kind:
    of tkEnum: ", pure, size: sizeof(cint)"
    of tkStruct: ", inheritable, bycopy"
    else: ", inheritable"
  let nimTypeKind = if typeDef.kind == tkEnum: "enum" else: "object"
  let enumFields = if typeDef.kind == tkEnum:
    "\n  " & typeDef.fields.mapIt($it.name).join(",")
    else: ""

  var typeDecl = parseStmt("""type $1* {.header: "$2", importcpp: "$1"$3.} = $4$5$6""".format(
    typeDef.name, headerName, additionalPragmas, nimTypeKind, ofPostfix, enumFields))

  if typeDef.kind != tkEnum:
    var recList = newNimNode(nnkRecList)
    for field in typeDef.fields:
      let pragmaNode = newNimNode(nnkPragma).add(
        makeStrPragma("importcpp", $toCppFieldName($field.name, $field.valueType)))
      let varIdent = newNimNode(nnkPragmaExpr).add(field.nameNode, pragmaNode)
      recList.add(newNimNode(nnkIdentDefs).add(varIdent, field.nimTypeNode, newEmptyNode()))
    typeDecl[0][0][2][2] = recList

  result = newStmtList()
  result.add(typeDecl)
  result.add(methDecls)
  result.add(methDefs)
  for nameInd in 1 .. < typeDef.parentNames.len:
    # generate converter for each secondary parent type
    let parentName = typeDef.parentNames[nameInd]
    var conv = newProc(
      name = ident("to" & parentName),
      params = [ident(parentName), newIdentDefs(ident("this"), ident($typeDef.name))],
      body = newEmptyNode(),
      procType = nnkConverterDef
    )
    conv.pragma = newNimNode(nnkPragma)
    conv.pragma.add(makeStrPragma("importcpp", "#"))
    conv.pragma.add(ident("nodecl"))
  result.add(newNimNode(nnkPragma).add(
              newNimNode(nnkExprColonExpr).add(ident("emit"), newStrLitNode(codeToEmit))))

proc parseType(kind: TypeKind, definition: NimNode, callSite: NimNode): TypeDefinition =
  let body = callSite[^1]
  let (name, parentNames) = extractNames(kind, definition)

  var opts: set[TypeOpt] = {}
  var paramStrs: seq[string] = @[]
  for i in 2 .. len(callSite) - 2:
    let optNode = callSite[i]
    if optNode.kind == nnkIdent and optNode.ident == !"exported":
      opts.incl(coExported)
    else:
      paramStrs.add(optNode.toStrLit.strVal)
  let paramString = paramStrs.join(", ")

  var methods: seq[TypeMethod] = @[]
  var fields: seq[TypeField] = @[]
  for statement in body:
    case statement.kind:
      of nnkCall:
        if statement[0].ident == !"UEProperty":
          assert(kind != tkInterface)
          fields.add(parseUProperty(kind, statement))
        elif statement[0].ident == !"UEFunction":
          var meth = parseUFunction(name, statement)
          if kind == tkInterface:
            meth.isVirtual = true
            meth.isAbstract = true
          methods.add(meth)
        else:
          parseError(statement, "expected UEProperty or UEFunction")
      of nnkVarSection:
        assert(kind != tkInterface)
        fields.add(parseField(statement))
      of nnkProcDef, nnkMethodDef:
        var meth = parseMethod(name, statement)
        if kind == tkInterface:
          meth.isVirtual = true
          meth.isAbstract = true
        if kind == tkInterface and meth.isUFunction:
          # UHT does some magic behind the scenes to make the method virtual
          # and overridable from blueprints
          meth.isVirtual = false
          meth.isAbstract = false
        methods.add(meth)
      of nnkIdent:
        if kind != tkEnum:
          parseError(statement, "field or method declaration expected")
        let field = TypeField(
          name: rope($statement.ident),
          nameNode: statement
        )
        fields.add(field)
      else:
        parseError(statement, "field or method declaration expected")

  result = TypeDefinition(
    node: definition,
    name: rope(name),
    kind: kind,
    parentNames: parentNames,
    paramStr: rope(paramString),
    fields: fields,
    methods: methods,
    opts: opts
  )

macro UEClass*(definition: expr, body: stmt): stmt {.immediate.} =
  let typeDef = parseType(tkClass, definition, callsite())
  result = genType(typeDef)

macro UEStruct*(definition: expr, body: stmt): stmt {.immediate.} =
  let typeDef = parseType(tkStruct, definition, callsite())
  result = genType(typeDef)

macro UEInterface*(definition: expr, body: stmt): stmt {.immediate.} =
  let typeDef = parseType(tkInterface, definition, callsite())
  result = genType(typeDef)

macro UEEnum*(definition: expr, body: stmt): stmt {.immediate.} =
  let typeDef = parseType(tkEnum, definition, callsite())
  result = genType(typeDef)
