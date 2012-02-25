import Statement, Expression, Scope

Conditional: abstract class extends Statement {
    condition: Expression = null
    body := Scope new()
    init: func(=condition,=token)
}

