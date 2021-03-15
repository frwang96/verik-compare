import verik.base.*
import verik.data.*

val DATA_WIDTH = 8

@alias fun t_UbitData() = t_Ubit(DATA_WIDTH)

enum class Op {
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
}