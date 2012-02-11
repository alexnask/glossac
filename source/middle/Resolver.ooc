import structs/Stack
import ../frontend/Token
import Module,FunctionDecl,StructDecl,VariableDecl,Node,Scope

Resolver: class {
    parents := Stack<Node> new()
    init: func(parent: Module) {
        parents push(parent)
    }

    // This function tries to find a function declaration based on it's name in the current resolver's trail
    findFunctionDecl: func(name: String) -> FunctionDecl {
        iter := parents backIterator()
        while(iter hasPrev?()) {
            node := iter prev() as Node
            if(node instanceOf?(Module)) { // Functions can only be defined in a module's core
                found: FunctionDecl = null
                node as Module functions each(|decl|
                    if(decl name == name) found = decl
                )
                // Too naive?
                if(found) return found
            } else if(node instanceOf?(FunctionDecl)) { // Or is it a case of recursion?
                if(node as FunctionDecl name == name) return node as FunctionDecl
            }
        }
        null
    }

    // This function tries to find a variable declaration based on it's name in the current resolver's trail
    findVariableDecl: func(name: String) -> VariableDecl {
        iter := parents backIterator()
        while(iter hasPrev?()) {
            node := iter prev() as Node
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
    
    // This function tries tofind a structure declaration based on a type name in the current resolver's trail
    findStructDecl: func(name: String) -> StructDecl {
        iter := parents backIterator()
        while(iter hasPrev?()) {
            node := iter prev() as Node
            if(node instanceOf?(Module)) { // Structures can only be defined in the module's core
                found: StructDecl = null
                node as Module structures each(|decl|
                    if(decl type name == name) found = decl
                )
                if(found) return found
            } else if(node instanceOf?(StructDecl)) { // Or is it type recursion?
                if(node as StructDecl type name == name) return node as StructDecl
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

