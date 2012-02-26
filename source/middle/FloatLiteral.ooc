import Expression, Type, Resolver
import ../frontend/Token

FloatLiteral: class extends Expression {
    value: Float
    type := static Type new("float", nullToken)

    init: func(=value,=token)
    clone: func -> This {
        FloatLiteral new(value,token)
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
        value toString()
    }
}

