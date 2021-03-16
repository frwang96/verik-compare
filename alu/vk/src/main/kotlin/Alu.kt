import verik.base.*
import verik.data.*

class Alu: Module() {

    @input  var op  = t_Op()
    @input  var a   = t_UbitData()
    @input  var b   = t_UbitData()
    @output var x   = t_UbitData()

    @com fun update() {
        @Suppress("LiftReturnOrAssignment")
        // TODO support exhaustive case assignment
        when (op) {
            Op.ADD -> x = a + b
            Op.SUB -> x = a - b
            Op.AND -> x = a and b
            Op.OR -> x = a or b
            Op.XOR -> x = a xor b
            Op.SLT -> x = if (s(a) < s(b)) u(DATA_WIDTH, 1) else u(DATA_WIDTH, 0)
            Op.SLTU -> x = if (a < b) u(DATA_WIDTH, 1) else u(DATA_WIDTH, 0)
            Op.SLL -> x = a shl b
            Op.SRL -> x = a shr b
            Op.SRA -> x = u(s(a) shr b)
        }
    }
}