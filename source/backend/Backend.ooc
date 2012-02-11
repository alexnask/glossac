import ../frontend/AstBuilder

// This is the base class for any backend.
Backend: abstract class {
    visitModule: abstract func(module: Module)
}

