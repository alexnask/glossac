import Statement, Scope, Resolver, Type, Conditional

Else: class extends Conditional {
    init: func(=token)
    clone: func -> This {
        c := Else new(token)
        c body = body
        c
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        if(body) body resolve(resolver)
        resolver pop(this)
        resolved? = true
    }

    toString: func -> String {
        "Αλλιώς\n%s\n" format(body toString())
    }
}

