`timescale 1ns / 1ps

module mux_4_tb;
//funziona
    reg [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7;
    wire [3:0] in_seg;
    reg [2:0] sel;
    
    mux_4 dut(seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, sel, in_seg);
    
    initial begin
        sel = 0;
        seg0 = 8;
        seg1 = 1;
        seg2 = 2;
        seg3 = 3;
        seg4 = 4;
        seg5 = 5;
        seg6 = 6;
        seg7 = 7;
        #30 $stop;
    end
    
    always #2 sel = sel + 1;
    
endmodule
