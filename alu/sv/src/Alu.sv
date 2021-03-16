`timescale 1ns / 1ns

module Alu (
    input  alu_pkg::Op op,
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [7:0] x
);

    always_comb begin
        case (op)
            alu_pkg::ADD: x = a + b;
            alu_pkg::SUB: x = a - b;
            alu_pkg::AND: x = a & b;
            alu_pkg::OR: x = a | b;
            alu_pkg::XOR: x = a ^ b;
            alu_pkg::SLT: x = signed'(a) < signed'(b);
            alu_pkg::SLTU: x = a < b;
            alu_pkg::SLL: x = a << b;
            alu_pkg::SRL: x = a >> b;
            alu_pkg::SRA: x = a >>> b;
        endcase
    end

endmodule: Alu

