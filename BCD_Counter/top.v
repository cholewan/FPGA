module top(
    input Clk, Rst, Btn, 
    output [7:0] HEX0, HEX1, HEX2, HEX3
);

    BcdCounter BC(
        .Clk(Clk), 
        .Rst(Rst), 
        .Btn(Btn),
        .HEX0(HEX0), 
        .HEX1(HEX1), 
        .HEX2(HEX2), 
        .HEX3(HEX3)
    );
    
endmodule
