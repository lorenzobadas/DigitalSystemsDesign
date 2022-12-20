`timescale 1ns/1ps

module mem_ptr(
    input ck, reset,
    input clr_ptr, inc_ptr,
    output reg [3:0] ptr
    );

    reg [3:0] ptr_next;

    always @(posedge ck, posedge reset) begin
        if (reset) ptr <= 0;
        else ptr <= ptr_next;
    end

    always @(ptr, clr_ptr, inc_ptr) begin
        if (clr_ptr) ptr_next = 0;
        else if (inc_ptr) ptr_next = ptr + 1;
        else ptr_next = ptr;
    end

endmodule