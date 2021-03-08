// See README.md for license details.

package cache

import chisel3._

class Mem extends Module {

  val io = IO(new MemBundle)

  val mem = RegInit(VecInit(Seq.fill(1 << Const.ADDR_WIDTH)(0.U(Const.DATA_WIDTH.W))))
  val data = Reg(UInt(Const.DATA_WIDTH.W))
  val valid = RegInit(false.B)

  io.rspData := RegNext(data)
  io.rspValid := RegNext(valid)

  when (io.reqOp =/= Const.op_invalid) {
    printf("mem received op=%d addr=0x%x data=0x%x\n", io.reqOp, io.reqAddr, io.reqData)
    when (io.reqOp === Const.op_write) {
      mem(io.reqAddr) := io.reqData
      data := 0.U
      valid := false.B
    } .otherwise {
      data := mem(io.reqAddr)
      valid := true.B
    }
  } .otherwise {
    data := 0.U
    valid := false.B
  }
}
