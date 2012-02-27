import Expression, Type, Literal, Resolver
import ../frontend/Token

RangeLiteral: class extends Literal {
    min,max: Expression = null
    type = Type new("range",nullToken)
    init: func(=min,=max,=token)
    clone: func -> This {
        RangeLiteral new(min,max,token)
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        type resolve(resolver)
        min resolve(resolver)
        max resolve(resolver)
        if(!min getType() number?() || !max getType() number?()) resolver fail("A range can only be constructed from numbers (got %s and %s)" format(min getType() toString(), max getType() toString()),token)
        resolver pop(this)
        resolved? = true
    }

    toString: func -> String {
        "%s μέχρι %s" format(min toString(), max toString())
    }
}

