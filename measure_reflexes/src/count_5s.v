`timescale 1ns/1ps

module count_5s(
    input ck, reset, clear,
    output reg hit
);

    reg [28:0] count, count_next;

    always @(posedge ck) begin
        if (reset) count <= 0;
        else count <= count_next;
    end

    always @(count, clear) begin
        hit = 0;
        if (clear) begin
            count_next = 0;
        end
        else if (count == 500_000_000) begin
            count_next = 0;
            hit = 1;
        end
        else begin
            count_next = count + 1;
        end
    end

endmodule