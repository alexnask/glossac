import VariableDecl,Expression,Resolver,Type

VariableAccess: class extends Expression {
    ref: VariableDecl = null
    expr: Expression = null // When accessing a structure's field, this should be  the structure
    name: String // Name of the variable we are trying to access
    
    init: func(=name,=expr,=token)

    clone: func -> This {
        c := VariableAccess new(name,expr,token)
        c
    }

    // To resolve a variable access, we search for a variable declaration with the name we are trying to access
    resolve: func(resolver: Resolver) {
        if(resolved?) return

        resolver push(this)
        if(!expr) {
            suggested := resolver findVariableDecl(name)
            if(suggested) ref = suggested
            else resolver fail("Undefined reference to variable " + name, token)
        } else {
            // Handle structure accessing
            // Resolve left expression, get its type
            // Get the structure declaration of the type
            // Set ref to the variable declaration of the field with this name
            // Profit.
            
        }
        resolver pop(this)
    }

    getType: func -> Type {
        (ref) ? ref type : null as Type
    }
    
    toString: func -> String {
        (expr) ? expr toString() + "." + name : name
    }
}

