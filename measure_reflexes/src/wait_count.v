`timescale 1ns/1ps

module wait_count(
    input ck, load_wait, dec_wait,
    input [1:0] new_error_count,
    output end_wait
);

    reg [1:0] error_count, error_count_next;

    always @(posedge ck) begin
        error_count <= error_count_next;
    end

    always @(error_count, load_wait, dec_wait, new_error_count) begin
        if (load_wait) begin
            error_count_next = new_error_count;
        end
        else if (dec_wait) begin
            error_count_next = error_count - 1;
        end
        else begin
            error_count_next = error_count;
        end
    end

    assign end_wait = ~|error_count;

endmodule