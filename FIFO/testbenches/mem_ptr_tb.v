`timescale 1ns / 1ps

module mem_ptr_tb;

    reg ck, reset, clr_ptr, inc_ptr;
    wire [3:0] ptr;

    mem_ptr dut(ck, reset, clr_ptr, inc_ptr, ptr);

    initial begin
        ck = 0;
        reset = 0;
        clr_ptr = 0;
        inc_ptr = 0;
        #7 reset = 1;
        #10 reset = 0;
        #10 inc_ptr = 1;
        #20 clr_ptr = 1;
        #10 clr_ptr = 0;
        #20
        #10 $stop;
    end

    always #5 ck = ~ck;

endmodule
