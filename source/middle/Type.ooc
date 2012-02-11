import Expression,FunctionDecl
import structs/ArrayList

Type: class extends Expression {
    name: String
    ref: StructDecl = null // The structure the type was defined in
    init: func(=name,=token)
    
    void := static This("void") // Void type wich is the default return type of a function
    
    pointer?: func -> Bool {
        instanceOf?(PointerType)
    }
    
    refLevel: func -> SSizeT { // Function that returns the level of the pointerization of the type
        level := 0
        type := clone()
        while(type pointer?()) {
            level += 1
            type = type as PointerType baseType
        }
        level
    }
    
    dereference: func -> Type {
        type := clone()
        while(type pointer?()) {
            type = type as PointerType baseType
        }
        type
    }
    
    toString: func -> String {
        name
    }
    
    clone: func -> This {
        Type new(name,token)
    }
    
    resolve: func(resolver: Resolver) {
        // Nothing will change in the type itself after resolving. However, in glossa all types (but function types and the vararg type) are defined through structures, even "base" types like void, int, float, etc..
        // So resolving is just a metter of finding a structure declarataion that matches the type's name
        // This is done in the rather anorthodox way glossac uses, through the resolver
        resolver push(this)
        suggested := resolver findStructDecl(name)
        if(suggested) ref = suggested
        else resolver fail("Could not resolve type " + name, token)
        resolver pop(this)
        resolved? = true
    }
}

VarArgType: class extends Type {
    init: func { super("...") }
    
    resolve: func(resolver: Resolver) {
        resolved? = true // No need to resolve anything, baby :D
    }
}

PointerType: class extends Type {
    baseType: Type
    init: func(=baseType) { token = baseType token }
    clone: func -> This {
        PointerType new(baseType clone())
    }
    
    resolve: func(resolver: Resolver) {
        baseType resolve(resolver)
        resolved? = true
    }
    
    toString: func -> String {
        baseType toString() + "*"
    }
}

ArrayType: class extends PointerType {
    init: super func(type: Type)
    clone: func -> This {
        ArrayType new(baseType clone())
    }
    
    resolve: super func(resolver: Resolver)
    
    toString: func -> String {
        baseType toString() + "[]"
    }
}

FuncType: class extends Type {
    argumentTypes := ArrayList<Type> new()
    returnType := Type void
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
    
    resolve: func(resolver: Resolver) {
        // To resolve a function type, we need to resolve evrey argument's type and its return type
        // TODO: sould i push to the resolver here?
        argumentTypes each(|arg|
            arg resolve(resolver)
        )
        returnType resolve(resolver)
        resolved? = true
    }
    
    toString: func -> String {
        ret := "Συνάρτηση ("
        isFirst := true
        for(arg in argumentTypes) {
            if(isFirst) isFirst = false
            else ret += ", "
            ret += arg toString()
        }
        ret += ")"
        if(returnType) ret += " -> " + returnType toString()
        ret
    }
}

