import AluTypes::*;
import Alu::*;
import AluTb::*;

(* synthesize *)
module mkTop(Empty);

    AluTb aluTb <- mkAluTb;

    rule compute;
        DataBit x = alu(aluTb.getOp, aluTb.getA, aluTb.getB);
        aluTb.setResult(x);
    endrule

endmodule