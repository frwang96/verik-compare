typedef 6 AddrWidth;
typedef 6 DataWidth;

typedef Bit#(AddrWidth) AddrBit;
typedef Bit#(DataWidth) DataBit;

typedef enum { Read, Write } Op deriving (Bits, Eq, FShow);

typedef struct {
    Op op;
    AddrBit addr;
    DataBit data;
} MemReq deriving (Bits, Eq, FShow);
