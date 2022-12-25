`timescale 1ns/1ps

module mm_control_tb;

    reg ck, reset, mm, clock_alarm, min;
    wire up_clock60, up_alarm60;

    mm_control dut(ck, reset, mm, clock_alarm, min, up_clock60, up_alarm60);

    initial begin
        ck = 0;
        reset = 1;
        mm = 0;
        clock_alarm = 1;
        min = 0;
        #7 reset = 0;
        #10 mm = 1;
        #250 mm = 0;
        #200 mm = 1;
        #20 mm = 0;
        #20 $stop;
    end

    always #5 ck = ~ck;

endmodule