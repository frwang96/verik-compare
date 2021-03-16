import AluTypes::*;

function DataBit alu(Op op, DataBit a, DataBit b);
    Int#(DataWidth) as = unpack(a);
    Int#(DataWidth) bs = unpack(b);
    return case (op) matches
        ADD: (a + b);
        SUB: (a - b);
        AND: (a & b);
        OR: (a | b);
        XOR: (a ^ b);
        SLT: (as < bs ? 1 : 0);
        SLTU: (a < b ? 1 : 0);
        SLL: (a << b);
        SRL: (a >> b);
        SRA: pack(as >> b);
    endcase;
endfunction
