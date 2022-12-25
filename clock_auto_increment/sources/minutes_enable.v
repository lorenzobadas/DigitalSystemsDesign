`timescale 1ns/1ps

module minutes_enable(
    input ck, reset,
    output hit
);
    parameter [32:0] MAX_COUNT = 33'd6_000_000_000;
    reg [32:0] count, count_next;

    always @(posedge ck, posedge reset) begin
        if (reset) count <= 0;
        else count <= count_next;
    end

    always @(count) begin
        if (count == MAX_COUNT) count_next = 0;
        else count_next = count + 1;
    end

    assign hit = (count == MAX_COUNT) ? 1 : 0;

endmodule