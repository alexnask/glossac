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
        if(condition getType() pointerLevel() < 1 && condition getType() toString() != "int") resolver fail("Conditional expression neither an int nor a pointer", token)
        if(body) body resolve(resolver)
        resolver pop(this)
    }

    toString: func -> String {
        "Αν %s τότε\n%s\nΤέλος" format(condition toString(), body toString())
    }
}

