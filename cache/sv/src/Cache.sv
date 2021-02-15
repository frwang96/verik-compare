`timescale 1ns / 1ns

import cache_pkg::*;

module Cache (
    input logic clk,
    MemBus rx_bp,
    MemBus tx_bp
);

    State    state;
    Line     lines [1<<INDEX_WIDTH];
    Op       cur_op;
    UbitAddr cur_addr;
    UbitData cur_data;

    always_ff @(posedge clk) begin
        rx_bp.rsp_vld <= 0;
        tx_bp.rst <= 0;
        tx_bp.req_op <= Op_INVALID;
        if (rx_bp.rst) begin
            tx_bp.rst <= 1;
            state <= State_READY;
            for (int i = 0; i < 1<<INDEX_WIDTH; i++) begin
                lines[i] <= '{Status_INVALID, 0, 0};
            end
        end
        else if (state == State_READY) begin
            if (rx_bp.req_op != Op_INVALID) begin
                automatic UbitTag tag;
                automatic UbitIndex index;
                automatic Line line;
                $display("cache received op=%s addr=0x%h data=0x%h", rx_bp.req_op.name(), rx_bp.req_addr,
                    rx_bp.req_data);
                cur_op <= rx_bp.req_op;
                cur_addr <= rx_bp.req_addr;
                cur_data <= rx_bp.req_data;
                tag = get_tag(rx_bp.req_addr);
                index = get_index(rx_bp.req_addr);
                line = lines[index];
                if (line.status != Status_INVALID && line.tag == tag) begin
                    $display("cache hit index=0x%h tag=0x%h line.tag=0x%h line.status=%s", index, tag, line.tag,
                        line.status.name());
                    if (rx_bp.req_op == Op_WRITE) begin
                        lines[index].data <= rx_bp.req_data;
                        lines[index].status <= Status_DIRTY;
                    end
                    else begin
                        rx_bp.rsp_vld <= 1;
                        rx_bp.rsp_data <= line.data;
                    end
                end
                else begin
                    $display("cache miss index=0x%h tag=0x%h line.tag=0x%h line.status=%s", index, tag, line.tag,
                        line.status.name());
                    if (line.status == Status_DIRTY) begin
                        tx_bp.req_op <= Op_WRITE;
                        tx_bp.req_addr <= {line.tag, index};
                        tx_bp.req_data <= line.data;
                        state <= State_WRITEBACK;
                    end
                    else begin
                        tx_bp.req_op <= Op_READ;
                        tx_bp.req_addr <= rx_bp.req_addr;
                        state <= State_FILL;
                    end
                end
            end
        end
        else if (state == State_WRITEBACK) begin
            tx_bp.req_op <= Op_READ;
            tx_bp.req_addr <= cur_addr;
            state <= State_FILL;
        end
        else if (state == State_FILL) begin
            if (tx_bp.rsp_vld) begin
                automatic UbitTag tag = get_tag(cur_addr);
                automatic UbitIndex index = get_index(cur_addr);
                $display("cache fill index=0x%h tag=0x%h data=0x%h", index, tag, tx_bp.rsp_data);
                lines[index] <= '{Status_CLEAN, tag, tx_bp.rsp_data};
                if (cur_op == Op_WRITE) begin
                    lines[index].data <= cur_data;
                    lines[index].status <= Status_DIRTY;
                end
                else begin
                    rx_bp.rsp_vld <= 1;
                    rx_bp.rsp_data <= tx_bp.rsp_data;
                end
                state <= State_READY;
            end
        end
    end

    function automatic UbitTag get_tag(UbitAddr addr);
        return addr[ADDR_WIDTH-1:ADDR_WIDTH-TAG_WIDTH];
    endfunction

    function automatic UbitIndex get_index(UbitAddr addr);
        return addr[INDEX_WIDTH-1:0];
    endfunction

endmodule: Cache
