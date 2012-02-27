import Expression, Type, Resolver, Literal
import ../frontend/Token

FloatLiteral: class extends Literal {
    value: Float
    type = Type new("float", nullToken)

    init: func(=value,=token)
    clone: func -> This {
        FloatLiteral new(value,token)
    }

    toString: func -> String {
        value toString()
    }
}

