`timescale 1ns/1ps

module vga_tb();


// clk
reg clk = 1'b1;
always begin
    #1;
    clk = ~clk;
end

// vars
wire vga_hs;
wire vga_vs;
wire [3:0] vga_r; 
wire [3:0] vga_g;
wire [3:0] vga_b;
reg reset_n;

initial begin
    #1 reset_n = 1'b0;
    #2 reset_n = 1'b1;
    #4000000 $stop;
end

vga DUT(
    .clk(clk), 
    .reset_n(reset_n),
    .vga_hs(vga_hs),
    .vga_vs(vga_vs),
    .vga_r(vga_r),
    .vga_g(vga_g),
    .vga_b(vga_b)
);
endmodule
