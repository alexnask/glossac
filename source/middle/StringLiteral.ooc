import Statement, Expression, Type, Resolver
import ../frontend/Token

StringLiteral: class extends Expression {
    value: String = null
    type := static ArrayType new(Type new("char",nullToken))

    init: func(=value,=token)
    clone: func -> This {
        StringLiteral new(value,token)
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        type resolve(resolver)
        resolver pop(this)
        resolved? = true
    }

    getType: func -> Type {
        type as Type
    }

    toString: func -> String {
        value
    }
}

