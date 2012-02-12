import structs/ArrayList
import Statement,Resolver,VariableDecl,Node

Scope: class extends Node {
    list := ArrayList<Statement> new()
    init: func
    resolve: func(resolver: Resolver) {
        if(resolved?) return

        resolver push(this)
        list each(|elem|
            resolver push(elem)
            elem resolve(resolver)
            resolver pop(elem)
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
    
    add: func(stmt: Statement) {
        list add(stmt)
    }
    
    clone: func -> This {
        c := Scope new()
        list each(|stmt|
            c add(stmt clone() as Statement)
        )
        c
    }
    
    toString: func -> String {
        ret := "{ "
        isFirst := true
        for(stmt in list) {
            if(isFirst) isFirst = false
            else ret += ", "
            ret += stmt toString()
        }
        ret += " }"
        ret
    }
}
