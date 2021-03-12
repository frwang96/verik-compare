// See README.md for license details.

package cache

import chisel3._

class Mem extends Module {

  val io = IO(new Bundle {
    val rst = Input(Bool())
    val rx = new MemBundle()
  })

  val mem = RegInit(VecInit(Seq.fill(1 << Const.ADDR_WIDTH)(0.U(Const.DATA_WIDTH.W))))
  val data = Reg(UInt(Const.DATA_WIDTH.W))
  val valid = RegInit(false.B)

  io.rx.rspData := data
  io.rx.rspValid := valid

  data := 0.U
  valid := false.B

  when (io.rst) {
    mem.foreach { _ := 0.U }
  } .elsewhen (io.rx.reqOp =/= Op.invalid) {
    printf("mem received op=%d addr=0x%x data=0x%x\n", io.rx.reqOp, io.rx.reqAddr, io.rx.reqData)
    when (io.rx.reqOp === Op.write) {
      mem(io.rx.reqAddr) := io.rx.reqData
    } .otherwise {
      data := mem(io.rx.reqAddr)
      valid := true.B
    }
  }
}
