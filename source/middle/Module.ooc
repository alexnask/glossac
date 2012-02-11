import structs/ArrayList
import Node,Import,Use,FunctionDecl,StructDecl,VariableDecl,Resolver,FunctionCall

Module: class extends Node {
    path: String
    init: func(=path,=token)

    functions := ArrayList<FunctionDecl> new()
    structures := ArrayList<StructDecl> new()
    variables := ArrayList<VariableDecl> new()
    imports := ArrayList<Import> new()
    uses := ArrayList<Use> new()
    
    resolve: func(resolver: Resolver) {
        
        for(struct in structures) {
            if(struct resolved?) continue
            struct resolve(resolver)
        }
        for(var in variables) {
            if(var resolved?) continue
            var resolve(resolver)
        }
        for(fn in functions) {
            if(fn resolved?) continue
            fn resolve(resolver)
        }

        resolved? = true
    }
    
    resolveCall: func(call: FunctionCall, resolver: Resolver) {
        
    }
    
    addUse: func(_use: Use) {
        uses add(_use)
    }
    
    addImport: func(_import: Import) {
        imports add(_import)
    }
    
    addFunction: func(fd: FunctionDecl) {
        functions add(fd)
    }
    
    addStructure: func(sd: StructDecl) {
        structures add(sd)
    }
    
    toString: func -> String {
        "Module with path:" + path
    }
    
    clone: func -> This {
        Module new(path,token)
    }
}
