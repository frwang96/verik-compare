`timescale 1ns / 1ns

module Mem
import cache_pkg::*;
(
    input logic clk,
    input logic rst,
    MemBus bp
);

    UbitData mem [1<<ADDR_WIDTH];

    always_ff @(posedge clk) begin
        bp.rsp_vld <= 0;
        if (rst) begin
            for (int i = 0; i < 1<<ADDR_WIDTH; i++) mem[i] <= 0;
        end
        else if (bp.req_op != Op_INVALID) begin
            $display("mem received op=%s addr=0x%h data=0x%h", bp.req_op.name(), bp.req_addr, bp.req_data);
            if (bp.req_op == Op_WRITE) begin
                mem[bp.req_addr] <= bp.req_data;
            end
            else begin
                bp.rsp_data <= mem[bp.req_addr];
                bp.rsp_vld <= 1;
            end
        end
    end

endmodule: Mem
