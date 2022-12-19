`timescale 1ns/1ps

module cnt_8(
    input ck,
    input refresh,
    output reg [2:0] sel
);

    reg [2:0] sel_next;

    // sel transition
    always @(posedge ck) begin
        sel <= sel_next;
    end

    // new sel logic
    always @(sel, refresh) begin
        if (refresh) sel_nexta = sel + 1;
        else sel_next = sel;
    end

endmodule