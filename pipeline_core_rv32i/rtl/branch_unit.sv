
module Branch_Unit #(
  parameter WIDTH = 32
)(
  // === Inputs ===
  input  rv32_pkg::opcode_t  opcode_EX,
  input  rv32_pkg::funct3_t  funct3_EX,
  input  logic [WIDTH-1:0]   rs1,
  input  logic [WIDTH-1:0]   rs2,
  input  logic               BrUn,   // 0 = signed, 1 = unsigned

  // === Output ===
  output logic               PCSel    // 1 = branch/jump taken
);
  import rv32_pkg::*;

  // ===== Internal wires =====
  logic BrEq, BrLT;

  // ===== Compare block =====
  assign BrEq = (rs1 == rs2);
  assign BrLT = (BrUn) ? (rs1 < rs2)
                       : ($signed(rs1) < $signed(rs2));

  // ===== Branch decision =====
  always_comb begin
    PCSel = 1'b0;  // default

    unique case (opcode_EX)
      // ----------------------
      // Branch instructions
      // ----------------------
      OC_B: begin
        unique case (funct3_EX)
          F3_BEQ  : PCSel =  BrEq      ? 1'b1 : 1'b0;
          F3_BNE  : PCSel = ~BrEq      ? 1'b1 : 1'b0;
          F3_BLT  : PCSel =  BrLT      ? 1'b1 : 1'b0;
          F3_BGE  : PCSel = (~BrLT|BrEq)? 1'b1 : 1'b0;
          F3_BLTU : PCSel =  BrLT      ? 1'b1 : 1'b0;
          F3_BGEU : PCSel = (~BrLT|BrEq)? 1'b1 : 1'b0;
          default : PCSel = 1'b0;
        endcase
      end

      // ----------------------
      // Jumps
      // ----------------------
      OC_J, OC_I_JALR: begin
        PCSel = 1'b1;
      end

      default: PCSel = 1'b0;
    endcase
  end
endmodule
