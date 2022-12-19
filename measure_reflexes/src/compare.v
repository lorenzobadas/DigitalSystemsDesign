`timescale 1ns/1ps

module compare(
    input [3:0] cnt0, cnt1, cnt2, cnt3, rec0, rec1, rec2, rec3,
    output reg new
);

    always @(cnt0, cnt1, cnt2, cnt3, rec0, rec1, rec2, rec3) begin
        if ({cnt3, cnt2, cnt1, cnt0} < {rec3, rec2, rec1, rec0}) new = 1;
        else new = 0;
    end

endmodule