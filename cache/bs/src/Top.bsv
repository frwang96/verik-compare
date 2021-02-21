import MemTypes::*;
import Mem::*;
import Cache::*;
import CacheTb::*;

(* synthesize *)
module mkTop(Empty);

    Reg#(Bit#(32)) counter <- mkReg(0);

    Mem mem <- mkMem;
    Cache cache <- mkCache;
    CacheTb cacheTb <- mkCacheTb;

    rule count;
        counter <= counter + 1;
        if (counter == 1000) $finish;
    endrule

    rule connectCacheTbCache;
        let memReq <- cacheTb.getReq;
        cache.reqCache(memReq);
    endrule

    rule connectCacheMem;
        let memReq <- cache.reqMem;
        mem.req(memReq);
    endrule

    rule connectMemCache;
        let rsp <- mem.rsp;
        cache.rspMem(rsp);
    endrule

    rule connectCacheCacheTb;
        let rsp <- cache.rspCache;
        cacheTb.setRsp(rsp);
    endrule

endmodule