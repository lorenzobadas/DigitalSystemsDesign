`timescale 1ns / 1ps

module data_tb; // ok
    reg ck, sh_data, miso;
    wire [7:0] data_out;
    
    data dut(ck , sh_data, miso, data_out);
    
    initial begin
        ck = 0;
        sh_data = 1;
        miso = 1;
        #7 miso = 0;
        #5
        #10
        #10 miso = 1;
        #10
        #10 miso = 0;
        #10 miso = 1;
        #50 $stop;        
    end
    
    always #5 ck = ~ck;
    
endmodule