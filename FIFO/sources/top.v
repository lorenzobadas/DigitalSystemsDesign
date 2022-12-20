`timescale 1ns / 1ps

module top(
    input ck, reset,
    input insert, remove, flush,
    input [7:0] SW,
    output full, empty,
    output CA, CB, CC, CD, CE, CF, CG,
    output [7:0] AN
    );
    wire insert_deb, remove_deb, flush_deb;
    debounce deb0(ck, reset, insert, insert_deb);
    debounce deb1(ck, reset, remove, remove_deb);
    debounce deb2(ck, reset, flush, flush_deb);

    wire [7:0] data_out;
    FIFO u0(ck, reset, flush_deb, insert_deb, remove_deb, SW, full, empty, data_out); 
    eight_display u1(ck, data_out[3:0], data_out[7:4], 0, 0, 0, 0, 0, 0, AN, {CA, CB, CC, CD, CE, CF, CG});
    
endmodule
