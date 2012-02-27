import Expression, Type, Resolver, VariableAccess, ArrayAccess, NullLiteral
import ../frontend/Token

BinaryOpType: enum {
    ass,
    add,
    mul,
    div,
    sub,
    mod,
    lshift,
    rshift,
    or,
    and,
    bOr,
    bAnd,
    bXor
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
                if(!left getType() integer?() || !right getType() integer?()) resolver fail("Operator mod can only be applied to integers (got %s and %s)" format(left getType() toString(), right getType() toString()), token)
                type = left getType()
            case =>
                if(optype == BinaryOpType add || optype == BinaryOpType sub || optype == BinaryOpType mul || optype == BinaryOpType div) {
                    if(!left getType() number?() || !right getType() number?()) resolver fail("An arithmetic operator's right and left values must be numbers (got %s and %s)" format(left getType() toString(), right getType() toString()), token)
                    type = left getType() against(right getType())
                } else if(optype == BinaryOpType or || optype == BinaryOpType and) {
                    if(!left getType() number?() || !right getType() number?()) resolver fail("A logic operator's right and left values must be numbers (got %s and %s)" format(left getType() toString(), right getType() toString()), token)
                    type = Type new("bool",nullToken)
                    type resolve(resolver)
                } else if(optype == BinaryOpType lshift || optype == BinaryOpType rshift || optype == BinaryOpType bOr || optype == BinaryOpType bAnd || optype == BinaryOpType bXor) {
                    if(!right getType() integer?()) resolver fail("A bitwise oprator's right value must be an integer number (got %s)" format(right getType() toString()), token)
                    type = left getType()
                }
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
            case BinaryOpType mod => "mod"
            case BinaryOpType lshift => "<<"
            case BinaryOpType rshift => ">>"
            case BinaryOpType or => "ή"
            case BinaryOpType and => "και"
            case BinaryOpType bOr => "|"
            case BinaryOpType bAnd => "&"
            case BinaryOpType bXor => "^"
            case => "DAFUQ"
        },
        right toString())
    }
}

