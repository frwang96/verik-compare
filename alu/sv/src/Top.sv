`timescale 1ns / 1ns

module Top;

    alu_pkg::Op op;
    logic [7:0] a;
    logic [7:0] b;
    logic [7:0] x;

    Alu alu (op, a, b, x);
    AluTb alu_tb (op, a, b, x);

endmodule: Top

