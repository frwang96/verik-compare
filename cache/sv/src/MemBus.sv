`timescale 1ns / 1ns

interface MemBus
import cache_pkg::*;
(input logic clk);

    Op       req_op;
    UbitAddr req_addr;
    UbitData req_data;
    logic    rsp_vld;
    UbitData rsp_data;

    clocking cp @(posedge clk);
        output req_op;
        output req_addr;
        output req_data;
        input  rsp_vld;
        input  rsp_data;
    endclocking

    modport tb_bp (clocking cp);

    modport tx_bp (
        output req_op,
        output req_addr,
        output req_data,
        input  rsp_vld,
        input  rsp_data
    );

    modport rx_bp (
        input  req_op,
        input  req_addr,
        input  req_data,
        output rsp_vld,
        output rsp_data
    );

endinterface: MemBus
