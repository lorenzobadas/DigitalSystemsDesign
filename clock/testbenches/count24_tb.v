`timescale 1ns/1ps

module count24_tb;

    reg ck, up24;
    wire [3:0] display3, display4;

    count24 dut(ck, up24, display3, display4);

    initial begin
        dut.display3 = 0;
        dut.display4 = 0;
        ck = 0;
        up24 = 1;
        #300 $stop;
    end

    always #5 ck = ~ck;

endmodule