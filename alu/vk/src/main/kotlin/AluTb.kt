import verik.base.*
import verik.data.*

class AluTb: Module() {

    @output var op  = t_Op()
    @output var a   = t_UbitData()
    @output var b   = t_UbitData()
    @input  var x   = t_UbitData()

    var expected = t_UbitData()

    @run fun test() {
        repeat(200) { transact() }
    }

    @task fun transact() {
        a = u(DATA_WIDTH, random())
        b = u(DATA_WIDTH, random())
        @Suppress("MoveVariableDeclarationIntoWhen")
        // TODO support inlined variable
        // TODO support random enum
        val s = random(10)
        when(s) {
            0 -> {
                op = Op.ADD
                expected = a + b
            }
            1 -> {
                op = Op.SUB
                expected = a - b
            }
            2 -> {
                op = Op.AND
                expected = a and b
            }
            3 -> {
                op = Op.OR
                expected = a or b
            }
            4 -> {
                op = Op.XOR
                expected = a xor b
            }
            5 -> {
                op = Op.SLT
                expected = if (s(a) < s(b)) u(DATA_WIDTH, 1) else u(DATA_WIDTH, 0)
            }
            6 -> {
                op = Op.SLTU
                expected = if (a < b) u(DATA_WIDTH, 1) else u(DATA_WIDTH, 0)
            }
            7 -> {
                op = Op.SLL
                expected = a shl b
            }
            8 -> {
                op = Op.SRL
                expected = a shr b
            }
            else -> {
                op = Op.SRA
                expected = u(s(a) shr b)
            }
        }
        delay(1)
        if (x == expected) print("PASS") else print("FAIL")
        println(" op=$op a=0x$a b=0x$b x=0x$x expected=0x$expected")
    }
}