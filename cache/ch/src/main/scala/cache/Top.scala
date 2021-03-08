package cache

import chisel3.stage.ChiselStage
import chisel3._

class Top extends Module {
  val io = IO(new MemBundle)

  val cache = Module(new Cache())
  cache.io.rx.reqOp := io.reqOp
  cache.io.rx.reqAddr := io.reqAddr
  cache.io.rx.reqData := io.reqData
  io.rspValid := cache.io.rx.rspValid
  io.rspData := cache.io.rx.rspData

  val mem = Module(new Mem())
  mem.io.reqOp := cache.io.tx.reqOp
  mem.io.reqAddr := cache.io.tx.reqAddr
  mem.io.reqData := cache.io.tx.reqData
  cache.io.tx.rspValid := mem.io.rspValid
  cache.io.tx.rspData := mem.io.rspData
}

object Main extends App {
  (new ChiselStage).emitVerilog(new Top, args)
}