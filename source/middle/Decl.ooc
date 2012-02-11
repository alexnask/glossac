import ../frontend/Token
import Expression

Decl: class extends Expression {
    init: super func(token: Token)
    
    externName: String // null -> not extern, "" -> extern with default name
    unmangledName: String // null -> not unmangled, "" -> unmangled with default name
    
    extern?: func -> Bool { externName != null }
    unmangled?: func -> Bool { unmangledName != null }
}
