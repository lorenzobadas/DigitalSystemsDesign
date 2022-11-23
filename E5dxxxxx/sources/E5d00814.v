`timescale 1ns / 1ps

module cnt_8(
    input ck, reset,
    output reg [2:0] sel
    );
    reg [2:0] cnt_next;
    
    // rete combinatoria che aumenta il count next di 1
    always @(sel) begin
        cnt_next = sel + 1;
    end
    
    // aggiornamento valore all'edge di clock o di reset
    always @(posedge ck, posedge reset) begin
        if (reset) sel <= 0;
        else if (ck) sel <= cnt_next;
    end   
    
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
            default: in_seg = 8'h0;
        endcase 
    end
    
endmodule

module dec3_8(
    input [2:0] sel,
    output reg an0, an1, an2, an3, an4, an5, an6, an7
    );
    
    always @(sel) begin
        case (sel)
         3'h0: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b10000000;
         3'h1: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b01000000;
         3'h2: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b00100000;
         3'h3: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b00010000;
         3'h4: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b00001000;
         3'h5: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b00000100;
         3'h6: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b00000010;
         3'h7: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b00000001;
         default: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b00000000;
        endcase
    end
    
endmodule

module seven_segments(
    input [3:0] in_seg,
    output reg CA, CB, CC, CD, CE, CF, CG
    );
    
    always @(in_seg) begin
        case (in_seg)
            4'h0: {CA, CB, CC, CD, CE, CF, CG} = 7'b0000001;
            4'h1: {CA, CB, CC, CD, CE, CF, CG} = 7'b1001111;
            4'h2: {CA, CB, CC, CD, CE, CF, CG} = 7'b0010010;
            4'h3: {CA, CB, CC, CD, CE, CF, CG} = 7'b0000110;
            4'h4: {CA, CB, CC, CD, CE, CF, CG} = 7'b1001100;
            4'h5: {CA, CB, CC, CD, CE, CF, CG} = 7'b0100100;
            4'h6: {CA, CB, CC, CD, CE, CF, CG} = 7'b0100000;
            4'h7: {CA, CB, CC, CD, CE, CF, CG} = 7'b0001111;
            4'h8: {CA, CB, CC, CD, CE, CF, CG} = 7'b0000000;
            4'h9: {CA, CB, CC, CD, CE, CF, CG} = 7'b0000100;
            4'hA: {CA, CB, CC, CD, CE, CF, CG} = 7'b0001000;
            4'hB: {CA, CB, CC, CD, CE, CF, CG} = 7'b1100000;
            4'hC: {CA, CB, CC, CD, CE, CF, CG} = 7'b0110001;
            4'hD: {CA, CB, CC, CD, CE, CF, CG} = 7'b1000010;
            4'hE: {CA, CB, CC, CD, CE, CF, CG} = 7'b0110000;
            4'hF: {CA, CB, CC, CD, CE, CF, CG} = 7'b0111000;
            default: {CA, CB, CC, CD, CE, CF, CG} = 7'b1111111;
        endcase
    end

endmodule

module genen(
    input ck, reset,
    output en
    );
    
    reg [26:0] cnt, cnt_next;
    parameter [26:0] max_cnt = 27'd99_999;
    
    always @(cnt) begin
        if (cnt == max_cnt) cnt_next = 0;
        else cnt_next = cnt + 1;
    end
    
    always @(posedge ck, posedge reset) begin
        if (reset) cnt <= 0;
        else if (ck) cnt <= cnt_next;
    end
    
    assign en = (cnt == max_cnt) ? 1 : 0;
    
endmodule

module top(
    input clk, reset,
    output CA, CB, CC, CD, CE, CF, CG,
    output AN0, AN1, AN2, AN3, AN4, AN5, AN6, AN7
    );
    wire en;
    wire [3:0] in_seg, seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7;
    wire [2:0] sel;
    
    assign seg7 = 4'hE;
    assign seg6 = 4'h5;
    assign seg5 = 4'hD;
    assign seg4 = 4'h0;
    assign seg3 = 4'h0;
    assign seg2 = 4'h8;
    assign seg1 = 4'h1;
    assign seg0 = 4'h4;
    
    // ricorda che il tasto reset sulla scheda è 1 a riposo e 0 quando premuto, per questo
    // lo passo negato ai moduli
    genen u0(clk, ~reset, en);
    cnt_8 u1(en, ~reset, sel);
    mux_4 u2(seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, sel, in_seg);
    dec3_8 u3(sel, AN0, AN1, AN2, AN3, AN4, AN5, AN6, AN7);
    seven_segments u4(in_seg, CA, CB, CC, CD, CE, CF, CG);
    
endmodule