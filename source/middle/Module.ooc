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
        // TODO: resolve imports and uses
        resolver push(this)
        for(struct in structures) {
            struct resolve(resolver)
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
    
    clone: func -> This {
        Module new(path)
    }
}
