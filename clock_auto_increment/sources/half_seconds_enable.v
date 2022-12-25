`timescale 1ns/1ps

module half_seconds_enable(
    input ck, reset,
    input clear,
    output hit
);
    parameter [25:0] MAX_COUNT = 26'd50_000_000;
    reg [25:0] count, count_next;

    always @(posedge ck, posedge reset) begin
        if (reset) count <= 0;
        else count <= count_next;
    end

    always @(count, clear) begin
        if (count == MAX_COUNT || clear) count_next = 0;
        else count_next = count + 1;
    end

    assign hit = (count == MAX_COUNT) ? 1 : 0;

endmodule