package cache

import chisel3.stage.ChiselStage
import chisel3._

class Top extends Module {

  val io = IO(new Bundle {
    val rst = Input(Bool())
    val rx = new MemBundle()
  })

  val cache = Module(new Cache())
  cache.io.rst := io.rst
  cache.io.rx.reqOp := io.rx.reqOp
  cache.io.rx.reqAddr := io.rx.reqAddr
  cache.io.rx.reqData := io.rx.reqData
  io.rx.rspValid := cache.io.rx.rspValid
  io.rx.rspData := cache.io.rx.rspData

  val mem = Module(new Mem())
  mem.io.rst := io.rst
  mem.io.rx.reqOp := cache.io.tx.reqOp
  mem.io.rx.reqAddr := cache.io.tx.reqAddr
  mem.io.rx.reqData := cache.io.tx.reqData
  cache.io.tx.rspValid := mem.io.rx.rspValid
  cache.io.tx.rspData := mem.io.rx.rspData
}

object Main extends App {
  (new ChiselStage).emitVerilog(new Top, args)
}