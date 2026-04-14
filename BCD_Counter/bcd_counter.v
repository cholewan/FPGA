module BcdCounter(
    input Clk, Rst, Btn,
    output [7:0] HEX0, HEX1, HEX2, HEX3
);

    wire Up;
    reg [3:0] Dig0;
    reg [3:0] Dig1;
    reg [3:0] Dig2;
    reg [3:0] Dig3;

    always @(posedge Clk, negedge Rst) begin
        if (!Rst) begin
            Dig0 <= 4'h08;
            Dig1 <= 4'h08;
            Dig2 <= 4'h09;
            Dig3 <= 4'h09;
        end
        else if (Up) begin  
            if (Dig0 == 4'h09) begin
                Dig0 <= 4'h00;    
                if (Dig1 == 4'h09) begin
                    Dig1 <= 4'h00;
                    if(Dig2 == 4'h09) begin
                        Dig2 <= 4'h00;
                        if (Dig3 == 4'h09) begin
                            Dig3 <= 4'h00;
                        end else
                            Dig3 <= Dig3 + 1'b1;
                    end else
                        Dig2 <= Dig2 + 1'b1;
                end else
                    Dig1 <= Dig1 + 1'b1;
            end else
                Dig0 <= Dig0 + 1'b1;
        end
    end

    ButtonDebouncer BD(
        .Clk(Clk),
        .Rst(Rst),
        .Btn(Btn),
        .Strobe(Up)
    );

    Seg7Decoder D0(
        .Digit(Dig0),
        .Segments(HEX0)
    );
    Seg7Decoder D1(
        .Digit(Dig1),
        .Segments(HEX1)
    );
    Seg7Decoder D2(
        .Digit(Dig2),
        .Segments(HEX2)
    );
    Seg7Decoder D3(
        .Digit(Dig3),
        .Segments(HEX3)
    );

endmodule 
