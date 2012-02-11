import ../frontend/AstBuilder
import ../middle/Module

// This is the base class for any backend.
Backend: abstract class {
    visitModule: abstract func(module: Module)
}

