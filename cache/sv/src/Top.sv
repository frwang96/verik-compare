`timescale 1ns / 1ns

module Top;

    logic clk;

    MemBus cache_bus (.clk (clk));

    MemBus mem_bus (.clk (clk));

    Cache cache (
        .clk   (clk),
        .rx_bp (cache_bus.rx_bp),
        .tx_bp (mem_bus.tx_bp)
    );

    Mem mem (.clk (clk), .bp (mem_bus.rx_bp));

    CacheTb tb (.bp (cache_bus.tb_bp));

    initial begin
        clk = 0;
        forever begin
            #1;
            clk = !clk;
        end
    end

endmodule: Top
