import Expression,Decl,Resolver

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
}


