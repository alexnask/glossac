import Statement, Scope

Loop: abstract class extends Statement {
    body := Scope new()
    init: func(=token)
}

