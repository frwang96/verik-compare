import verik.base.*
import verik.data.*

val ADDR_WIDTH = 6
val DATA_WIDTH = 8
val TAG_WIDTH = 3
val INDEX_WIDTH = 3

@alias fun t_UbitAddr() = t_Ubit(ADDR_WIDTH)
@alias fun t_UbitData() = t_Ubit(DATA_WIDTH)
@alias fun t_UbitTag() = t_Ubit(TAG_WIDTH)
@alias fun t_UbitIndex() = t_Ubit(INDEX_WIDTH)

enum class Op {
    INVALID,
    READ,
    WRITE
}

enum class State {
    READY,
    WRITEBACK,
    FILL
}

enum class Status {
    INVALID,
    CLEAN,
    DIRTY
}

class Line: Struct() {

    var status = t_Status()
    var tag    = t_UbitTag()
    var data   = t_UbitData()
}