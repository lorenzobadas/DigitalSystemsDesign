`timescale 1ns/1ps

module count_errors(
    input ck, reset, inc_errors,
    output reg [1:0] error_count
);

    reg [1:0] error_count_next;

    always @(posedge ck, posedge reset) begin
        if (reset) error_count <= 0;
        else error_count <= error_count_next;
    end

    always @(error_count, inc_errors) begin
        if (inc_errors) begin
            if (error_count == 3) error_count_next = error_count;
            else error_count_next = error_count + 1;
        end
        else begin
            error_count_next = error_count;
        end
    end

endmodule