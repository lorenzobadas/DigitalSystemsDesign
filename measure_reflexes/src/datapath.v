`timescale 1ns / 1ps

module datapath(
    input ck, reset,
    input enable, clear_ms_enable, clear_count_ms, write_enable, load_wait, dec_wait, inc_errors, load_rand, clear_5s,
    output zero, hit_5s, end_wait, one_ms, new,
    output [3:0] cnt0, cnt1, cnt2, cnt3, rec0, rec1, rec2, rec3
);
    wire [5:0] new_value;
    count6bit u0(ck, reset, new_value);
    dec_count u1(ck, reset, load_rand, new_value, zero);
    ms_enable u2(ck, reset, clear_ms_enable, one_ms);
    count_ms u3(ck, reset, clear_count_ms, enable, cnt0, cnt1, cnt2, cnt3);
    memory u4(ck, reset, write_enable, cnt0, cnt1, cnt2, cnt3, rec0, rec1, rec2, rec3);
    compare u5(cnt0, cnt1, cnt2, cnt3, rec0, rec1, rec2, rec3, new);
    count_5s u6(ck, reset, clear_5s, hit_5s);
    
    wire [1:0] error_count;
    count_errors u7(ck, reset, inc_errors, error_count);
    wait_count u8(ck, load_wait, dec_wait, error_count, end_wait);
    
endmodule
