`timescale 1ns/1ps

module light_to_seg(
    input LC, LB, LA, RA, RB, RC,
    output reg [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7
    );
    parameter [3:0] ON = 8, OFF = 0;

    always @(LC, LB, LA, RA, RB, RC) begin
        if (LC) seg7 = ON;
        else seg7 = OFF;
        if (LB) seg6 = ON;
        else seg6 = OFF;
        if (LA) seg5 = ON;
        else seg5 = OFF;
        if (RA) seg2 = ON;
        else seg2 = OFF;
        if (RB) seg1 = ON;
        else seg1 = OFF;
        if (RC) seg0 = ON;
        else seg0 = OFF;
        seg3 = OFF;
        seg4 = OFF;
    end

endmodule