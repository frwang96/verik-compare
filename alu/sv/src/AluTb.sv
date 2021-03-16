`timescale 1ns / 1ns

module AluTb
import alu_pkg::*;
(
    output Op op,
    output UbitData a,
    output UbitData b,
    input  UbitData x
);

    initial begin
        repeat (200) transact();
    end

    task automatic transact();
        UbitData expected;
        a = $urandom();
        b = $urandom();
        op = Op'($urandom_range(Op.num() - 1));
        case (op)
            ADD: expected = a + b;
            SUB: expected = a - b;
            AND: expected = a & b;
            OR: expected = a | b;
            XOR: expected = a ^ b;
            SLT: expected = signed'(a) < signed'(b);
            SLTU: expected = a < b;
            SLL: expected = a << b;
            SRL: expected = a >> b;
            SRA: expected = a >>> b;
        endcase

        #1;
        if (x == expected) $write("PASS");
        else $write("FAIL");
        $display(" op=%s a=0x%h b=0x%h x=0x%h expected=0x%h", op.name(), a, b, x, expected);
    endtask

endmodule: AluTb
