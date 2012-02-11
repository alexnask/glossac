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
            c args add(arg clone() as Expression)
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
    // Note that we dereference the argument types of the declaration before comparing them to the expressions' types wich we also dereference
    // In this implementation of glossa it is valid to pass an argument to a function whithout implicitely referencing it, letting the compiler do that
    // so we compare the root types. We then add the correct amount of referencing or dereferencing to the passed argument
    // TODO: add the correct amount of referencing or dereferencing to the passed argument using the `Expression pointerize` and `Type refLevel` methods
    matches?: func(fd: FunctionDecl) -> Bool {
        if(!fd) return false
        // Varargs should only be the last argument type of a function
        if(fd arguments last() type instanceOf?(VarArgType)) {
            if(args getSize() < fd arguments getSize() - 1) return false
            for(i in 0 .. fd arguments getSize() - 1) {
                if(fd arguments get(i) type dereference() != args get(i) getType() dereference()) return false
            }
            return true
        } else if(args getSize() != fd arguments getSize()) return false
        for(i in 0 .. fd arguments getSize()) {
            if(fd arguments get(i) type dereference() != args get(i) getType() dereference()) return false
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
    
    toString: func -> String {
        ret := name + "("
        isFirst := true
        for(arg in args) {
            if(isFirst) isFirst = false
            else ret += ", "
            ret += arg toString()
        }
        ret += ")"
        ret
    }
}

