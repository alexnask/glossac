import structs/ArrayList
import Statement,Resolver

Scope: class extends Node {
    list := ArrayList<Statement> new()
    
    resolve: func(resolver: Resolver) {
        resolver push(this)
        list each(|elem|
            elem resolve(resolver)
        )
        resolver pop(this)
    }
}
