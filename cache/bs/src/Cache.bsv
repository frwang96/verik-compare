import MemTypes::*;

interface Cache;
    method Action inReq(MemReq memReq);
    method ActionValue#(MemReq) outReq;
    method Action inRsp(DataBit rsp);
    method ActionValue#(DataBit) outRsp;
endinterface

(* synthesize *)
module mkCache(Cache);

    Reg#(Maybe#(MemReq)) curMemReq <- mkReg(Invalid);
    Reg#(Maybe#(DataBit)) curRsp <- mkReg(Invalid);

    method Action inReq(MemReq memReq) if (!isValid(curMemReq));
        $write("cache received op=", fshow(memReq.op));
        $write(" addr=0x%h data=0x%h\n", memReq.addr, memReq.data);
        curMemReq <= Valid(memReq);
    endmethod

    method ActionValue#(MemReq) outReq if (isValid(curMemReq));
        curMemReq <= Invalid;
        return fromMaybe(?, curMemReq);
    endmethod

    method Action inRsp(DataBit rsp) if (!isValid(curRsp));
        curRsp <= Valid(rsp);
    endmethod

    method ActionValue#(DataBit) outRsp if (isValid(curRsp));
        curRsp <= Invalid;
        return fromMaybe(?, curRsp);
    endmethod

endmodule