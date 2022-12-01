`timescale 1ns / 1ps

module control_tb;
    reg ck, read, ready;
    wire start, ld0, ld1, ld2, ld3;
    wire [7:0] reg_name;
    control dut(ck, read, ready, start, ld0, ld1, ld2, ld3, reg_name);
    
    initial begin
        ck = 0;
        read = 0;
        ready = 1;
        #12 read = 1;
        #5 read = 0;
        #1000 $stop;
    end
    
    always #5 ck = ~ck;
    
endmodule
