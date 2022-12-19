`timescale 1ns/1ps

module count_ds(
    input ck, reset, 
    output reg enable_ds
);

    parameter [23:0] MAX_COUNT = 10_000_000;
    reg [23:0] count, count_next;
    always @(posedge ck, posedge reset) begin
        if (reset) count <= 0;
        else count <= count_next;
    end

    always @(count) begin
        if (count == MAX_COUNT) begin
            count_next = 0;
            enable_ds = 1;
        end
        else begin
            count_next = count + 1;
            enable_ds = 0;
        end
    end

endmodule

module dec_count(
    input ck, reset, load,
    input [5:0] new_value,
    output zero
);

    reg [5:0] value, value_next;
    wire enable;

    count_ds u0(ck, reset, enable);

    always @(posedge ck, posedge reset) begin
        if (reset) value <= 0;
        else value <= value_next;
    end

    always @(new_value, value, load, enable) begin
        if (load) value_next = new_value;
        else if (enable && value) value_next = value - 1;
        else value_next = value;
    end

    assign zero = ~|value;

endmodule