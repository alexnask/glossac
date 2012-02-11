import structs/Stack
import ../frontend/Token
import Module,FunctionDecl

Resolver: class {
    parents := Stack<Node> new()
    init: func(parent: Module) {
        parents push(parent)
    }

    // This function tries to find a function declaration based on it's name in the current resolver's trail
    findFunctionDecl: func(name: String) -> FunctionDecl {
        iter := parents backIterator()
        while(iter hasPrev?()) {
            node := iter prev()
            if(node instanceOf?(Module)) { // Functions can only be defined in a module's core
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

    // This function tries to find a varaible declaration based on it's name in the current resolver's trail
    findVariableDecl: func(name: String) -> VariableDecl {
        iter := parents backIterator()
        while(iter hasPrev?()) {
            node := iter prev()
            if(node instanceOf?(Module)) { // Global variable
                found: VariableDecl = null
                node as Module variables each(|decl|
                    if(decl name == name) found = decl
                )
                if(found) return found
            } else if(node instanceOf?(Scope)) { // Local variable
                found := node as Scope variable(name)
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

