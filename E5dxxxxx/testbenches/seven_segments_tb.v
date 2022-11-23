`timescale 1ns / 1ps

module seven_segments_tb;
//funziona
    reg [3:0] in_seg;
    wire CA, CB, CC, CD, CE, CF, CG;
    seven_segments dut(in_seg, CA, CB, CC, CD, CE, CF, CG);
    
    initial begin
        in_seg = 0;
        #100 $stop;
    end
    
    always #1 in_seg = in_seg + 1;

endmodule
