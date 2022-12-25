`timescale 1ns/1ps

module cnt_4(
    input ck,
    input refresh,
    output reg [1:0] sel
    );

    reg [1:0] sel_next;

    // sel transition
    always @(posedge ck) begin
        sel <= sel_next;
    end

    // new sel logic
    always @(sel, refresh) begin
        if (refresh) sel_next = sel + 1;
        else sel_next = sel;
    end

endmodule

module dec2_4(
    input [1:0] sel,
    output reg [7:0] an
    );

    always @(sel) begin
        case (sel)
            3'h0: an = 8'b1111_1110;
            3'h1: an = 8'b1111_1101;
            3'h2: an = 8'b1111_1011;
            3'h3: an = 8'b1111_0111;
            default: an = 8'b1111_1111;
        endcase
    end

endmodule

module mux_4(
    input [3:0] seg0, seg1, seg2, seg3,
    input [1:0] sel,
    output reg [3:0] in_seg
    );

    always @(seg0, seg1, seg2, seg3, sel) begin
        case (sel)
            4'h0: in_seg = seg0;
            4'h1: in_seg = seg1;
            4'h2: in_seg = seg2;
            4'h3: in_seg = seg3;
            default: in_seg = 4'h0;
        endcase
    end

endmodule

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

module four_display(
    input ck,
    input refresh,
    input [3:0] seg0, seg1, seg2, seg3,
    output [7:0] an,
    output [6:0] c
    );
    wire [1:0] sel;
    wire [3:0] in_seg;
    
    cnt_4 u1(ck, refresh, sel);
    mux_4 u2(seg0, seg1, seg2, seg3, sel, in_seg);
    dec2_4 u3(sel, an);
    seven_segments u4(in_seg, c);
endmodule