`timescale 1ns / 1ns

package alu_pkg;

    parameter DATA_WIDTH = 8;

    typedef logic[DATA_WIDTH-1:0] UbitData;

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
    } Op;

endpackage