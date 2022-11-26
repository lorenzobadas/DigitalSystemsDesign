`timescale 1ns / 1ps

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

module BCD_counter(
    input ck, reset, add1,
    output reg [3:0] out_seg,
    output carry_out
    );
    reg [3:0] value_next;
    
    always @(posedge ck, posedge reset) begin
        if(reset) begin 
            out_seg <= 0;
        end
        else begin 
            out_seg <= value_next;
        end
    end
    
    always @(add1, out_seg) begin
        if (add1) begin
            if (out_seg == 4'h9) value_next = 0;
            else value_next = out_seg + 1;
        end
        else value_next = out_seg;
    end
    
    assign carry_out = (out_seg == 4'h9 && add1) ? 1 : 0;
endmodule

module debounce_FSM(
    input ck, reset, button,
    output reg push
    );
    
    parameter [2:0] IDLE = 3'h0, PUSH = 3'h1, WAIT1 = 3'h2, STILL_PUSHING = 3'h3, NOT_PUSH = 3'h4, WAIT0 = 3'h5;
    reg [2:0] state, state_next;
    reg reset_timer;
    wire ms;
    
    // state transition
    always @(posedge ck, posedge reset) begin
        if (reset) state <= IDLE;
        else state <= state_next;
    end
    
    // state output
    always @(state) begin
        case (state)
            IDLE: begin
                push = 0;
                reset_timer = 0;
            end
            PUSH: begin 
                push = 1;
                reset_timer = 1;
            end
            WAIT1: begin 
                push = 0;
                reset_timer = 0;
            end
            STILL_PUSHING: begin
                push = 0;
                reset_timer = 0;
            end
            NOT_PUSH: begin
                push = 0;
                reset_timer = 1;
            end
            WAIT0: begin
                push = 0;
                reset_timer = 0;
            end
        endcase
    end
    
    // next state
    always @(state, button, ms) begin
        case (state)
            IDLE: 
                if (button) state_next = PUSH;
                else state_next = IDLE;
            PUSH:
                state_next = WAIT1;
            WAIT1:
                if (ms) state_next = STILL_PUSHING;
                else state_next = WAIT1;
            STILL_PUSHING:
                if (~button) state_next = NOT_PUSH;
                else state_next = STILL_PUSHING;
            NOT_PUSH:
                state_next = WAIT0;
            WAIT0:
                if (ms) state_next = IDLE;
                else state_next = WAIT0;
            default:
                state_next = IDLE;
        endcase
    end
    
    count_ms u0(ck, reset_timer, ms);
    
endmodule

module count_ms(
    input ck, reset,
    output enable
    );
    parameter [16:0] MAX_COUNT = 100_000;
    reg [16:0] count, count_next;
    // count transition
    always @(posedge ck, posedge reset) begin
        if (reset) begin
            count <= 0;
        end
        else begin
            count <= count_next;
        end
    end
    
    // get count_next
    always @(count) begin
        if (count == MAX_COUNT) begin
            count_next = 0;
        end
        else begin
            count_next = count + 1;
        end
    end
    assign enable = count == MAX_COUNT ? 1 : 0;
endmodule

module eight_displays(
    input ck, reset, add1,
    output [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7
    );
    
    wire co0, co1, co2, co3, co4, co5, co6, co7;
    BCD_counter u0(ck, reset, add1, seg0, co0);
    BCD_counter u1(ck, reset, co0, seg1, co1);
    BCD_counter u2(ck, reset, co1, seg2, co2);
    BCD_counter u3(ck, reset, co2, seg3, co3);
    BCD_counter u4(ck, reset, co3, seg4, co4);
    BCD_counter u5(ck, reset, co4, seg5, co5);
    BCD_counter u6(ck, reset, co5, seg6, co6);
    BCD_counter u7(ck, reset, co6, seg7, co7);
endmodule

module top(
    input clk, reset, button,
    output CA, CB, CC, CD, CE, CF, CG, AN0, AN1, AN2, AN3, AN4, AN5, AN6, AN7
    );
    wire en, add1;
    wire [2:0] sel;
    wire [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, in_seg;
    genen u0(clk, ~reset, en);
    cnt_8 u1(en, ~reset, sel);
    dec3_8 u2(sel, AN0, AN1, AN2, AN3, AN4, AN5, AN6, AN7);
    mux_4 u3(seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, sel, in_seg);
    seven_segments u4(in_seg, CA, CB, CC, CD, CE, CF, CG);
    debounce_FSM u5(clk, ~reset, button, add1);
    eight_displays u6(clk, ~reset, add1, seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7);
    
endmodule
