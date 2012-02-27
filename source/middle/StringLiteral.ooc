import Statement, Expression, Type, Resolver, Literal
import ../frontend/Token

StringLiteral: class extends Literal {
    value: String = null
    type = ArrayType new(Type new("char",nullToken)) as Type

    init: func(=value,=token)
    clone: func -> This {
        StringLiteral new(value,token)
    }

    toString: func -> String {
        value
    }
}

