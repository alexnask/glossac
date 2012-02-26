import structs/ArrayList
import Statement, Expression, Type, Resolver

ArrayAccess: class extends Expression {
    indices := ArrayList<Expression> new() // In glossa, multiple indices are used to access multidimensional arrays. You can do doubleArray[0,0] while doubleArray[0][0] is still valid :D
    expr: Expression = null // The array we are trying to access
    init: func(=expr,=token)
    clone: func -> This {
        c := ArrayAccess new(expr,token)
        indices each(|index|
            c indices add(index clone() as Expression)
        )
        c
    }

    resolve: func (resolver: Resolver) {
        if(resolved?) return
        resolver push(this)

        expr resolve(resolver)
        dimensions := expr getType() arrayLevel()
        if(dimensions < 1) resolver fail("Cannot access element of non array type %s" format(expr getType() toString()), token)
        else if(indices getSize() > dimensions) resolver fail("Trying to access array type of %d dimensions %d dimensions deep" format(dimensions, indices getSize()), token)

        indices each(|index|
            index resolve(resolver)
            if(!index getType() number?()) resolver fail("Indexes to an array acces can only be numbers (got %s)" format(index getType() toString()), index token)
        )

        resolver pop(this)
        resolved? = true
    }

    getType: func -> Type {
        expr getType() dereference(indices getSize())
    }

    toString: func -> String {
        ret := expr toString() + "["
        first := true
        indices each(|index|
            if(first) first = false
            else ret += ", "
            ret += index toString()
        )
        ret + "]"
    }
}

