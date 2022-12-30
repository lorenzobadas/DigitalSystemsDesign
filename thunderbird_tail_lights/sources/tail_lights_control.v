`timescale 1ns / 1ps

module tail_lights_control(
    input clk, reset,
    input left, right, haz,
    input interr_dir, interr_haz,
    output reg clear_timer_haz, clear_timer_dir,
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
                clear_timer_haz = 0;
                clear_timer_dir = 1;
            end
            HAZ_ON: begin
                {LC, LB, LA, RA, RB, RC} = 6'b111_111;
                clear_timer_haz = 1;
                clear_timer_dir = 0;
            end
            HAZ_OFF: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                clear_timer_haz = 1;
                clear_timer_dir = 0;
            end
            WAIT_H_ON: begin
                {LC, LB, LA, RA, RB, RC} = 6'b111_111;
                clear_timer_haz = 0;
                clear_timer_dir = 0;
            end
            WAIT_H_OFF: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                clear_timer_haz = 0;
                clear_timer_dir = 0;
            end
            L0: begin
                {LC, LB, LA, RA, RB, RC} = 6'b001_000;
                clear_timer_haz = 0;
                clear_timer_dir = 1;
            end
            L1: begin
                {LC, LB, LA, RA, RB, RC} = 6'b011_000;
                clear_timer_haz = 0;
                clear_timer_dir = 1;
            end
            L2: begin
                {LC, LB, LA, RA, RB, RC} = 6'b111_000;
                clear_timer_haz = 0;
                clear_timer_dir = 1;
            end
            L_OFF: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                clear_timer_haz = 0;
                clear_timer_dir = 1;
            end
            WAIT_L_0: begin
                {LC, LB, LA, RA, RB, RC} = 6'b001_000;
                clear_timer_haz = 0;
                clear_timer_dir = 0;
            end
            WAIT_L_1: begin
                {LC, LB, LA, RA, RB, RC} = 6'b011_000;
                clear_timer_haz = 0;
                clear_timer_dir = 0;
            end
            WAIT_L_2: begin
                {LC, LB, LA, RA, RB, RC} = 6'b111_000;
                clear_timer_haz = 0;
                clear_timer_dir = 0;
            end
            WAIT_L_OFF: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                clear_timer_haz = 0;
                clear_timer_dir = 0;
            end
            R0: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_100;
                clear_timer_haz = 0;
                clear_timer_dir = 1;
            end
            R1: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_110;
                clear_timer_haz = 0;
                clear_timer_dir = 1;
            end
            R2: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_111;
                clear_timer_haz = 0;
                clear_timer_dir = 1;
            end
            R_OFF: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                clear_timer_haz = 0;
                clear_timer_dir = 1;
            end
            WAIT_R_0: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_100;
                clear_timer_haz = 0;
                clear_timer_dir = 0;
            end
            WAIT_R_1: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_110;
                clear_timer_haz = 0;
                clear_timer_dir = 0;
            end
            WAIT_R_2: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_111;
                clear_timer_haz = 0;
                clear_timer_dir = 0;
            end
            WAIT_R_OFF: begin
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                clear_timer_haz = 0;
                clear_timer_dir = 0;
            end
            default: begin 
                {LC, LB, LA, RA, RB, RC} = 6'b000_000;
                clear_timer_haz = 0;
                clear_timer_dir = 0;
            end
        endcase
    end
endmodule