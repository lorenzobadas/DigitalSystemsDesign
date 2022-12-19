`timescale 1ns/1ps

module top(
    input ck, reset,
    input start_button, reflex_button,
    output CA, CB, CC, CD, CE, CF, CG, DP,
    output led, block,
    output [7:0] AN
);
    wire refresh;
    wire enable, clear_ms_enable, clear_count_ms, write_enable, load_wait, dec_wait, inc_errors, load_rand, clear_5s, zero, hit_5s, end_wait, one_ms, new;
    wire [3:0] cnt0, cnt1, cnt2, cnt3, rec0, rec1, rec2, rec3;
    assign DP = AN[7] & AN[3];

    datapath u0(ck, reset, enable, clear_ms_enable, clear_count_ms, write_enable, load_wait, dec_wait, inc_errors, load_rand, clear_5s, zero, hit_5s, end_wait, one_ms, new, cnt0, cnt1, cnt2, cnt3, rec0, rec1, rec2, rec3);
    control u1(ck, reset, start_button, reflex_button, one_ms, end_wait, new, zero, hit_5s, enable, clear_ms_enable, clear_count_ms, write_enable, load_wait, dec_wait, inc_errors, load_rand, clear_5s, led, block);
    eight_display u2(ck, cnt0, cnt1, cnt2, cnt3, rec0, rec1, rec2, rec3, AN, {CA, CB, CC, CD, CE, CF, CG});

endmodule