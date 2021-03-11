package cache

import chisel3._
import chisel3.util._

class Cache extends Module {

    val io = IO(new Bundle {
        val rx = new MemBundle()
        val tx = Flipped(new MemBundle())
    })

    val state = RegInit(Const.stateReady)
    val lines = Reg(Vec(1 << Const.INDEX_WIDTH, new Line()))

    val curOp = Reg(UInt(Const.OP_WIDTH.W))
    val curAddr = Reg(UInt(Const.ADDR_WIDTH.W))
    val curData = Reg(UInt(Const.DATA_WIDTH.W))

    val rspValid = RegInit(false.B)
    val rspData = Reg(UInt(Const.DATA_WIDTH.W))
    val reqOp = RegInit(Const.opInvalid)
    val reqAddr = Reg(UInt(Const.ADDR_WIDTH.W))
    val reqData = Reg(UInt(Const.DATA_WIDTH.W))

    io.rx.rspValid := rspValid
    io.rx.rspData := rspData
    io.tx.reqOp := reqOp
    io.tx.reqAddr := reqAddr
    io.tx.reqData := reqData

    rspValid := false.B
    rspData := 0.U
    reqOp := Const.opInvalid
    reqAddr := 0.U
    reqData := 0.U

    when (state === Const.stateReady) {
        when (io.rx.reqOp =/= Const.opInvalid) {
            printf("cache received op=%d addr=0x%x data=0x%x\n", io.rx.reqOp, io.rx.reqAddr, io.rx.reqData)
            curOp := io.rx.reqOp
            curAddr := io.rx.reqAddr
            curData := io.rx.reqData

            val tag = getTag(io.rx.reqAddr)
            val index = getIndex(io.rx.reqAddr)
            val line = lines(index)
            when (line.status =/= Const.statusInvalid && line.tag === tag) {
                printf("cache hit index=0x%x tag=0x%x line.tag=0x%x line.status=0x%x\n", index, tag, line.tag, line.status)
                when (io.rx.reqOp === Const.opWrite) {
                    lines(index).data := io.rx.reqData
                    lines(index).status := Const.statusDirty
                } .otherwise {
                    rspValid := true.B
                    rspData := line.data
                }
            } .otherwise {
                printf("cache miss index=0x%x tag=0x%x line.tag=0x%x line.status=0x%x\n", index, tag, line.tag, line.status)
                when (line.status === Const.statusDirty) {
                    reqOp := Const.opWrite
                    reqAddr := Cat(line.tag, index)
                    reqData := line.data
                    state := Const.stateWriteback
                } .otherwise {
                    reqOp := Const.opRead
                    reqAddr := io.rx.reqAddr
                    state := Const.stateFill
                }
            }
        }
    } .elsewhen (state === Const.stateWriteback) {
        reqOp := Const.opRead
        reqAddr := curAddr
        state := Const.stateFill
    } .elsewhen (state === Const.stateFill) {
        when (io.tx.rspValid) {
            val tag = getTag(curAddr)
            val index = getTag(curAddr)
            printf("cache fill index=0x%x tag=0x%x data=0x%x\n", index, tag, io.tx.rspData)
            lines(index).tag := tag
            when (curOp === Const.opWrite) {
                lines(index).data := curData
                lines(index).status := Const.statusDirty
            } .otherwise {
                lines(index).data := io.tx.rspData
                lines(index).status := Const.statusClean
                rspValid := true.B
                rspData := io.tx.rspData
            }
            state := Const.stateReady
        }
    }

    def getTag(addr: UInt) = {
        addr(Const.ADDR_WIDTH - 1, Const.ADDR_WIDTH - Const.TAG_WIDTH)
    }

    def getIndex(addr: UInt) = {
        addr(Const.INDEX_WIDTH - 1, 0)
    }
}
