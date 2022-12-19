`timescale 1ns/1ps

module count6bit(
    input ck, reset,
    output reg [5:0] count
);

    reg [5:0] count_next;

    always @(posedge ck, posedge reset) begin
        if (reset) count <= 0;
        else count <= count_next;
    end

    always @(count) begin
        count_next = count + 1;
    end

endmodule