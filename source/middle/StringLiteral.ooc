import Statement, Expression, Type, Resolver
import ../frontend/Token

StringLiteral: class extends Expression {
    value: String = null

    init: func(=value,=token)
    clone: func -> This {
        StringLiteral new(value,token)
    }

    getType: func -> Type {
        ArrayType new(Type new("char",nullToken))
    }

    toString: func -> String {
        value
    }
}

