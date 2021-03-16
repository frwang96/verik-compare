import AluTypes::*;
import Randomizable::*;

interface AluTb;
    method Op getOp;
    method DataBit getA;
    method DataBit getB;
    method Action setResult(DataBit x);
endinterface

(* synthesize *)
module mkAluTb(AluTb);

    Reg#(Bool) isInit <- mkReg(False);
    Randomize#(Bit#(16)) randomizerOp <- mkGenericRandomizer;
    Randomize#(DataBit) randomizerA <- mkGenericRandomizer;
    Randomize#(DataBit) randomizerB <- mkGenericRandomizer;

    Reg#(Op) op <- mkReg(ADD);
    Reg#(DataBit) a <- mkReg(0);
    Reg#(DataBit) b <- mkReg(0);

    Reg#(Bit#(8)) counter <- mkReg(0);

    rule doInit(!isInit);
        randomizerOp.cntrl.init;
        randomizerA.cntrl.init;
        randomizerB.cntrl.init;
        isInit <= True;
    endrule

    method Op getOp;
        return op;
    endmethod

    method DataBit getA;
        return a;
    endmethod

    method DataBit getB;
        return b;
    endmethod

    method Action setResult(DataBit x);
        if (counter == 200) $finish();
        counter <= counter + 1;

        Int#(DataWidth) as = unpack(a);
        Int#(DataWidth) bs = unpack(b);
        DataBit expected = case(op) matches
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

        if (x == expected) $write("PASS");
        else $write("FAIL");
        $write(" op=", fshow(op));
        $write(" a=0x%h b=0x%h x=0x%h expected=0x%h\n", a, b, x, expected);

        Bit#(16) randOp <- randomizerOp.next();
        op <= case (randOp % 10) matches
            0: ADD;
            1: SUB;
            2: AND;
            3: OR;
            4: XOR;
            5: SLT;
            6: SLTU;
            7: SLL;
            8: SRL;
            9: SRA;
        endcase;
        DataBit randA <- randomizerA.next();
        DataBit randB <- randomizerB.next();
        a <= randA;
        b <= randB;
    endmethod

endmodule