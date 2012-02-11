import structs/ArrayList
import ../frontend/Token
import Node,FunctionDecl,StructDecl,VariableDecl,Resolver,FunctionCall

Module: class extends Node {
    path: String
    init: func(=path) { super(Token _null) }

    functions := ArrayList<FunctionDecl> new()
    structures := ArrayList<StructDecl> new()
    variables := ArrayList<VariableDecl> new()
    //imports := ArrayList<Import> new()
    //uses := ArrayList<Use> new()
    
    resolve: func(resolver: Resolver) {
        if(resolved?) return
        ("Resolving " + toString() + "...") println()
        // TODO: resolve imports and uses
        resolver push(this)
        for(_struct in structures) {
            ("Resolving " + _struct toString() + "...") println()
            _struct resolve(resolver)
            (_struct toString() + " done") println()
        }
        for(var in variables) {
            var resolve(resolver)
        }
        for(fn in functions) {
            fn resolve(resolver)
        }
        (toString() + " done") println()
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
    
    clone: func -> This {
        Module new(path)
    }
}
