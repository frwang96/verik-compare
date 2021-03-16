package alu

import chisel3._

class AluBundle extends Bundle {
  val op = Input(UInt(Op.WIDTH.W))
  val a = Input(UInt(Const.DATA_WIDTH.W))
  val b = Input(UInt(Const.DATA_WIDTH.W))
  val x = Output(UInt(Const.DATA_WIDTH.W))
}
