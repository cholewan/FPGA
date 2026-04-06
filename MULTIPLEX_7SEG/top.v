module top(
    input Clk, Rst,
    input [7:0] Number,
    output [3:0] Digit,
    output [7:0] Segments
);

MultiplexDisplay #(
    .CLK_FREQENCY(50_000_000),
    .SINGLE_DIG_FREQENCY(200)
) MX(
    .Clk(Clk), 
    .Rst(Rst),
    .Number(Number),
    .Digit(Digit),
    .Segments(Segments)
);

endmodule
