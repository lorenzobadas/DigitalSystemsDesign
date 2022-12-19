`timescale 1ns/1ps

module gen_refresh(
    input ck,
    output refresh
);

    reg [26:0] cnt, cnt_next;
    parameter [26:0] MAX_CNT = 27'd99_999;

    always @(posedge ck) begin
        cnt <= cnt_next;
    end

    always @(cnt) begin
        if (cnt == MAX_CNT) cnt_next = 0;
        else cnt_next = cnt + 1;
    end

    assign refresh = (cnt == MAX_CNT) ? 1 : 0;

endmodule