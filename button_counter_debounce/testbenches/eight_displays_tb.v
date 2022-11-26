`timescale 1ns / 1ps

module eight_displays_tb; // sembra funzioni
    
    reg ck, reset, add1;
    wire [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7;
    eight_displays dut(ck, reset, add1, seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7);
    initial begin
        ck = 0;
        reset = 0;
        add1 = 1;
        #7 reset = 1;
        #10 reset = 0;
        #150 add1 = 0;
        #20 add1 = 1;
        #10000 $stop;
    end
    
    always #1 ck = ~ck;
endmodule
