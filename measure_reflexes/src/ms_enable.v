`timescale 1ns/1ps

module ms_enable(
    input ck, reset, clear,
    output reg one_ms
);
    reg [16:0] count, count_next;

    always @(posedge ck, posedge reset) begin
        if (reset) count <= 0;
        else count <= count_next;
    end

    always @(count, clear) begin
        one_ms = 0;
        if (clear) begin
            count_next = 0;
        end
        else if (count == 100_000) begin
            count_next = 0;
            one_ms = 1;
        end
        else begin
            count_next = count + 1;
        end
    end

endmodule