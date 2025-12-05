
module RISCV_Top (
    input  logic        CLOCK_50,
    input  logic        KEY,
    output logic [17:0] led
);

    logic [25:0] clk_div;
    logic        clk;
    logic        slow_clk;
    logic        rst_n;
    
    assign clk = CLOCK_50;
    assign rst_n = KEY; 

    // Chia tần số
    always_ff @(posedge CLOCK_50 or negedge rst_n) begin
        if (!rst_n)
            clk_div <= 26'd0;
        else
            clk_div <= clk_div + 1'd1;
    end

    assign slow_clk = clk_div[5]; 

    // Kết nối pipeline CPU
    RV32I_Pipline pipeline (
        .clk (slow_clk),
        .rst_n (rst_n),      
        .led (led)
    );

endmodule

