// See README.md for license details.

package cache

import chisel3._

class Mem extends Module {

  val io = IO(new MemBundle)

  val mem = Reg(Vec(1 << Const.ADDR_WIDTH, UInt(Const.DATA_WIDTH.W)))

  io.rspValid := false.B
  io.rspData := 0.U

  when (io.reqOp =/= Const.op_invalid) {
    printf("mem received op=%x", io.reqOp)
  }
}
