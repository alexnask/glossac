import ../frontend/AstBuilder
import ../middle/[Module, ArrayAccess, Comparison, FloatLiteral, If, Node, Return, Ternary, While, BinaryOp, Conditional, FlowControl, IntLiteral, NullLiteral, Scope, Type, BoolLiteral, Decl, Foreach, Literal, Parenthesis, Statement, UnaryOp, Cast, Else, FunctionCall, Loop, RangeLiteral, StringLiteral, VariableAccess, CharLiteral, Expression, FunctionDecl, StructDecl, VariableDecl]

// This is the base class for any backend.
Backend: abstract class {
    visit: func(node: Node) {
    }
    visitModule: abstract func(module: Module)
}

