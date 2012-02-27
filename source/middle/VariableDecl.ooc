import Expression,Decl,Resolver,Type,NullLiteral

VariableDecl: class extends Decl {
    expr: Expression = null // This is the default expression of to be assigned to the variable once declared
    name: String // Name of the variable
    type: Type // Type of the variable

    init: func(=name,=type,=token)

    clone: func -> This {
        c := VariableDecl new(name,type,token)
        c expr = expr
        c externName = externName
        c unmangledName = unmangledName
        c
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return

        resolver push(this)

        redifinitionLevel := resolver checkVariableRedifinition(name)
        if(redifinitionLevel == 1) resolver warn("Definition of " + name + " shadows previous definition", token)
        else if(redifinitionLevel == 2) resolver fail("Illegal redifinition of " + name, token)

        type resolve(resolver)
        if(expr) {
            expr resolve(resolver)
            // We allow implicit casting of null to a pointer type :)
            if(expr getType() != type && !(type pointer?() && expr instanceOf?(NullLiteral))) {
                resolver fail("Type mismatch, expected " + type toString() + " got " + expr getType() toString(), token)
            }
        }
        resolver pop(this)
        resolved? = true
    }

    getType: func -> Type {
        type
    }

    toString: func -> String {
        name + ": " + type toString() + ((expr) ? " <- " + expr toString() : "")
    }
}

