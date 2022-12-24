`timescale 1ns/1ps

module mm_control(
    input ck, reset,
    input mm,
    input clock_alarm, min,
    output up_clock60, up_alarm60
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

    always @(state, clock_alarm, mm) begin
        case (state)
            IDLE: begin
                if (mm && clock_alarm) state_next = UP_CLOCK;
                else if (mm && !clock_alarm) state_next = UP_ALARM;
                else state_next = IDLE;
            end
            UP_CLOCK: state_next = WAIT;
            UP_ALARM: state_next = WAIT;
            WAIT: begin
                if (mm) state_next = WAIT;
                else state_next = IDLE;
            end
            default: state_next = IDLE;
        endcase
    end

    always @(state, min) begin
        case (state)
            IDLE: begin
                up_clock60 = min;
                up_alarm60 = 0;
            end
            UP_CLOCK: begin
                up_clock60 = 1;
                up_alarm60 = 0;
            end
            UP_ALARM: begin
                up_clock60 = min;
                up_alarm60 = 1;
            end
            WAIT: begin
                up_clock60 = min;
                up_alarm60 = 0;
            end
            default: begin
                up_clock60 = min;
                up_alarm60 = 0;
            end
        endcase
    end

endmodule