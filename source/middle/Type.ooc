import Expression,FunctionDecl,Statement,Resolver,StructDecl
import ../frontend/Token
import structs/ArrayList

// This is not strictly equality. operator== first checks wether the types are equivalent (same name and reference and pointer levels) and then checks to see if the types are compatible, meaning that implicit casts can be done between them :D
operator== (left,right: Type) -> Bool {
    (left refLevel() == right refLevel() && left pointerLevel() == right pointerLevel() && left dereference() name == right dereference() name) || Type compatible?(left,right)
}

operator!= (left,right: Type) -> Bool {
    !(left == right)
}

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

    scalar?: func -> Bool {
        pointer?() || ((ref) ? ref number?() && !array?() : false)
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

    arrayLevel: func -> SSizeT {
        level := 0
        type := clone()
        while(type array?()) {
            level += 1
            type = type as ArrayType baseType
        }
        level
    }

    dereference: func(levels : Int = -1) -> Type {
        if(levels == -1) levels = refLevel()
        type := clone()
        while(levels > 0 && (type pointer?() || type array?())) {
            type = type as PointerType baseType
            levels -= 1
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

    // The type is a number type if the structure declaration extends a C number type and our refLevel is 0 :D
    number?: func -> Bool {
        refLevel() == 0 && ((ref) ? ref number?() : false)
    }

    integer?: func -> Bool {
        refLevel() == 0 && ((ref) ? ref integer?() : false)
    }

    floating?: func -> Bool {
        refLevel() == 0 && ((ref) ? ref floating?() : false)
    }

    // Returns this or other, depending on wich of the two number types is of "higher order". Yes I know my method sucks
    // The order goes like this:
    // long double
    // double
    // float
    // unsigned long int
    // long int
    // unsigned int
    // int
    // ... 
    against: func(other: Type) -> Type {
        if(!number?() || !other number?()) return this
        thisExtName := (ref externName != "") ? ref externName : name
        otherExtName := (other ref externName != "") ? other ref externName : other name
        if(thisExtName == "long double") return this
        else if(otherExtName == "long double") return other
        else if(thisExtName == "double") return this
        else if(otherExtName == "double") return other
        else if(thisExtName == "float") return this
        else if(otherExtName == "float") return other
        else if(thisExtName == "long int") return this
        else if(otherExtName == "long int") return other
        this
    }

    // Returns true if the two types are compatible, meaning that implicit casts are possible betwwen values of those types :D
    // Because we don't want to be able to implicitely cast any pointer to any other, we do not check for scalar types but rather for numbers
    compatible?: func(other: Type) -> Bool {
        (number?() && other number?())
    }

    toString: func -> String {
        name
    }

    clone: func -> This {
        c := Type new(name,token)
        c ref = ref
        c
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
        c := ArrayType new(baseType clone(),token)
        c inner = inner
        c
    }
    
    resolve: func(resolver: Resolver) {
        baseType resolve(resolver)
        resolver push(this)
        if(inner) {
            inner resolve(resolver)
            // Make sure the index passed in the brackets is a number
            if(!inner getType() number?()) resolver fail("An array's index should be a number, got an expression of type %s" format(inner getType() name), token)
        }
        resolver pop(this)
        resolved? = true
    }

    toString: func -> String {
        match(inner) {
            case null =>
                "%s[]" format(baseType toString())
            case =>
                "%s[%s]" format(baseType toString(), inner toString())
        }
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
        // To resolve a function type, we need to resolve every argument's type and its return type
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
        if(returnType) ret += " : " + returnType toString()
        ret
    }
}

