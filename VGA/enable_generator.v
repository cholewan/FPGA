module enableGenerator #(
    parameter DIVIDER = 100_000
)(
    input clk, reset_n, enable,
    output reg strobe
);

    reg [$clog2(DIVIDER)-1:0] counter;

    always @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
           strobe <= 1'b0;
           counter <= 0; 
        end else if (enable) begin
            strobe <= 0;
            if (counter == (DIVIDER-1)) begin
                strobe <= 1'b1;
                counter <= 0;
            end else 
                counter <= counter + 1'b1;
        end else begin
            strobe <= 0;
            counter <= 0;
        end
    end

endmodule