import Expression, Resolver, Type
import ../frontend/Token

ComparisonType: enum {
    eq,
    neq,
    lt,
    gt,
    leqt,
    geqt
}

Comparison: class extends Expression {
    left, right: Expression = null
    ctype: ComparisonType
    type := static Type new("bool", nullToken)
    init: func(=left,=right,=ctype,=token)
    clone: func -> This {
        Comparison new(left,right,ctype,token)
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        type resolve(resolver)
        left resolve(resolver)
        right resolve(resolver)
        if(left getType() != right getType()) resolver fail("You can only compare expressions of the same or compatible types (got %s and %s)" format(left getType() toString(), right getType() toString()), token)

        if((ctype == ComparisonType lt || ctype == ComparisonType leqt || ctype == ComparisonType gt || ctype == ComparisonType geqt) && (!left getType() scalar?() || !right getType() scalar?())) resolver fail("You can only numerically compare scalar types (got %s and %s)" format(left getType() toString(), right getType() toString()), token)
        resolver pop(this)
        resolved? = true
    }

    toString: func -> String {
        "%s %s %s" format(left toString(),
        match (ctype) {
            case ComparisonType eq => "="
            case ComparisonType neq => "<>"
            case ComparisonType lt => "<"
            case ComparisonType leqt => "<="
            case ComparisonType gt => ">"
            case ComparisonType geqt => ">="
            case => "Dafuq?"
        }, right toString())
    }

    getType: func -> Type {
        type
    }
}

