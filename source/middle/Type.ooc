import Expression,FunctionDecl,Statement,Resolver,StructDecl
import ../frontend/Token
import structs/ArrayList

Type: class extends Statement {
    name: String
    ref: StructDecl = null // The structure the type was defined in
    init: func(=name,=token)
    
    _void := static This new("void", nullToken) // Void type wich is the default return type of a function
    
    pointer?: func -> Bool {
        instanceOf?(PointerType) && !instanceOf?(ArrayType)
    }
    
    array?: func -> Bool {
        instanceOf?(ArrayType)
    }
    
    refLevel: func -> SSizeT { // Function that returns the level of the pointerization of the type
        level := 0
        type := clone()
        while(type pointer?() || type array?()) {
            level += 1
            type = type as PointerType baseType
        }
        level
    }
    
    pointerLevel: func -> SSizeT {
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
        while(type pointer?() || type array?()) {
            type = type as PointerType baseType
        }
        type
    }
    
    trimPointers: func -> Type {
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
    init: func(token: Token) { super("...",token) }
    
    resolve: func(resolver: Resolver) {
        resolved? = true // No need to resolve anything, baby :D
    }
}

PointerType: class extends Type {
    baseType: Type
    init: func(=baseType) { token = baseType token }
    init: func~withToken(=baseType,=token)
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
    inner: Expression = null // The number of elements right? :D
    init: func(=baseType)
    init: func~withToken(=baseType,=token)
    init: func~withInnerAndToken(=baseType,=inner,=token)
    clone: func -> This {
        ArrayType new(baseType clone())
    }
    
    resolve: func(resolver: Resolver) {
        baseType resolve(resolver)
        resolver push(this)
        if(inner) inner resolve(resolver)
        // Should check for the index being a number right? :D
        resolver pop(this)
        resolved? = true
    }
    
    toString: func -> String {
        baseType toString() + "[]"
    }
}

FuncType: class extends Type {
    argumentTypes := ArrayList<Type> new()
    returnType := Type _void
    init: func(=token)
    
    addArgument: func(type: Type) {
        argumentTypes add(type)
    }
    
    clone: func -> This {
        c := FuncType new(token)
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

