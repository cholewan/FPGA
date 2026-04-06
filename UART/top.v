module top(
    input Clk, Rst, Btn,
    input [7:0] Data,
    output UartTx
);

    wire Switch;
    reg UartSendByte;

    always @(posedge Clk, negedge Rst) begin
        if (!Rst) begin
            UartSendByte <= 1'b0;
        end
        else if (Switch) 
            UartSendByte <= 1'b1;
        else if (!Switch)
            UartSendByte <= 1'b0;
    end

    UartTransmitByte #(
        .CLK_FREQENCY(50_000_000),
        .UART_BAUD_RATE(115_200)
    ) TX(
        .Clk(Clk),
        .Rst(Rst),
        .UartSendByte(UartSendByte),
        .Data(Data),
        .UartTx(UartTx)
    );

    ButtonDebouncer BD(
        .Clk(Clk),
        .Rst(Rst),
        .Btn(Btn),
        .Strobe(Switch)
    );

endmodule
