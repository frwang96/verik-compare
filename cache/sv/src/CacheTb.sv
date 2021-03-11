`timescale 1ns / 1ns

import cache_pkg::*;

module CacheTb (
    output logic rst,
    MemBus bp
);

    UbitData mem [1<<ADDR_WIDTH];

    initial begin
        reset();
        repeat (200) transact();
        $finish();
    end

    task automatic reset();
        for (int i = 0; i < 1<<ADDR_WIDTH; i++) mem[i] = 0;
        rst <= 1;
        bp.cp.req_op <= Op_INVALID;
        @(bp.cp);
        rst <= 0;
    endtask

    task automatic transact();
        repeat (3) @(bp.cp);
        if ($urandom_range(1) == 0) begin
            UbitAddr addr = $urandom();
            UbitData data = $urandom();
            mem[addr] = data;
            $display("tb write addr=0x%h data=0x%h", addr, data);
            @(bp.cp);
            bp.cp.req_op <= Op_WRITE;
            bp.cp.req_addr <= addr;
            bp.cp.req_data <= data;
            @(bp.cp);
            bp.cp.req_op <= Op_INVALID;
        end
        else begin
            UbitAddr addr = $urandom();
            UbitData data;
            UbitData expected;
            $display("tb read addr=0x%h", addr);
            @(bp.cp);
            bp.cp.req_op <= Op_READ;
            bp.cp.req_addr <= addr;
            @(bp.cp);
            bp.cp.req_op <= Op_INVALID;
            while (!bp.cp.rsp_vld) @(bp.cp);
            data = bp.cp.rsp_data;
            expected = mem[addr];
            if (data == expected) $display($sformatf("tb PASS data=0x%h expected=0x%h", data, expected));
            else $display($sformatf("tb FAIL data=0x%h expected=0x%h", data, expected));
        end
    endtask

endmodule: CacheTb
