package cache

import chisel3._
import chisel3.util._

object Const {

  val ADDR_WIDTH = 6
  val DATA_WIDTH = 8
  val TAG_WIDTH = 3
  val INDEX_WIDTH = 3

  val op_invalid :: op_read :: op_write :: Nil = Enum(3)
  val OP_WIDTH = op_invalid.getWidth

  val state_ready :: state_writeback :: state_fill :: Nil = Enum(3)
  val STATE_WIDTH = state_ready.getWidth

  val status_invalid :: status_clean :: status_dirty :: Nil = Enum(3)
  val STATUS_WIDTH = status_invalid.getWidth
}

class Line() extends Bundle {

  val status = UInt(Const.STATUS_WIDTH.W)
  val tag    = UInt(Const.TAG_WIDTH.W)
  val data   = UInt(Const.DATA_WIDTH.W)
}
