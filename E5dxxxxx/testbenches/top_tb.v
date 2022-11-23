`timescale 1ns / 1ps

module top_tb;

    reg ck, reset;
    wire CA, CB, CC, CD, CE, CF, CG, an0, an1, an2, an3, an4, an5, an6, an7;
    top dut(ck, reset, CA, CB, CC, CD, CE, CF, CG, an0, an1, an2, an3, an4, an5, an6, an7);
    initial begin
        ck = 0;
        #3 reset = 1;
        #2 reset = 0;
        #150 $stop;
    end
    
    always #2 ck = ~ck;

endmodule
