package cache

import chisel3._
import chisel3.util._

object Const {

  val ADDR_WIDTH = 6
  val DATA_WIDTH = 8
  val TAG_WIDTH = 3
  val INDEX_WIDTH = 3

  val opInvalid :: opRead :: opWrite :: Nil = Enum(3)
  val OP_WIDTH = opInvalid.getWidth

  val stateReady :: stateWriteback :: stateFill :: Nil = Enum(3)
  val STATE_WIDTH = stateReady.getWidth

  val statusInvalid :: statusClean :: statusDirty :: Nil = Enum(3)
  val STATUS_WIDTH = statusInvalid.getWidth
}

class Line() extends Bundle {

  val status = UInt(Const.STATUS_WIDTH.W)
  val tag    = UInt(Const.TAG_WIDTH.W)
  val data   = UInt(Const.DATA_WIDTH.W)
}
