import verik.base.*
import verik.data.*

class AluTb: Module() {

    @output var op  = t_Op()
    @output var a   = t_UbitData()
    @output var b   = t_UbitData()
    @input  var x   = t_UbitData()

    @run fun test() {
        repeat(200) { transact() }
    }

    @task fun transact() {
        a = u(DATA_WIDTH, random())
        b = u(DATA_WIDTH, random())
        op = random_enum(t_Op())
        val expected = when (op) {
            Op.ADD -> a + b
            Op.SUB -> a - b
            Op.AND -> a and b
            Op.OR -> a or b
            Op.XOR -> a xor b
            Op.SLTU -> if (a < b) u(1) else u(0)
            Op.SLT -> if (s(a) < s(b)) u(1) else u(0)
            Op.SLL -> a shl b
            Op.SRL -> a shr b
            Op.SRA -> u(s(a) shr b)
        }
        delay(1)
        if (x == expected) print("PASS") else print("FAIL")
        println(" op=$op a=0x$a b=0x$b x=0x$x expected=0x$expected")
    }
}