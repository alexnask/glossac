import Statement, Expression, Type, Resolver
import ../frontend/Token

BoolLiteral: class extends Expression {
    value: Bool
    type := static Type new("bool",nullToken)

    init: func(=value,=token)
    clone: func -> This {
        BoolLiteral new(value,token)
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        type resolve(resolver)
        resolver pop(this)
        resolved? = true
    }

    getType: func -> Type {
        type
    }

    toString: func -> String {
        value ? "true" : "false"
    }
}

