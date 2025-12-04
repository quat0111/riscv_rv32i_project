module Immediate_Generator(
    input logic [31:0] Instr,
    input logic  [2:0]  ImmSel,  
    output logic [31:0] Imm
    );

    assign Imm =     (ImmSel == 3'b000) ? {{20{Instr[31]}}, Instr[31:20]} :                                          // I-type
                     (ImmSel == 3'b001) ? {{20{Instr[31]}}, Instr[31:25], Instr[11:7]} :                             // S-type (SB, SH, SW)
                     (ImmSel == 3'b010) ? {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0} :  // B-type
                     (ImmSel == 3'b011) ? {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0} :           // J-type (JAL)
                     (ImmSel == 3'b100) ? {Instr[31:12], 12'b0} :                                                    // U-type (LUI, AUIPC)
                                          32'b0;                                                                     // default
endmodule
