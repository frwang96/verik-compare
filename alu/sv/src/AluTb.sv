`timescale 1ns / 1ns

module AluTb (
    output alu_pkg::Op op,
    output logic [7:0] a,
    output logic [7:0] b,
    input  logic [7:0] x
);

    initial begin
        repeat (200) transact();
    end

    task automatic transact();
        logic [7:0] expected;
        a = $urandom();
        b = $urandom();
        op = alu_pkg::Op'($urandom_range(alu_pkg::Op.num() - 1));
        case (op)
            alu_pkg::ADD: expected = a + b;
            alu_pkg::SUB: expected = a - b;
            alu_pkg::AND: expected = a & b;
            alu_pkg::OR: expected = a | b;
            alu_pkg::XOR: expected = a ^ b;
            alu_pkg::SLT: expected = signed'(a) < signed'(b);
            alu_pkg::SLTU: expected = a < b;
            alu_pkg::SLL: expected = a << b;
            alu_pkg::SRL: expected = a >> b;
            alu_pkg::SRA: expected = a >>> b;
        endcase

        #1;
        if (x == expected) $write("PASS");
        else $write("FAIL");
        $display(" op=%s a=0x%h b=0x%h x=0x%h expected=0x%h", op.name(), a, b, x, expected);
    endtask

endmodule: AluTb
