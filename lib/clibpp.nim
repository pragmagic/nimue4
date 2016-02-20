# Source: https://github.com/onionhammer/clibpp
# Many modifications applied

## Easy way to 'Mock' C++ interface
import macros, parseutils, strutils
import macroutils

type TMacroOptions = tuple
    header, importc: NimNode
    className: NimNode
    ns: string
    inheritable: bool
    isNoDef: bool
    byCopy: bool

proc makeProcedure(className, ns: string, statement: NimNode, classNameNode: NimNode, classGenericParams: NimNode = newEmptyNode()): NimNode =
    ## Generate an imported procedure definition for the input class name
    var procName = if statement[0].kind == nnkAccQuoted: $(statement[0][0].basename) else: $(statement[0].basename)
    var pragmas  = statement.pragma
    var params   = statement.params

    var isOperator = false
    if statement[0].kind != nnkPostfix:
      statement[0] = postfix(statement[0], "*") # export all defined procs
    if statement[0][1].kind == nnkAccQuoted:
      isOperator = true

    if statement[2].kind == nnkEmpty:
      statement[2] = classGenericParams.copy()
    elif classGenericParams.kind != nnkEmpty:
      assert(statement[2].kind == nnkGenericParams)
      assert(classGenericParams.kind == nnkGenericParams)
      let tmp = statement[2]
      statement[2] = newNimNode(nnkGenericParams)
      classGenericParams.copyChildrenTo(statement[2])
      tmp.copyChildrenTo(statement[2])

    if pragmas.kind == nnkEmpty:
        statement.pragma = newNimNode(nnkPragma)
        pragmas = statement.pragma

    # Add importc (if static) or importcpp pragma
    var importCPragma: NimNode
    var thisNode: NimNode

    let isStatic = statement.removePragma("isStatic")
    let isConstructor = statement.hasPragma("constructor")
    let userSuppliedName = statement.removeStrPragma("cppname")
    let cppName = if userSuppliedName == nil: procName.capitalize() else: userSuppliedName
    # Check if static is set (and remove static pragma)
    if isStatic:
        assert(not isOperator)
        importCPragma = newNimNode(nnkExprColonExpr)
            .add(newIdentNode("importc"))
            .add(newStrLitNode(ns & className & "::" & procName))

        # If static, insert 'this: typedesc[`className`]' param
        thisNode = newNimNode(nnkIdentDefs)
            .add(newIdentNode("this"))
            .add(parseExpr("typedesc[" & className & "]"))
            .add(newNimNode(nnkEmpty))
    elif isConstructor:
      importCPragma = newNimNode(nnkExprColonExpr)
            .add(newIdentNode("importcpp"))
            .add(newStrLitNode(className & "(@)"))
    else:
        var importCppPattern = "#." & cppName & "(@)"
        if isOperator and userSuppliedName == nil:
          importCppPattern = case procName:
            of "[]": "(#[#])"
            of "[]=": "#[#] = #"
            else: "(# " & procName & " #)"
        importCPragma = newNimNode(nnkExprColonExpr).add(
          ident("importcpp"), newStrLitNode(importCppPattern))

        # If not static, insert 'this: `className`' param
        thisNode = newNimNode(nnkIdentDefs)
            .add(newIdentNode("this"))
            .add(classNameNode.copyNimTree())
            .add(newNimNode(nnkEmpty))

    if thisNode != nil:
      params.insert(1, thisNode)
    pragmas.add importCPragma

    result = statement
    if statement.kind == nnkMethodDef:
      # TODO: remove when https://github.com/nim-lang/Nim/issues/3848 is fixed
      result = newNimNode(nnkProcDef)
      statement.copyChildrenTo(result)

