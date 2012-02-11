import Statement,Type

Expression: abstract class extends Statement {
    init: func(=token)
    getType: abstreact func -> Type // Every expression can be evaluated to a type
}

