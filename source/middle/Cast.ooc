import Expression, Type, Resolver

Cast: class extends Expression {
    expr: Expression = null
    type: Type = null
    init: func(=expr,=type,=token)
    clone: func -> This {
        Cast new(expr,type,token)
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        expr resolve(resolver)
        type resolve(resolver)
        resolver pop(this)
        resolved? = true
    }

    getType: func -> Type {
        type
    }

    toString: func -> String {
        "%s ως %s" format(expr toString(), type toString())
    }
}

