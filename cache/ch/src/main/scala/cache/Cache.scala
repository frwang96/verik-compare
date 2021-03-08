package cache

import chisel3._

class Cache extends Module {

    val io = IO(new Bundle {
        val rx = new MemBundle()
        val tx = Flipped(new MemBundle())
    })

    io.tx.reqOp := io.rx.reqOp
    io.tx.reqAddr := io.rx.reqAddr
    io.tx.reqData := io.rx.reqData
    io.rx.rspValid := io.tx.rspValid
    io.rx.rspData := io.tx.rspData
}
