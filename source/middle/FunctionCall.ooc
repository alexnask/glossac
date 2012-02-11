import structs/ArrayList
import Resolver,Expression,FunctionDecl

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
    }
}
