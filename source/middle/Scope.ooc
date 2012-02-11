import structs/ArrayList
import Statement,Resolver,VariableDecl

Scope: class extends Statement {
    list := ArrayList<Statement> new()
    
    resolve: func(resolver: Resolver) {
        resolver push(this)
        list each(|elem|
            elem resolve(resolver)
        )
        resolver pop(this)
    }
    
    // Returns true if the variable is declared within this scope
    variable: func(name: String) -> VariableDecl {
        for(elem in list) {
            if(elem instanceOf?(VariableDecl)) {
                if(elem as VariableDecl name == name && elem resolved?) return elem as VariableDecl
            }
        }
        null
    }
}
