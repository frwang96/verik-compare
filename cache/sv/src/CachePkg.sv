`timescale 1ns / 1ns

package cache_pkg;

    parameter ADDR_WIDTH  = 6;
    parameter DATA_WIDTH  = 8;
    parameter TAG_WIDTH   = 3;
    parameter INDEX_WIDTH = 3;

    typedef logic[ADDR_WIDTH-1:0]  UbitAddr;
    typedef logic[DATA_WIDTH-1:0]  UbitData;
    typedef logic[TAG_WIDTH-1:0]   UbitTag;
    typedef logic[INDEX_WIDTH-1:0] UbitIndex;

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
        Status   status;
        UbitTag  tag;
        UbitData data;
    } Line;

endpackage
