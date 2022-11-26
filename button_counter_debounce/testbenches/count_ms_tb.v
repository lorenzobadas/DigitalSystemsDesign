`timescale 1ns / 1ps

module count_ms_tb; //funziona
    reg ck, reset;
    wire enable;
    count_ms dut(ck, reset, enable);
    initial begin
        ck = 0;
        reset = 0;
        #3 reset = 1;
        #10 reset = 0;
        #150 $stop;
    end
    
    always #5 ck = ~ck;
    
endmodule