proc buildProceduresFromVar(className: NimNode; ns, header: string; varIdent, varType: NimNode): seq[NimNode] =
  let setterName = postfix(newNimNode(nnkAccQuoted).add(varIdent, ident("=")), "*")
  let getter = newProc(postfix(varIdent, "*"), [varType, newIdentDefs(ident("this"), className.copyNimTree())], newEmptyNode())
  let setter = newProc(setterName, [newEmptyNode(),
                                  newIdentDefs(ident("this"), className.copyNimTree()), # newNimNode(nnkVarTy).add(ident(classname))),
                                  newIdentDefs(ident("val"), varType)], newEmptyNode())

  let cppIdent = if varType.toStrLit.strVal == "bool": $varIdent else: ($varIdent).capitalize
  let getterImportCPragma = newNimNode(nnkExprColonExpr).add(
        ident("importcpp"), newStrLitNode("#." & cppIdent))
  let setterImportCPragma = newNimNode(nnkExprColonExpr).add(
        ident("importcpp"), newStrLitNode("#." & cppIdent & " = #"))
  let headerPragma = newNimNode(nnkExprColonExpr).add(
        ident("header"), newStrLitNode(header))

  getter.pragma = newNimNode(nnkPragma)
  getter.pragma.add(getterImportCPragma)
  getter.pragma.add(headerPragma)
  getter.pragma.add(ident("noSideEffect"))

  setter.pragma = newNimNode(nnkPragma)
  setter.pragma.add(setterImportCPragma)
  setter.pragma.add(headerPragma.copyNimTree())

  result = @[getter, setter]

proc parse_opts(className: NimNode; opts: seq[NimNode]): TMacroOptions =
    result.inheritable = true
    if opts.len == 1 and opts[0].kind == nnkStrLit:
        # user passed a header
        result.header = opts[0]
    else:
        for opt in opts.items:
            var handled = true
            case opt.kind
            of nnkExprEqExpr, nnkExprColonExpr:
                case ($ opt[0].ident).toLower
                of "header":
                    result.header = opt[1]
                of "importc":
                    result.importc = opt[1]
                of "namespace", "ns":
                    result.ns = $opt[1] & "::"
                else:
                    handled = false
            of nnkIdent:
                case ($ opt.ident).toLower
                of "notypedef":
                  result.isNoDef = true
                of "bycopy":
                  result.byCopy = true
                else:
                    handled = false
            else:
                handled = false

            if not handled:
                echo "Warning, unhandled argument: ", repr(opt)

    if not isNil(result.importc) or isNil(result.ns):
        result.ns = ""
    if not isNil(result.ns):
        result.importc = newStrLitNode(result.ns & $className)

    result.className = className

proc buildStaticAccessor(name,ty, className:NimNode; ns:string): NimNode =
    result = newProc(
        name = postfix(name, "*"),
        procType = nnkProcDef,
        body = newEmptyNode(),
        params = [ty, newIdentDefs(ident"ty", parseExpr("typedesc["& $(className) & "]"))]
    )
    let cppIdent = if ty.toStrLit.strVal == "bool": $name.basename else: ($name.basename).capitalize
    result.pragma = newNimNode(nnkPragma).add(
        ident"noDecl",
        newNimNode(nnkExprColonExpr).add(
            ident"importcpp",
            newLit(ns & $className & "::" & cppIdent & "@")))

macro namespace*(namespaceName: expr, body: stmt): stmt {.immediate.} =
    result = newStmtList()

    var newNamespace = newNimNode(nnkExprColonExpr).
        add(ident("ns"), namespaceName)

    # Inject new namespace into each class declaration
    for i in body.children:
        if $i[0] == "class":
            i.insert 2, newNamespace

    result.add body

proc extractVarName(node: NimNode): NimNode =
  ## returns ident node
  case node.kind
  of nnkPragmaExpr:
    result = extractVarName(node[0])
  of nnkPostfix:
    result = extractVarName(node[1])
  else:
    result = node

proc addVarPragma(node, pragma: NimNode): NimNode =
  assert({nnkExprColonExpr, nnkIdent}.contains(pragma.kind))

  if node.kind != nnkPragmaExpr:
    result = newNimNode(nnkPragmaExpr).add(node, newNimNode(nnkPragma).add(pragma))
  else:
    result = node
    result[1].add(pragma)

proc extractLeftIdent(node: NimNode): NimNode =
  if node.kind == nnkIdent:
    result = node
  else:
    result = extractLeftIdent(node[0])

proc flattenBracketExpr(node: NimNode): NimNode =
  assert(node.kind == nnkBracketExpr)
  result = newNimNode(nnkBracketExpr)
  for c in children(node):
    result.add(extractLeftIdent(c))

