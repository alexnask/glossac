import Expression, Type, Resolver

Ternary: class extends Expression {
    condition,ifTrue,ifFalse: Expression = null
    type: Type = null
    init: func(=condition,=ifTrue,=ifFalse,=token)
    clone: func -> This {
        Ternary new(condition,ifTrue,ifFalse,token)
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        condition resolve(resolver)
        ifTrue resolve(resolver)
        ifFalse resolve(resolver)

        if(!condition getType() scalar?()) resolver fail("Conditional expression can only be of scalar type (got %s)" format(condition getType() toString()), token)
        if(ifTrue getType() != ifFalse getType()) resolver fail("The two branches of a ternary expression should be of the same or compatible types (got %s and %s)" format(ifTrue getType() toString(), ifFalse getType() toString()), token)
        type = ifTrue getType() against(ifFalse getType())

        resolver pop(this)
        resolved? = true
    }

    getType: func -> Type { type }
    toString: func -> String {
        "( %s ) ? %s : %s" format(condition toString(), ifTrue toString(), ifFalse toString())
    }
}

