`timescale 1ns / 1ps

module cnt_tb; // ok
    reg ck, clr, en;
    wire hit, hit7, hit15;
    cnt dut0(ck, en, clr, hit);
    cnt7 dut1(ck, en, clr, hit7);
    cnt15 dut2(ck, en, clr, hit15);
    
    initial begin
        ck = 0;
        clr = 0;
        en = 0;
        #3 clr = 1;
        #10 clr = 0;
        #5 en = 1;
        #15 en = 0;
        #5 en = 1;
        
        #80 $stop;
    end
    
    always #5 ck = ~ck; 

endmodule