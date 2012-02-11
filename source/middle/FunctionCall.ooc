import structs/ArrayList
import Resolver,Expression,FunctionDecl,Type

FunctionCall: class extends Expression {
    name: String // Name of the function to be called
    ref: FunctionDecl = null // The declaration of the function
    
    args := ArrayList<Expression> new()

    init: func(=name, =token)
    clone: func -> This {
        c := FunctionCall new(name,token)
        args each(|arg|
            c args add(arg clone())
        )
        c
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return

        resolver push(this)
        // Resolve argument expressions
        args each(|arg|
            if(arg resolved?) return
            arg resolve(resolver)
        )
        // Find the function declaration
        suggested := resolver findFunctionDecl(name)
        resolver pop(this)

        if(matches?(suggested)) ref = suggested
        else resolver fail("Could not resolve function call " + name, token)

        resolved? = true
        
    }
    
    // Because glossa is not a polymorphic language, the matching is relatively simple
    // We do not use a scoring system and do not keep the call's expected return type it was inferred to but rather only the arguments
    // If the argument types of the call match those of the definition then we know this is the right definition
    matches?: func(fd: FunctionDecl) -> Bool {
        if(!fd) return false
        // Varargs should only be the last argument type of a function
        if(fd arguments get(-1) type instanceOf?(VarArgType)) {
            if(args size() < fd arguments size() - 1) return false
            for(i in 0 .. fd arguments size() - 1) {
                if(fd arguments get(i) type != args get(i) getType()) return false
            }
            return true
        } else if(args size() != fd arguments size()) return false
        for(i in 0 .. fd arguments size()) {
            if(fd arguments get(i) type != args get(i) getType()) return false
        }
        true
    }
    
    addArg: func(arg: Expression) {
        args add(arg)
    }

    getType: func -> Type {
        // The type of the function call as an expression is the type returned by the function :D
        (ref) ? ref returnType : null
    }
}

