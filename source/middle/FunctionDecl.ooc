import structs/ArrayList
import Node,Resolver,Type,Scope,Decl

FunctionDecl: class extends Decl {
    name: String
    returnType := Type void
    arguments := ArrayList<VariableDecl> new()
    body := Scope new()

    init: func(=name,=token)

    resolve: func(resolver: Resolver) {
        resolver push(this)
        if(returnType) {
            if(!returnType resolved?) returnType resolve(resolver)
        }
        for(argument in arguments) {
            if(argument resolved?) continue
            argument resolve(resolver)
        }
        for(stmt in body) {
            if(stmt resolved?) continue
            stmt resolve(resolver)
        }
        resolved? = true
        resolver pop(this)
    }
    
    clone: func -> This {
        c := FunctionDecl new(name,token)
        c returnType = returnType
        arguments each(|arg|
            c arguments add(arg clone())
        )
        c externName = externName
        c unmangledName = unmangledName
        c body = body
        c
    }
    
    toString: func -> String {
        ret := "Συνάρτηση "
        ret += name + " "
        if(extern?()) ret += "εξωτερική(" + externName + ") "
        if(unmangled?()) ret += "unmangled(" + unmangledName + ") "
        ret += "("
        for(arg in arguments) {
            ret += arg toString()
            if(arguments indexOf(arg) != arguments size() - 1) {
                ret += ", "
            }
        }
        ret += ") -> "
        ret += returnType toString()
        ret
    }
}
