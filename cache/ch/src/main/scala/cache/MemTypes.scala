package cache

import chisel3._
import chisel3.util._

object Const {

  val ADDR_WIDTH = 6
  val DATA_WIDTH = 8
  val TAG_WIDTH = 3
  val INDEX_WIDTH = 3
}

object Op {

  val invalid :: read :: write :: Nil = Enum(3)
  val WIDTH = invalid.getWidth
}

object State {

  val ready :: writeback :: fill :: Nil = Enum(3)
  val WIDTH = ready.getWidth
}

object Status {

  val invalid :: clean :: dirty :: Nil = Enum(3)
  val WIDTH = invalid.getWidth
}

class Line() extends Bundle {

  val status = UInt(Status.WIDTH.W)
  val tag    = UInt(Const.TAG_WIDTH.W)
  val data   = UInt(Const.DATA_WIDTH.W)
}
