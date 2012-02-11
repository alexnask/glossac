import source/frontend/AstBuilder
import source/middle/Resolver

astBuilder := AstBuilder new("test.glossa")
res := Resolver new(astBuilder module)
