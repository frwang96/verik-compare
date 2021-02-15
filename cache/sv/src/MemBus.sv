`timescale 1ns / 1ns

import cache_pkg::*;

interface MemBus (input logic clk);

    logic    rst;
    Op       req_op;
    UbitAddr req_addr;
    UbitData req_data;
    logic    rsp_vld;
    UbitData rsp_data;

    clocking cp @(posedge clk);
        output rst;
        output req_op;
        output req_addr;
        output req_data;
        input  rsp_vld;
        input  rsp_data;
    endclocking

    modport tb_bp (clocking cp);

    modport tx_bp (
        output rst,
        output req_op,
        output req_addr,
        output req_data,
        input  rsp_vld,
        input  rsp_data
    );

    modport rx_bp (
        input  rst,
        input  req_op,
        input  req_addr,
        input  req_data,
        output rsp_vld,
        output rsp_data
    );

endinterface: MemBus
