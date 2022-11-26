`timescale 1ns / 1ps

module debounce_FSM_tb; // funziona
    reg ck, reset, button;
    wire push;
    debounce_FSM dut(ck, reset, button, push);
    initial begin
        ck = 0;
        reset = 0;
        button = 0;
        #3 reset = 1;
        #10 reset = 0;
        
        #1 button = ~button;
        #1 button = ~button;
        #1 button = ~button;
        #1 button = ~button;
        #1 button = ~button;
        #100 button = ~button;
        #1 button = ~button;
        #1 button = ~button;
        #1 button = ~button;
        #1 button = ~button;
        
        #100 $stop;
    end
    
    always #5 ck = ~ck;
endmodule
