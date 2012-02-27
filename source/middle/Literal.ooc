import Expression, Type, Resolver

Literal: abstract class extends Expression {
    type: Type
    init: func(=token)

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        type resolve(resolver)
        resolver pop(this)
        resolved? = true
    }

    getType: func -> Type { type }
}

