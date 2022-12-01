`timescale 1ns / 1ps

module cnt_8(
    input ck, reset,
    output reg [2:0] sel
    );
    reg [2:0] cnt_next;
    
    // rete combinatoria che aumenta il count next di 1
    always @(sel) begin
        cnt_next = sel + 1;
    end
    
    // aggiornamento valore all'edge di clock o di reset
    always @(posedge ck, posedge reset) begin
        if (reset) sel <= 0;
        else if (ck) sel <= cnt_next;
    end   
    
endmodule


module mux_4(
    input [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7,
    input [2:0] sel,
    output reg [3:0] in_seg
    );
    
    always @(seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, sel) begin
        case (sel)
            4'h0: in_seg = seg0;
            4'h1: in_seg = seg1;
            4'h2: in_seg = seg2;
            4'h3: in_seg = seg3;
            4'h4: in_seg = seg4;
            4'h5: in_seg = seg5;
            4'h6: in_seg = seg6;
            4'h7: in_seg = seg7;
            default: in_seg = 8'h0;
        endcase 
    end
    
endmodule

module dec3_8(
    input [2:0] sel,
    output reg an0, an1, an2, an3, an4, an5, an6, an7
    );
    
    always @(sel) begin
        case (sel)
         3'h0: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b10000000;
         3'h1: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b01000000;
         3'h2: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b00100000;
         3'h3: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b00010000;
         3'h4: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b00001000;
         3'h5: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b00000100;
         3'h6: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b00000010;
         3'h7: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b00000001;
         default: {an0, an1, an2, an3, an4, an5, an6, an7} = ~8'b00000000;
        endcase
    end
    
endmodule

module seven_segments(
    input [3:0] in_seg,
    output reg CA, CB, CC, CD, CE, CF, CG
    );
    
    always @(in_seg) begin
        case (in_seg)
            4'h0: {CA, CB, CC, CD, CE, CF, CG} = 7'b0000001;
            4'h1: {CA, CB, CC, CD, CE, CF, CG} = 7'b1001111;
            4'h2: {CA, CB, CC, CD, CE, CF, CG} = 7'b0010010;
            4'h3: {CA, CB, CC, CD, CE, CF, CG} = 7'b0000110;
            4'h4: {CA, CB, CC, CD, CE, CF, CG} = 7'b1001100;
            4'h5: {CA, CB, CC, CD, CE, CF, CG} = 7'b0100100;
            4'h6: {CA, CB, CC, CD, CE, CF, CG} = 7'b0100000;
            4'h7: {CA, CB, CC, CD, CE, CF, CG} = 7'b0001111;
            4'h8: {CA, CB, CC, CD, CE, CF, CG} = 7'b0000000;
            4'h9: {CA, CB, CC, CD, CE, CF, CG} = 7'b0000100;
            4'hA: {CA, CB, CC, CD, CE, CF, CG} = 7'b0001000;
            4'hB: {CA, CB, CC, CD, CE, CF, CG} = 7'b1100000;
            4'hC: {CA, CB, CC, CD, CE, CF, CG} = 7'b0110001;
            4'hD: {CA, CB, CC, CD, CE, CF, CG} = 7'b1000010;
            4'hE: {CA, CB, CC, CD, CE, CF, CG} = 7'b0110000;
            4'hF: {CA, CB, CC, CD, CE, CF, CG} = 7'b0111000;
            default: {CA, CB, CC, CD, CE, CF, CG} = 7'b1111111;
        endcase
    end

endmodule

module genen(
    input ck, reset,
    output en
    );
    
    reg [26:0] cnt, cnt_next;
    parameter [26:0] max_cnt = 27'd99_999;
    
    always @(cnt) begin
        if (cnt == max_cnt) cnt_next = 0;
        else cnt_next = cnt + 1;
    end
    
    always @(posedge ck, posedge reset) begin
        if (reset) cnt <= 0;
        else if (ck) cnt <= cnt_next;
    end
    
    assign en = (cnt == max_cnt) ? 1 : 0;
    
endmodule

module eight_display(
    input ck, reset,
    input [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7,
    output CA, CB, CC, CD, CE, CF, CG,
    output AN0, AN1, AN2, AN3, AN4, AN5, AN6, AN7
    );
    wire en;
    wire [3:0] in_seg;
    wire [2:0] sel;
    
    // ricorda che il tasto reset sulla scheda è 1 a riposo e 0 quando premuto, per questo
    // lo passo negato ai moduli
    genen u0(ck, ~reset, en);
    cnt_8 u1(en, ~reset, sel);
    mux_4 u2(seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, sel, in_seg);
    dec3_8 u3(sel, AN0, AN1, AN2, AN3, AN4, AN5, AN6, AN7);
    seven_segments u4(in_seg, CA, CB, CC, CD, CE, CF, CG);
    
endmodule

module cnt(
    input ck, en, clr,
    output hit
    );
    parameter [1:0] MAX_COUNT = 2'h3;
    reg [1:0] count, count_next;
    always @(posedge ck) begin
        count <= count_next; 
    end
    
    always @(count, en, clr) begin
        if (clr) count_next = 0;
        else if (en) begin
            if (count == MAX_COUNT) count_next = 0;
            else count_next = count + 1;
        end
        else count_next = count;
    end
    
    assign hit = count == MAX_COUNT ? 1 : 0;
endmodule

module cnt7(
    input ck, en7, clr,
    output hit7
    );
    parameter [2:0] MAX_COUNT = 3'h7;
    reg [2:0] count, count_next;
    always @(posedge ck) begin
        count <= count_next; 
    end
    
    always @(count, en7, clr) begin
        if (clr) count_next = 0;
        else if (en7) begin
            if (count == MAX_COUNT) count_next = 0;
            else count_next = count + 1;
        end
        else count_next = count;
    end
    
    assign hit7 = count == MAX_COUNT ? 1 : 0;
endmodule

module cnt15(
    input ck, en15, clr,
    output hit15
    );
    parameter [3:0] MAX_COUNT = 4'd15;
    reg [3:0] count, count_next;
    always @(posedge ck) begin
        count <= count_next; 
    end
    
    always @(count, en15, clr) begin
        if (clr) count_next = 0;
        else if (en15) begin
            if (count == MAX_COUNT) count_next = 0;
            else count_next = count + 1;
        end
        else count_next = count;
    end
    
    assign hit15 = count == MAX_COUNT ? 1 : 0;
endmodule

module instr(
    input ck, load_instr, sh_instr,
    input [7:0] reg_name,
    output mosi
    );
    reg [15:0] instr_buffer, instr_buffer_next;
    
    always @(posedge ck) begin
        instr_buffer <= instr_buffer_next;
    end
    
    always @(instr_buffer, load_instr, sh_instr, reg_name) begin
        if (load_instr) instr_buffer_next = {8'h0b, reg_name};
        else if (sh_instr) instr_buffer_next = {instr_buffer[14:0], 1'bx};
        else instr_buffer_next = instr_buffer;
    end
    
    assign mosi = instr_buffer[15];
    
endmodule

module data(
    input ck, sh_data, miso,
    output reg [7:0] data_out
    );
    reg [7:0] data_out_next;
    always @(posedge ck) begin
        data_out <= data_out_next;
    end
    
    always @(data_out, sh_data, miso) begin
        if (sh_data) data_out_next = {data_out[6:0], miso};
        else data_out_next = data_out;
    end
        
endmodule

module control_readreg(
    input ck, start, hit, hit7, hit15,
    output ready, sclk, nCS, load_instr, sh_instr, sh_data, clr, en, clr7, en7, clr15, en15
    );
    parameter [3:0] 
        IDLE = 0, 
        WAIT_CSS = 1, 
        LAST_CSS = 2,
        SCLK0 = 3,
        LAST0 = 4,
        SCLK1 = 5,
        LAST1 = 6,
        READ0 = 7,
        LASTR0 = 8,
        READ1 = 9,
        LASTR1 = 10,
        OK = 11,
        WAIT_CS1 = 12;
    reg [3:0] state, state_next;
    reg [11:0] uscita;
    // state transition
    always @(posedge ck) begin
        state <= state_next;
    end
    
    // calc next state
    always @(state, start, hit, hit7, hit15) begin
        case (state)
            IDLE: begin
                casex ({start, hit, hit7, hit15})
                    4'b1xxx: state_next = WAIT_CSS;
                    default: state_next = IDLE;
                endcase
            end
            WAIT_CSS: begin
                casex ({start, hit, hit7, hit15})
                    4'bx1xx: state_next = LAST_CSS;
                    default: state_next = WAIT_CSS;
                endcase
            end
            LAST_CSS: begin
                state_next = SCLK0;
            end
            SCLK0: begin
                casex ({start, hit, hit7, hit15})
                    4'bx1xx: state_next = LAST0;
                    default: state_next = SCLK0;
                endcase
            end
            LAST0: begin
                state_next = SCLK1;
            end
            SCLK1: begin
                casex ({start, hit, hit7, hit15})
                    4'bx1xx: state_next = LAST1;
                    default: state_next = SCLK1;
                endcase
            end
            LAST1: begin
                casex ({start, hit, hit7, hit15})
                    4'bxxx1: state_next = READ0; // finished sending bits
                    default: state_next = SCLK0; // send next bit
                endcase
            end
            READ0: begin
                casex ({start, hit, hit7, hit15})
                    4'bx1xx: state_next = LASTR0;
                    default: state_next = READ0;
                endcase
            end
            LASTR0: begin
                state_next = READ1;
            end
            READ1: begin
                casex ({start, hit, hit7, hit15})
                    4'bx1xx: state_next = LASTR1;
                    default: state_next = READ1;
                endcase
            end
            LASTR1: begin
                casex ({start, hit, hit7, hit15})
                    4'bxx1x: state_next = OK; // finished interaction
                    default state_next = READ0; // read next bit
                endcase
            end
            OK: begin
                state_next = WAIT_CS1;
            end
            WAIT_CS1: begin
                state_next = IDLE;
            end
            default: begin
                state_next = IDLE;
            end
        endcase
    end
    
    // output logic
    always @(state) begin
        case (state)
            IDLE:       uscita = 12'b001_100_1x_xx_xx;
            WAIT_CSS:   uscita = 12'b000_000_01_xx_xx;
            LAST_CSS:   uscita = 12'b000_000_1x_xx_1x;
            SCLK0:      uscita = 12'b000_000_01_xx_00;
            LAST0:      uscita = 12'b000_000_1x_xx_00;
            SCLK1:      uscita = 12'b010_000_01_xx_00;
            LAST1:      uscita = 12'b010_010_1x_1x_01;
            READ0:      uscita = 12'b000_000_01_00_xx;
            LASTR0:     uscita = 12'b000_001_1x_00_xx;
            READ1:      uscita = 12'b010_000_01_00_xx;
            LASTR1:     uscita = 12'b010_000_1x_01_xx;
            OK:         uscita = 12'b100_000_xx_xx_xx;
            WAIT_CS1:   uscita = 12'b000_000_xx_xx_xx;
            default:    uscita = 12'b000_000_xx_xx_xx;
        endcase
    end
    
    assign {ready, sclk, nCS, load_instr, sh_instr, sh_data, clr, en, clr7, en7, clr15, en15} = uscita;
    
endmodule

module read_reg(
    input ck, start, miso,
    input [7:0] reg_name,
    output [7:0] data_out,
    output ready, nCS, sclk, mosi
    );
    
    wire load_instr, sh_instr, sh_data, clr, en, hit, clr7, en7, hit7, clr15, en15, hit15;
    
    control_readreg u0(ck, start, hit, hit7, hit15, ready, sclk, nCS, load_instr, sh_instr, sh_data, clr, en, clr7, en7, clr15, en15);
    instr u1(ck, load_instr, sh_instr, reg_name, mosi);
    data u2(ck, sh_data, miso, data_out);
    cnt u3(ck, en, clr, hit);
    cnt7 u4(ck, en7, clr7, hit7);
    cnt15 u5(ck, en15, clr15, hit15);
    
endmodule

module control(
    input ck, read, ready,
    output start, ld0, ld1, ld2, ld3,
    output [7:0] reg_name
    );
    
    parameter [3:0]
        WAIT = 0,
        R0 = 1,
        W0 = 2,
        R1 = 3,
        W1 = 4,
        R2 = 5,
        W2 = 6,
        R3 = 7,
        W3 = 8;
    reg [3:0] state, state_next;
    
    parameter [7:0] 
        REG0 = 8'h8,
        REG1 = 8'h9,
        REG2 = 8'ha,
        REG3 = 8'h0;
    reg [12:0] outputs;
    
    // state transition
    always @(posedge ck) begin
        state <= state_next;
    end
    
    // next state logic
    always @(state, read, ready) begin
        case (state)
            WAIT: begin
                if (read) state_next = R0;
                else state_next = WAIT;
            end
            R0: begin
                if (ready) state_next = W0;
                else state_next = R0;
            end
            W0: state_next = R1;
            R1: begin
                if (ready) state_next = W1;
                else state_next = R1;
            end
            W1: state_next = R2;
            R2: begin
                if (ready) state_next = W2;
                else state_next = R2;
            end
            W2: state_next = R3;
            R3: begin
                if (ready) state_next = W3;
                else state_next = R3;
            end
            W3: state_next = WAIT;
            default: state_next = WAIT;
        endcase
    end
    
    // output logic
    always @(state) begin
        case (state)
            WAIT: outputs = {8'bxxxxxxxx, 5'b00000};
            R0: outputs =   {REG0, 5'b10000};
            W0: outputs =   {8'bxxxxxxxx, 5'b01000};
            R1: outputs =   {REG1, 5'b10000};
            W1: outputs =   {8'bxxxxxxxx, 5'b00100};
            R2: outputs =   {REG2, 5'b10000};
            W2: outputs =   {8'bxxxxxxxx, 5'b00010};
            R3: outputs =   {REG3, 5'b10000};
            W3: outputs =   {8'bxxxxxxxx, 5'b00001};
            default: outputs = 13'h0;
        endcase
    end
    
    assign {reg_name, start, ld0, ld1, ld2, ld3} = outputs;    
    
endmodule

module reg_display(
    input ck,
    input [7:0] data_in, 
    input load,
    output [3:0] seg1, seg0
    );
    
    reg [7:0] segments_out, segments_out_next;
    
    // segments transition
    always @(posedge ck) begin
        segments_out <= segments_out_next;
    end
    
    // next segments computing
    always @(segments_out, load, data_in) begin
        if (load) segments_out_next = data_in;
        else segments_out_next = segments_out;
    end
    
    // output logic
    assign {seg1, seg0} = segments_out;
endmodule

module gensec(
    input ck,
    output enable
    );
    
    parameter [26:0] COUNT_MAX = 27'd100000000;
    reg [26:0] count, count_next;
    
    // state transition
    always @(posedge ck) begin
        count <= count_next;
    end
    
    // next count logic
    always @(count) begin
        if (count == COUNT_MAX) count_next = 0;
        else count_next = count + 1;
    end
    
    // output logic
    assign enable = count == COUNT_MAX ? 1 : 0;
    
endmodule

module top(
    input ck, reset, miso,
    output nCS, sclk, mosi, an0, an1, an2, an3, an4, an5, an6, an7, ca, cb, cc, cd, ce, cf, cg
    );
    wire start, ready, ld0, ld1, ld2, ld3, read;
    wire [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7;
    wire [7:0] reg_name, data_out;
    
    gensec gen_read(ck, read);
    control controllo(ck, read, ready, start, ld0, ld1, ld2, ld3, reg_name);
    read_reg read_reg(ck, start, miso, reg_name, data_out, ready, nCS, sclk, mosi);
    reg_display reg0(ck, data_out, ld0, seg1, seg0);
    reg_display reg1(ck, data_out, ld1, seg3, seg2);
    reg_display reg2(ck, data_out, ld2, seg5, seg4);
    reg_display reg3(ck, data_out, ld3, seg7, seg6);
    eight_display display(ck, reset, seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, ca, cb, cc, cd, ce, cf, cg, an0, an1, an2, an3, an4, an5, an6, an7);
endmodule