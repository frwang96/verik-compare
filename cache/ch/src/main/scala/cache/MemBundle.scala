package cache

import chisel3._

class MemBundle extends Bundle {
  val reqOp    = Input(UInt(Const.op_invalid.getWidth.W))
  val reqAddr  = Input(UInt(Const.ADDR_WIDTH.W))
  val reqData  = Input(UInt(Const.DATA_WIDTH.W))
  val rspValid = Output(Bool())
  val rspData  = Output(UInt(Const.DATA_WIDTH.W))
}
