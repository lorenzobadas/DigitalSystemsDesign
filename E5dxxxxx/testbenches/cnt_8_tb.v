`timescale 1ns / 1ps

module cnt_8_tb;
// funziona
    reg ck, reset;
    wire [2:0] sel;
    cnt_8 dut(.ck(ck), .reset(reset), .sel(sel));
    
    initial begin
        ck = 0;
        reset = 0;
        #20 reset = 1;
        #10 reset = 0;
        #200 $stop;
    end
    
    always #5 ck = ~ck;
endmodule
