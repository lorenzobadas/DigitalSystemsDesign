`timescale 1ns/1ps

module time_gen(
    input ck, reset,
    output sec, min, refresh
);
    wire clear = 0;
    half_seconds_enable u0(ck, reset, clear, sec);
    minutes_enable u1(ck, reset, min);
    refresh_enable u2(ck, refresh);

endmodule