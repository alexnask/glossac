import Statement, Expression, Type, Resolver
import ../frontend/Token

CharLiteral: class extends Expression {
    value: String = null
    type := static Type new("char", nullToken)

    init: func(=value,=token)
    clone: func -> This {
        CharLiteral new(value,token)
    }

    getType: func -> Type {
        type
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        type resolve(resolver)
        resolver pop(this)
        resolved? = true
    }

    toString: func -> String {
        value
    }
}

