`timescale 1ns/1ps

module timer_haz(
    input clk, clear,
    output enable
    );
    
    parameter [25:0] MAX_COUNT = 26'd50_000_000;
    reg [25:0] count, count_next;

    always @(posedge clk) begin
        count <= count_next;
    end

    always @(count, clear) begin
        if (count == MAX_COUNT || clear) count_next = 0;
        else count_next = count + 1;
    end

    assign enable = count == MAX_COUNT ? 1 : 0;

endmodule