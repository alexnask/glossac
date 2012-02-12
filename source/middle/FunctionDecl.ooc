import structs/ArrayList
import Node,Resolver,Type,Scope,Decl,VariableDecl

FunctionDecl: class extends Decl {
    name: String
    returnType := Type _void
    arguments := ArrayList<VariableDecl> new()
    body: Scope = null // null: no body, not null: body

    init: func(=name,=token)

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        
        resolver push(this)
        // Fix redifinition of functions :(
        if(resolver checkRootSymbolRedifinition(name)) resolver fail("Redifinition of function " + name, token)

        if(returnType) {
            returnType resolve(resolver)
        }
        for(argument in arguments) {
            argument resolve(resolver)
        }
        body resolve(resolver)
        resolved? = true
        resolver pop(this)
    }
    
    clone: func -> This {
        c := FunctionDecl new(name,token)
        c returnType = returnType
        arguments each(|arg|
            c arguments add(arg as VariableDecl clone())
        )
        c externName = externName
        c unmangledName = unmangledName
        c body = body
        c
    }
    
    toString: func -> String {
        ret := "Συνάρτηση "
        ret += name + " "
        if(isextern?()) ret += "εξωτερική(" + externName + ") "
        if(isunmangled?()) ret += "unmangled(" + unmangledName + ") "
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
    
    getType: func -> Type {
        ftype := FuncType new(token)
        arguments each(|arg|
            ftype argumentTypes add(arg type)
        )
        ftype returnType = returnType
        ftype
    }
}
