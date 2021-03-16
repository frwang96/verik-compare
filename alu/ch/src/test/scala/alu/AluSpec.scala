// See README.md for license details.

package alu

import chisel3.iotesters._

import scala.util.Random

class AluTester(dut: Alu) extends PeekPokeTester(dut) {

  Random.setSeed(0)
  for (_ <- 0 until 200) {
    val op = Random.nextInt(10)
    val a = Random.nextInt(1 << Const.DATA_WIDTH)
    val b = Random.nextInt(1 << Const.DATA_WIDTH)
    poke(dut.io.op, op)
    poke(dut.io.a, a)
    poke(dut.io.b, b)
    step(1)

    val x = peek(dut.io.x)
    val sa = signExtend(a)
    val sb = signExtend(b)
    val expected =
      (if (op == Op.add.toInt) a + b
      else if (op == Op.sub.toInt) a - b
      else if (op == Op.and.toInt) a & b
      else if (op == Op.or.toInt) a | b
      else if (op == Op.xor.toInt) a ^ b
      else if (op == Op.slt.toInt) if (sa < sb) 1 else 0
      else if (op == Op.sltu.toInt) if (a < b) 1 else 0
      else if (op == Op.sll.toInt) if (b < 32) a << b else 0
      else if (op == Op.srl.toInt) if (b < 32) a >>> b else 0
      else if (op == Op.sra.toInt) if (b < 32) sa >> b else if (sa < 0) -1 else 0
      else 0) & ((1 << Const.DATA_WIDTH) - 1)

    if (x == expected) printf("PASS") else printf("FAIL")
    printf(" op=%d a=0x%x b=0x%x x=0x%x expected=0x%x\n", op, a, b, x, expected)
  }

  def signExtend(x: Int): Int = if (x < (1 << (Const.DATA_WIDTH - 1))) x else (-(1 << Const.DATA_WIDTH)) | x
}

class AluSpec extends ChiselFlatSpec {
  behavior of "Top"
  it should "transact" in {
    chisel3.iotesters.Driver(() => new Alu()) { dut =>
      new AluTester(dut)
    } should be (true)
  }
}