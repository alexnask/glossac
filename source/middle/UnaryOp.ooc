import Expression, Type, Resolver
import ../frontend/Token

UnaryOpType: enum {
    logicalNot,
    binaryNot,
    unaryMinus,
    addressOf,
    dereference
}

UnaryOp: class extends Expression {
    inner: Expression = null
    optype: UnaryOpType
    type: Type
    init: func(=inner,=optype,=token)
    clone: func -> This {
        UnaryOp new(inner,optype,token)
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        inner resolve(resolver)
        match(optype) {
            case UnaryOpType logicalNot =>
                if(!inner getType() scalar?()) resolver fail("Operator ! can only be aplied to scalar types (got %s)" format(inner getType() toString()), token)
                type = Type new("bool", nullToken)
                type resolve(resolver)
            case UnaryOpType binaryNot =>
                if(!inner getType() scalar?()) resolver fail("Operator ~ can only be aplied to scalar types (got %s)" format(inner getType() toString()), token)
                type = Type new("bool", nullToken)
                type resolve(resolver)
            case UnaryOpType unaryMinus =>
                if(!inner getType() number?()) resolver fail("Operator - can only be aplied to numbers (got %s)" format(inner getType() toString()), token)
                type = inner getType()
            case UnaryOpType addressOf =>
                type = PointerType new(inner getType())
                type resolve(resolver)
            case UnaryOpType dereference =>
                if(!inner getType() pointer?()) resolver fail("You can only dereference pointer types (got %s)" format(inner getType() toString()), token)
                type = inner getType() dereference(1)
                type resolve(resolver)
            case =>
                // DAFUQ
        }
        resolver pop(this)
        resolved? = true
    }

    getType: func -> Type {
        type
    }

    toString: func -> String {
        "%s%s" format(
            match(optype) {
                case UnaryOpType logicalNot => "!"
                case UnaryOpType binaryNot  => "~"
                case UnaryOpType unaryMinus => "-"
                case UnaryOpType addressOf  => "&"
                case UnaryOpType dereference=> "@"
                case => "DAFUQ"
            },
            inner toString()
        )
    }
}

