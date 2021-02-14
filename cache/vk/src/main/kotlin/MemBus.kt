import verik.base.*
import verik.data.*

class MemBus: Bus() {

    @input private var clk = t_Boolean()

    private var rst      = t_Boolean()
    private var req_op   = t_Op()
    private var req_addr = t_UbitAddr()
    private var req_data = t_UbitData()
    private var rsp_vld  = t_Boolean()
    private var rsp_data = t_UbitData()

    @make val cp = t_MemClockPort().with(
        event    = posedge(clk),
        rst      = rst,
        req_op   = req_op,
        req_addr = req_addr,
        req_data = req_data,
        rsp_vld  = rsp_vld,
        rsp_data = rsp_data
    )

    @make val tb_bp = t_MemTbBusPort().with(cp)

    @make val tx_bp = t_MemTxBusPort().with(
        rst      = rst,
        req_op   = req_op,
        req_addr = req_addr,
        req_data = req_data,
        rsp_vld  = rsp_vld,
        rsp_data = rsp_data
    )

    @make val rx_bp = t_MemRxBusPort().with(
        rst      = rst,
        req_op   = req_op,
        req_addr = req_addr,
        req_data = req_data,
        rsp_vld  = rsp_vld,
        rsp_data = rsp_data
    )
}

class MemClockPort: ClockPort() {

    @output var rst = t_Boolean()
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

    @output var rst = t_Boolean()
    @output var req_op   = t_Op()
    @output var req_addr = t_UbitAddr()
    @output var req_data = t_UbitData()
    @input  var rsp_vld  = t_Boolean()
    @input  var rsp_data = t_UbitData()
}

class MemRxBusPort: BusPort() {

    @input  var rst = t_Boolean()
    @input  var req_op   = t_Op()
    @input  var req_addr = t_UbitAddr()
    @input  var req_data = t_UbitData()
    @output var rsp_vld  = t_Boolean()
    @output var rsp_data = t_UbitData()
}
