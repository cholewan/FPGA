module MultiplexDisplay #(
    parameter CLK_FREQENCY = 10_000_000,
    parameter SINGLE_DIG_FREQENCY = 200
)(
    input Clk, Rst,
    input [7:0] Number,
    output reg [3:0] Digit,
    output [7:0] Segments
);

    localparam DISP_AMOUNT = 4;
    localparam DIVIDER_FREQ = CLK_FREQENCY / (SINGLE_DIG_FREQENCY * DISP_AMOUNT);
    wire Strobe;
    reg [1:0] DigitCounter;
	 
	reg [3:0] dig0;
    reg [3:0] dig1;
    reg [3:0] dig2;
    reg [3:0] dig3;
    reg [3:0] CurrentDig;

    always @(posedge Clk, negedge Rst) begin
        if (!Rst) begin
            DigitCounter <= 0;
        end
        else if (Strobe) begin
            if (DigitCounter == DISP_AMOUNT-1)
                DigitCounter <= 0;
            else 
                DigitCounter <= DigitCounter + 1'b1;
        end
    end

    always @(*) begin
        dig0 = Number % 10;
        dig1 = (Number / 10) % 10;
        dig2 = (Number / 100) % 10;
        dig3 = (Number / 1000) % 10;
			
        case (DigitCounter)
            2'h0: begin Digit = 4'b1110; CurrentDig = dig0; end
            2'h1: begin Digit = 4'b1101; CurrentDig = dig1; end
            2'h2: begin Digit = 4'b1011; CurrentDig = dig2; end
            2'h3: begin Digit = 4'b0111; CurrentDig = dig3; end
            default: Digit = 4'b1110;
        endcase
    end

    EnableGenerator #(
        .DIVIDER(DIVIDER_FREQ)
    ) EG(
        .Clk(Clk),
        .Rst(Rst), 
        .Enable(1'b1),
        .Strobe(Strobe)
    );

    Seg7Decoder S7(
        .Digit(CurrentDig),
        .Segments(Segments)
    );

endmodule