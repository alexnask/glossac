import Statement,Type

Expression: abstract class extends Statement {
    init: func(=token)
    getType: abstract func -> Type // Every expression can be evaluated to a type

    pointerize: func(level: SSizeT = 0) -> Expression {
        // TODO: Should return an expression of "this" refererenced "level" times, where 0 is not at all, -n is dereferenced n times.
        this
    }
}

