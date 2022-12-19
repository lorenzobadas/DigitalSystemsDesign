`timescale 1ns/1ps

module counter(
    input ck, reset, clear, enable,
    output carry,
    output reg [3:0] count
);

    reg [3:0] count_next;

    always @(posedge ck, posedge reset) begin
        if (reset) count <= 9;
        else count <= count_next;
    end

    always @(count, enable, clear) begin
        if (clear) begin
            count_next = 0;
        end
        else if (enable) begin
            if (count == 9) begin
                count_next = 0;
            end
            else count_next = count + 1;
        end
        else begin
            count_next = count;
        end
    end

    assign carry = (count == 9 && enable) ? 1 : 0;

endmodule

module count_ms(
    input ck, reset, clear, enable,
    output [3:0] cnt0, cnt1, cnt2, cnt3
);
    wire carry0, carry1, carry2, carry3;
    counter c0(ck, reset, clear, enable, carry0, cnt0);
    counter c1(ck, reset, clear, carry0, carry1, cnt1);
    counter c2(ck, reset, clear, carry1, carry2, cnt2);
    counter c3(ck, reset, clear, carry2, carry3, cnt3);

endmodule