import Statement, Expression, Type, Resolver
import ../frontend/Token

CharLiteral: class extends Expression {
    value: String = null

    init: func(=value,=token)
    clone: func -> This {
        CharLiteral new(value,token)
    }

    getType: func -> Type {
        Type new("char",nullToken)
    }

    toString: func -> String {
        value
    }
}

