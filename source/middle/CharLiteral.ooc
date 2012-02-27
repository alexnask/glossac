import Statement, Expression, Type, Resolver, Literal
import ../frontend/Token

CharLiteral: class extends Literal {
    value: String = null
    type = Type new("char", nullToken)

    init: func(=value,=token)
    clone: func -> This {
        CharLiteral new(value,token)
    }

    toString: func -> String {
        value
    }
}

