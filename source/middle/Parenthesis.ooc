import Expression, Type, Resolver

Parenthesis: class extends Expression {
    inner: Expression = null
    init: func(=inner,=token)
    clone: func -> This {
        Parenthesis new(inner,token)
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        inner resolve(resolver)
        resolver pop(this)
        resolved? = true
    }

    getType: func -> Type {
        inner getType()
    }

    toString: func -> String {
        "( %s )" format(inner toString())
    }
}

