import verik.base.*
import verik.collection.*
import verik.data.*

class Mem: Module() {

    @input var clk = t_Boolean()
    @inout val bp  = t_MemRxBusPort()

    var mem = t_Array(exp(ADDR_WIDTH), t_UbitData())

    @seq fun update() {
        on (posedge(clk)) {
            bp.rsp_vld = false
            if (bp.rst) {
                for (i in range(exp(ADDR_WIDTH))) {
                    mem[i] = u(0)
                }
            } else {
                if (bp.req_op != Op.INVALID) {
                    println("mem received op=${bp.req_op} addr=0x${bp.req_addr} data=0x${bp.req_data}")
                    if (bp.req_op == Op.WRITE) {
                        mem[bp.req_addr] = bp.req_data
                    } else {
                        bp.rsp_data = mem[bp.req_addr]
                        bp.rsp_vld = true
                    }
                }
            }
        }
    }
}