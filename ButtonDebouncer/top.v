module top(
    input Clk, Rst, Btn,
    output reg LED
);

    wire Switch;

    always @(posedge Clk, negedge Rst) begin
        if (!Rst) begin
            LED <= 1'b0;
        end
        else if (Switch) begin
            LED <= ~LED;
        end
    end

    ButtonDebouncer BD(
        .Clk(Clk),
        .Rst(Rst),
        .Btn(Btn),
        .Strobe(Switch)
    );

endmodule
