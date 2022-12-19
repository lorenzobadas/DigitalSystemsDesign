`timescale 1ns/1ps

module eight_display(
    input ck,
    input [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7,
    output [7:0] an,
    output [6:0] c
);
    wire refresh;
    wire [2:0] sel;
    wire [3:0] in_seg;
    

    gen_refresh u0(ck, refresh);
    cnt_8 u1(ck, refresh, sel);
    mux_4 u2(seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, sel, in_seg);
    dec3_8 u3(sel, an);
    seven_segments u4(in_seg, c);

endmodule