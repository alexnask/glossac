import structs/ArrayList
import ../frontend/Token
import Node,FunctionDecl,StructDecl,VariableDecl,Resolver,FunctionCall,Type

Module: class extends Node {
    path: String
    init: func(=path) { super(nullToken) }

    functions := ArrayList<FunctionDecl> new()
    structures := ArrayList<StructDecl> new()
    variables := ArrayList<VariableDecl> new()
    //imports := ArrayList<Import> new()
    //uses := ArrayList<Use> new()
    
    resolve: func(resolver: Resolver) {
        if(resolved?) return
        // TODO: resolve imports and uses
        resolver push(this)
        for(_struct in structures) {
            _struct resolve(resolver)
        }
        for(var in variables) {
            var resolve(resolver)
        }
        for(fn in functions) {
            fn resolve(resolver)
        }
        resolver pop(this)
        resolved? = true
    }
    
    //addUse: func(_use: Use) {
    //    uses add(_use)
    //}
    
    //addImport: func(_import: Import) {
    //    imports add(_import)
    //}
    
    addFunction: func(fd: FunctionDecl) {
        functions add(fd)
    }
    
    addStructure: func(sd: StructDecl) {
        structures add(sd)
    }
    
    addVariable: func(vd: VariableDecl) {
        variables add(vd)
    }
    
    toString: func -> String {
        "Module[" + path + "]"
    }
    
    symbol: func(name: String) -> Node {
        for(sd in structures) {
            if(sd type name == name) return sd as Node
        }
        for(vd in variables) {
            if(vd name == name) return vd as Node
        }
        for(fd in functions) {
            if(fd name == name) return fd as Node
        }
        null
    }
    
    hasSymbol?: func(name: String) -> Bool {
        hasVariable?(name) || hasStruct?(name) || hasFunction?(name)
    }
    
    hasStruct?: func(name: String) -> Bool {
        for(sd in structures) {
            if(sd type name == name) return true
        }
        false
    }
    
    hasFunction?: func(name: String) -> Bool {
        for(fd in functions) {
            if(fd name == name) return true
        }
        false
    }
    
    hasVariable?: func(name: String) -> Bool {
        for(vd in variables) {
            if(vd name == name) return true
        }
        false
    }
    
    clone: func -> This {
        Module new(path)
    }
}

