import Type,VariableDecl,Decl,Resolver
import structs/ArrayList

StructDecl: class extends Decl {
    type: Type
    fields := ArrayList<VariableDecl> new()
    getType: func -> Type { type }
    
    init: func(name: String,=token) {
        type = Type new(name,token)
    }
    
    clone: func -> This {
        c := StructDecl new(type name,token)
        fields each(|field|
            c fields add(field clone())
        )
        c externName = externName
        c unmangledName = unmangledName
        c
    }
    
    resolve: func(resolver: Resolver) {
        if(resolved?) return

        resolver push(this)
        if(resolver checkRootSymbolRedifinition(type name, this)) resolver fail("Redifinition of structure " + type name, token)
        // Resolve the fields' types
        // A structure's fields cannot have default values
        fields each(|field|
            if(field expr) resolver fail("A structure's field cannot have a default value", token)
            field type resolve(resolver)
        )
        resolver pop(this)
    }
    
    toString: func -> String {
        ret := "Δομή "
        ret += type toString() + " "
        if(isextern?()) ret += "εξωτερική(" + externName + ") "
        ret
    }
}

