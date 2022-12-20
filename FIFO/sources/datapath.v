`timescale 1ns/1ps

module datapath(
    input ck, reset,
    input [7:0] data_in,
    input inc_wp, inc_rp, clear_wp, clear_rp,
    input wp_rp_sel,
    input chip_sel,
    input write_enable,
    output test,
    output [7:0] data_out
    );
    wire [3:0] w_ptr, r_ptr;
    mem_ptr write_ptr(ck, reset, clear_wp, inc_wp, w_ptr);
    mem_ptr read_ptr(ck, reset, clear_rp, inc_rp, r_ptr);

    assign test = (w_ptr == r_ptr) ? 1 : 0;

    wire [3:0] address;
    assign address = wp_rp_sel ? w_ptr : r_ptr;

    RAM ram(ck, chip_sel, write_enable, data_in, address, data_out);

endmodule