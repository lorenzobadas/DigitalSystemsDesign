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
        if (refresh) sel_next = sel + 1;
        else sel_next = sel;
    end

endmodule

module dec3_8(
    input [2:0] sel,
    output reg [7:0] an
);

    always @(sel) begin
        case (sel)
            3'h0: an = 8'b1111_1110;
            3'h1: an = 8'b1111_1101;
            3'h2: an = 8'b1111_1011;
            3'h3: an = 8'b1111_0111;
            3'h4: an = 8'b1110_1111;
            3'h5: an = 8'b1101_1111;
            3'h6: an = 8'b1011_1111;
            3'h7: an = 8'b0111_1111;
            default: an = 8'b1111_1111;
        endcase
    end

endmodule

module gen_refresh(
    input ck,
    output refresh
);

    reg [26:0] cnt, cnt_next;
    parameter [26:0] MAX_CNT = 27'd99_999;

    always @(posedge ck) begin
        cnt <= cnt_next;
    end

    always @(cnt) begin
        if (cnt == MAX_CNT) cnt_next = 0;
        else cnt_next = cnt + 1;
    end

    assign refresh = (cnt == MAX_CNT) ? 1 : 0;

endmodule

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

`timescale 1ns/1ps

module eight_display(
    input ck,
    input [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7,
    output [7:0] an,
    output [6:0] c
);
    wire refresh;
    wire [2:0] sel;
    wire [3:0] in_seg;
    

    gen_refresh u0(ck, refresh);
    cnt_8 u1(ck, refresh, sel);
    mux_4 u2(seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, sel, in_seg);
    dec3_8 u3(sel, an);
    seven_segments u4(in_seg, c);

endmodule