`timescale 1ns / 1ps

module instr_tb; // ok
    reg ck, load_instr, sh_instr;
    reg [7:0] reg_name;
    wire mosi;
    instr dut(ck, load_instr, sh_instr, reg_name, mosi);
    
    initial begin
        ck = 0;
        load_instr = 0;
        sh_instr = 0;
        reg_name = 8'hFF;
        #3 load_instr = 1;
        #5 load_instr = 0;
        #5 sh_instr = 1;
        #5 sh_instr = 0;
        #5
        #5
        #5 sh_instr = 1;
        #5 sh_instr = 0;
        #5 sh_instr = 1;
        #50 $stop;
    end
    
    always #5 ck = ~ck;
    
endmodule