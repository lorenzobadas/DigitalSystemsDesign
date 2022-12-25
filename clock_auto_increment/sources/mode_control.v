`timescale 1ns/1ps

module mode_control(
    input ck, reset,
    input mode,
    output reg clock_alarm
);

    parameter [1:0]
        IDLE_CLOCK = 0,
        ALARM = 1,
        IDLE_ALARM = 2,
        CLOCK = 3;
    reg [1:0] state, state_next;

    always @(posedge ck, posedge reset) begin
        if (reset) state <= IDLE_CLOCK;
        else state <= state_next;
    end

    always @(state, mode) begin
        case (state)
            IDLE_CLOCK: begin
                if (mode) state_next = ALARM;
                else state_next = IDLE_CLOCK;
            end
            ALARM: begin
                if (mode) state_next = ALARM;
                else state_next = IDLE_ALARM;
            end
            IDLE_ALARM: begin
                if (mode) state_next = CLOCK;
                else state_next = IDLE_ALARM;
            end
            CLOCK: begin
                if (mode) state_next = CLOCK;
                else state_next = IDLE_CLOCK;
            end
            default: state_next = IDLE_CLOCK;
        endcase
    end

    always @(state) begin
        case (state)
            IDLE_CLOCK: clock_alarm = 1;
            CLOCK:      clock_alarm = 1;
            IDLE_ALARM: clock_alarm = 0;
            ALARM:      clock_alarm = 0;
            default:    clock_alarm = 1;
        endcase
    end

endmodule