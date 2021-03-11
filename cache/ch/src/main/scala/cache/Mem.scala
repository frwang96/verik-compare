// See README.md for license details.

package cache

import chisel3._

class Mem extends Module {

  val io = IO(new MemBundle)

  val mem = RegInit(VecInit(Seq.fill(1 << Const.ADDR_WIDTH)(0.U(Const.DATA_WIDTH.W))))
  val data = Reg(UInt(Const.DATA_WIDTH.W))
  val valid = RegInit(false.B)

  io.rspData := data
  io.rspValid := valid

  data := 0.U
  valid := false.B

  when (io.reqOp =/= Const.opInvalid) {
    printf("mem received op=%d addr=0x%x data=0x%x\n", io.reqOp, io.reqAddr, io.reqData)
    when (io.reqOp === Const.opWrite) {
      mem(io.reqAddr) := io.reqData
    } .otherwise {
      data := mem(io.reqAddr)
      valid := true.B
    }
  }
}
