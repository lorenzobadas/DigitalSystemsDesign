`timescale 1ns/1ps

module count60_tb;

    reg ck, up60;
    wire carry;
    wire [3:0] display0, display1;

    count60 dut(ck, up60, carry, display0, display1);

    initial begin
        dut.u0.count = 0;
        dut.u1.count = 0;
        ck = 0;
        up60 = 1;
        #590 up60 = 0;
        #10 up60 = 1;
        #100 $stop;
    end

    always #5 ck = ~ck;
    
endmodule