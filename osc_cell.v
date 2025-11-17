`timescale  1ns/1ps

module osc_cell(
    //T = 0, I1 = 0, I2 = 0 =>  RST
    //T = 0, I1 = 1, I2 =0 =>  OSC
    //I1 = 1 -> start

    input wire T, //Trigger alow osc
    input wire I1, //Input 1 allow osc
    input wire I2, //Input 2 allow osc

    output wire OSC //Oscillator output
);
    //internal wire
    wire w1;
    wire w2;
    wire w3;
    //prevent synthesys tool break loop
    (* KEEP = "TRUE", DONT_TOUCH = "TRUE" *)
    assign Osc = w2 & w3;

    assign w1 = Osc & T; //AND
    assign w2 = I1 ^ w1; //XOR
    assign w3 = T ^ I2; //XOR

endmodule