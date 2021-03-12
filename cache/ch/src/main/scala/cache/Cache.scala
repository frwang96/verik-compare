package cache

import chisel3._
import chisel3.util._

class Cache extends Module {

    val io = IO(new Bundle {
        val rst = Input(Bool())
        val rx = new MemBundle()
        val tx = Flipped(new MemBundle())
    })

    val state = RegInit(State.ready)
    val lines = Reg(Vec(1 << Const.INDEX_WIDTH, new Line()))

    val curOp = RegInit(Op.invalid)
    val curAddr = Reg(UInt(Const.ADDR_WIDTH.W))
    val curData = Reg(UInt(Const.DATA_WIDTH.W))

    val rspValid = RegInit(false.B)
    val rspData = Reg(UInt(Const.DATA_WIDTH.W))
    val reqOp = RegInit(Op.invalid)
    val reqAddr = Reg(UInt(Const.ADDR_WIDTH.W))
    val reqData = Reg(UInt(Const.DATA_WIDTH.W))

    io.rx.rspValid := rspValid
    io.rx.rspData := rspData
    io.tx.reqOp := reqOp
    io.tx.reqAddr := reqAddr
    io.tx.reqData := reqData

    rspValid := false.B
    rspData := 0.U
    reqOp := Op.invalid
    reqAddr := 0.U
    reqData := 0.U

    when (io.rst) {
        lines.foreach { _.status := Status.invalid }
    } .elsewhen (state === State.ready) {
        when (io.rx.reqOp =/= Op.invalid) {
            printf("cache received op=%d addr=0x%x data=0x%x\n", io.rx.reqOp, io.rx.reqAddr, io.rx.reqData)
            curOp := io.rx.reqOp
            curAddr := io.rx.reqAddr
            curData := io.rx.reqData

            val tag = getTag(io.rx.reqAddr)
            val index = getIndex(io.rx.reqAddr)
            val line = lines(index)
            when (line.status =/= Status.invalid && line.tag === tag) {
                printf("cache hit index=0x%x tag=0x%x line.tag=0x%x line.status=0x%x\n", index, tag, line.tag, line.status)
                when (io.rx.reqOp === Op.write) {
                    lines(index).data := io.rx.reqData
                    lines(index).status := Status.dirty
                } .otherwise {
                    rspValid := true.B
                    rspData := line.data
                }
            } .otherwise {
                printf("cache miss index=0x%x tag=0x%x line.tag=0x%x line.status=0x%x\n", index, tag, line.tag, line.status)
                when (line.status === Status.dirty) {
                    reqOp := Op.write
                    reqAddr := Cat(line.tag, index)
                    reqData := line.data
                    state := State.writeback
                } .otherwise {
                    reqOp := Op.read
                    reqAddr := io.rx.reqAddr
                    state := State.fill
                }
            }
        }
    } .elsewhen (state === State.writeback) {
        reqOp := Op.read
        reqAddr := curAddr
        state := State.fill
    } .elsewhen (state === State.fill) {
        when (io.tx.rspValid) {
            val tag = getTag(curAddr)
            val index = getIndex(curAddr)
            printf("cache fill index=0x%x tag=0x%x data=0x%x\n", index, tag, io.tx.rspData)
            lines(index).tag := tag
            when (curOp === Op.write) {
                lines(index).data := curData
                lines(index).status := Status.dirty
            } .otherwise {
                lines(index).data := io.tx.rspData
                lines(index).status := Status.clean
                rspValid := true.B
                rspData := io.tx.rspData
            }
            state := State.ready
        }
    }

    def getTag(addr: UInt) = {
        addr(Const.ADDR_WIDTH - 1, Const.ADDR_WIDTH - Const.TAG_WIDTH)
    }

    def getIndex(addr: UInt) = {
        addr(Const.INDEX_WIDTH - 1, 0)
    }
}
