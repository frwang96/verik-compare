`timescale 1ns / 1ns

module Alu
import alu_pkg::*;
(
    input  Op op,
    input  UbitData a,
    input  UbitData b,
    output UbitData x
);

    always_comb begin
        case (op)
            ADD: x = a + b;
            SUB: x = a - b;
            AND: x = a & b;
            OR: x = a | b;
            XOR: x = a ^ b;
            SLT: x = signed'(a) < signed'(b);
            SLTU: x = a < b;
            SLL: x = a << b;
            SRL: x = a >> b;
            SRA: x = a >>> b;
        endcase
    end

endmodule: Alu

