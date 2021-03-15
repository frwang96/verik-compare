import verik.base.*

class Alu: Module() {

    @input  var op  = t_Op()
    @input  var a   = t_UbitData()
    @input  var b   = t_UbitData()
    @output var x   = t_UbitData()
}