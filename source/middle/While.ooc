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
        if(condition getType() pointerLevel() < 1 && !condition getType() number?()) resolver fail("Conditional expression neither a number nor a pointer", token)
        if(body) body resolve(resolver)
        resolver pop(this)
        resolved? = true
    }

    toString: func -> String {
        "Οσο %s\n%s\nΤέλος" format(condition toString(), body toString())
    }    
}

