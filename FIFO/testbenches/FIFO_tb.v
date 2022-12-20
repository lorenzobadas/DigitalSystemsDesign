`timescale 1ns / 1ps

module FIFO_tb;

    reg ck, reset, flush, insert, remove;
    reg [7:0] data_in;
    wire full, empty;
    wire [7:0] data_out;

    FIFO dut(ck, reset, flush, insert, remove, data_in, full, empty, data_out);

    initial begin
        ck = 0;
        reset = 0;
        flush = 0;
        insert = 0;
        remove = 0;
        data_in = 0;
        #7 reset = 1;
        #10 reset = 0;
        #10 insert = 1;
        #10 insert = 0; data_in = data_in + 1;
        #10 insert = 1;
        #10 insert = 0; data_in = data_in + 1;
        #10 $stop;
    end

    always #5 ck = ~ck;

endmodule
