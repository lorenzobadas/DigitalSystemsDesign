`timescale 1ns / 1ps

module genen_tb;
//funziona
    reg ck, reset;
    wire en;
    genen dut(ck, reset, en);
    
    initial begin
        ck = 0;
        #2 reset = 1;
        #100 reset = 0;
        #1000 $stop;
    end
    
    always #3 ck = ~ck;

endmodule
