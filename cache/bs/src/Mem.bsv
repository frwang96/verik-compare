import MemTypes::*;
import RegFile::*;

interface Mem;
    method Action req(MemReq memReq);
    method ActionValue#(DataBit) rsp;
endinterface

(* synthesize *)
module mkMem(Mem);

    RegFile#(AddrBit, DataBit) mem <- mkRegFile('0, '1);

    Reg#(Maybe#(DataBit)) rspData <- mkReg(Invalid);

    method Action req(MemReq memReq) if (!isValid(rspData));
        if (memReq.op == Write) begin
            mem.upd(memReq.addr, memReq.data);
        end
        else if (memReq.op == Read) begin
            rspData <= Valid(mem.sub(memReq.addr));
        end
    endmethod

    method ActionValue#(DataBit) rsp if (isValid(rspData));
        rspData <= Invalid;
        return fromMaybe(?, rspData);
    endmethod

endmodule
