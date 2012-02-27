import Statement, Expression, Type, Resolver, Literal
import ../frontend/Token

BoolLiteral: class extends Literal {
    value: Bool
    type = Type new("bool",nullToken)

    init: func(=value,=token)
    clone: func -> This {
        BoolLiteral new(value,token)
    }

    toString: func -> String {
        value ? "true" : "false"
    }
}

