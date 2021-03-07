// See README.md for license details.

package cache

import chisel3.iotesters._

class CacheTester(dut: Top) extends PeekPokeTester(dut)

class CacheSpec extends ChiselFlatSpec {
  behavior of "Top"
  it should "transact" in {
    chisel3.iotesters.Driver(() => new Top()) { dut =>
      new CacheTester(dut)
    } should be (true)
  }
}