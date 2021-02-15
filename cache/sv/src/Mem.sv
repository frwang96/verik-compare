`timescale 1ns / 1ns

module Mem (
    input logic  clk,
    MemBus bp
);

    logic [7:0] mem [64];

    always_ff @(posedge clk) begin: update
        bp.rsp_vld <= 1'b0;
        if (bp.rst) begin
            for (int i = 0; i < 64; i++) begin
                mem[i] <= 8'h00;
            end
        end
        else if (bp.req_op != pkg::Op_INVALID) begin
            $display($sformatf("mem received op=%s addr=0x%h data=0x%h", bp.req_op.name(), bp.req_addr, bp.req_data));
            if (bp.req_op == pkg::Op_WRITE) begin
                mem[bp.req_addr] <= bp.req_data;
            end
            else begin
                bp.rsp_data <= mem[bp.req_addr];
                bp.rsp_vld <= 1'b1;
            end
        end
    end: update

endmodule: Mem
