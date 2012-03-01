import ../Backend
import ../../middle/[Module, ArrayAccess, Comparison, FloatLiteral, If, Node, Return, Ternary, While, BinaryOp, Conditional, FlowControl, IntLiteral, NullLiteral, Scope, Type, BoolLiteral, Decl, Foreach, Literal, Parenthesis, Statement, UnaryOp, Cast, Else, FunctionCall, Loop, RangeLiteral, StringLiteral, VariableAccess, CharLiteral, Expression, FunctionDecl, StructDecl, VariableDecl]

PrinterBackend: class extends Backend {
    init: func(=baseModule)
    visitModule: func(module: Module) {
        module toString() println()
    }
    visitArrayAccess: func(arrAcc: ArrayAccess)
    visitFloatLiteral: func(floatLit: FloatLiteral)
    visitIf: func(ifStmt: If)
    visitReturn: func(ret: Return)
    visitTernary: func(ternary: Ternary)
    visitWhile: func(whileStmt: While)
    visitBinaryOp: func(binOp: BinaryOp)
    visitFlowControl: func(flowControl: FlowControl)
    visitIntLiteral: func(intLit: IntLiteral)
    visitNullLiteral: func(nullLit: NullLiteral)
    visitScope: func(scope: Scope)
    visitType: func(type: Type)
    visitBoolLiteral: func(boolLit: BoolLiteral)
    visitForeach: func(foreach: Foreach)
    visitParenthesis: func(parenthesis: Parenthesis)
    visitUnaryOp: func(unOp: UnaryOp)
    visitCast: func(cast: Cast)
    visitElse: func(elseStmt: Else)
    visitFunctionCall: func(fCall: FunctionCall)
    visitRangeLiteral: func(rangeLit: RangeLiteral)
    visitStringLiteral: func(strLit: StringLiteral)
    visitVariableAccess: func(varAcc: VariableAccess)
    visitCharLiteral: func(charLit: CharLiteral)
    visitFunctionDecl: func(fDecl: FunctionDecl)
    visitStructDecl: func(sDecl: StructDecl)
    visitVariableDecl: func(vDecl: VariableDecl)
}

