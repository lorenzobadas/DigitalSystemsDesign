`timescale 1ns/1ps

module seven_segments(
	input [3:0] in_seg,
	output reg [6:0] c // {ca, cb, cc, cd, ce, cf, cg}
);

	always @(in_seg) begin
		case (in_seg)
			4'h0: c = 7'b0000001;
			4'h1: c = 7'b1001111;
			4'h2: c = 7'b0010010;
			4'h3: c = 7'b0000110;
			4'h4: c = 7'b1001100;
			4'h5: c = 7'b0100100;
			4'h6: c = 7'b0100000;
			4'h7: c = 7'b0001111;
			4'h8: c = 7'b0000000;
			4'h9: c = 7'b0000100;
			4'hA: c = 7'b0001000;
			4'hB: c = 7'b1100000;
			4'hC: c = 7'b0110001;
			4'hD: c = 7'b1000010;
			4'hE: c = 7'b0110000;
			4'hF: c = 7'b0111000;
			default: c = 7'b1111111;
		endcase
	end

endmodule