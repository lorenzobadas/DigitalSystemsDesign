`timescale 1ns / 1ps

module control_readreg_tb;
    reg ck, start;
    wire hit, hit7, hit15;
    wire ready, sclk, nCS, load_instr, sh_instr, sh_data, clr, en, clr7, en7, clr15, en15;
    
    control_readreg dut(ck, start, hit, hit7, hit15, ready, sclk, nCS, load_instr, sh_instr, sh_data, clr, en, clr7, en7, clr15, en15);
    cnt u0(ck, en, clr, hit);
    cnt7 u1(ck, en7, clr7, hit7);
    cnt15 u2(ck, en15, clr15, hit15);
    
    initial begin
        ck = 0;
        start = 0;
        #12 start = 1;
        #5 start = 0;
        
    end
    
    always #5 ck = ~ck;
    
endmodule
