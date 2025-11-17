`timescale 1ns/1ps

//a reg 16bit in Galois LFSR config, P = x^16 + x^10 + x^7 + x^4 + x^0
module ring_generator (
    input wire clk,
    input wire rst,

    input wire [3:0] osc_in,
    output wire bit_out
);
    //16bit reg, dff[0] is LSB (x^0), dff[15] is MSB (x^15)
    reg [15:0] q_reg;
    //wire for bit feedback
    wire [15:0] q_next;
    wire feedback_bit = q_reg[15];

    //P = x^16 + x^10 + x^7 + x^4 + x^0
    assign q_next[0] = feedback_bit ^ osc_in[3]; //FF0 x^0 & OSC3

    //FF1-3: Shift
    assign q_next[1] = q_reg[0];
    assign q_next[2] = q_reg[1];
    assign q_next[3] = q_reg[2];

    //FF4: Tap x^4
    assign q_next[4] = q_reg[3] ^ feedback_bit;

    //FF 5-6: Shift
    assign q_next[5] = q_reg[4];
    assign q_next[6] = q_reg[5];

    //FF 7: Tap x^7
    assign q_next[7] = q_reg[6] ^ feedback_bit;

    //FF8: Shift
    assign q_next[8] = q_reg[7];

    //FF9: Osc 0
    assign q_next[9] = q_reg[8] ^ osc_in[0];

    //FF10: Tap x^10;
    assign q_next[10] = q_reg[9] ^ feedback_bit;

    //FF11: Osc1
    assign q_next[11] = q_reg[10] ^ osc_in[1];

    assign q_next[12] = q_reg[11];
    assign q_next[13] = q_reg[12];

    assign q_next[14] = q_reg[13] ^ osc_in[2];

    assign q_next[15] = q_reg[14];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q_reg <= 16'h0000;
        end else begin
            q_reg <= q_next;
        end
    end

    //assign output parallel
    assign bit_out = q_reg[15];

endmodule