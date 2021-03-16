typedef 8 DataWidth;

typedef Bit#(DataWidth) DataBit;

typedef enum {
    ADD,
    SUB,
    AND,
    OR,
    XOR,
    SLT,
    SLTU,
    SLL,
    SRL,
    SRA
} Op deriving (Bits, Eq, FShow);
