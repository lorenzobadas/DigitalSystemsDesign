`timescale 1ns/1ps

module memory(
    input ck, reset, write_enable,
    input [3:0] cnt0, cnt1, cnt2, cnt3,
    output reg [3:0] rec0, rec1, rec2, rec3
);

    reg [3:0] new_rec0, new_rec1, new_rec2, new_rec3;

    always @(posedge ck, posedge reset) begin
        if (reset) begin
            rec0 <= 9;
            rec1 <= 9;
            rec2 <= 9;
            rec3 <= 9;
        end
        else begin
            rec0 <= new_rec0;
            rec1 <= new_rec1;
            rec2 <= new_rec2;
            rec3 <= new_rec3;
        end
    end

    always @(write_enable, cnt0, cnt1, cnt2, cnt3, rec0, rec1, rec2, rec3) begin
        if (write_enable) begin
            new_rec0 = cnt0;
            new_rec1 = cnt1;
            new_rec2 = cnt2;
            new_rec3 = cnt3;
        end
        else begin
            new_rec0 = rec0;
            new_rec1 = rec1;
            new_rec2 = rec2;
            new_rec3 = rec3;
        end
    end
endmodule