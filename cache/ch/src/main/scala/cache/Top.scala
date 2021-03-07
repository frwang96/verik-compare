package cache

import chisel3.stage.ChiselStage
import chisel3._

class Top extends Module {
  val io = IO(new MemBundle)

  val mem = Module(new Mem())
  mem.io.reqOp := io.reqOp
  mem.io.reqAddr := io.reqAddr
  mem.io.reqData := io.reqData
  io.rspValid := mem.io.rspValid
  io.rspData := mem.io.rspData
}

object Main extends App {
  (new ChiselStage).emitVerilog(new Top, args)
}