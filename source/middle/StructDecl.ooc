import Type,VariableDecl,Decl,Resolver
import structs/ArrayList

StructDecl: class extends Decl {
    type: Type
    fields := ArrayList<VariableDecl> new()
    getType: func -> Type { type }

    init: func(name: String,=token) {
        type = Type new(name,token)
    }

    number?: func -> Bool {
        integer?() || floating?()
    }

    integer?: func -> Bool {
        if(isextern?()) {
            extName := (externName != "") ? externName : type name
            return (extName == "int" || extName == "long" || extName == "long long" || extName == "char" || extName == "_Bool" || extName == "short" || extName == "unsigned int" || extName == "unsigned short" || extName == "unsigned long" || extName == "unsigned long long" || extName == "unsigned char" || extName == "unsigned" || extName == "signed char")
        }
        false
    }

    floating?: func -> Bool {
        if(isextern?()) {
            extName := (externName != "") ? externName : type name
            return (extName == "float" || extName == "double" || extName == "long double")
        }
        false
    }

    clone: func -> This {
        c := StructDecl new(type name,token)
        fields each(|field|
            c fields add(field clone())
        )
        c externName = externName
        c unmangledName = unmangledName
        c
    }

    resolve: func(resolver: Resolver) {
        if(resolved?) return

        resolver push(this)
        if(resolver checkRootSymbolRedifinition(type name, this)) resolver fail("Redifinition of structure " + type name, token)
        // Resolve the fields' types
        // A structure's fields cannot have default values
        fields each(|field|
            if(field expr) resolver fail("A structure's field cannot have a default value", token)
            field type resolve(resolver)
        )
        resolver pop(this)
    }

    toString: func -> String {
        ret := "Δομή "
        ret += type toString() + " "
        if(isextern?()) ret += "εξωτερική(" + externName + ")"
        ret += "\n"
        fields each(|field|
            ret += field toString() + "\n"
        )
        ret += "Τέλος"
        ret
    }
}

