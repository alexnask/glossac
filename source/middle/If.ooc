import Statement, Scope, Resolver, Type, Conditional

If: class extends Conditional {
    init: func(=condition,=token)
    clone: func -> This {
        c := If new(condition,token)
        c body = body
        c
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
        "Αν %s τότε\n%s\nΤέλος" format(condition toString(), body toString())
    }
}

