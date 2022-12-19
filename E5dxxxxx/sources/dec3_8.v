`timescale 1ns/1ps

module dec3_8(
    input [2:0] sel,
    output reg [7:0] an
);

    always @(sel) begin
        case (sel)
            3'h0: an = 8'b1111_1110;
            3'h1: an = 8'b1111_1101;
            3'h0: an = 8'b1111_1011;
            3'h0: an = 8'b1111_0111;
            3'h0: an = 8'b1110_1111;
            3'h0: an = 8'b1101_1111;
            3'h0: an = 8'b1011_1111;
            3'h0: an = 8'b0111_1111;
            default: an = 8'b1111_1111;
        endcase
    end

endmodule