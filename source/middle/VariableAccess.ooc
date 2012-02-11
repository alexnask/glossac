import VariableDecl,Expression

VariableAccess: class extends Expression {
    ref: VariableDecl = null
    name: String // Name of the variable we are trying to access
}
