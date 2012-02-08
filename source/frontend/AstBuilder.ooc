import io/File, text/[EscapeSequence]
import structs/[ArrayList, List, Stack, HashMap]

parse: extern proto func (AstBuilder, CString) -> Int

/* reserved C99 keywords
reservedWords := ["auto", "int", "long", "char", "register", "short", "do",
                  "sizeof", "double", "struct", "switch", "typedef", "union",
                  "unsigned", "signed", "goto", "enum", "const"]
reservedHashs := computeReservedHashs(reservedWords)

ReservedKeywordError: class extends Error {
    init: super func ~tokenMessage
}

computeReservedHashs: func (words: String[]) -> ArrayList<Int> {
    list := ArrayList<Int> new()
    words length times(|i|
        word := words[i]
        list add(ac_X31_hash(word))
    )
    list
}
*/

AstBuilder: class {

    stack: Stack<Object>
    tokenPos : Int*

    onUse: unmangled(onUse) func (name: CString) {
        module addUse(Use new(name toString(), params, token()))
    }

    onImport: unmangled(onImport) func (path, name: CString) {
        namestr := name toString()
        output : String = ((path == null) || (path@ == '\0')) ? namestr : path toString() + namestr
        module addImport(Import new( output , token()))
    }

    /*
     * Structures
     */

    onStructStart: unmangled(onClassStart) func (name) {
        /*
        cDecl := ClassDecl new(name toString(), token())
        cDecl setVersion(getVersion())
        cDecl doc = doc toString()
        cDecl module = module
        module addType(cDecl)
        stack push(cDecl)
        */
    }

    onStructBody: unmangled(onClassBody) func {
        //peek(ClassDecl) addDefaultInit()
    }

    onStructEnd: unmangled(onClassEnd) func {
        //pop(ClassDecl)
    }

    /*
     * Variable declarations
     */

    onVarDeclStart: unmangled(onVarDeclStart) func {
        //stack push(Stack<VariableDecl> new())
    }

    onVarDeclName: unmangled(onVarDeclName) func (name) {
        //vDecl := VariableDecl new(null, name toString(), token())
        //vDecl doc = doc toString()
        //peek(Stack<VariableDecl>) push(vDecl)
    }

    onVarDeclExtern: unmangled(onVarDeclExtern) func (cexternName: CString) {
        /*
        externName := cexternName toString()
        vars := peek(Stack<VariableDecl>)
        if(externName empty?()) {
            vars each(|var| var setExternName(""))
        } else {
            if(vars getSize() != 1) {
                params errorHandler onError(SyntaxError new(token(), "Trying to set an extern name on several variables at once!"))
            }
            vars peek() setExternName(externName)
        }
        */
    }

    onVarDeclUnmangled: unmangled(onVarDeclUnmangled) func (cunmangledName: CString) {
        /*
        unmangledName :=cunmangledName toString()
        vars := peek(Stack<VariableDecl>)
        if(unmangledName empty?()) {
            vars each(|var| var setUnmangledName(""))
        } else {
            if(vars getSize() != 1) {
                params errorHandler onError(SyntaxError new(token(), "Trying to set an unmangled name on several variables at once!"))
            }
            vars peek() setUnmangledName(unmangledName)
        }
        */
    }

    onVarDeclExpr: unmangled(onVarDeclExpr) func (expr: Expression) {
        //peek(Stack<VariableDecl>) peek() setExpr(expr)
    }

    onVarDeclStatic: unmangled(onVarDeclStatic) func {
        //peek(Stack<VariableDecl>) each(|vd| vd setStatic(true))
    }

    onVarDeclType: unmangled(onVarDeclType) func (type: Type) {
        //peek(Stack<VariableDecl>) each(|vd| vd type = type)
    }

    onVarDeclEnd: unmangled(onVarDeclEnd) func -> Object {
        /*
        stack := pop(Stack<VariableDecl>)
        if(stack getSize() == 1) return stack peek() as Object
        // FIXME: Better detection to avoid 'stack' being passed as a Statement to, say, an If
        return stack as Object
        */
    }
    
    /*
    gotVarDecl: func (vd: VariableDecl) {
        hash := ac_X31_hash(vd getName())
        idx := reservedHashs indexOf(hash)
        if(idx != -1) {
            // same hash? compare length and then full-string comparison
            word := reservedWords[idx]
            if(word length() == vd getName() length() && word == vd getName()) {
                params errorHandler onError(ReservedKeywordError new(vd token, "%s is a reserved C99 keyword, you can't use it in a variable declaration" format(vd getName())))
            }
        }

        match (node := peek(Object)) {
            case tDecl: TypeDecl =>
                tDecl addVariable(vd)
            case list: List<Node> =>
                vd isArg = true
                list add(vd)
            case =>
                gotStatement(vd)
        }
    }
    */

    /*
     * Types
     */

    onTypeNew: unmangled(onTypeNew) func (name: CString) -> Type {
        //BaseType new(name toString() trim(), token())
    }

    onTypePointer: unmangled(onTypePointer) func (type: Type) -> Type {
        //PointerType new(type, token())
    }
s
    onTypeBrackets: unmangled(onTypeBrackets) func (type: Type, inner: Expression) -> Type {
        //ArrayType new(type, inner, token())
    }

    onTypeList: unmangled(onTypeList) func -> TypeList {
        //TypeList new(token())
    }

    onTypeListElement: unmangled(onTypeListElement) func (list: TypeList, element: Type) {
        //list types add(element)
    }

    /*
     * Function types
     */

    onFuncTypeNew: unmangled(onFuncTypeNew) func -> FuncType {
        /*
        f := FuncType new(token())
        f isClosure = true
        f
        */
    }

    onFuncTypeArgument: unmangled(onFuncTypeArgument) func (f: FuncType, argType: Type) {
        //f argTypes add(argType)
    }

    onFuncTypeVarArg: unmangled(onFuncTypeVarArg) func (f: FuncType) {
        // TODO: what if we actually want ooc varargs in a FuncType?
        // I'm really not sure what to do syntax-wise.
        //f varArg = VarArgType C
    }

    onFuncTypeReturnType: unmangled(onFuncTypeReturnType) func (f: FuncType, returnType: Type) {
        //f returnType = returnType
    }

    /*
     * Functions
     */

    onFunctionStart: unmangled(onFunctionStart) func (name) {
        /*
        fDecl := FunctionDecl new(name toString(), token())
        fDecl setVersion(getVersion())
        fDecl doc = doc toString()
        stack push(fDecl)
        */
    }

    onFunctionExtern: unmangled(onFunctionExtern) func (externName: CString) {
        //peek(FunctionDecl) setExternName(externName toString())
    }

    onFunctionUnmangled: unmangled(onFunctionUnmangled) func (unmangledName: CString) {
        //peek(FunctionDecl) setUnmangledName(unmangledName toString())
    }

    onFunctionArgsStart: unmangled(onFunctionArgsStart) func {
        //stack push(peek(FunctionDecl) args)
    }

    onFunctionArgsEnd: unmangled(onFunctionArgsEnd) func {
        //pop(ArrayList<Argument>)
    }

    onFunctionReturnType: unmangled(onFunctionReturnType) func (type: Type) {
        //peek(FunctionDecl) returnType = type
    }

    onFunctionBody: unmangled(onFunctionBody) func {
        //peek(FunctionDecl) hasBody = true
    }

    onFunctionEnd: unmangled(onFunctionEnd) func -> FunctionDecl {
        /*
        fDecl := pop(FunctionDecl)

        match(node := peek(Object)) {
            case module =>
                module addFunction(fDecl)
            case tDecl: TypeDecl =>
                tDecl addFunction(fDecl)
            case addon: Addon =>
                addon addFunction(fDecl)
        }
        return fDecl
        */
    }

    /*
     * Function calls
     */

    onFunctionCallStart: unmangled(onFunctionCallStart) func (name: CString) {
        //stack push(FunctionCall new(name toString(), token()))
    }

    onFunctionCallArg: unmangled(onFunctionCallArg) func (expr: Expression) {
        //peek(FunctionCall) args add(expr)
    }

    onFunctionCallEnd: unmangled(onFunctionCallEnd) func -> FunctionCall {
        //pop(FunctionCall)
    }

    onFunctionCallExpr: unmangled(onFunctionCallExpr) func (call: FunctionCall, expr: Expression) {
        //call expr = expr
    }

    /*
     * Literals
     */

    onStringLiteral: unmangled(onStringLiteral) func (text: CString) -> StringLiteral {
        StringLiteral new(text toString() replaceAll("\n", "\\n") replaceAll("\t", "\\t"), token())
    }

    onCharLiteral: unmangled(onCharLiteral) func (value: CString) -> CharLiteral {
        CharLiteral new(value toString(), token())
    }

    // statement
    onStatement: unmangled(onStatement) func (stmt: Statement) {
        /*
        match stmt {
            case vd: VariableDecl =>
                gotVarDecl(vd)
            case stack: Stack<VariableDecl> =>
                if(stack T inheritsFrom?(VariableDecl)) {
                    for(vd in stack) {
                        gotVarDecl(vd)
                    }
                }
            case =>
                gotStatement(stmt)
        }
        */
    }

    gotStatement: func (stmt: Statement) {
        /*
        node := peek(Node)

        match {
            case node instanceOf?(FunctionDecl) =>
                fDecl := node as FunctionDecl
                fDecl body add(stmt)
            case node instanceOf?(ControlStatement) =>
                cStmt := node as ControlStatement
                cStmt body add(stmt)
            case node instanceOf?(ArrayAccess) =>
                aa := node as ArrayAccess
                if(!stmt instanceOf?(Expression)) {
                    params errorHandler onError(SyntaxError new(stmt token, "Expected an expression here, not a statement!"))
                }
                aa indices add(stmt as Expression)
            case node instanceOf?(Module) =>
                if(stmt instanceOf?(VariableDecl)) {
                    vd := stmt as VariableDecl
                    vd setGlobal(true)
                }
                module := node as Module

                spec := getVersion()
                if(spec != null) {
                    vb := VersionBlock new(spec, token())
                    vb getBody() add(stmt)
                    module body add(vb)
                } else {
                    module body add(stmt)
                }
            case node instanceOf?(ClassDecl) =>
                cDecl := node as ClassDecl
                fDecl := cDecl lookupFunction(ClassDecl DEFAULTS_FUNC_NAME, "")
                if(fDecl == null) {
                    fDecl = FunctionDecl new(ClassDecl DEFAULTS_FUNC_NAME, cDecl token)
                    cDecl addFunction(fDecl)
                }
                fDecl getBody() add(stmt)
            case node instanceOf?(ArrayLiteral) =>
                arrayLit := node as ArrayLiteral
                if(!stmt instanceOf?(Expression)) {
                    params errorHandler onError(SyntaxError new(stmt token, "Expected an expression here, not a statement!"))
                }
                arrayLit getElements() add(stmt as Expression)
            case node instanceOf?(Tuple) =>
                tuple := node as Tuple
                if(!stmt instanceOf?(Expression)) {
                    params errorHandler onError(SyntaxError new(stmt token, "Expected an expression here, not a statement!"))
                }
                tuple getElements() add(stmt as Expression)
            case =>
                "[gotStatement] Got a %s, don't know what to do with it, parent = %s\n" printfln(stmt toString(), node class name)
        }
        */
    }

    onArrayAccessStart: unmangled(onArrayAccessStart) func (array: Expression) {
        //stack push(ArrayAccess new(array, token()))
    }

    onArrayAccessEnd: unmangled(onArrayAccessEnd) func () -> ArrayAccess {
        //pop(ArrayAccess)
    }

    // return
    onReturn: unmangled(onReturn) func (expr: Expression) -> Return {
        //Return new(expr, token())
    }

    // variable access
    onVarAccess: unmangled(onVarAccess) func (expr: Expression, name: CString) -> VariableAccess {
        //return VariableAccess new(expr, name toString(), token())
    }

    // cast
    onCast: unmangled(onCast) func (expr: Expression, type: Type) -> Cast {
        //return Cast new(expr, type, token())
    }

    // block {}
    onBlockStart: unmangled(onBlockStart) func {
        //stack push(Block new(token()))
    }

    onBlockEnd: unmangled(onBlockEnd) func -> Block {
        //pop(Block)
    }

    // if
    onIfStart: unmangled(onIfStart) func (condition: Expression) {
        //stack push(If new(condition, token()))
    }

    onIfEnd: unmangled(onIfEnd) func -> If {
        //pop(If)
    }

    // else
    onElseStart: unmangled(onElseStart) func {
        //stack push(Else new(token()))
    }

    onElseEnd: unmangled(onElseEnd) func -> Else {
        //pop(Else)
    }

    // foreach
    onForeachStart: unmangled(onForeachStart) func (decl, collec: Expression) {
        /*
        if(decl instanceOf?(Stack)) {
            decl = decl as Stack<VariableDecl> pop()
        }
        stack push(Foreach new(decl, collec, token()))
        */
    }

    onForeachEnd: unmangled(onForeachEnd) func -> Foreach {
        //pop(Foreach)
    }

    // while
    onWhileStart: unmangled(onWhileStart) func (condition: Expression) {
        //stack push(While new(condition, token()))
    }

    onWhileEnd: unmangled(onWhileEnd) func -> While {
        //pop(While)
    }

    /*
     * Arguments
     */
    onVarArg: unmangled(onVarArg) func (name: CString) {
        //peek(List<Node>) add(VarArg new(token(), name ? name toString() : null))
    }

    onTypeArg: unmangled(onTypeArg) func (type: Type) {
        // TODO: add check for extern function (TypeArgs are illegal in non-extern functions.)
        //peek(List<Node>) add(Argument new(type, "", token()))
    }

    onBreak: unmangled(onBreak) func -> FlowControl {
        //FlowControl new(FlowAction _break, token())
    }

    onContinue: unmangled(onContinue) func -> FlowControl {
        //FlowControl new(FlowAction _continue, token())
    }

    onEquals: unmangled(onEquals) func (left, right: Expression) -> Comparison {
        //Comparison new(left, right, CompType equal, token())
    }

    onNotEquals: unmangled(onNotEquals) func (left, right: Expression) -> Comparison {
        //Comparison new(left, right, CompType notEqual, token())
    }

    onLessThan: unmangled(onLessThan) func (left, right: Expression) -> Comparison {
        //Comparison new(left, right, CompType smallerThan, token())
    }

    onMoreThan: unmangled(onMoreThan) func (left, right: Expression) -> Comparison {
        //Comparison new(left, right, CompType greaterThan, token())
    }

    onLessThanOrEqual: unmangled(onLessThanOrEqual) func (left, right: Expression) -> Comparison {
        //Comparison new(left, right, CompType smallerOrEqual, token())
    }
    onMoreThanOrEqual: unmangled(onMoreThanOrEqual) func (left, right: Expression) -> Comparison {
        //Comparison new(left, right, CompType greaterOrEqual, token())
    }

    onDecLiteral: unmangled(onDecLiteral) func (value: CString) -> IntLiteral {
        //IntLiteral new(value toString() replaceAll("_", "") toLLong(), token())
    }

    onOctLiteral: unmangled(onOctLiteral) func (value: CString) -> IntLiteral {
        //IntLiteral new(value toString() replaceAll("_", "") substring(2) toLLong(8), token())
    }

    onBinLiteral: unmangled(onBinLiteral) func (value: CString) -> IntLiteral {
        //IntLiteral new(value toString() replaceAll("_", "") substring(2) toLLong(2), token())
    }

    onHexLiteral: unmangled(onHexLiteral) func (value: CString) -> IntLiteral {
        //IntLiteral new(value toString() replaceAll("_", "") toLLong(16), token())
    }

    onFloatLiteral: unmangled(onFloatLiteral) func (value: CString) -> FloatLiteral {
        //FloatLiteral new(value toString() replaceAll("_", ""), token())
    }

    onBoolLiteral: unmangled(onBoolLiteral) func (value: Bool) -> BoolLiteral {
        //BoolLiteral new(value, token())
    }

    onNull: unmangled(onNull) func -> NullLiteral {
        //NullLiteral new(token())
    }

    onTernary: unmangled(onTernary) func (condition, ifTrue, ifFalse: Expression) -> Ternary {
        //Ternary new(condition, ifTrue, ifFalse, token())
    }

    onAssign: unmangled(onAssign) func (left, right: Expression) -> BinaryOp {
        //BinaryOp new(left, right, OpType ass, token())
    }

    onAdd: unmangled(onAdd) func (left, right: Expression) -> BinaryOp {
        //BinaryOp new(left, right, OpType add, token())
    }

    onSub: unmangled(onSub) func (left, right: Expression) -> BinaryOp {
        //BinaryOp new(left, right, OpType sub, token())
    }

    onMod: unmangled(onMod) func (left, right: Expression) -> BinaryOp {
        //BinaryOp new(left, right, OpType mod, token())
    }

    onMul: unmangled(onMul) func (left, right: Expression) -> BinaryOp {
        //BinaryOp new(left, right, OpType mul, token())
    }

    onDiv: unmangled(onDiv) func (left, right: Expression) -> BinaryOp {
        //BinaryOp new(left, right, OpType div, token())
    }

    onRangeLiteral: unmangled(onRangeLiteral) func (left, right: Expression) -> RangeLiteral {
        //RangeLiteral new(left, right, token())
    }

    onBinaryLeftShift: unmangled(onBinaryLeftShift) func (left, right: Expression) -> BinaryOp {
        //BinaryOp new(left, right, OpType lshift, token())
    }

    onBinaryRightShift: unmangled(onBinaryRightShift) func (left, right: Expression) -> BinaryOp {
        //BinaryOp new(left, right, OpType rshift, token())
    }

    onLogicalOr: unmangled(onLogicalOr) func (left, right: Expression) -> BinaryOp {
        //BinaryOp new(left, right, OpType or, token())
    }

    onLogicalAnd: unmangled(onLogicalAnd) func (left, right: Expression) -> BinaryOp {
        //BinaryOp new(left, right, OpType and, token())
    }

    onBinaryOr: unmangled(onBinaryOr) func (left, right: Expression) -> BinaryOp {
        //BinaryOp new(left, right, OpType bOr, token())
    }

    onBinaryXor: unmangled(onBinaryXor) func (left, right: Expression) -> BinaryOp {
        //BinaryOp new(left, right, OpType bXor, token())
    }

    onBinaryAnd: unmangled(onBinaryAnd) func (left, right: Expression) -> BinaryOp {
        //BinaryOp new(left, right, OpType bAnd, token())
    }

    onLogicalNot: unmangled(onLogicalNot) func (inner: Expression) -> UnaryOp {
        //UnaryOp new(inner, UnaryOpType logicalNot, token())
    }

    onBinaryNot: unmangled(onBinaryNot) func (inner: Expression) -> UnaryOp {
        //UnaryOp new(inner, UnaryOpType binaryNot, token())
    }

    onUnaryMinus: unmangled(onUnaryMinus) func (inner: Expression) -> UnaryOp {
        //UnaryOp new(inner, UnaryOpType unaryMinus, token())
    }

    onParenthesis: unmangled(onParenthesis) func (inner: Expression) -> Parenthesis {
        //Parenthesis new(inner, token())
    }

    onAddressOf: unmangled(onAddressOf) func (inner: Expression) -> AddressOf {
        //AddressOf new(inner, inner token)
    }

    onDereference: unmangled(onDereference) func (inner: Expression) -> Dereference {
        //Dereference new(inner, token())
    }

    token: func -> Token {
        Token new(tokenPos[0], tokenPos[1], module)
    }

    peek: func <T> (T: Class) -> T {
        node := stack peek() as Node
        if(!node instanceOf?(T)) {
            params errorHandler onError(InternalError new(token(), "Should've peek'd a %s, but peek'd a %s. Stack = %s" format(T name, node class name, stackRepr())))
        }
        return node
    }

    pop: func <T> (T: Class) -> T {
        node := stack pop() as Node
        if(!node instanceOf?(T)) {
            params errorHandler onError(InternalError new(token(), "Should've pop'd a %s, but pop'd a %s. Stack = %s" format(T name, node class name, stackRepr())))
        }
        return node
    }

    stackRepr: func -> String {
        sb := Buffer new()
        for(e in stack) {
            sb append(e class name). append(", ")
        }
        sb toString()
    }

}

// position in stream handling
setTokenPositionPointer: unmangled func (this: AstBuilder, tokenPos: Int*) { this tokenPos = tokenPos }

// string handling
StringClone: unmangled func (string: CString) -> CString             { string clone() }
mangleIdents: unmangled func (string: CString) -> CString            {
    if(string == "this") return "_this" toCString()
    string
}
trailingQuest: unmangled func (string: CString) -> CString           { (string toString() + "__quest") toCString() }
trailingBang:  unmangled func (string: CString) -> CString           { (string toString() + "__bang")  toCString() }
error: unmangled func (this: AstBuilder, errorID: Int, message: CString, index: Int) {
    msg : String = (message == null) ? null : message toString()
    this error(errorID, msg, index)
}

SyntaxError: class extends Error {
    init: super func ~tokenMessage
}

