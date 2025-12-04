
module RISCV_Top_DE2115 (
    input  wire CLOCK_50,
    input  wire KEY,
    output wire [17:0] LEDR
);
    wire clk = CLOCK_50;
    wire rst = ~KEY;
	 logic [25:0] clk_div;
	 
		always_ff @(posedge CLOCK_50 or posedge rst) begin
			 if (rst) clk_div <= 0;
			 else     clk_div <= clk_div + 1;
		end
		
		wire slow_clk = clk_div[5];  // khoảng ~1Hz

		CPU CPU (
			 .clk(slow_clk),
			 .rst(rst),
			 .LED_out(LEDR)
		);

    //assign LEDR = cpu_inst.dmem.LEDR;  // kết nối LED thật
endmodule
