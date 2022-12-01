`timescale 1ns / 1ps

module reg_display_tb; // ok
    reg ck;
    reg [7:0] data_in;
    reg load;
    wire [3:0] seg1, seg0;
    
    reg_display dut(ck, data_in, load, seg1, seg0);
    
    initial begin
        ck = 0;
        load = 0;
        data_in = 7;
        #7 load = 1;
        #10 load = 0;
        #10 data_in = 8'h9f;
        #10 load = 1;
        #50 $stop;
    end
    
    always #5 ck = ~ck;
endmodule
