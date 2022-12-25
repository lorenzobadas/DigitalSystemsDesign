`timescale 1ns/1ps

module mm_control(
    input ck, reset,
    input mm,
    input clock_alarm, min,
    output reg up_clock60, up_alarm60
);
    reg clear;
    wire hit;
    half_seconds_enable u0(ck, reset, clear, hit);

    parameter [2:0]
        IDLE = 0,
        EN_MM = 1,
        WAIT_SEC = 2,
        AUTO1 = 3,
        INC_UP1 = 4,
        AUTO2 = 5,
        INC_UP2 = 6,
        STOP_AUTO = 7;
    reg [2:0] state, state_next;

    always @(posedge ck, posedge reset) begin
        if (reset) state <= IDLE;
        else state <= state_next;
    end

    always @(state, mm, hit) begin
        case (state)
            IDLE: begin
                if (mm) state_next = EN_MM;
                else state_next = IDLE;
            end
            EN_MM: begin
                state_next = WAIT_SEC;
            end
            WAIT_SEC: begin
                if (hit && mm) state_next = AUTO1;
                else if (!mm) state_next = IDLE;
                else state_next = WAIT_SEC;
            end
            AUTO1: begin
                if (!mm) state_next = AUTO2;
                else if (hit) state_next = INC_UP1;
                else state_next = AUTO1;
            end
            INC_UP1: begin
                state_next = AUTO1;
            end
            AUTO2: begin
                if (mm) state_next = STOP_AUTO;
                else if (hit) state_next = INC_UP2;
                else state_next = AUTO2;
            end
            INC_UP2: begin
                state_next = AUTO2;
            end
            STOP_AUTO: begin
                if (!mm) state_next = IDLE;
                else state_next = STOP_AUTO;
            end
            default: state_next = IDLE;
        endcase
    end

    always @(state, min, clock_alarm) begin
        case (state)
            IDLE: begin
                up_clock60 = min;
                up_alarm60 = 0;
                clear = 1'bx;
            end
            EN_MM: begin
                up_clock60 = clock_alarm | min;
                up_alarm60 = ~clock_alarm;
                clear = 1'b1;
            end
            WAIT_SEC: begin
                up_clock60 = min;
                up_alarm60 = 0;
                clear = 0;
            end
            AUTO1: begin
                up_clock60 = 0;
                up_alarm60 = 0;
                clear = 0;
            end
            INC_UP1: begin
                up_clock60 = clock_alarm;
                up_alarm60 = ~clock_alarm;
                clear = 0;
            end
            AUTO2: begin
                up_clock60 = 0;
                up_alarm60 = 0;
                clear = 0;
            end
            INC_UP2: begin
                up_clock60 = clock_alarm;
                up_alarm60 = ~clock_alarm;
                clear = 0;
            end
            STOP_AUTO: begin
                up_clock60 = min;
                up_alarm60 = 0;
                clear = 1'bx;
            end
            default: begin
                up_clock60 = min;
                up_alarm60 = 0;
                clear = 1'bx;
            end
        endcase
    end

endmodule