`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2024 02:55:27 PM
// Design Name: 
// Module Name: tb_Instruction_Memory
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


module tb_Instruction_Memory();
    logic rst;
    logic [31:0] addr;
    logic [31:0] instr;
    
    Instruction_Memory dut (.rst(rst), 
                           .addr(addr), 
                           .instr(instr));

    initial begin
        rst = 1;
        #20;
        rst = 0;
        addr = 32'h00000000; #20;
        addr = 32'h00000004; #20;
        addr = 32'h00000008; #20;
        addr = 32'h0000000C; #20;
        addr = 32'h00000010; #20;
        addr = 32'h00000004; #20;
        addr = 32'h0000000C; #20;
        $stop;
    end   
	
endmodule
