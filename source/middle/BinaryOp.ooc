import Expression, Type, Resolver, VariableAccess, ArrayAccess, NullLiteral

BinaryOpType: enum {
    ass,
    add,
    mul,
    div,
    sub,
    mod
}

BinaryOp: class extends Expression {
    left,right: Expression = null
    optype: BinaryOpType
    type: Type
    init: func(=left,=right,=optype,=token)
    clone: func -> This {
        BinaryOp new(left,right,optype,token)
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        left resolve(resolver)
        right resolve(resolver)
        match (optype) {
            case BinaryOpType ass =>
                if(!left instanceOf?(VariableAccess) && !left instanceOf?(ArrayAccess)) resolver fail("Lvalue of assignement must be an access", token)
                if(left getType() != right getType() && !(left getType() pointer?() && right instanceOf?(NullLiteral))) resolver fail("Type mismatch (expected %s, got %s)" format(left getType() toString(), right getType() toString()), token)
                type = left getType()
            case BinaryOpType mod =>
                if(!left getType() integer?() || !right getType() integer?()) resolver fail("Operator % can only be applied to integers (got %s and %s)" format(left getType() toString(), right getType() toString()), token)
                type = left getType()
            case =>
                if(!left getType() number?() || !right getType() number?()) resolver fail("An arithmetic operator's right and left values must be numbers (got %s and %s)" format(left getType() toString(), right getType() toString()), token)
                type = left getType() against(right getType())
        }
        resolver pop(this)
        resolved? = true
    }

    getType: func -> Type { type }
    toString: func -> String {
        "%s %s %s" format(left toString(),
        match(optype) {
            case BinaryOpType ass => "<-"
            case BinaryOpType add => "+"
            case BinaryOpType sub => "-"
            case BinaryOpType mul => "*"
            case BinaryOpType div => "/"
            case BinaryOpType mod => "%"
            case => "DAFUQ"
        },
        right toString())
    }
}

