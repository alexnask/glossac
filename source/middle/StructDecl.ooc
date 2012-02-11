import Type,VariableDecl,Decl
import structs/ArrayList

StructDecl: class extends Decl {
    type: Type
    fields := ArrayList<VariableDecl> new()
    getType: func -> Type { type }
    
    init: func(name: String,=token) {
        type = Type new(name)
    }
    
    resolve: func(resolver: Resolver) {
        resolver push(this)
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
        if(extern?()) ret += "εξωτερική(" + externName + ") "
        ret
    }
}

