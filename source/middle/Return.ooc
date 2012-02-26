import Statement, Expression, Resolver, Type, FunctionDecl

Return: class extends Statement {
    expr: Expression = null // Expression to return, can only be null if the function return type is void

    init: func(=expr,=token)
    clone: func -> This {
        c := Return new(expr,token)
        c
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        // get the function declaration we are in
        ref := resolver getCurrentFunctionDecl()
        if(!ref) resolver fail("Return statement should only be found in a function declaration", token)
        if(expr) {
            expr resolve(resolver)
        }
        if(ref returnType && ref returnType != Type _void) {
            if(!expr || expr getType() != ref returnType) resolver fail("Return statements should only take expressions of the same type as the return type of the function declaration (expected %s, got %s)" format(ref returnType toString(), expr getType() toString()), expr token)
        } else {
            if(expr) resolver fail("Return statements should not take expressions in a function of void return type", expr token)
        }
        resolver pop(this)
        resolved? = true
    }

    toString: func -> String {
        "Γύρνα %s" format(expr toString())
    }
}

