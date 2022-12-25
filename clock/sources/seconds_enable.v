`timescale 1ns/1ps

module seconds_enable(
    input ck, reset,
    output reg hit
);
    parameter [25:0] MAX_COUNT = 26'd50_000_000;
    reg [25:0] count, count_next;

    reg hit_next;

    always @(posedge ck, posedge reset) begin
        if (reset) begin
            count <= 0;
            hit <= 0;
        end
        else begin
            count <= count_next;
            hit <= hit_next;
        end
    end

    always @(count, hit) begin
        if (count == MAX_COUNT) begin
            count_next = 0;
            hit_next = ~hit;
        end
        else begin
            count_next = count + 1;
            hit_next = hit;
        end
    end

endmodule