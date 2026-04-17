module top(
    input Clk, Rst, D_in,
    output [7:0] HEX0, HEX1, HEX2, HEX3, 
	output LED_KHz, LED_Overflow
);

    // 2-ff synchronizer
    reg D_in_FF1S; always @(posedge Clk) D_in_FF1S <= D_in;
    reg D_in_FF2S; always @(posedge Clk) D_in_FF2S <= D_in_FF1S;

    FrequencyCounter FC(
        .Clk(Clk), 
        .Rst(Rst), 
        .D_in(D_in_FF2S),
        .HEX0(HEX0), 
        .HEX1(HEX1), 
        .HEX2(HEX2), 
        .HEX3(HEX3),
        .LED_KHz(LED_KHz),
        .LED_Overflow(LED_Overflow)
    );
    
endmodule
