import io/File, text/[EscapeSequence]
import structs/[ArrayList, List, Stack, HashMap]
import ../middle/[Module,Expression,StructDecl,FunctionCall,FunctionDecl,Statement,Statement,Type,VariableAccess,VariableDecl,Node,Scope,If,Conditional,
       Else,Return,IntLiteral,CharLiteral,StringLiteral,ArrayAccess,BoolLiteral,FloatLiteral,Loop,While,FlowControl,Comparison,Parenthesis,UnaryOp,Cast,
       NullLiteral,BinaryOp,Ternary,RangeLiteral]
import Token

parse: extern proto func (AstBuilder, CString) -> Int

Foreach: class {}

// Basically we push stuff in the stack and modify the stacks last object with the called events.
// At the end, the stack should contain only Modules (?)
// Then, we resolve the modules in order, adding the symbols resolved to them. When a module asks for a symbol we first look in the module itself, the in the modules previously resolved. (From the smaller scope to the largest)
// Then, we go through each module and call the backend

// So we push the Module
// Here is a struct decl, we push it to stack
// Here is a variable decl, we push it to the struct decl
// Oh noes, onStatement() is called on the struct decl
// We pop it and we see the top of the stack is a module
// So we add it to the module's structure declarations
// etc...

AstBuilder: class {

    stack: Stack<Object>
    tokenPos : Int*
    module: Module
    
    init: func(path: String) {
        // This is really shitty right now
        // but basically we will here convert relative paths to absolute before creating the module
        module = Module new(path)
        stack = Stack<Object> new()
        stack push(module)
        parse(this, module path toCString())
    }

    onUse: unmangled(onUse) func (name: CString) {
        //module addUse(Use new(name toString(), params, token()))
    }

    onImport: unmangled(onImport) func (path, name: CString) {
        /*
        namestr := name toString()
        output : String = ((path == null) || (path@ == '\0')) ? namestr : path toString() + namestr
        module addImport(Import new( output , token()))
        */
    }

    /*
     * Structures
     */

    onStructStart: unmangled(onStructStart) func (name: CString) {
        structDecl := StructDecl new(name toString(),token())
        module addStructure(structDecl)
        stack push(structDecl)
    }
    
    onStructExtern: unmangled(onStructExtern) func(name: CString) {
        peek(StructDecl) externName = name toString()
    }

    onStructEnd: unmangled(onStructEnd) func {
        pop(StructDecl)
    }

    /*
     * Variable declarations
     */

    onVarDeclStart: unmangled(onVarDeclStart) func {
        stack push(Stack<VariableDecl> new())
    }

    onVarDeclName: unmangled(onVarDeclName) func (name: CString) {
        vDecl := VariableDecl new(name toString(), null, token())
        peek(Stack<VariableDecl>) push(vDecl)
    }

    onVarDeclExtern: unmangled(onVarDeclExtern) func (cexternName: CString) {
        externName := cexternName toString()
        vars := peek(Stack<VariableDecl>)
        if(externName empty?()) {
            vars each(|var| var externName = "")
        } else {
            if(vars getSize() != 1) {
                Exception new(token() formatMessage("[ERROR]: ", "Trying to set an extern name on several variables at once!")) throw()
            }
            vars peek() externName = cexternName toString()
        }
    }

    onVarDeclUnmangled: unmangled(onVarDeclUnmangled) func (cunmangledName: CString) {
        unmangledName :=cunmangledName toString()
        vars := peek(Stack<VariableDecl>)
        if(unmangledName empty?()) {
            vars each(|var| var unmangledName = "")
        } else {
            if(vars getSize() != 1) {
                //params errorHandler onError(SyntaxError new(token(), "Trying to set an unmangled name on several variables at once!"))
                "Trying to set an unmangled name on several variables at once!" println()
            }
            vars peek() unmangledName = cunmangledName toString()
        }
    }

    onVarDeclExpr: unmangled(onVarDeclExpr) func (expr: Expression) {
        peek(Stack<VariableDecl>) peek() expr = expr
    }

    onVarDeclType: unmangled(onVarDeclType) func (type: Type) {
        peek(Stack<VariableDecl>) each(|vd| vd type = type)
    }

    onVarDeclEnd: unmangled(onVarDeclEnd) func -> Object {
        stack := pop(Stack<VariableDecl>)
        if(stack getSize() == 1) return stack peek() as Object
        // FIXME: Better detection to avoid 'stack' being passed as a Statement to, say, an If
        return stack as Object
    }
    
    gotVarDecl: func (vd: VariableDecl) {
        match (node := peek(Object)) {
            case sDecl: StructDecl =>
                sDecl fields add(vd)
            case list: List<Node> =>
                //vd isArg = true
                list add(vd)
            case =>
                gotStatement(vd)
        }
    }

    /*
     * Types
     */

    onTypeNew: unmangled(onTypeNew) func (name: CString) -> Type {
        Type new(name toString() trim(), token())
    }

    onTypePointer: unmangled(onTypePointer) func (type: Type) -> Type {
        PointerType new(type, token())
    }

    onTypeBrackets: unmangled(onTypeBrackets) func (type: Type, inner: Expression) -> Type {
        ArrayType new(type, inner, token())
    }

    /*
     * Function types
     */

    onFuncTypeNew: unmangled(onFuncTypeNew) func -> FuncType {
        FuncType new(token())
    }

    onFuncTypeArgument: unmangled(onFuncTypeArgument) func (f: FuncType, argType: Type) {
        f argumentTypes add(argType)
    }

    onFuncTypeVarArg: unmangled(onFuncTypeVarArg) func (f: FuncType) {
        f argumentTypes add(VarArgType new(token()))
    }

    onFuncTypeReturnType: unmangled(onFuncTypeReturnType) func (f: FuncType, returnType: Type) {
        f returnType = returnType
    }

    /*
     * Functions
     */

    onFunctionStart: unmangled(onFunctionStart) func (name: CString) {
        stack push(FunctionDecl new(name toString(), token()))
    }

    onFunctionExtern: unmangled(onFunctionExtern) func (externName: CString) {
        peek(FunctionDecl) externName = externName toString()
    }

    onFunctionUnmangled: unmangled(onFunctionUnmangled) func (unmangledName: CString) {
        peek(FunctionDecl) unmangledName = unmangledName toString()
    }

    onFunctionArgsStart: unmangled(onFunctionArgsStart) func {
        stack push(peek(FunctionDecl) arguments)
    }

    onFunctionArgsEnd: unmangled(onFunctionArgsEnd) func {
        pop(ArrayList<VariableDecl>)
    }

    onFunctionReturnType: unmangled(onFunctionReturnType) func (type: Type) {
        peek(FunctionDecl) returnType = type
    }

    onFunctionBody: unmangled(onFunctionBody) func {
        peek(FunctionDecl) body = Scope new()
    }

    onFunctionEnd: unmangled(onFunctionEnd) func -> FunctionDecl {
        fDecl := pop(FunctionDecl)
        peek(Module) addFunction(fDecl)
        return fDecl
    }

    /*
     * Function calls
     */

    onFunctionCallStart: unmangled(onFunctionCallStart) func (name: CString) {
        stack push(FunctionCall new(name toString(), token()))
    }

    onFunctionCallArg: unmangled(onFunctionCallArg) func (expr: Expression) {
        peek(FunctionCall) args add(expr)
    }

    onFunctionCallEnd: unmangled(onFunctionCallEnd) func -> FunctionCall {
        pop(FunctionCall)
    }

    /*
     * Literals
     */

    onStringLiteral: unmangled(onStringLiteral) func (text: CString) -> StringLiteral {
        // Null byte automatically added
        StringLiteral new(text toString() replaceAll("\n", "\\n") replaceAll("\t", "\\t") + '\0', token())
    }

    onCharLiteral: unmangled(onCharLiteral) func (value: CString) -> CharLiteral {
        CharLiteral new(value toString(), token())
    }

    // statement
    onStatement: unmangled(onStatement) func (stmt: Statement) {
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
    }

    gotStatement: func (stmt: Statement) {
        node := peek(Node)
        match {
            case node instanceOf?(FunctionDecl) =>
                fDecl := node as FunctionDecl
                fDecl body add(stmt)
            case node instanceOf?(Conditional) =>
                cStmt := node as Conditional
                cStmt body add(stmt)
            case node instanceOf?(Loop) =>
                lStmt := node as Loop
                lStmt body add(stmt)
            case node instanceOf?(ArrayAccess) =>
                aa := node as ArrayAccess
                if(!stmt instanceOf?(Expression)) {
                    Exception new(token() formatMessage("[ERROR]: ", "Expected an expression here, not a statement!")) throw()
                }
                aa indices add(stmt as Expression)
            case node instanceOf?(Module) =>
                if(stmt instanceOf?(VariableDecl)) {
                    vd := stmt as VariableDecl
                    node as Module addVariable(vd)
                } else {
                    "Whatdafuck" println()
                }
            case node instanceOf?(Scope) =>
                node as Scope add(stmt)
            case =>
                "[gotStatement] Got a %s, don't know what to do with it, parent = %s\n" printfln(stmt toString(), node class name)
        }
    }

    onArrayAccessStart: unmangled(onArrayAccessStart) func (array: Expression) {
        stack push(ArrayAccess new(array, token()))
    }

    onArrayAccessEnd: unmangled(onArrayAccessEnd) func -> ArrayAccess {
        pop(ArrayAccess)
    }

    // return
    onReturn: unmangled(onReturn) func (expr: Expression) -> Return {
        Return new(expr, token())
    }

    // variable access
    onVarAccess: unmangled(onVarAccess) func (expr: Expression, name: CString) -> Expression {
        VariableAccess new(name toString(), expr, token())
    }

    // cast
    onCast: unmangled(onCast) func (expr: Expression, type: Type) -> Cast {
        Cast new(expr, type, token())
    }

    // A block is simply a Scope, used for local variable declarations etc
    onBlockStart: unmangled(onBlockStart) func {
        stack push(Scope new())
    }

    onBlockEnd: unmangled(onBlockEnd) func -> Scope {
        pop(Scope)
    }

    // if
    onIfStart: unmangled(onIfStart) func (condition: Expression) {
        stack push(If new(condition, token()))
    }

    onIfEnd: unmangled(onIfEnd) func -> If {
        pop(If)
    }

    // else
    onElseStart: unmangled(onElseStart) func {
        peek(If)
        stack push(Else new(token()))
    }

    onElseEnd: unmangled(onElseEnd) func -> Else {
        pop(Else)
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

    onForeachStep: unmangled(onForeachStep) func(step: Expression) {
        //peek(Foreach) step = step
    }

    onForeachEnd: unmangled(onForeachEnd) func -> Foreach {
        null
        //pop(Foreach)
    }

    // while
    onWhileStart: unmangled(onWhileStart) func (condition: Expression) {
        stack push(While new(condition, token()))
    }

    onWhileEnd: unmangled(onWhileEnd) func -> While {
        pop(While)
    }

    /*
     * Arguments
     */
    onVarArg: unmangled(onVarArg) func (name: CString) {
        peek(List<Node>) add(VariableDecl new(name toString(), VarArgType new(token()), token()))
    }

    onTypeArg: unmangled(onTypeArg) func (type: Type) {
        peek(List<Node>) add(VariableDecl new("", type, token()))
    }

    onBreak: unmangled(onBreak) func -> FlowControl {
        FlowControl new(FlowAction _break, token())
    }

    onContinue: unmangled(onContinue) func -> FlowControl {
        FlowControl new(FlowAction _continue, token())
    }

    onEquals: unmangled(onEquals) func (left, right: Expression) -> Comparison {
        Comparison new(left, right, ComparisonType eq, token())
    }

    onNotEquals: unmangled(onNotEquals) func (left, right: Expression) -> Comparison {
        Comparison new(left, right, ComparisonType neq, token())
    }

    onLessThan: unmangled(onLessThan) func (left, right: Expression) -> Comparison {
        Comparison new(left, right, ComparisonType lt, token())
    }

    onMoreThan: unmangled(onMoreThan) func (left, right: Expression) -> Comparison {
        Comparison new(left, right, ComparisonType gt, token())
    }

    onLessThanOrEqual: unmangled(onLessThanOrEqual) func (left, right: Expression) -> Comparison {
        Comparison new(left, right, ComparisonType leqt, token())
    }
    onMoreThanOrEqual: unmangled(onMoreThanOrEqual) func (left, right: Expression) -> Comparison {
        Comparison new(left, right, ComparisonType geqt, token())
    }

    onDecLiteral: unmangled(onDecLiteral) func (value: CString) -> IntLiteral {
        IntLiteral new(value toString() replaceAll("_", "") toLLong(), token())
    }

    onOctLiteral: unmangled(onOctLiteral) func (value: CString) -> IntLiteral {
        IntLiteral new(value toString() replaceAll("_", "") substring(2) toLLong(8), token())
    }

    onBinLiteral: unmangled(onBinLiteral) func (value: CString) -> IntLiteral {
        IntLiteral new(value toString() replaceAll("_", "") substring(2) toLLong(2), token())
    }

    onHexLiteral: unmangled(onHexLiteral) func (value: CString) -> IntLiteral {
        IntLiteral new(value toString() replaceAll("_", "") toLLong(16), token())
    }

    onFloatLiteral: unmangled(onFloatLiteral) func (value: CString) -> FloatLiteral {
        FloatLiteral new(value toString() replaceAll("_", "") toFloat(), token())
    }

    onBoolLiteral: unmangled(onBoolLiteral) func (value: Bool) -> BoolLiteral {
        BoolLiteral new(value, token())
    }

    onNull: unmangled(onNull) func -> NullLiteral {
        NullLiteral new(token())
    }

    onTernary: unmangled(onTernary) func (condition, ifTrue, ifFalse: Expression) -> Ternary {
        Ternary new(condition, ifTrue, ifFalse, token())
    }

    onAssign: unmangled(onAssign) func (left, right: Expression) -> BinaryOp {
        BinaryOp new(left, right, BinaryOpType ass, token())
    }

    onAdd: unmangled(onAdd) func (left, right: Expression) -> BinaryOp {
        BinaryOp new(left, right, BinaryOpType add, token())
    }

    onSub: unmangled(onSub) func (left, right: Expression) -> BinaryOp {
        BinaryOp new(left, right, BinaryOpType sub, token())
    }

    onMod: unmangled(onMod) func (left, right: Expression) -> BinaryOp {
        BinaryOp new(left, right, BinaryOpType mod, token())
    }

    onMul: unmangled(onMul) func (left, right: Expression) -> BinaryOp {
        BinaryOp new(left, right, BinaryOpType mul, token())
    }

    onDiv: unmangled(onDiv) func (left, right: Expression) -> BinaryOp {
        BinaryOp new(left, right, BinaryOpType div, token())
    }

    onRangeLiteral: unmangled(onRangeLiteral) func (left, right: Expression) -> RangeLiteral {
        RangeLiteral new(left, right, token())
    }

    onBinaryLeftShift: unmangled(onBinaryLeftShift) func (left, right: Expression) -> BinaryOp {
        BinaryOp new(left, right, BinaryOpType lshift, token())
    }

    onBinaryRightShift: unmangled(onBinaryRightShift) func (left, right: Expression) -> BinaryOp {
        BinaryOp new(left, right, BinaryOpType rshift, token())
    }

    onLogicalOr: unmangled(onLogicalOr) func (left, right: Expression) -> BinaryOp {
        BinaryOp new(left, right, BinaryOpType or, token())
    }

    onLogicalAnd: unmangled(onLogicalAnd) func (left, right: Expression) -> BinaryOp {
        BinaryOp new(left, right, BinaryOpType and, token())
    }

    onBinaryOr: unmangled(onBinaryOr) func (left, right: Expression) -> BinaryOp {
        BinaryOp new(left, right, BinaryOpType bOr, token())
    }

    onBinaryXor: unmangled(onBinaryXor) func (left, right: Expression) -> BinaryOp {
        BinaryOp new(left, right, BinaryOpType bXor, token())
    }

    onBinaryAnd: unmangled(onBinaryAnd) func (left, right: Expression) -> BinaryOp {
        BinaryOp new(left, right, BinaryOpType bAnd, token())
    }

    onLogicalNot: unmangled(onLogicalNot) func (inner: Expression) -> UnaryOp {
        UnaryOp new(inner, UnaryOpType logicalNot, token())
    }

    onBinaryNot: unmangled(onBinaryNot) func (inner: Expression) -> UnaryOp {
        UnaryOp new(inner, UnaryOpType binaryNot, token())
    }

    onUnaryMinus: unmangled(onUnaryMinus) func (inner: Expression) -> UnaryOp {
        UnaryOp new(inner, UnaryOpType unaryMinus, token())
    }

    onParenthesis: unmangled(onParenthesis) func (inner: Expression) -> Parenthesis {
        Parenthesis new(inner, token())
    }

    onAddressOf: unmangled(onAddressOf) func (inner: Expression) -> UnaryOp {
        UnaryOp new(inner, UnaryOpType addressOf, token())
    }

    onDereference: unmangled(onDereference) func (inner: Expression) -> UnaryOp {
        UnaryOp new(inner, UnaryOpType dereference, token())
    }
    
    token: func -> Token {
        Token new(tokenPos[0], tokenPos[1], module)
    }
    
    peek: func <T> (T: Class) -> T {
        node := stack peek() as Node
        if(!node instanceOf?(T)) {
            "Should've peek'd a %s, but peek'd a %s. Stack = %s" format(T name, node class name, stackRepr()) println()
             exit(1)
        }
        return node
    }

    pop: func <T> (T: Class) -> T {
        node := stack pop() as Node
        if(!node instanceOf?(T)) {
            "Should've pop'd a %s, but pop'd a %s. Stack = %s" format(T name, node class name, stackRepr()) println()
            exit(1)
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
    
    error: func (errorID: Int, message: String, index: Int) {
        Exception new(Token new(index, 1, module) formatMessage("[ERROR]: ", message)) throw()
    }
}

// position in stream handling
setTokenPositionPointer: unmangled func (this: AstBuilder, tokenPos: Int*) { this tokenPos = tokenPos }

// string handling
StringClone: unmangled func (string: CString) -> CString             { string clone() }
mangleIdents: unmangled func (string: CString) -> CString            {
    string
}
trailingQuest: unmangled func (string: CString) -> CString           { (string toString() + "__quest") toCString() }
trailingBang:  unmangled func (string: CString) -> CString           { (string toString() + "__bang")  toCString() }
error: unmangled func (this: AstBuilder, errorID: Int, message: CString, index: Int) {
    msg : String = (message == null) ? null : message toString()
    this error(errorID, msg, index)
}

