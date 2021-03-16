package alu

import chisel3.util._

object Const {

  val DATA_WIDTH = 8
}

object Op {

  val add :: sub :: and :: or :: xor :: slt :: sltu :: sll :: srl :: sra :: Nil = Enum(10)
  val WIDTH = add.getWidth
}
