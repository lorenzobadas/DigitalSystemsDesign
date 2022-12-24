`timescale 1ns/1ps

module count_ms(
    input ck,
    input clear,
    output hit
);
    parameter [16:0] COUNT_MAX = 17'd100_000;
    reg [16:0] count, count_next;

    always @(posedge ck) begin
        count <= count_next;
    end

    always @(count) begin
        if (count == COUNT_MAX) count_next = 0;
        else count_next = count + 1;
    end

    assign hit = (count == COUNT_MAX) ? 1 : 0;

endmodule

module debounce_control(
    input ck,
    input button, ms,
    output reg clear, button_deb
);

    parameter [1:0]
        IDLE = 0,
        PUSH = 1,
        STILL_PUSH = 2,
        NOT_PUSH = 3;

    reg [1:0] state, state_next;

    always @(posedge ck) begin
        state <= state_next;
    end

    always @(state, ms, button) begin
        case (state)
            IDLE: begin
                if (button) state_next = PUSH;
                else state_next = IDLE;
            end
            PUSH: begin
                if (ms) state_next = STILL_PUSH;
                else state_next = PUSH;
            end
            STILL_PUSH: begin
                if (button) state_next = STILL_PUSH;
                else state_next = NOT_PUSH;
            end
            NOT_PUSH: begin
                if (ms) state_next = IDLE;
                else state_next = NOT_PUSH;
            end
            default: state_next = IDLE;
        endcase
    end

    always @(state) begin
        case (state)
            IDLE: begin
                clear = 1;
                button_deb = 0;
            end
            PUSH: begin
                clear = 0;
                button_deb = 1;
            end
            STILL_PUSH: begin
                clear = 1;
                button_deb = 1;
            end
            NOT_PUSH: begin
                clear = 0;
                button_deb = 0;
            end
            default: begin
                clear = 0;
                button_deb = 0;
            end
        endcase
    end

endmodule

module debounce(
    input ck,
    input button,
    output button_deb
);
    wire ms, clear;
    debounce_control u0(ck, button, ms, clear, button_deb);
    count_ms u1(ck, clear, ms);

endmodule