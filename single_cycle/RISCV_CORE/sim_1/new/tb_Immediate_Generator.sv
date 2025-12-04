`timescale 1ns / 1ps

module tb_Immediate_Generator();
	logic [31:0] Instr;
	logic [2:0] ImmSel;
	logic [31:0] Imm;

	Immediate_Generator imm_gen (.Instr(Instr), 
                               .ImmSel(ImmSel), 
                               .Imm(Imm));

	initial begin
		// Initialize Inputs
        Instr = 32'h00A10093;
        ImmSel = 3'b000;
        #10;
        Instr = 32'h0051a623;
        ImmSel = 3'b001;
        #10; 
        Instr = 32'h00208A63;
        ImmSel = 3'b010;
        #10;
        Instr = 32'h020000EF;
        ImmSel = 3'b011;
        #10;
        Instr = 32'h123452B7;
        ImmSel = 3'b100;
        #10;
        $stop;
	end
      
endmodule
