`timescale 1ns/1ps

module time_gen(
    input ck, reset,
    output sec, min, refresh
);

    half_seconds_enable u0(ck, reset, sec);
    minutes_enable u1(ck, reset, min);
    refresh_enable u2(ck, refresh);

endmodule