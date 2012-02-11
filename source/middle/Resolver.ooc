import structs/Stack
import ../frontend/Token
import Module,FunctionDecl

Resolver: class {
    parents := Stack<Node> new()
    init: func(parent: Module) {
        parents push(parent)
    }

    findFunctionDecl: func(name: String) -> FunctionDecl {
        iter := parents backIterator()
        while(iter hasPrev?()) {
            node := iter prev()
            if(node instanceOf?(Module)) {
                found: FunctionDecl = null
                node as Module functions each(|decl|
                    if(decl name == name) found = decl
                )
                // Too naive?
                if(found) return found
            }
        }
        null
    }
    
    push: func(node: Node) {
        parents push(node)
    }
    
    pop: func(node: Node) {
        if(node != parents pop()) fail("Expected poped node to be " + node toString(), node token)
    }
    
    
    fail: func(msg: String, token: Token) {
        Exception new("Resolver failed: " + msg + "\n At " + token toString()) throw()
    }
}

