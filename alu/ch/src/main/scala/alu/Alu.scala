package alu

import chisel3._
import chisel3.stage.ChiselStage
import chisel3.util._

class Alu extends Module {

    val io = IO(new AluBundle)

    io.x := 0.U
    switch(io.op) {
        is (Op.add) { io.x := io.a + io.b }
        is (Op.sub) { io.x := io.a - io.b }
        is (Op.and) { io.x := io.a & io.b }
        is (Op.or) { io.x := io.a | io.b }
        is (Op.xor) { io.x := io.a ^ io.b }
        is (Op.slt) { io.x := Mux(io.a.asSInt() < io.b.asSInt(), 1.U, 0.U) }
        is (Op.sltu) { io.x := Mux(io.a < io.b, 1.U, 0.U) }
        is (Op.sll) { io.x := io.a << io.b }
        is (Op.srl) { io.x := io.a >> io.b }
        is (Op.sra) { io.x := (io.a.asSInt() >> io.b).asUInt() }
    }
}

object Main extends App {
    (new ChiselStage).emitVerilog(new Alu, args)
}
