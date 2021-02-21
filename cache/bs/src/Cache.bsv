import MemTypes::*;
import RegFile::*;

interface Cache;
    method Action reqCache(MemReq memReq);
    method ActionValue#(MemReq) reqMem;
    method Action rspMem(DataBit rsp);
    method ActionValue#(DataBit) rspCache;
endinterface

(* synthesize *)
module mkCache(Cache);

    Reg#(State) state <- mkReg(Ready);

    Reg#(Maybe#(MemReq)) curMemReq <- mkReg(Invalid);
    Reg#(Maybe#(DataBit)) curRsp <- mkReg(Invalid);

    RegFile#(IndexBit, Line) lines <- mkRegFile('0, '1);

    function IndexBit getIndex(AddrBit addr);
        return truncate(addr);
    endfunction

    function TagBit getTag(AddrBit addr);
        return truncate(addr >> valueOf(IndexWidth));
    endfunction

    method Action reqCache(MemReq memReq) if (!isValid(curMemReq));
        $write("cache received op=", fshow(memReq.op));
        $write(" addr=0x%h data=0x%h\n", memReq.addr, memReq.data);
        curMemReq <= Valid(memReq);
    endmethod

    method ActionValue#(MemReq) reqMem if (isValid(curMemReq));
        curMemReq <= Invalid;
        return fromMaybe(?, curMemReq);
    endmethod

    method Action rspMem(DataBit rsp) if (!isValid(curRsp));
        curRsp <= Valid(rsp);
    endmethod

    method ActionValue#(DataBit) rspCache if (isValid(curRsp));
        curRsp <= Invalid;
        return fromMaybe(?, curRsp);
    endmethod
endmodule