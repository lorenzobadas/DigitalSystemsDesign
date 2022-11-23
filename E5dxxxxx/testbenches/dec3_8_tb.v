`timescale 1ns / 1ps

module dec3_8_tb;
//funziona
    reg [2:0] sel;
    wire a0, a1, a2, a3, a4, a5, a6, a7;
    dec3_8 dut(sel, a0, a1, a2, a3, a4, a5, a6, a7);
    
    initial begin
       sel = 0;
       #32 $stop; 
    end
    
    always #2 sel = sel + 1;
    
endmodule
