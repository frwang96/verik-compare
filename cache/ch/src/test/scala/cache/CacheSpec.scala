// See README.md for license details.

package cache

import chisel3.iotesters._

import scala.util.Random

class CacheTester(dut: Top) extends PeekPokeTester(dut) {

  val mem = new Array[Int](1 << Const.ADDR_WIDTH)

  for (_ <- 0 until 200) {
    step(3)
    if (Random.nextBoolean()) {
      // write mem
      val addr = Random.nextInt() & ((1 << Const.ADDR_WIDTH) - 1)
      val data = Random.nextInt() & ((1 << Const.DATA_WIDTH) - 1)
      mem(addr) = data
      poke(dut.io.reqOp, Op.write)
      poke(dut.io.reqAddr, addr)
      poke(dut.io.reqData, data)
      printf("tb write addr=0x%x data=0x%x\n", addr, data)
      step(1)

      poke(dut.io.reqOp, Op.invalid)
      step(1)
    } else {
      // read mem
      val addr = Random.nextInt() & ((1 << Const.ADDR_WIDTH) - 1)
      poke(dut.io.reqOp, Op.read)
      poke(dut.io.reqAddr, addr)
      printf("tb read addr=0x%x\n", addr)
      step(1)

      poke(dut.io.reqOp, Op.invalid)
      while (peek(dut.io.rspValid) != BigInt(1)) step(1)
      val data = peek(dut.io.rspData)
      val expected = mem(addr)

      if (data == expected) {
        printf("tb PASS data=0x%x expected=0x%x\n", data, expected)
      } else {
        printf("tb FAIL data=0x%x expected=0x%x\n", data, expected)
      }
    }
  }
}

class CacheSpec extends ChiselFlatSpec {
  behavior of "Top"
  it should "transact" in {
    chisel3.iotesters.Driver(() => new Top()) { dut =>
      new CacheTester(dut)
    } should be (true)
  }
}