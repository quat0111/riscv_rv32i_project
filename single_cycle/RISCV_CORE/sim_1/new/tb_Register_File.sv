`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2024 11:16:07 PM
// Design Name: 
// Module Name: tb_Register_File
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_Register_File();
	reg clk, rst, RegWEn;
	reg [4:0] rsR1, rsR2, rsW;
	reg [31:0] dataW;
	// Outputs
	wire [31:0] dataR1, dataR2; 

	// Instantiate the Unit Under Test (UUT)
	Register_File REG_FILE (
		.clk(clk), 
		.rst(rst), 
		.RegWEn(RegWEn), 
		.rsR1(rsR1), 
		.rsR2(rsR2), 
		.rsW(rsW), 
		.dataW(dataW), 
		.dataR1(dataR1), 
		.dataR2(dataR2)
	);

    initial begin
        clk = 1;
        forever #10 clk = ~clk; 
    end

    initial begin
        rst = 1; 
        #40;
        rst = 0;
        rsR1 = 5'd3; rsR2 = 5'd3; rsW = 5'd0;
        dataW = 32'hBABABABA;
        RegWEn = 0; 
        #40;        
        rsW = 5'd3;
        #40;
        RegWEn = 1;
        #40;  
        rsR1 = 5'd4; rsR2 = 5'd5;
        #40;
        rsW = 5'd4;#20;
        rsW = 5'd5;#20;
        rsR1 = 5'd0;#40;
        rsW = 5'd0;#20;
#50;
$finish;
  
    end
        
endmodule
