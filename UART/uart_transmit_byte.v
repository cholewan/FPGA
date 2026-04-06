module UartTransmitByte #(
    parameter CLK_FREQENCY = 10_000_000,  // Hz
    parameter UART_BAUD_RATE = 115_200    // Bits/s 
)(
    input Clk, Rst, UartSendByte,
    input [7:0] Data,
    output reg UartTx
);

    localparam BIT_WIDTH = CLK_FREQENCY / UART_BAUD_RATE;
    reg [3:0] CurrentBit;
    reg IsBusy;
    reg [7:0] DataBuff;
    wire Strobe;

    always @(posedge Clk, negedge Rst) begin
        if (!Rst) begin
            CurrentBit <= 1'b0;
            IsBusy <= 1'b0;
            DataBuff <= 0;
        end
        else if (UartSendByte) begin
            DataBuff <= Data;
            IsBusy <= 1'b1;
            CurrentBit <= CurrentBit + 1'b1;  // START bit
        end
        else if (IsBusy) begin
            if (Strobe)
                if (CurrentBit == 10) begin
                    CurrentBit <= 0;
                    IsBusy <= 0;
                end
                else
                    CurrentBit <= CurrentBit + 1'b1;
        end
    end

    always @(*) begin
        case(CurrentBit)
            4'h00: UartTx = 1'b1;  // No transmission HIGH
            4'h01: UartTx = 1'b0;  // START bit
            4'h02: UartTx = DataBuff[0];
            4'h03: UartTx = DataBuff[1];
            4'h04: UartTx = DataBuff[2];
            4'h05: UartTx = DataBuff[3];
            4'h06: UartTx = DataBuff[4];
            4'h07: UartTx = DataBuff[5];
            4'h08: UartTx = DataBuff[6];
            4'h09: UartTx = DataBuff[7];
            4'h0A: UartTx = 1'b1;  // STOP bit
            default: UartTx = 1'b1;
        endcase
    end

    EnableGenerator #(
        .DIVIDER(BIT_WIDTH)
    )(
        .Clk(Clk), 
        .Rst(Rst), 
        .Enable(IsBusy),
        .Strobe(Strobe)
    );

endmodule