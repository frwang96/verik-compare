import MemTypes::*;
import Vector::*;

interface Mem;
    method Action reset();
    method Action req(MemReq memReq);
    method ActionValue#(DataBit) rsp;
endinterface

(* synthesize *)
module mkMem(Mem);

    Vector#(TExp#(AddrWidth), Reg#(DataBit)) mem <- replicateM(mkRegU);

    Reg#(Maybe#(DataBit)) rspData <- mkReg(Invalid);

    method Action reset;
        for (Integer i = 0; i < valueOf(TExp#(AddrWidth)); i = i+1)
            mem[i] <= 0;
    endmethod

    method Action req(MemReq memReq) if (!isValid(rspData));
        $write("mem received op=", fshow(memReq.op));
        $write(" addr=0x%h data=0x%h\n", memReq.addr, memReq.data);
        if (memReq.op == Write) begin
            mem[memReq.addr] <= memReq.data;
        end
        else if (memReq.op == Read) begin
            rspData <= Valid(mem[memReq.addr]);
        end
    endmethod

    method ActionValue#(DataBit) rsp if (isValid(rspData));
        rspData <= Invalid;
        return fromMaybe(?, rspData);
    endmethod

endmodule
