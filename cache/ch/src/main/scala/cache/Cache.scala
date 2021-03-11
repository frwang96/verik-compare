package cache

import chisel3._

class Cache extends Module {

    val io = IO(new Bundle {
        val rx = new MemBundle()
        val tx = Flipped(new MemBundle())
    })

    val state = Reg(UInt(Const.STATE_WIDTH.W))
    val lines = Reg(Vec(1 << Const.INDEX_WIDTH, new Line()))

    val cur_op = Reg(UInt(Const.OP_WIDTH.W))
    val cur_addr = Reg(UInt(Const.ADDR_WIDTH.W))
    val cur_data = Reg(UInt(Const.DATA_WIDTH.W))

    io.tx.reqOp := io.rx.reqOp
    io.tx.reqAddr := io.rx.reqAddr
    io.tx.reqData := io.rx.reqData
    io.rx.rspValid := io.tx.rspValid
    io.rx.rspData := io.tx.rspData

    def get_tag(addr: UInt) = {
        addr(Const.ADDR_WIDTH - 1, Const.ADDR_WIDTH - Const.TAG_WIDTH)
    }

    def get_index(addr: UInt) = {
        addr(Const.INDEX_WIDTH - 1, 0)
    }
}
