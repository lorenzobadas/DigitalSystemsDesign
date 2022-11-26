`timescale 1ns / 1ps

module BCD_counter_tb;
    reg ck, reset, add1;
    wire [3:0] seg, seg1;
    wire cout, cout1;
    BCD_counter dut(ck, reset, add1, seg, cout);
    BCD_counter dut1(ck, reset, cout, seg1, cout1);
    initial begin
        ck = 0;
        add1 = 0;
        reset = 0;
        #3 reset = 1;
        #10 reset = 0;
        add1 = 1;
        #90 add1 = ~add1;
        #30 add1 = ~add1;
        #500 $stop;
    end
    
    always #5 ck = ~ck;
endmodule
