import Statement,Type,UnaryOp

Expression: abstract class extends Statement {
    init: func(=token)
    getType: abstract func -> Type // Every expression can be evaluated to a type

    pointerize: func(level: SSizeT = 0) -> Expression {
        exp := clone() as Expression
        if(level > 0) {
            while(level > 0) {
                exp = UnaryOp new(exp, UnaryOpType addressOf, exp token)
                level -= 1
            }
        } else if(level < 0) {
            while(level < 0) {
                exp = UnaryOp new(exp, UnaryOpType dereference, exp token)
                level += 1
            }
        }
        exp
    }
}

