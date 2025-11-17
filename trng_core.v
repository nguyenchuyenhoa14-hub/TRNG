`timescale 1ns/1ps  

module trng_core(
    input wire clk,
    input wire rst,
    input wire enable,

    output wire random_bit
);
    //signal wire OSC and RG
    wire [3:0] osc_out_signals;

    //signal controll osc_cell
    wire i1_signal = 1'b1;
    wire i2_signal = 1'b0;

    //use enable signal to initative, T = enable = 0 -> reset, enable =1 -> T = 1
    wire t_signal = enable;

    osc_cell u_osc_0 (
        .T(t_signal),
        .I1(i1_signal),
        .I2(i2_signal),
        .OSC(osc_out_signals[0])
    );

    osc_cell u_osc_1 (
        .T(t_signal),
        .I1(i1_signal),
        .I2(i2_signal),
        .OSC(osc_out_signals[1])
    );

    osc_cell u_osc_2 (
        .T(t_signal),
        .I1(i1_signal),
        .I2(i2_signal),
        .OSC(osc_out_signals[2])
    );

    osc_cell u_osc_3 (
        .T(t_signal),
        .I1(i1_signal),
        .I2(i2_signal),
        .OSC(osc_out_signals[3])
    );
    
    ring_generator u_ring_gen (
        .clk(clk),
        .rst(rst),
        .osc_in(osc_out_signals),
        .bit_out(random_bit)
    );
    
endmodule