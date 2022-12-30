`timescale 1ns/1ps

module top(
    input clk, reset, 
    input left, right, haz,
    output CA, CB, CC, CD, CE, CF, CG,
    output [7:0] AN
    );
    wire interr_dir, interr_haz, clear_timer_dir, clear_timer_haz, LC, LB, LA, RA, RB, RC;
    wire [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7;
    tail_lights_control u0(clk, reset, left, right, haz, interr_dir, interr_haz, clear_timer_haz, clear_timer_dir, LC, LB, LA, RA, RB, RC);
    timer_dir u1(clk, clear_timer_dir, interr_dir);
    timer_haz u2(clk, clear_timer_haz, interr_haz);
    light_to_seg u3(LC, LB, LA, RA, RB, RC, seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7);
    eight_display u4(clk, seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, AN, {CA, CB, CC, CD, CE, CF, CG});


endmodule