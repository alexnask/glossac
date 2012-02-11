import ../frontend/Token
import Expression

Decl: abstract class extends Expression {
    init: super func(token: Token)
    
    externName: String // null -> not extern, "" -> extern with default name
    unmangledName: String // null -> not unmangled, "" -> unmangled with default name
    
    isextern?: func -> Bool { externName != null }
    isunmangled?: func -> Bool { unmangledName != null }
}
