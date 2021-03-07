package cache

import chisel3.util._

object Const {

  val ADDR_WIDTH = 6
  val DATA_WIDTH = 8
  val TAG_WIDTH = 3
  val INDEX_WIDTH = 3

  val op_invalid :: op_read :: op_write :: Nil = Enum(3)
}
