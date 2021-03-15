import verik.base.*

class Top: Module() {

    var op  = t_Op()
    var a   = t_UbitData()
    var b   = t_UbitData()
    var x   = t_UbitData()

    @make val alu = t_Alu().with(op, a, b, x)
    @make val alu_tb = t_AluTb().with(op, a, b, x)
}