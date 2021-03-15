import verik.base.*

class AluTb: Module() {

    @output var op  = t_Op()
    @output var a   = t_UbitData()
    @output var b   = t_UbitData()
    @input  var x   = t_UbitData()

    @run fun test() {
        repeat(200) { transact() }
    }

    @task fun transact() {
        op = when (random(10)) {
            0 -> Op.ADD
            1 -> Op.SUB
            2 -> Op.AND
            3 -> Op.OR
            4 -> Op.XOR
            5 -> Op.SLT
            6 -> Op.SLTU
            7 -> Op.SLL
            8 -> Op.SRL
            else -> Op.SRA
        }
    }
}