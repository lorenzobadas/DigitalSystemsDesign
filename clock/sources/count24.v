`timescale 1ns/1ps

module count24(
    input ck,
    input up24,
    output reg [3:0] display3, display4
);

    reg [7:0] display3_next, display4_next;

    always @(posedge ck) begin
        {display4, display3} <= {display4_next, display3_next};
    end

    always @(up24, display3, display4) begin
        if (up24) begin
            if (display4 == 2 && display3 == 3) begin
                {display4_next, display3_next} = 8'd0;
            end
            else if (display3 == 9) begin
                display4_next = display4 + 1;
                display3_next = 4'd0;
            end
            else begin
                display4_next = display4;
                display3_next = display3 + 1;
            end
        end
        else begin
            {display4_next, display3_next} = {display4, display3};
        end
    end

endmodule