`timescale 1ns / 1ps

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

module timer_haz(
    input clk, reset,
    output enable
    );
    
    parameter [25:0] MAX_COUNT = 26'd50_000_000;
    reg [25:0] count, count_next;

    always @(posedge clk, posedge reset) begin
        if (reset) count <= 0;
        else count <= count_next;
    end

    always @(count) begin
        if (count == MAX_COUNT) count_next = 0;
        else count_next = count + 1;
    end

    assign enable = count == MAX_COUNT ? 1 : 0;

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
            4'h0: {CA, CB, CC, CD, CE, CF, CG} = 7'b1111111;//7'b0000001; mod to look better
            4'h1: {CA, CB, CC, CD, CE, CF, CG} = 7'b1001111;
            4'h2: {CA, CB, CC, CD, CE, CF, CG} = 7'b0010010;
            4'h3: {CA, CB, CC, CD, CE, CF, CG} = 7'b0000110;
            4'h4: {CA, CB, CC, CD, CE, CF, CG} = 7'b1001100;
            4'h5: {CA, CB, CC, CD, CE, CF, CG} = 7'b0100100;
            4'h6: {CA, CB, CC, CD, CE, CF, CG} = 7'b0100000;
            4'h7: {CA, CB, CC, CD, CE, CF, CG} = 7'b0001111;
            4'h8: {CA, CB, CC, CD, CE, CF, CG} = 7'b0110110;//7'b0000000; mod to look better
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

module timer_dir(
    input clk, reset,
    output enable
    );
    
    parameter [24:0] MAX_COUNT = 25'd25_000_000;
    reg [24:0] count, count_next;

    always @(posedge clk, posedge reset) begin
        if (reset) count <= 0;
        else count <= count_next;
    end

    always @(count) begin
        if (count == MAX_COUNT) count_next = 0;
        else count_next = count + 1;
    end

    assign enable = count == MAX_COUNT ? 1 : 0;

endmodule


module tail_lights_FSM(
    input clk, reset, left, right, haz,
    output reg LC, LB, LA, RA, RB, RC
    );

    parameter [4:0]
        IDLE = 0,
        HAZ_ON = 1,
        HAZ_OFF = 2,
        WAIT_H_ON = 3,
        WAIT_H_OFF = 4,
        L0 = 5,
        L1 = 6,
        L2 = 7,
        L_OFF = 8,
        WAIT_L_0 = 9,
        WAIT_L_1 = 10,
        WAIT_L_2 = 11,
        WAIT_L_OFF = 12,
        R0 = 13,
        R1 = 14,
        R2 = 15,
        R_OFF = 16,
        WAIT_R_0 = 17,
        WAIT_R_1 = 18,
        WAIT_R_2 = 19,
        WAIT_R_OFF = 20;

    reg [4:0] state, state_next;
    reg reset_timer_haz, reset_timer_dir;
    wire interr_haz, interr_dir;

    // timers
    timer_haz th(clk, reset_timer_haz, interr_haz);
    timer_dir td(clk, reset_timer_dir, interr_dir);

    // state transition
    always @(posedge clk, posedge reset) begin
        if (reset) state <= IDLE;
        else state <= state_next;
    end

    // next state logic
    always @(state, left, right, haz, interr_haz, interr_dir) begin
        case (state)
            IDLE: begin
                casex ({left, right, haz})
                    3'bxx1: state_next = HAZ_ON;
                    3'b100: state_next = L0;
                    3'b010: state_next = R0;
                    default: state_next = IDLE;
                endcase
            end
            HAZ_ON: begin
                if (haz) state_next = WAIT_H_ON;
                else state_next = IDLE;
            end
            HAZ_OFF: begin
                if (haz) state_next = WAIT_H_OFF;
                else state_next = IDLE;
            end
            WAIT_H_ON: begin
                case ({interr_haz, haz})
                    2'b01: state_next = WAIT_H_ON;
                    2'b11: state_next = HAZ_OFF;
                    default: state_next = IDLE;
                endcase
            end
            WAIT_H_OFF: begin
                case ({interr_haz, haz})
                    2'b01: state_next = WAIT_H_OFF;
                    2'b11: state_next = HAZ_ON;
                    default: state_next = IDLE;
                endcase
            end
            L0: begin
                case ({left, right, haz})
                    3'b100: state_next = WAIT_L_0;
                    default: state_next = IDLE;
                endcase
            end
            L1: begin
                case ({left, right, haz})
                    3'b100: state_next = WAIT_L_1;
                    default: state_next = IDLE;
                endcase
            end
            L2: begin
                case ({left, right, haz})
                    3'b100: state_next = WAIT_L_2;
                    default: state_next = IDLE;
                endcase
            end
            L_OFF: begin
                case ({left, right, haz})
                    3'b100: state_next = WAIT_L_OFF;
                    default: state_next = IDLE;
                endcase
            end
            WAIT_L_0: begin
                case ({interr_dir, left, right, haz})
                    4'b0100: state_next = WAIT_L_0;
                    4'b1100: state_next = L1;
                    default: state_next = IDLE;
                endcase
            end
            WAIT_L_1: begin
                case ({interr_dir, left, right, haz})
                    4'b0100: state_next = WAIT_L_1;
                    4'b1100: state_next = L2;
                    default: state_next = IDLE;
                endcase
            end
            WAIT_L_2: begin
                case ({interr_dir, left, right, haz})
                    4'b0100: state_next = WAIT_L_2;
                    4'b1100: state_next = L_OFF;
                    default: state_next = IDLE;
                endcase
            end
            WAIT_L_OFF: begin
                case ({interr_dir, left, right, haz})
                    4'b0100: state_next = WAIT_L_OFF;
                    4'b1100: state_next = L0;
                    default: state_next = IDLE;
                endcase
            end
            R0: begin
                case ({left, right, haz})
                    3'b010: state_next = WAIT_R_0;
                    default: state_next = IDLE;
                endcase
            end
            R1: begin
                case ({left, right, haz})
                    3'b010: state_next = WAIT_R_1;
                    default: state_next = IDLE;
                endcase
            end
            R2: begin
                case ({left, right, haz})
                    3'b010: state_next = WAIT_R_2;
                    default: state_next = IDLE;
                endcase
            end
            R_OFF: begin
                case ({left, right, haz})
                    3'b010: state_next = WAIT_R_OFF;
                    default: state_next = IDLE;
                endcase
            end
            WAIT_R_0: begin
                case ({interr_dir, left, right, haz})
                    4'b0010: state_next = WAIT_R_0;
                    4'b1010: state_next = R1;
                    default: state_next = IDLE;
                endcase
            end
            WAIT_R_1: begin
                case ({interr_dir, left, right, haz})
                    4'b0010: state_next = WAIT_R_1;
                    4'b1010: state_next = R2;
                    default: state_next = IDLE;
                endcase
            end
            WAIT_R_2: begin
                case ({interr_dir, left, right, haz})
                    4'b0010: state_next = WAIT_R_2;
                    4'b1010: state_next = R_OFF;
                    default: state_next = IDLE;
                endcase
            end
            WAIT_R_OFF: begin
                case ({interr_dir, left, right, haz})
                    4'b0010: state_next = WAIT_R_OFF;
                    4'b1010: state_next = R0;
                    default: state_next = IDLE;
                endcase
            end
        endcase
    end

    // output logic
    always @(state) begin
        case (state)
            IDLE: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                reset_timer_haz = 0;
                reset_timer_dir = 1;
            end
            HAZ_ON: begin
                {LC, LB, LA, RA, RB, RC} = 6'b111_111;
                reset_timer_haz = 1;
                reset_timer_dir = 0;
            end
            HAZ_OFF: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                reset_timer_haz = 1;
                reset_timer_dir = 0;
            end
            WAIT_H_ON: begin
                {LC, LB, LA, RA, RB, RC} = 6'b111_111;
                reset_timer_haz = 0;
                reset_timer_dir = 0;
            end
            WAIT_H_OFF: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                reset_timer_haz = 0;
                reset_timer_dir = 0;
            end
            L0: begin
                {LC, LB, LA, RA, RB, RC} = 6'b001_000;
                reset_timer_haz = 0;
                reset_timer_dir = 1;
            end
            L1: begin
                {LC, LB, LA, RA, RB, RC} = 6'b011_000;
                reset_timer_haz = 0;
                reset_timer_dir = 1;
            end
            L2: begin
                {LC, LB, LA, RA, RB, RC} = 6'b111_000;
                reset_timer_haz = 0;
                reset_timer_dir = 1;
            end
            L_OFF: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                reset_timer_haz = 0;
                reset_timer_dir = 1;
            end
            WAIT_L_0: begin
                {LC, LB, LA, RA, RB, RC} = 6'b001_000;
                reset_timer_haz = 0;
                reset_timer_dir = 0;
            end
            WAIT_L_1: begin
                {LC, LB, LA, RA, RB, RC} = 6'b011_000;
                reset_timer_haz = 0;
                reset_timer_dir = 0;
            end
            WAIT_L_2: begin
                {LC, LB, LA, RA, RB, RC} = 6'b111_000;
                reset_timer_haz = 0;
                reset_timer_dir = 0;
            end
            WAIT_L_OFF: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                reset_timer_haz = 0;
                reset_timer_dir = 0;
            end
            R0: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_100;
                reset_timer_haz = 0;
                reset_timer_dir = 1;
            end
            R1: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_110;
                reset_timer_haz = 0;
                reset_timer_dir = 1;
            end
            R2: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_111;
                reset_timer_haz = 0;
                reset_timer_dir = 1;
            end
            R_OFF: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                reset_timer_haz = 0;
                reset_timer_dir = 1;
            end
            WAIT_R_0: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_100;
                reset_timer_haz = 0;
                reset_timer_dir = 0;
            end
            WAIT_R_1: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_110;
                reset_timer_haz = 0;
                reset_timer_dir = 0;
            end
            WAIT_R_2: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_111;
                reset_timer_haz = 0;
                reset_timer_dir = 0;
            end
            WAIT_R_OFF: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                reset_timer_haz = 0;
                reset_timer_dir = 0;
            end
            default: begin 
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                reset_timer_haz = 0;
                reset_timer_dir = 0;
            end
        endcase
    end
endmodule

module light_to_seg(
    input clk, reset, left, right, haz,
    output reg [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7
    );
    parameter [3:0] ON = 8, OFF = 0;
    wire LC, LB, LA, RA, RB, RC;
    tail_lights_FSM tlFSM(clk, reset, left, right, haz, LC, LB, LA, RA, RB, RC);

    always @(LC, LB, LA, RA, RB, RC) begin
        if (LC) seg7 = ON;
        else seg7 = OFF;
        if (LB) seg6 = ON;
        else seg6 = OFF;
        if (LA) seg5 = ON;
        else seg5 = OFF;
        if (RA) seg2 = ON;
        else seg2 = OFF;
        if (RB) seg1 = ON;
        else seg1 = OFF;
        if (RC) seg0 = ON;
        else seg0 = OFF;
        seg3 = OFF;
        seg4 = OFF;
    end

endmodule

module top(
    input clk, reset, left, right, haz,
    output CA, CB, CC, CD, CE, CF, CG, AN0, AN1, AN2, AN3, AN4, AN5, AN6, AN7
    );
    wire en;
    wire [2:0] sel;
    wire [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, in_seg;
    genen u0(clk, ~reset, en);
    cnt_8 u1(en, ~reset, sel);
    dec3_8 u2(sel, AN0, AN1, AN2, AN3, AN4, AN5, AN6, AN7);
    mux_4 u3(seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, sel, in_seg);
    seven_segments u4(in_seg, CA, CB, CC, CD, CE, CF, CG);
    light_to_seg u5(clk, ~reset, left, right, haz, seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7);
    
endmodule
