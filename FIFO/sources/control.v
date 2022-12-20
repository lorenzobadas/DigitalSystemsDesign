`timescale 1ns/1ps

module control(
    input ck, reset,
    input insert, remove, flush,
    input test,
    output inc_wp, inc_rp, clear_wp, clear_rp,
    output wp_rp_sel,
    output chip_sel,
    output write_enable,
    output full, empty
    );

    parameter [3:0]
        EMPTY = 0,
        WRITE = 1,
        IDLE = 2,
        READ = 3,
        FULL = 4,
        CLEAR = 5,
        DUM_W = 6,
        DUM_R = 7;
    reg [3:0] state, state_next;

    always @(posedge ck, posedge reset) begin
        if (reset) state <= EMPTY;
        else state <= state_next;
    end

    always @(state, insert, remove, flush, test) begin
        case (state)
            EMPTY: begin
                if (flush) state_next = EMPTY;
                else if (insert && !remove) state_next = WRITE;
                else if (remove && !insert) state_next = EMPTY;
                else state_next = EMPTY;
            end
            WRITE: begin
                state_next = DUM_W;
            end
            DUM_W: begin
                if (test) state_next = FULL;
                else state_next = IDLE;
            end
            IDLE: begin
                if (flush) state_next = CLEAR;
                else if (insert && !remove) state_next = WRITE;
                else if (remove && !insert) state_next = READ;
                else state_next = IDLE;
            end
            READ: begin
                state_next = DUM_R;
            end
            DUM_R: begin
                if (test) state_next = EMPTY;
                else state_next = IDLE;
            end
            FULL: begin
                if (flush) state_next = CLEAR;
                else if (insert && !remove) state_next = FULL;
                else if (remove && !insert) state_next = READ;
                else state_next = FULL;
            end
            CLEAR: begin
                state_next = EMPTY;
            end
        endcase
    end

    reg [8:0] outputs;
    always @(state) begin
        case (state)
            EMPTY:  outputs = 9'b0000x0x01;
            WRITE:  outputs = 9'b100011100;
            DUM_W:  outputs = 9'b0000x0x00;
            IDLE:   outputs = 9'b0000x0x00;
            READ:   outputs = 9'b010001000;
            DUM_R:  outputs = 9'b0000x0x00;
            FULL:   outputs = 9'b0000x0x10;
            CLEAR:  outputs = 9'b0011x0x00;
        endcase
    end

    assign {inc_wp, inc_rp, clear_wp, clear_rp, wp_rp_sel, chip_sel, write_enable, full, empty} = outputs;

endmodule