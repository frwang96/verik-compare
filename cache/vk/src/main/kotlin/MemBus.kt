import verik.base.*
import verik.data.*

class MemBus: Bus() {

    @input var clk = t_Boolean()

    var req_op   = t_Op()
    var req_addr = t_UbitAddr()
    var req_data = t_UbitData()
    var rsp_vld  = t_Boolean()
    var rsp_data = t_UbitData()

    @make val cp = t_MemClockPort().with(
        event    = posedge(clk),
        req_op   = req_op,
        req_addr = req_addr,
        req_data = req_data,
        rsp_vld  = rsp_vld,
        rsp_data = rsp_data
    )

    @make val tb_bp = t_MemTbBusPort().with(cp)

    @make val tx_bp = t_MemTxBusPort().with(
        req_op   = req_op,
        req_addr = req_addr,
        req_data = req_data,
        rsp_vld  = rsp_vld,
        rsp_data = rsp_data
    )

    @make val rx_bp = t_MemRxBusPort().with(
        req_op   = req_op,
        req_addr = req_addr,
        req_data = req_data,
        rsp_vld  = rsp_vld,
        rsp_data = rsp_data
    )
}

class MemClockPort: ClockPort() {

    @output var req_op   = t_Op()
    @output var req_addr = t_UbitAddr()
    @output var req_data = t_UbitData()
    @input  var rsp_vld  = t_Boolean()
    @input  var rsp_data = t_UbitData()
}

class MemTbBusPort: BusPort() {

    @inout val cp = t_MemClockPort()
}

class MemTxBusPort: BusPort() {

    @output var req_op   = t_Op()
    @output var req_addr = t_UbitAddr()
    @output var req_data = t_UbitData()
    @input  var rsp_vld  = t_Boolean()
    @input  var rsp_data = t_UbitData()
}

class MemRxBusPort: BusPort() {

    @input  var req_op   = t_Op()
    @input  var req_addr = t_UbitAddr()
    @input  var req_data = t_UbitData()
    @output var rsp_vld  = t_Boolean()
    @output var rsp_data = t_UbitData()
}
