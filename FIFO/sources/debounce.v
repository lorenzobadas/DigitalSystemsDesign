`timescale 1ns/1ps

module count_ms(
    input ck,
    input clear,
    output hit
    );
    parameter [16:0] MAX_COUNT = 17'd100_000;
    reg [16:0] count, count_next;
    always @(posedge ck) begin
        count <= count_next;
    end

    always @(count, clear) begin
        if (clear) count_next = 0;
        else count_next = count + 1;
    end

    assign hit = (count == MAX_COUNT) ? 1 : 0;

endmodule

module debounce(
    input ck, reset,
    input button,
    output reg button_deb
    );

    reg clear;
    wire hit;
    count_ms u0(ck, clear, hit);

    parameter [2:0]
        IDLE = 0,
        PUSH = 1,
        WAIT1 = 2,
        STILL_PUSHING = 3,
        NOT_PUSH = 4,
        WAIT0 = 5;
    reg [2:0] state, state_next;

    always @(posedge ck, posedge reset) begin
        if (reset) state <= IDLE;
        else state <= state_next;
    end

    always @(state, button, hit) begin
        case (state)
            IDLE: begin
                if (button) state_next = PUSH;
                else state_next = IDLE;
            end
            PUSH: begin
                state_next = WAIT1;
            end
            WAIT1: begin
                if (hit) state_next = STILL_PUSHING;
                else state_next = WAIT1;
            end
            STILL_PUSHING: begin
                if (!button) state_next = NOT_PUSH;
                else state_next = STILL_PUSHING;
            end
            NOT_PUSH: begin
                state_next = WAIT0;
            end
            WAIT0: begin
                if (hit) state_next = IDLE;
                else state_next = WAIT0;
            end
        endcase
    end

    always @(state) begin
        clear = 1'bx;
        button_deb = 1'b0;
        case (state)
            PUSH: begin
                button_deb = 1;
                clear = 1;
            end
            WAIT1: begin
                clear = 0;
            end
            NOT_PUSH: begin
                clear = 1;
            end
            WAIT0: begin
                clear = 0;
            end
        endcase
    end

endmodule