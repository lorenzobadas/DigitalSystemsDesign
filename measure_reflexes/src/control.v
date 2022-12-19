`timescale 1ns/1ps

module control(
    input ck, reset,
    input start, pul,
    input one_ms, end_wait, new, zero, hit_5s,
    output enable, clear_ms_enable, clear_count_ms, write_enable, load_wait, dec_wait, inc_errors, load_rand, clear_5s,
    output led, block
);

    parameter [3:0] 
        IDLE = 0,
        WAIT_RAND = 1,
        ONE_MS = 2,
        ENABLE_MS = 3,
        COMPARE = 4,
        LOAD_MEMORY = 5,
        ERROR = 6,
        LOAD_ERROR = 7,
        WAIT_ERROR = 8,
        DEC_WAIT = 9;
    reg [3:0] state, state_next;
    // state transition
    always @(posedge ck, posedge reset) begin
        if (reset) state <= IDLE;
        else state <= state_next;
    end

    // next state logic
    always @(state, start, pul, end_wait, one_ms, new, zero, hit_5s) begin
        case (state)
            IDLE: begin
                if (start) state_next = WAIT_RAND;
                else state_next = IDLE;
            end
            WAIT_RAND: begin
                if (zero) state_next = ONE_MS;
                else if (pul) state_next = ERROR;
                else state_next = WAIT_RAND;
            end
            ONE_MS: begin
                if (pul) state_next = COMPARE;
                else if (one_ms) state_next = ENABLE_MS;
                else state_next = ONE_MS;
            end
            ENABLE_MS: begin
                if (pul) state_next = COMPARE;
                else state_next = ONE_MS;
            end
            COMPARE: begin
                if (start && new) state_next = LOAD_MEMORY;
                else if (start && !new) state_next = WAIT_RAND;
                else state_next = COMPARE;
            end
            LOAD_MEMORY: begin
                state_next = WAIT_RAND;
            end
            ERROR: begin
                state_next = LOAD_ERROR;
            end
            LOAD_ERROR: begin
                state_next = WAIT_ERROR;
            end
            WAIT_ERROR: begin
                if (end_wait) state_next = IDLE;
                else if (hit_5s) state_next = DEC_WAIT;
                else state_next = WAIT_ERROR;
            end
            DEC_WAIT: begin
                state_next = WAIT_ERROR;
            end
            default: state_next = IDLE;
        endcase
    end

    // output logic
    reg [10:0] outputs;
    always @(state) begin
        case (state)
            IDLE:           outputs = 11'b0x10xx01x00;
            WAIT_RAND:      outputs = 11'b0110xx00x00;
            ONE_MS:         outputs = 11'b0000xx0xx10;
            ENABLE_MS:      outputs = 11'b1000xx0xx10;
            COMPARE:        outputs = 11'b0x00xx01x00;
            LOAD_MEMORY:    outputs = 11'b0x11xx01x00;
            ERROR:          outputs = 11'b0x10xx1xx01;
            LOAD_ERROR:     outputs = 11'b0x10100x101;
            WAIT_ERROR:     outputs = 11'b0x10000x001;
            DEC_WAIT:       outputs = 11'b0x10010x001;
            default:        outputs = 11'b0;
        endcase
    end
    assign {enable, clear_ms_enable, clear_count_ms, write_enable, load_wait, dec_wait, inc_errors, load_rand, clear_5s, led, block} = outputs;
endmodule