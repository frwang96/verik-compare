import MemTypes::*;
import Mem::*;
import MemTb::*;

(* synthesize *)
module mkTop(Empty);

    Reg#(Bit#(32)) counter <- mkReg(0);

    Mem mem <- mkMem;
    MemTb memTb <- mkMemTb;

    rule count;
        counter <= counter + 1;
        if (counter == 200) $finish;
    endrule

    rule connectMemTbMem;
        let memReq <- memTb.getReq;
        mem.req(memReq);
    endrule

    rule connectMemMemTb;
        let rsp <- mem.rsp;
        memTb.setRsp(rsp);
    endrule

endmodule