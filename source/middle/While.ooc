import Statement, Expression, Loop, Scope, Resolver

While: class extends Loop {
    condition: Expression = null
    init: func(=condition,=token)
    clone: func -> This {
        w := While new(condition,token)
        body list each(|stmt|
            w body add(stmt)
        )
        w
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        condition resolve(resolver)
        if(!condition getType() scalar?()) resolver fail("Conditional expression should be of a scalar type (got %s)" format(condition getType() toString()), token)
        if(body) body resolve(resolver)
        resolver pop(this)
        resolved? = true
    }

    toString: func -> String {
        "Οσο %s\n%s\nΤέλος" format(condition toString(), body toString())
    }    
}

