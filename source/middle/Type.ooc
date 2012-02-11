import Expression

Type: class extends Expression {
    name: String
    init: func(=name,=token)

    pointer?: func -> Bool {
        instanceOf?(PointerType)
    }
    
    dereference: func -> Type {
        type := clone()
        while(type pointer?()) {
            type = type as PointerType baseType
        }
    }
    
    toString: func -> String {
        ret := name
        type := clone()
        while(type pointer?()) {
            if(type instanceOf?(ArrayType) {
                ret += "[]"
            } else ret += "*"
            type = type as PointerType baseType
        }
        ret
    }
    
    clone: func -> This {
        Type new(name,token)
    }
}

PointerType: class extends Type {
    baseType: Type
    init: func(=baseType) { token = baseType token }
    clone: func -> This {
        PointerType new(baseType clone())
    }
}

ArrayType: class extends PointerType {
    baseType: Type
    init: func(=baseType) { token = baseType token }
    clone: func -> This {
        ArrayType new(baseType clone())
    }
}

