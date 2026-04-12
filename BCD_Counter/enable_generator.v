module EnableGenerator #(
    parameter DIVIDER = 100_000
)(
    input Clk, Rst, Enable,
    output reg Strobe
);

    reg [$clog2(DIVIDER)-1:0] Counter;

    always @(posedge Clk, negedge Rst) begin
        if (!Rst) begin
           Strobe <= 1'b0;
           Counter <= 0; 
        end
        else if (Enable) begin
            Strobe <= 0;
            if (Counter == (DIVIDER-1)) begin
                Strobe <= 1'b1;
                Counter <= 0;
            end
            else 
                Counter <= Counter + 1'b1;
        end
        else begin
            Strobe <= 0;
            Counter <= 0;
        end
    end

endmodule