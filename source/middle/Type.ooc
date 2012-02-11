import Expression,FunctionDecl
import structs/ArrayList

Type: class extends Expression {
    name: String
    init: func(=name,=token)
    
    void := static This("void") // Void type wich is the default return type of a function
    
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
        name
    }
    
    clone: func -> This {
        Type new(name,token)
    }
    
    resolve: func(resolver: Resolver) {
        
    }
}

VarArgType: class extends Type {
    init: func { super("...") }
}

PointerType: class extends Type {
    baseType: Type
    init: func(=baseType) { token = baseType token }
    clone: func -> This {
        PointerType new(baseType clone())
    }
    
    
    toString: func -> String {
        baseType toString() + "*"
    }
}

ArrayType: class extends PointerType {
    baseType: Type
    init: func(=baseType) { token = baseType token }
    clone: func -> This {
        ArrayType new(baseType clone())
    }
    
    toString: func -> String {
        baseType toString() + "[]"
    }
}

FuncType: class extends Type {
    argumentTypes := ArrayList<Type> new()
    returnType: Type = null
    init: func
    
    addArgument: func(type: Type) {
        argumentTypes add(type)
    }
    
    clone: func -> This {
        c := FuncType new()
        c returnType = returnType
        argumentTypes each(|arg|
            c argumentTypes add(arg clone())
        )
        c
    }
    
    toString: func -> String {
        ret := "Συνάρτηση ("
        for(arg in argumentTypes) {
            ret += arg toString()
            if(argumentTypes indexOf?(arg) != argumentTypes size() - 1) {
                ret += ", "
            }
        }
        ret += ")"
        if(returnType) ret += " -> " + returnType toString()
        ret
    }
}

