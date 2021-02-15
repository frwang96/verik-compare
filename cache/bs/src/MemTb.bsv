import MemTypes::*;
import Randomizable::*;

interface MemTb;
    method ActionValue#(MemReq) getReq;
    method Action setRsp(DataBit rsp);
endinterface

(* synthesize *)
module mkMemTb(MemTb);

    Reg#(Bool) isInit <- mkReg(False);
    Randomize#(Bool) randomizerOp <- mkGenericRandomizer;
    Randomize#(AddrBit) randomizerAddr <- mkGenericRandomizer;
    Randomize#(DataBit) randomizerData <- mkGenericRandomizer;

    rule doInit(!isInit);
        randomizerOp.cntrl.init;
        randomizerAddr.cntrl.init;
        randomizerData.cntrl.init;
        isInit <= True;
    endrule

    method ActionValue#(MemReq) getReq;
        let op <- randomizerOp.next;
        if (op) begin
            let addr <- randomizerAddr.next;
            let data <- randomizerData.next;
            $display("tb write addr=0x%h data=0x%h", addr, data);
            return MemReq{ op: Write, addr: addr, data: data };
        end
        else begin
            let addr <- randomizerAddr.next;
            $display("tb read addr=0x%h", addr);
            return MemReq{ op: Read, addr: addr, data: ? };
        end
    endmethod

    method Action setRsp(DataBit rsp);
    endmethod

endmodule