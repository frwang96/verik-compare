import MemTypes::*;
import Randomizable::*;
import RegFile::*;

interface CacheTb;
    method ActionValue#(Bool) isReset;
    method ActionValue#(MemReq) getReq;
    method Action setRsp(DataBit rsp);
endinterface

(* synthesize *)
module mkCacheTb(CacheTb);

    Reg#(Bool) isInit <- mkReg(False);
    Randomize#(Bool) randomizerOp <- mkGenericRandomizer;
    Randomize#(AddrBit) randomizerAddr <- mkGenericRandomizer;
    Randomize#(DataBit) randomizerData <- mkGenericRandomizer;

    RegFile#(AddrBit, DataBit) mem <- mkRegFile('0, '1);
    Reg#(Maybe#(MemReq)) memReq <- mkReg(Invalid);
    Reg#(Bit#(8)) delayCounter <- mkReg(0);
    Reg#(Bit#(8)) reqCounter <- mkReg(0);

    rule doInit(!isInit);
        randomizerOp.cntrl.init;
        randomizerAddr.cntrl.init;
        randomizerData.cntrl.init;
        isInit <= True;
    endrule

    rule delayCount if (delayCounter != 0);
        delayCounter <= delayCounter - 1;
    endrule

    method ActionValue#(Bool) isReset;
        return !isInit;
    endmethod

    method ActionValue#(MemReq) getReq if (!isValid(memReq) && delayCounter == 0);
        if (reqCounter == 200) $finish();
        reqCounter <= reqCounter + 1;
        let op <- randomizerOp.next;
        if (op) begin
            let addr <- randomizerAddr.next;
            let data <- randomizerData.next;
            $display("tb write addr=0x%h data=0x%h", addr, data);
            MemReq req = MemReq{ op: Write, addr: addr, data: data };
            mem.upd(addr, data);
            delayCounter <= 3;
            return req;
        end
        else begin
            let addr <- randomizerAddr.next;
            $display("tb read addr=0x%h", addr);
            MemReq req = MemReq{ op: Read, addr: addr, data: ? };
            memReq <= Valid(req);
            return req;
        end
    endmethod

    method Action setRsp(DataBit rsp) if (isValid(memReq) && delayCounter == 0);
        AddrBit addr = fromMaybe(?, memReq).addr;
        DataBit expected = mem.sub(addr);
        if (rsp == expected) begin
            $display("tb PASS data=0x%h expected=0x%h", rsp, expected);
        end
        else begin
            $display("tb FAIL data=0x%h expected=0x%h", rsp, expected);
        end
        delayCounter <= 3;
        memReq <= Invalid;
    endmethod

endmodule