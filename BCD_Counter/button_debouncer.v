module ButtonDebouncer(
    input Clk, Btn, Rst,
    output reg Strobe
);

    reg [7:0] Sipo;
    wire Enable;

    always @(posedge Clk, negedge Rst) begin
        if (!Rst) begin
            Sipo <= 8'h00;
            Strobe <= 1'b0;
        end 
        else begin
            Strobe <= 1'b0;
            if (Enable) begin
                if (!Btn) Sipo <= {Sipo [6:0], 1'b1};
                else Sipo <= {Sipo [6:0], 1'b0};

                if (Sipo == 8'h7f) Strobe <= 1'b1;
            end
        end
    end

    EnableGenerator #(
        .DIVIDER(100_000) // (1/(50e6/100e3))*8=16ms, 50e6 is Clk 50MHz, 100e3 is DIVIDER, 8 is SIPO
    ) EG(
        .Clk(Clk),
        .Rst(Rst),
        .Strobe(Enable),
		.Enable(1'b1)
    );

endmodule