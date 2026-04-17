module FrequencyCounter(
    input Clk, Rst, D_in,
    output [7:0] HEX0, HEX1, HEX2, HEX3,
    output reg LED_KHz, LED_Overflow
);

    reg [3:0] Dig0; // 1
    reg [3:0] Dig1; // 10
    reg [3:0] Dig2; // 100
    reg [3:0] Dig3; // 1 000
    reg [3:0] Dig4; // 10 000
    reg [3:0] Dig5; // 100 000

    reg [3:0] Dig0Latch;
    reg [3:0] Dig1Latch;
    reg [3:0] Dig2Latch;
    reg [3:0] Dig3Latch;

    reg PrevD_in;
    wire Latch;
    reg KHz_Enabled;
    reg Overflow; // if freqency is >= 1 MHz

    wire Carry0 = (Dig0 == 4'h09);
    wire Carry1 = (Carry0 && Dig1 == 4'h09);
    wire Carry2 = (Carry1 && Dig2 == 4'h09);
    wire Carry3 = (Carry2 && Dig3 == 4'h09);
    wire Carry4 = (Carry3 && Dig4 == 4'h09);
    wire Carry5 = (Carry4 && Dig5 == 4'h09);

    always @(posedge Clk, negedge Rst) begin
        if (!Rst) begin
            KHz_Enabled <= 1'b0;
            Dig0 <= 4'h00;
            Dig1 <= 4'h00;
            Dig2 <= 4'h00;
            Dig3 <= 4'h00;
            Dig4 <= 4'h00;
            Dig5 <= 4'h00;
            Dig0Latch <= 4'h00;
            Dig1Latch <= 4'h00;
            Dig2Latch <= 4'h00;
            Dig3Latch <= 4'h00;
            Overflow <= 1'b0;
            LED_Overflow <= 1'b0;
        end
        else begin
            PrevD_in <= D_in;
            if (Latch) begin    // Display freqency every 1s
                Overflow <= 1'b0;
                if (!KHz_Enabled) begin
                    LED_KHz <= 1'b0;
                    Dig0Latch <= Dig0;
                    Dig1Latch <= Dig1;
                    Dig2Latch <= Dig2;
                    Dig3Latch <= Dig3;
                end 
                else if (Overflow) begin
                    LED_Overflow <= 1'b1;
                    Dig0Latch <= 4'h00; 
                    Dig1Latch <= 4'h00; 
                    Dig2Latch <= 4'h00; 
                    Dig3Latch <= 4'h00; 
                end
                else begin
                    LED_Overflow <= 1'b0;
                    LED_KHz <= 1'b1;
                    Dig0Latch <= Dig3;
                    Dig1Latch <= Dig4;
                    Dig2Latch <= Dig5;
                    Dig3Latch <= 4'h00; 
                end
                Dig0 <= 4'h00;
                Dig1 <= 4'h00;
                Dig2 <= 4'h00;
                Dig3 <= 4'h00;
                Dig4 <= 4'h00;
                Dig5 <= 4'h00;
            end
            if (PrevD_in == 1'b0 && D_in == 1'b1) begin  // BCD counter
                Dig0 <= Carry0 ? 4'h00 : Dig0 + 1'b1;
                if (Carry0) Dig1 <= (Dig1 == 4'h09) ? 4'h00 : Dig1 + 1'b1;
                if (Carry1) Dig2 <= (Dig2 == 4'h09) ? 4'h00 : Dig2 + 1'b1;
                if (Carry2) begin
                    if (Dig3 == 4'h09) begin
                        Dig3 <= 4'h00;
                        KHz_Enabled <= 1'b1;    // >= 1 KHz
                    end
                    else begin
                        Dig3 <= Dig3 + 1'b1;     
                    end
                end
                if (Carry3) Dig4 <= (Dig4 == 4'h09) ? 4'h00 : Dig4 + 1'b1;
                if (Carry4) begin
                    if (Dig5 == 4'h09) begin
                        Overflow <=1'b1;    // >= 1 MHz
                    end
                    else begin
                        Dig5 <= Dig5 + 1'b1;
                    end
                end
            end
            if (Dig3 < 4'h09 && Dig4 == 4'h00 && Dig5 == 4'h00) KHz_Enabled <= 1'b0;  // KHz
        end
    end

    EnableGenerator #(
        .DIVIDER(50_000_000) // 1 sek
    ) EG(
        .Clk(Clk),
        .Rst(Rst),
        .Strobe(Latch),
		.Enable(1'b1)
    );

    Seg7Decoder D0(
        .Digit(Dig0Latch),
        .Segments(HEX0)
    );
    Seg7Decoder D1(
        .Digit(Dig1Latch),
        .Segments(HEX1)
    );
    Seg7Decoder D2(
        .Digit(Dig2Latch),
        .Segments(HEX2)
    );
    Seg7Decoder D3(
        .Digit(Dig3Latch),
        .Segments(HEX3)
    );

endmodule 