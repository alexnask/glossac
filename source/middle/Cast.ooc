import Expression, Type, Resolver

// TODO: Is there any kind of checking between types we can do?
// Testing for same refLevels could be a thing but this is not necessarily a good idea as one type could extend a non-pointer C type and the other a pointer one, so the refLevels would be the same in gossa but not in the generated C source.
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

