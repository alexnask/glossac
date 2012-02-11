import structs/ArrayList
import Node,Resolver,Type,Scope

FunctionDecl: class extends Expression {
    name: String
    returnType: Type
    arguments := ArrayList<VariableDecl> new()
    externName: String // null -> not extern, "" -> extern with default name
    unmangledName: String // null -> not unmangled, "" -> unmangled with default name
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

    extern?: func -> Bool {
        externName != null
    }
    unmangled?: func -> Bool {
        unamgledNmae != null
    }
    
    clone: func -> This {
        c := FunctionDecl new(name,token)
        c returnType = returnType
        c arguments = arguments
        c externName = externName
        c unmangledName = unmangledName
        c body = body
        c
    }
}
