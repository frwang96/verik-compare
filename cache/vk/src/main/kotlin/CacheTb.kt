import verik.base.*
import verik.collection.*
import verik.data.*

class CacheTb: Module() {

    @inout val bp = t_MemTbBusPort()

    val mem = t_Array(exp(ADDR_WIDTH), t_UbitData())

    @run fun run_test() {
        reset()
        repeat(100) { transact() }
        finish()
    }

    @task fun reset() {
        for (i in range(exp(ADDR_WIDTH))) {
            mem[i] = u(0)
        }
        wait(bp.cp)
        bp.cp.rst = true
        bp.cp.req_op = Op.INVALID
        wait(bp.cp)
        bp.cp.rst = false
    }

    @task fun transact() {
        repeat(3) { wait(bp.cp) }
        if (random(2) == 0) {
            // write mem
            val addr = u(ADDR_WIDTH, random())
            val data = u(DATA_WIDTH, random())
            mem[addr] = data
            println("tb write addr=0x$addr data=0x$data")

            wait(bp.cp)
            bp.cp.req_op = Op.WRITE
            bp.cp.req_addr = addr
            bp.cp.req_data = data
            wait(bp.cp)
            bp.cp.req_op = Op.INVALID
        } else {
            // read mem
            val addr = u(ADDR_WIDTH, random())
            println("tb read addr=0x$addr")

            wait(bp.cp)
            bp.cp.req_op = Op.READ
            bp.cp.req_addr = addr
            wait(bp.cp)
            bp.cp.req_op = Op.INVALID

            while (!bp.cp.rsp_vld) wait(bp.cp)
            val data = bp.cp.rsp_data
            val expected = mem[addr]

            if (data == expected) {
                println("tb PASS data=0x$data expected=0x$expected")
            } else {
                println("tb FAIL data=0x$data expected=0x$expected")
            }
        }
    }
}