`timescale 1ns / 1ns

package pkg;

    typedef enum {
        Op_INVALID,
        Op_READ,
        Op_WRITE
    } Op;

    typedef enum {
        State_READY,
        State_WRITEBACK,
        State_FILL
    } State;

    typedef enum {
        Status_INVALID,
        Status_CLEAN,
        Status_DIRTY
    } Status;

    typedef struct {
        pkg::Status status;
        logic [2:0] tag;
        logic [7:0] data;
    } Line;

endpackage
