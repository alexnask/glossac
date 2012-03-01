import ../frontend/AstBuilder
import ../middle/[Module, ArrayAccess, Comparison, FloatLiteral, If, Node, Return, Ternary, While, BinaryOp, Conditional, FlowControl, IntLiteral, NullLiteral, Scope, Type, BoolLiteral, Decl, Foreach, Literal, Parenthesis, Statement, UnaryOp, Cast, Else, FunctionCall, Loop, RangeLiteral, StringLiteral, VariableAccess, CharLiteral, Expression, FunctionDecl, StructDecl, VariableDecl]

// This is the base class for any backend.
Backend: abstract class {
    baseModule: Module
    init: func(=baseModule)
    run: func { visit(baseModule) }

    visit: func(node: Node) {
        match (node) {
            case module: Module => visitModule(module)
            case arrAcc: ArrayAccess => visitArrayAccess(arrAcc)
            case floatLit: FloatLiteral => visitFloatLiteral(floatLit)
            case ifStmt: If => visitIf(ifStmt)
            case ret: Return => visitReturn(ret)
            case ternary: Ternary => visitTernary(ternary)
            case whileStmt: While => visitWhile(whileStmt)
            case binOp: BinaryOp => visitBinaryOp(binOp)
            case flowControl: FlowControl => visitFlowControl(flowControl)
            case intLit: IntLiteral => visitIntLiteral(intLit)
            case nullLit: NullLiteral => visitNullLiteral(nullLit)
            case scope: Scope => visitScope(scope)
            case type: Type => visitType(type)
            case boolLit: BoolLiteral => visitBoolLiteral(boolLit)
            case foreach: Foreach => visitForeach(foreach)
            case parenthesis: Parenthesis => visitParenthesis(parenthesis)
            case unOp: UnaryOp => visitUnaryOp(unOp)
            case cast: Cast => visitCast(cast)
            case elseStmt: Else => visitElse(elseStmt)
            case fCall: FunctionCall => visitFunctionCall(fCall)
            case rangeLit: RangeLiteral => visitRangeLiteral(rangeLit)
            case strLit: StringLiteral => visitStringLiteral(strLit)
            case varAcc: VariableAccess => visitVariableAccess(varAcc)
            case charLit: CharLiteral => visitCharLiteral(charLit)
            case fDecl: FunctionDecl => visitFunctionDecl(fDecl)
            case sDecl: StructDecl => visitStructDecl(sDecl)
            case vDecl: VariableDecl => visitVariableDecl(vDecl)
            case => "Dunno what to do with %s D:" format(node toString())
        }
    }

    visitModule: abstract func(module: Module)
    visitArrayAccess: abstract func(arrAcc: ArrayAccess)
    visitFloatLiteral: abstract func(floatLit: FloatLiteral)
    visitIf: abstract func(ifStmt: If)
    visitReturn: abstract func(ret: Return)
    visitTernary: abstract func(ternary: Ternary)
    visitWhile: abstract func(whileStmt: While)
    visitBinaryOp: abstract func(binOp: BinaryOp)
    visitFlowControl: abstract func(flowControl: FlowControl)
    visitIntLiteral: abstract func(intLit: IntLiteral)
    visitNullLiteral: abstract func(nullLit: NullLiteral)
    visitScope: abstract func(scope: Scope)
    visitType: abstract func(type: Type)
    visitBoolLiteral: abstract func(boolLit: BoolLiteral)
    visitForeach: abstract func(foreach: Foreach)
    visitParenthesis: abstract func(parenthesis: Parenthesis)
    visitUnaryOp: abstract func(unOp: UnaryOp)
    visitCast: abstract func(cast: Cast)
    visitElse: abstract func(elseStmt: Else)
    visitFunctionCall: abstract func(fCall: FunctionCall)
    visitRangeLiteral: abstract func(rangeLit: RangeLiteral)
    visitStringLiteral: abstract func(strLit: StringLiteral)
    visitVariableAccess: abstract func(varAcc: VariableAccess)
    visitCharLiteral: abstract func(charLit: CharLiteral)
    visitFunctionDecl: abstract func(fDecl: FunctionDecl)
    visitStructDecl: abstract func(sDecl: StructDecl)
    visitVariableDecl: abstract func(vDecl: VariableDecl)
}

