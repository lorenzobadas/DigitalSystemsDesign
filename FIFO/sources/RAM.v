`timescale 1ns/1ps

module RAM(
    input ck,
    input chip_sel,
    input write_enable,
    input [7:0] data_in,
    input [3:0] address,
    output reg [7:0] data_out
    );

    reg [7:0] memory [0:15];

    always @(posedge ck) begin
        if (chip_sel) begin
            if (write_enable) memory[address] <= data_in;
            else data_out <= memory[address];
        end
    end

endmodule