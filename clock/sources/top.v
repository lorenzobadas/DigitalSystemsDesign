`timescale 1ns/1ps

module top(
    input ck, reset,
    input mode, hh, mm, switch,
    output alarm, mode0, mode1,
    output CA, CB, CC, CD, CE, CF, CG, DP,
    output [7:0] AN
    );

    wire mode_deb, hh_deb, mm_deb, switch_deb;
    debounce u0(ck, mode, mode_deb);
    debounce u1(ck, hh, hh_deb);
    debounce u2(ck, mm, mm_deb);
    debounce u3(ck, switch, switch_deb);

    wire clock_alarm;
    mode_control u4(ck, reset, mode_deb, clock_alarm);

    wire sec, min, refresh;
    time_gen u5(ck, reset, sec, min, refresh);

    wire up_clock60, up_alarm60, up_clock24, up_alarm24, carry, carry_null;
    mm_control u6(ck, reset, mm_deb, clock_alarm, min, up_clock60, up_alarm60);
    hh_control u7(ck, reset, hh_deb, clock_alarm, carry, up_clock24, up_alarm24);
    
    wire [3:0] h0, h1, h2, h3, a0, a1, a2, a3;
    count24 clock24(ck, up_clock24, h2, h3);
    count60 clock60(ck, up_clock60, carry, h0, h1);

    count24 alarm24(ck, up_alarm24, a2, a3);
    count60 alarm60(ck, up_alarm60, carry_null, a0, a1);

    wire [3:0] seg0, seg1, seg2, seg3;

    assign seg0 = (clock_alarm) ? h0 : a0;
    assign seg1 = (clock_alarm) ? h1 : a1;
    assign seg2 = (clock_alarm) ? h2 : a2;
    assign seg3 = (clock_alarm) ? h3 : a3;

    four_display u8(ck, refresh, seg0, seg1, seg2, seg3, AN, {CA, CB, CC, CD, CE, CF, CG});

    wire sec_tog;
    toggle u9(ck, reset, sec, sec_tog);
    assign DP = (clock_alarm) ? ~(sec_tog & ~AN[2]) : AN[2];

    assign alarm = (switch_deb && ({h3, h2, h1, h0} == {a3, a2, a1, a0})) ? 1 : 0;

    assign mode0 = clock_alarm;
    assign mode1 = ~clock_alarm;

endmodule