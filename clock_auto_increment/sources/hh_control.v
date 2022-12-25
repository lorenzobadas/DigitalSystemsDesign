`timescale 1ns/1ps

module hh_control(
    input ck, reset,
    input hh,
    input clock_alarm, carry_from_minutes,
    output reg up_clock24, up_alarm24
);

    parameter [1:0]
        IDLE = 0,
        UP_CLOCK = 1,
        UP_ALARM = 2,
        WAIT = 3;
    reg [1:0] state, state_next;

    always @(posedge ck, posedge reset) begin
        if (reset) state <= IDLE;
        else state <= state_next;
    end

    always @(state, clock_alarm, hh) begin
        case (state)
            IDLE: begin
                if (hh && clock_alarm) state_next = UP_CLOCK;
                else if (hh && !clock_alarm) state_next = UP_ALARM;
                else state_next = IDLE;
            end
            UP_CLOCK: state_next = WAIT;
            UP_ALARM: state_next = WAIT;
            WAIT: begin
                if (hh) state_next = WAIT;
                else state_next = IDLE;
            end
            default: state_next = IDLE;
        endcase
    end

    always @(state, carry_from_minutes) begin
        case (state)
            IDLE: begin
                up_clock24 = carry_from_minutes;
                up_alarm24 = 0;
            end
            UP_CLOCK: begin
                up_clock24 = 1;
                up_alarm24 = 0;
            end
            UP_ALARM: begin
                up_clock24 = carry_from_minutes;
                up_alarm24 = 1;
            end
            WAIT: begin
                up_clock24 = carry_from_minutes;
                up_alarm24 = 0;
            end
            default: begin
                up_clock24 = carry_from_minutes;
                up_alarm24 = 0;
            end
        endcase
    end

endmodule