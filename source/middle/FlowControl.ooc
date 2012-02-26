import Statement, Loop, Resolver

FlowAction: enum {
    _break,
    _continue
}

FlowControl: class extends Statement {
    action: FlowAction
    init: func(=action,=token)
    clone: func -> This {
        FlowControl new(action,token)
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        if(!resolver getCurrentLoop()) resolver fail("Flow control statement can only be placed in a loop", token)
        resolver pop(this)
        resolved? = true
    }

    toString: func -> String {
        match (action) {
            case FlowAction _break =>
                "σταμάτα"
            case =>
                "συνέχισε"
        }
    }
}

