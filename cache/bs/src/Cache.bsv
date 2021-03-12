import FIFOF::*;
import Vector::*;
import MemTypes::*;

interface Cache;
    method Action reset;
    method Action reqCache(MemReq memReq);
    method ActionValue#(DataBit) rspCache;
    method ActionValue#(MemReq) reqMem;
    method Action rspMem(DataBit rsp);
endinterface

(* synthesize *)
module mkCache(Cache);

    Reg#(State) state <- mkReg(Ready);

    Reg#(MemReq) curMemReq <- mkRegU();

    FIFOF#(MemReq) reqQ <- mkSizedFIFOF(1);
    FIFOF#(DataBit) rspQ <- mkSizedFIFOF(1);
    FIFOF#(DataBit) hitQ <- mkSizedFIFOF(1);

    Vector#(TExp#(IndexWidth), Reg#(Line)) lines <- replicateM(mkRegU);

    function IndexBit getIndex(AddrBit addr);
        return truncate(addr);
    endfunction

    function TagBit getTag(AddrBit addr);
        return truncate(addr >> valueOf(IndexWidth));
    endfunction

    rule waitWriteback(state == Writeback);
        reqQ.enq(MemReq{op: Read, addr: curMemReq.addr, data: ?});
        state <= Fill;
    endrule

    rule waitFill(state == Fill);
        DataBit data = rspQ.first();
        rspQ.deq();
        IndexBit index = getIndex(curMemReq.addr);
        TagBit tag = getTag(curMemReq.addr);
        $display("cache fill index=0x%h tag=0x%h data=0x%h", index, tag, data);
        if (curMemReq.op == Read) begin
            lines[index] <= Line{status: Clean, tag: tag, data: data};
            hitQ.enq(data);
        end
        else begin
            lines[index] <= Line{status: Dirty, tag: tag, data: curMemReq.data};
        end
        state <= Ready;
    endrule

    method Action reset;
        for (Integer i = 0; i < valueOf(TExp#(IndexWidth)); i = i+1)
            lines[i] <= Line{status: Invalid, tag: ?, data: ?};
    endmethod

    method Action reqCache(MemReq memReq) if (state == Ready && hitQ.notFull);
        $write("cache received op=", fshow(memReq.op));
        $write(" addr=0x%h data=0x%h\n", memReq.addr, memReq.data);
        IndexBit index = getIndex(memReq.addr);
        TagBit tag = getTag(memReq.addr);
        Line line = lines[index];
        curMemReq <= memReq;
        if (line.status != Invalid && line.tag == tag) begin
            $write("cache hit index=0x%h tag=0x%h line.tag=0x%h", index, tag, line.tag);
            $write(" line.status=", fshow(line.status));
            $write("\n");
            if (memReq.op == Read) begin
                hitQ.enq(line.data);
            end
            else begin
                lines[index] <= Line{status: Dirty, tag: tag, data: memReq.data};
            end
        end
        else begin
            $write("cache miss index=0x%h tag=0x%h line.tag=0x%h", index, tag, line.tag);
            $write(" line.status=", fshow(line.status));
            $write("\n");
            if (line.status == Dirty) begin
                reqQ.enq(MemReq{op: Write, addr: {line.tag, index}, data: line.data});
                state <= Writeback;
            end
            else begin
                reqQ.enq(MemReq{op: Read, addr: memReq.addr, data: ?});
                state <= Fill;
            end
        end
    endmethod

    method ActionValue#(DataBit) rspCache;
        hitQ.deq();
        return hitQ.first();
    endmethod

    method ActionValue#(MemReq) reqMem;
        reqQ.deq();
        return reqQ.first();
    endmethod

    method Action rspMem(DataBit rsp);
        rspQ.enq(rsp);
    endmethod
endmodule