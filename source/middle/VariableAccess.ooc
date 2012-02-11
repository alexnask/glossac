import VariableDecl,Expression,Resolver,Type

VariableAccess: class extends Expression {
    ref: VariableDecl = null
    name: String // Name of the variable we are trying to access
    
    init: func(=name,=token)

    clone: func -> This {
        c := VariableAccess new(name,token)
        c
    }

    // To resolve a variable access, we search for a variable declaration with the name we are trying to access
    resolve: func(resolver: Resolver) {
        resolver push(this)
        suggested := resolver findVariableDecl(name)
        if(suggested) ref = suggested
        else resolver fail("Undefined reference to variable " + name, token)
        resolver pop(this)
    }

    getType: func -> Type {
        (ref) ? ref type : null
    }
}

