`timescale 1ns/1ps

module count10(
    input ck,
    input inc,
    output carry_out,
    output reg [3:0] count
);

    reg [3:0] count_next;

    always @(posedge ck) begin
        count <= count_next;
    end

    always @(count, inc) begin
        if (inc) begin
            if (count == 9) count_next = 0;
            else count_next = count + 1;
        end
        else begin
            count_next = count;
        end
    end

    assign carry_out = (count == 9 && inc) ? 1 : 0;

endmodule

module count6(
    input ck,
    input inc,
    output carry_out,
    output reg [3:0] count
);

    reg [3:0] count_next;

    always @(posedge ck) begin
        count <= count_next;
    end

    always @(count, inc) begin
        if (inc) begin
            if (count == 5) count_next = 0;
            else count_next = count + 1;
        end
        else begin
            count_next = count;
        end
    end

    assign carry_out = (count == 5 && inc) ? 1 : 0;

endmodule

module count60(
    input ck,
    input up60,
    output carry_to_hours,
    output [3:0] display0, display1
);

    wire carry_out;
    count10 u0(ck, up60, carry_out, display0);
    count6  u1(ck, carry_out, carry_to_hours, display1);

endmodule