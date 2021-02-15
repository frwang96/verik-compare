`timescale 1ns / 1ns

module CacheTb (
    MemBus bp
);

    logic [7:0] mem [64];

    initial begin: run_test
        reset();
        repeat (1000) begin
            transact();
        end
        $finish();
    end: run_test

    task automatic reset();
        for (int i = 0; i < 64; i++) begin
            mem[i] = 8'h00;
        end
        @(bp.cp);
        bp.cp.rst <= 1'b1;
        bp.cp.req_op <= pkg::Op_INVALID;
        @(bp.cp);
        bp.cp.rst <= 1'b0;
    endtask

    task automatic transact();
        repeat (3) begin
            @(bp.cp);
        end
        if ($urandom_range(2 - 1) == 0) begin
            logic [5:0] addr;
            logic [7:0] data;
            addr = 6'($urandom());
            data = 8'($urandom());
            mem[addr] = data;
            $display($sformatf("tb write addr=0x%h data=0x%h", addr, data));
            @(bp.cp);
            bp.cp.req_op <= pkg::Op_WRITE;
            bp.cp.req_addr <= addr;
            bp.cp.req_data <= data;
            @(bp.cp);
            bp.cp.req_op <= pkg::Op_INVALID;
        end
        else begin
            logic [5:0] addr;
            logic [7:0] data;
            logic [7:0] expected;
            addr = 6'($urandom());
            $display($sformatf("tb read addr=0x%h", addr));
            @(bp.cp);
            bp.cp.req_op <= pkg::Op_READ;
            bp.cp.req_addr <= addr;
            @(bp.cp);
            bp.cp.req_op <= pkg::Op_INVALID;
            while (!bp.cp.rsp_vld) begin
                @(bp.cp);
            end
            data = bp.cp.rsp_data;
            expected = mem[addr];
            if (data == expected) begin
                $display($sformatf("tb PASS data=0x%h expected=0x%h", data, expected));
            end
            else begin
                $display($sformatf("tb FAIL data=0x%h expected=0x%h", data, expected));
            end
        end
    endtask

endmodule: CacheTb
