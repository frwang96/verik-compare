import MemTypes::*;
import Mem::*;
import Cache::*;
import CacheTb::*;

(* synthesize *)
module mkTop(Empty);

    Mem mem <- mkMem;
    Cache cache <- mkCache;
    CacheTb cacheTb <- mkCacheTb;

    rule reset if (cacheTb.isReset);
        mem.reset;
        cache.reset;
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