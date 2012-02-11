import ../backend/Backend
import ../frontend/Token
import Resolver

// A node is an element that can be resolved and translated by a backend.
Node: abstract class {
    resolved? := false
    token: Token
    
    init: func(=token)
    // Resolving function to be overloaded by children classes
    resolve: func(resolver: Resolver) {
        resolved? = true
    }

    toString: abstract func -> String
    clone: abstract func -> This
}

