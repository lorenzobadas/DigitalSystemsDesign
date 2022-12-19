`timescale 1ns/1ps

module mux_4(
    input [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7,
    input [2:0] sel,
    output reg [3:0] in_seg
);

    always @(seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, sel) begin
        case (sel)
            4'h0: in_seg = seg0;
            4'h1: in_seg = seg1;
            4'h2: in_seg = seg2;
            4'h3: in_seg = seg3;
            4'h4: in_seg = seg4;
            4'h5: in_seg = seg5;
            4'h6: in_seg = seg6;
            4'h7: in_seg = seg7;
            default: in_seg = 4'h0;
        endcase
    end

endmodule