// See README.md for license details.

package cache

import chisel3._

class Mem extends Module {

  val io = IO(new MemBundle)

  io.rspValid := false.B
  io.rspData := 0.U
}
