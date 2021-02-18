typedef 6 AddrWidth;
typedef 6 DataWidth;
typedef 3 TagWidth;

typedef Bit#(AddrWidth) AddrBit;
typedef Bit#(DataWidth) DataBit;
typedef Bit#(TagWidth) TagBit;

typedef enum {
    Read,
    Write
} Op deriving (Bits, Eq, FShow);

typedef enum {
    Ready,
    Writeback,
    Fill
} State deriving (Bits, Eq, FShow);

typedef enum {
    Invalid,
    Clean,
    Dirty
} Status deriving (Bits, Eq, FShow);

typedef struct {
    Op op;
    AddrBit addr;
    DataBit data;
} MemReq deriving (Bits, Eq, FShow);

typedef struct {
    Status status;
    TagBit tag;
    DataBit data;
} Line deriving (Bits, Eq, FShow);
