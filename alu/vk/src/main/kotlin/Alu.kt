import verik.base.*
import verik.data.*

class Alu: Module() {

    @input  var op  = t_Op()
    @input  var a   = t_UbitData()
    @input  var b   = t_UbitData()
    @output var x   = t_UbitData()

    @com fun update() {
        x = when (op) {
            Op.ADD -> a + b
            Op.SUB -> a - b
            Op.AND -> a and b
            Op.OR -> a or b
            Op.XOR -> a xor b
            Op.SLT -> if (s(a) < s(b)) u(1) else u(0)
            Op.SLTU -> if (a < b) u(1) else u(0)
            Op.SLL -> a shl b
            Op.SRL -> a shr b
            Op.SRA -> u(s(a) shr b)
        }
    }
}