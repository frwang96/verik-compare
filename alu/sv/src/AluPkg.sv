`timescale 1ns / 1ns

package alu_pkg;

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