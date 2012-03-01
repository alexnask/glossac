import source/frontend/AstBuilder
import source/middle/Resolver
import source/backend/printer/PrinterBackend

astBuilder := AstBuilder new("test.glossa")
res := Resolver new(astBuilder module)
back := PrinterBackend new(astBuilder module)
back run()
