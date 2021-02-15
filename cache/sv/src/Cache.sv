`timescale 1ns / 1ns

module Cache (
    input logic  clk,
    MemBus rx_bp,
    MemBus tx_bp
);

    pkg::State  state;
    pkg::Line   lines [8];
    pkg::Op     cur_op;
    logic [5:0] cur_addr;
    logic [7:0] cur_data;

    always_ff @(posedge clk) begin: update
        rx_bp.rsp_vld <= 1'b0;
        tx_bp.rst <= 1'b0;
        tx_bp.req_op <= pkg::Op_INVALID;
        if (rx_bp.rst) begin
            tx_bp.rst <= 1'b1;
            state <= pkg::State_READY;
            for (int i = 0; i < 8; i++) begin
                lines[i] <= '{pkg::Status_INVALID, 3'h0, 8'h00};
            end
        end
        else if (state == pkg::State_READY) begin
            if (rx_bp.req_op != pkg::Op_INVALID) begin
                automatic logic [2:0] tag;
                automatic logic [2:0] index;
                automatic pkg::Line   line;
                $display($sformatf("cache received op=%s addr=0x%h data=0x%h", rx_bp.req_op.name(), rx_bp.req_addr,
                    rx_bp.req_data));
                cur_op <= rx_bp.req_op;
                cur_addr <= rx_bp.req_addr;
                cur_data <= rx_bp.req_data;
                tag = get_tag(rx_bp.req_addr);
                index = get_index(rx_bp.req_addr);
                line = lines[index];
                if (line.status != pkg::Status_INVALID && line.tag == tag) begin
                    $display($sformatf("cache hit index=0x%h tag=0x%h line.tag=0x%h line.status=%s", index, tag,
                        line.tag, line.status.name()));
                    if (rx_bp.req_op == pkg::Op_WRITE) begin
                        lines[index].data <= rx_bp.req_data;
                        lines[index].status <= pkg::Status_DIRTY;
                    end
                    else begin
                        rx_bp.rsp_vld <= 1'b1;
                        rx_bp.rsp_data <= line.data;
                    end
                end
                else begin
                    $display($sformatf("cache miss index=0x%h tag=0x%h line.tag=0x%h line.status=%s", index, tag,
                        line.tag, line.status.name()));
                    if (line.status == pkg::Status_DIRTY) begin
                        tx_bp.req_op <= pkg::Op_WRITE;
                        tx_bp.req_addr <= {line.tag, index};
                        tx_bp.req_data <= line.data;
                        state <= pkg::State_WRITEBACK;
                    end
                    else begin
                        tx_bp.req_op <= pkg::Op_READ;
                        tx_bp.req_addr <= rx_bp.req_addr;
                        state <= pkg::State_FILL;
                    end
                end
            end
        end
        else if (state == pkg::State_WRITEBACK) begin
            tx_bp.req_op <= pkg::Op_READ;
            tx_bp.req_addr <= cur_addr;
            state <= pkg::State_FILL;
        end
        else if (state == pkg::State_FILL) begin
            if (tx_bp.rsp_vld) begin
                automatic logic [2:0] tag;
                automatic logic [2:0] index;
                tag = get_tag(cur_addr);
                index = get_index(cur_addr);
                $display($sformatf("cache fill index=0x%h tag=0x%h data=0x%h", index, tag, tx_bp.rsp_data));
                lines[index] <= '{pkg::Status_CLEAN, tag, tx_bp.rsp_data};
                if (cur_op == pkg::Op_WRITE) begin
                    lines[index].data <= cur_data;
                    lines[index].status <= pkg::Status_DIRTY;
                end
                else begin
                    rx_bp.rsp_vld <= 1'b1;
                    rx_bp.rsp_data <= tx_bp.rsp_data;
                end
                state <= pkg::State_READY;
            end
        end
    end: update

    function automatic logic [2:0] get_tag(
        logic [5:0] addr
    );
        return addr[5:3];
    endfunction

    function automatic logic [2:0] get_index(
        logic [5:0] addr
    );
        return addr[2:0];
    endfunction

endmodule: Cache
