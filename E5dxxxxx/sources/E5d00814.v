`timescale 1ns/1ps

module E5d00814(
    input ck,
    output [7:0] AN,
    output CA, CB, CC, CD, CE, CF, CG
);
    wire [3:0] seg7 = 4'hE;
    wire [3:0] seg6 = 4'h5;
    wire [3:0] seg5 = 4'hd;
    wire [3:0] seg4 = 4'h0;
    wire [3:0] seg3 = 4'h0;
    wire [3:0] seg2 = 4'h8;
    wire [3:0] seg1 = 4'h1;
    wire [3:0] seg0 = 4'h4;

    eight_display u0(ck, seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, AN, {CG, CF, CE, CD, CC, CB, CA});

endmodule