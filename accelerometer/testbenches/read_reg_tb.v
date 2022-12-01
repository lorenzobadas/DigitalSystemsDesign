`timescale 1ns / 1ps

module read_reg_tb;
    reg ck, start, miso;
    reg [7:0] reg_name;
    wire [7:0] data_out;
    wire ready, nCS, sclk, mosi;
    read_reg dut(ck, start, miso, reg_name, data_out, ready, nCS, sclk, mosi);
    initial begin
        ck = 0;
        start = 0;
        miso = 1;
        reg_name = 8;
        #12 start = 1;
        #50 start = 0;
        #1000 $stop;
    end
    
    always #5 ck = ~ck;
    
endmodule