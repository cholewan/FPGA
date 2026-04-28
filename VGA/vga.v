module vga(
    input clk, reset_n,
    output reg [3:0] vga_r, vga_g, vga_b,
    output reg vga_hs, vga_vs
);

    localparam HS_MAX = 799;
    localparam VS_MAX = 524;

    // Counters
    reg [9:0] hs_counter;
    reg [9:0] vs_counter;

    // States
    localparam S_PULSE       = 2'b00; 
    localparam S_BACK_PORCH  = 2'b01;  
    localparam S_DATA        = 2'b10;  
    localparam S_FRONT_PORCH = 2'b11;  


    // Hs, Vs Counter
    always @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            hs_counter <= 0;
            vs_counter <= 0;
        end else begin
            if (hs_counter == HS_MAX) hs_counter <= 0;
            else hs_counter <= hs_counter + 1'b1;

            if (hs_counter == HS_MAX - 1) begin
                if (vs_counter == VS_MAX) vs_counter <= 0;
                else vs_counter <= vs_counter + 1'b1;
            end
        end
    end

    // --- HS PART ---
    // State maschine
    reg [1:0] hs_current_state;
    reg [1:0] hs_next_state;

    // Sequential Always Block
    always @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            hs_current_state <= S_PULSE;
        end else begin
            hs_current_state <= hs_next_state;
        end
    end

    // Combitinational Always Block to update next state value
    always @(*) begin
        if      (hs_counter >= 95  && hs_counter < 143)  hs_next_state = S_BACK_PORCH;
        else if (hs_counter >= 143 && hs_counter < 783)  hs_next_state = S_DATA;
        else if (hs_counter >= 783 && hs_counter < 799)  hs_next_state = S_FRONT_PORCH;
        else if (hs_counter == 799)                      hs_next_state = S_PULSE; 
        else                                             hs_next_state = S_PULSE; 
    end

    // State Machine out
    always @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            vga_hs <= 1'b0;
        end else begin
            if (hs_next_state == S_PULSE) vga_hs <= 1'b0;
            else vga_hs <= 1'b1;
        end
    end


    // --- VS PART ---
    // States
    reg [1:0] vs_current_state;
    reg [1:0] vs_next_state;

    // Seqential always block
    always @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            vs_current_state <= S_BACK_PORCH;
        end else begin
            // if resove every problem that i had with VS states
            if (hs_counter == HS_MAX) vs_current_state <= vs_next_state; 
        end
    end

    // Combitinational logic
    always @(*) begin 
        // here i use real nuber and not "number - 1" like in hs because in hs it is incremented on every clk cycle where here i increment every 800 clk cycle and vs_counter is alredy - 1 compare to hs counter (look at counter block if (hs_counter == HS_MAX - 1))
        if      (vs_counter >= 2   && vs_counter < 35)   vs_next_state = S_BACK_PORCH;
        else if (vs_counter >= 35  && vs_counter < 515)  vs_next_state = S_DATA;
        else if (vs_counter >= 515 && vs_counter < 525)  vs_next_state = S_FRONT_PORCH;
        else if (vs_counter == 0)                        vs_next_state = S_PULSE; 
        else                                             vs_next_state = S_PULSE; 
    end

    // State Machine out
    always @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            vga_vs <= 1'b0;
        end else begin
            if (vs_next_state == S_PULSE) vga_vs <= 1'b0;
            else vga_vs <= 1'b1;
        end
    end


    // Display colors
    reg [9:0] color_counter;
    always @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            vga_r <= 4'b0000;
            vga_g <= 4'b0000;
            vga_b <= 4'b0000;
            color_counter <= 0;
        end else begin
            if (vs_next_state == S_DATA && hs_next_state == S_DATA) begin
                if (color_counter == 639) color_counter <= 0;
                else color_counter <= color_counter + 1'b1;

                case (color_counter)
                    10'd0: begin vga_r <= 4'b1111; vga_g <= 4'b0000; vga_b <= 4'b0000; end
                    10'd160: begin vga_r <= 4'b0000; vga_g <= 4'b1111; vga_b <= 4'b0000; end
                    10'd320: begin vga_r <= 4'b0000; vga_g <= 4'b0000; vga_b <= 4'b1111; end
                    10'd480: begin vga_r <= 4'b1111; vga_g <= 4'b0000; vga_b <= 4'b1111; end
                    default: begin vga_r <= vga_r; vga_g <= vga_g; vga_b <= vga_b; end
                endcase
            end else begin
                vga_r <= 4'b0000;
                vga_g <= 4'b0000;
                vga_b <= 4'b0000;
            end
        end
    end

endmodule