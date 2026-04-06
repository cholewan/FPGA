module Seg7Decoder(
    input [3:0] Digit,
    output reg [7:0] Segments
);

always @(*) begin
    case(Digit)
        4'd0: Segments = 8'hC0;
        4'd1: Segments = 8'hF9;
        4'd2: Segments = 8'hA4;
        4'd3: Segments = 8'hB0;
        4'd4: Segments = 8'h99;
        4'd5: Segments = 8'h92;
        4'd6: Segments = 8'h82;
        4'd7: Segments = 8'hF8;
        4'd8: Segments = 8'h80;
        4'd9: Segments = 8'h90;
        default: Segments = 8'h00;
    endcase
end

endmodule