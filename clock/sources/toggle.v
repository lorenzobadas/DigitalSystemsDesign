`timescale 1ns/1ps

module toggle(
    input ck, reset,
    input signal,
    output reg signal_tog
    );

    reg signal_tog_next;

    always @(posedge ck, posedge reset) begin
        if (reset) signal_tog <= 0;
        else signal_tog <= signal_tog_next;
    end

    always @(signal_tog, signal) begin
        if (signal) signal_tog_next = ~signal_tog;
        else signal_tog_next = signal_tog;
    end

endmodule