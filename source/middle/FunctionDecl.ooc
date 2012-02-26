import structs/ArrayList
import Node,Resolver,Type,Scope,Decl,VariableDecl,Return,Expression

FunctionDecl: class extends Decl {
    name: String
    returnType := Type _void
    arguments := ArrayList<VariableDecl> new()
    body: Scope = null // null: no body, not null: body

    init: func(=name,=token)

    resolve: func(resolver: Resolver) {
        if(resolved?) return

        resolver push(this)
        if(resolver checkRootSymbolRedifinition(name,this)) resolver fail("Redifinition of function " + name, token)

        if(returnType) returnType resolve(resolver)

        for(argument in arguments) {
            argument resolve(resolver)
        }
        if(isextern?() && body && body list getSize() > 0) resolver fail("Extern function " + name + " can't have a function body", body token)
        if(body) {
            body resolve(resolver)
            // Ok all is good up to now, so we should determine if the function returns as it should or wether we need to make an autoreturn happen
            if(returnType && returnType != Type _void) {
                last := (body list getSize() > 0) ? body list last() : null
                if(!last || !last instanceOf?(Return)) {
                    if(!last || !last instanceOf?(Expression)) resolver fail("Function %s does not return and an autoreturn cannot be determined" format(name), token)
                    else if(last as Expression getType() name != returnType name) resolver fail("Expression cannot be used as function's %s autoreturn, types do not match (expected %s, got %s)" format(name, returnType name, last as Expression getType() name), last token)
                    else {
                        // Correct autoreturn :D
                        last = Return new(last as Expression, last token)
                        last resolve(resolver)
                        body list set(body list lastIndex(),last)
                    }
                }
            }
        }

        resolved? = true
        resolver pop(this)
    }
    
    clone: func -> This {
        c := FunctionDecl new(name,token)
        c returnType = returnType
        arguments each(|arg|
            c arguments add(arg as VariableDecl clone())
        )
        c externName = externName
        c unmangledName = unmangledName
        c body = body
        c
    }
    
    toString: func -> String {
        ret := "Συνάρτηση "
        ret += name + " "
        if(isextern?()) ret += "εξωτερική(" + externName + ") "
        if(isunmangled?()) ret += "unmangled(" + unmangledName + ") "
        ret += "("
        isFirst := true
        for(arg in arguments) {
            if(isFirst) isFirst = false
            else ret += ", "
            ret += arg toString()
        }
        ret += ") : "
        ret += returnType toString()
        ret
    }
    
    getType: func -> Type {
        ftype := FuncType new(token)
        arguments each(|arg|
            ftype argumentTypes add(arg type)
        )
        ftype returnType = returnType
        ftype
    }
}
