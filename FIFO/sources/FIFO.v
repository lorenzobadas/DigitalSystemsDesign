`timescale 1ns / 1ps

module FIFO(
    input ck, reset,
    input flush, insert, remove,
    input [7:0] data_in,
    output full, empty, 
    output [7:0] data_out
    );
    wire inc_wp, inc_rp, clear_wp, clear_rp, wp_rp_sel, chip_sel, write_enable, test;
    control u0(ck, reset, insert, remove, flush, test, inc_wp, inc_rp, clear_wp, clear_rp, wp_rp_sel, chip_sel, write_enable, full, empty);
    datapath u1(ck, reset, data_in, inc_wp, inc_rp, clear_wp, clear_rp, wp_rp_sel, chip_sel, write_enable, test, data_out);

endmodule
