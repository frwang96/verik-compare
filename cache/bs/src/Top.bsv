import MemTypes::*;
import Mem::*;
import CacheTb::*;

(* synthesize *)
module mkTop(Empty);

    Reg#(Bit#(32)) counter <- mkReg(0);

    Mem mem <- mkMem;
    CacheTb cacheTb <- mkCacheTb;

    rule count;
        counter <= counter + 1;
        if (counter == 500) $finish;
    endrule

    rule connectCacheTbMem;
        let memReq <- cacheTb.getReq;
        mem.req(memReq);
    endrule

    rule connectMemCacheTb;
        let rsp <- mem.rsp;
        cacheTb.setRsp(rsp);
    endrule

endmodule