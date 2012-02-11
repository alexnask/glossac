import structs/ArrayList
import Node,Resolver,Type,Scope,Decl

FunctionDecl: class extends Decl {
    name: String
    returnType := Type void
    arguments := ArrayList<VariableDecl> new()
    body := Scope new()

    init: func(=name,=token)

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        
        resolver push(this)
        if(returnType) {
            if(!returnType resolved?) returnType resolve(resolver)
        }
        for(argument in arguments) {
            argument resolve(resolver)
        }
        for(stmt in body) {
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
        isFirst := true
        for(arg in arguments) {
            if(isFirst) isFirst = false
            else ret += ", "
            ret += arg toString()
        }
        ret += ") -> "
        ret += returnType toString()
        ret
    }
}
