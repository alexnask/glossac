import VariableDecl,Expression,Resolver,Type,StructDecl
import structs/ArrayList

VariableAccess: class extends Expression {
    ref: VariableDecl = null
    expr: Expression = null // When accessing a structure's field, this should be  the structure
    name: String // Name of the variable we are trying to access
    
    init: func(=name,=expr,=token)

    clone: func -> This {
        c := VariableAccess new(name,expr,token)
        c
    }

    // To resolve a variable access, we search for a variable declaration with the name we are trying to access
    resolve: func(resolver: Resolver) {
        if(resolved?) return

        resolver push(this)
        if(!expr) {
            suggested := resolver findVariableDecl(name)
            if(suggested) ref = suggested
            else resolver fail("Undefined reference to variable " + name, token)
        } else {
            expr resolve(resolver)
            // Note the derenference call. We find the fields of the naked type and then we will dereference the expression to the naked type.
            suggestedStruct := resolver findStructDecl(expr getType() dereference() name)
            if(!suggestedStruct) resolver fail("Cannot resolve type of expression " + expr toString(), token)
            else if(expr getType() pointerLevel() != expr getType() refLevel()) resolver fail("Cannot access field of array type " + expr getType() toString(), token)
            
            suggestedStruct fields each(|field|
                if(field name == name) {
                    ref = field
                }
            )
            if(!ref) resolver fail("Structure " + suggestedStruct type name + " has no field named " + name, token)
            // We dereference the expression to a refLevel of 1, meaning that the final expression will still be a pointer and the C backend will use the '->' operator to access the field
            if(expr getType() refLevel() > 1) {
                expr = expr pointerize(1 - expr getType() refLevel())
            }
        }
        resolver pop(this)
    }

    getType: func -> Type {
        (ref) ? ref type : null as Type
    }

    toString: func -> String {
        (expr) ? expr toString() + "." + name : name
    }
}

