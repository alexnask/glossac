import Type,VariableDecl
import structs/ArrayList

StructDecl: class extends Expression {
    type: Type
    externName: String // null -> not extern, "" -> default name (the type's name)
    fields := ArrayList<VariableDecl> new()
    getType: func -> Type { type }
    
    init: func(=type,=token)
    
    extern?: func -> Bool {
        externName != null
    }
    
    resolve: func(resolver: Resolver) {
        resolver push(this)
        resolver pop(this)
    }
}

