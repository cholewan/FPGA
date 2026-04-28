module top(
    input clk, reset_n,
    output [3:0] vga_r, vga_g, vga_b,
    output vga_hs, vga_vs
);

    wire pixel_clk;

    vga vg(
    .clk(pixel_clk), 
    .reset_n(reset_n),
    .vga_hs(vga_hs),
    .vga_vs(vga_vs),
    .vga_r(vga_r),
    .vga_g(vga_g),
    .vga_b(vga_b)
    );

    enableGenerator #(
        .DIVIDER(2)
    ) px_clk (
        .clk(clk),
        .reset_n(reset_n),
        .enable(1'b1),
        .strobe(pixel_clk)
    );

endmodule
