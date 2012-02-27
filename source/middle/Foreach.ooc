import Loop, Expression, Type, Resolver, RangeLiteral, VariableDecl, VariableAccess
import ../frontend/Token

Foreach: class extends Loop {
    decl,step,range: Expression = null
    init: func(=decl,=range,=token)
    clone: func -> This {
        c := Foreach new(decl,range,token)
        c step = step
        c
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return
        resolver push(this)
        if(!decl instanceOf?(VariableDecl) && !decl instanceOf?(VariableAccess)) resolver fail("A foreach loop's variable declaration should only be a declaration or access", decl token)
        else if(decl instanceOf?(VariableAccess)) decl = VariableDecl new(decl as VariableAccess name, Type new("int",nullToken), decl token)
        decl resolve(resolver)
        if(decl as VariableDecl expr != null) resolver fail("A foreach loop's variable declaration should not have a default value", decl token)
        else if(!decl getType() number?()) resolver fail("A foreach loop's variable declaration should be of a number type (got %s)" format(decl getType() toString()), decl token)
        range resolve(resolver)
        if(range getType() != Type new("range",nullToken)) resolver fail("A foreach loop can only loop through a range (got %s)" format(range getType() toString()), token)
        if(step) {
            step resolve(resolver)
            if(!step getType() number?()) resolver fail("A foreach loop's step should be of a number type (got %s)" format(step getType() toString()), step token)
        }
        body resolve(resolver)
        resolver pop(this)
        resolved? = true
    }

    toString: func -> String {
        match(step) {
            case null =>
                "Για %s από %s\n%s\nΤέλος" format(decl toString(), range toString(), body toString())
            case =>
                "Για %s από %s βήμα %s\n%s\nΤέλος" format(decl toString(), range toString(), step toString(), body toString())
        }
    }
}

