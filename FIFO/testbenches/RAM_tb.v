`timescale 1ns / 1ps

module RAM_tb; // works as expected

    reg ck, chip_sel, write_enable;
    reg [7:0] data_in;
    reg [3:0] address;
    wire [7:0] data_out;
    
    RAM dut(ck, chip_sel, write_enable, data_in, address, data_out);

    initial begin
        ck = 0;
        chip_sel = 0;
        write_enable = 0;
        data_in = 8'hCA;
        address = 0;
        #7 chip_sel = 1;
        write_enable = 1;
        #10 write_enable = 0;
        #10 address = 7;
        #10 write_enable = 1;
        #10 address = 8;
        write_enable = 0;
        #10 chip_sel = 0;
        address = 0;
        #20 chip_sel = 1;
        #10 $stop;
    end

    always #5 ck = ~ck;

endmodule
