`timescale 1ns / 1ns

module Top
import alu_pkg::*;
();

    Op op;
    UbitData a;
    UbitData b;
    UbitData x;

    Alu alu (op, a, b, x);
    AluTb alu_tb (op, a, b, x);

endmodule: Top