macro class*(className, opts: expr, body: stmt): stmt {.immediate.} =
    ## Defines a C++ class
    result = newStmtList()

    var parent: NimNode
    var className = className
    var genericParamsNode = newEmptyNode()
    if className.kind == nnkInfix and className[0].ident == !"of":
      parent = className[2]
      className = className[1]
    var classNameNode = className
    if className.kind == nnkBracketExpr:
      classNameNode = flattenBracketExpr(className)
      var idents = newNimNode(nnkIdentDefs)
      if className[1].kind == nnkExprColonExpr:
        className[1].copyChildrenTo(idents)
        idents.add(newEmptyNode())
      else:
        assert(className[1].kind == nnkIdent)
        className.copyChildrenTo(idents)
        idents.del(0)
        idents.add(newEmptyNode(), newEmptyNode())
      genericParamsNode = newNimNode(nnkGenericParams).add(idents)
      className = className[0]

    var oseq: seq[NimNode] = @[]
    if len(callsite()) > 3:
      # slots 2 .. -2 are arguments
      for i in 2 .. len(callsite())-2:
        oseq.add callsite()[i]
    let opts = parse_opts(className, oseq)

    # Declare a type named `className`, importing from C++
    var newType = parseExpr(
        "type $1* {.header:$2, importcpp$3.} = object".format(
            $ opts.className, repr(opts.header),
            (if opts.importc.isNil: "" else: ":"& repr(opts.importc))))
    newType[0][1] = genericParamsNode

    var recList = newNimNode(nnkRecList)
    newType[0][2][2] = recList
    if not parent.isNil:
        # Type has a parent
        newType[0][2][1] = newNimNode(nnkOfInherit).add(parent)
    elif opts.inheritable:
        # Add inheritable pragma
        newType[0][0][1].add(ident"inheritable")
    if opts.byCopy:
        newType[0][0][1].add(ident"bycopy")
    # Iterate through statements in class definition
    var body = callsite()[< callsite().len]
    if body.kind != nnkDo and body.kind != nnkStmtList:
      body = newEmptyNode()
    let classname_s = $opts.className
    # Fix for nnkDo showing up here
    if body.kind == nnkDo: body = body.body

    for statement in body.children:
        case statement.kind:
        of nnkProcDef, nnkMethodDef:
            # Add procs with header pragma
            var headerPragma = newNimNode(nnkExprColonExpr).add(
                ident("header"),
                opts.header.copyNimNode)
            var member = makeProcedure(classname_s, opts.ns, statement, classNameNode, genericParamsNode)
            member.pragma.add headerPragma
            if member.kind == nnkMethodDef:
              member.pragma.add(ident("base"))
            result.add member

        of nnkVarSection:
            # Add any var declared in the class to the type
            # create accessors for any static variables
            # proc varname* (ty:typedesc[classtype]): ty{.importcpp:"Class::StaticVar@"}
            var
                statics: seq[tuple[name,ty: NimNode]] = @[]
                fields : seq[tuple[name,ty: NimNode]] = @[]

            for id_def in children(statement):
                let ty = id_def[id_def.len - 2]

                for i in 0 .. id_def.len - 3:
                    # iterate over the var names, check each for isStatic pragma
                    let this_ident = id_def[i]
                    var isStatic = false
                    if this_ident.kind == nnkPragmaExpr:
                        for prgma in children(this_ident[1]):
                            if prgma.kind == nnkIdent and ($prgma).eqIdent("isStatic"):
                                statics.add((this_ident[0], ty))
                                isStatic = true
                                break

                    if not isStatic:
                      if opts.isNoDef:
                        let varNameNode = if this_ident.kind == nnkPragmaExpr: this_ident[0] else: this_ident
                        let members = buildProceduresFromVar(classNameNode, opts.ns, $(opts.header), varNameNode, ty)
                        result.add(members)
                      else:
                        fields.add((this_ident, ty))

                for n,ty in items(fields):
                  var varNameNode = n
                  let varNameIdent = extractVarName(n)
                  var cppName = removeStrPragma(varNameNode, "cppname")
                  if cppName == nil:
                    cppName = ($varNameIdent).capitalize
                  if cppName != $varNameIdent:
                    varNameNode = addVarPragma(varNameNode, makeStrPragma("importcpp", cppName))

                  recList.add newIdentDefs(varNameNode, ty)
                for n,ty in items(statics):
                    result.add buildStaticAccessor(n, ty, opts.className, opts.ns)

        else:
            result.add statement
    if not opts.isNoDef:
      result.insert(0, newType)
