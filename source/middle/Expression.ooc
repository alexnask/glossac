import Statement,Type

Expression: abstract class extends Statement {
    init: func(=token)
    getType: abstract func -> Type // Every expression can be evaluated to a type
}

