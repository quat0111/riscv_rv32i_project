
////////////////////////////////////////////////////////////
// Control Logic - Complete RV32I Datapath
// Generates ALL control signals for single-cycle CPU
// Supports: R, I, S, B, J, U types (add, sub, and, or, slt,
// beq, jal, lui, auipc, lw, sw, etc.)
////////////////////////////////////////////////////////////

module Control_Logic(
    input logic [31:0] instr,     // full instruction
    input logic   BrEq,      // from Branch Comparator
    input logic   BrLT,      // from Branch Comparator
    output logic    PCSel,     // PC source select
    output logic [2:0] ImmSel, // immediate type
    output logic    RegWEn,    // register write enable
    output logic    BrUn,      // signed/unsigned branch compare
    output logic    Bsel,      // select ALU operand B (reg/imm)
    output logic    Asel,      // select ALU operand A (reg/PC)
    output logic [3:0] ALUSel, // ALU operation select
    output logic    MemRW,     // memory read/write
    output logic [1:0] WBSel   // writeback source select
);

    // Extract instruction fields
    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];

    always_comb begin
        // Default values
        PCSel   = 0;
        ImmSel  = 3'b000;
        RegWEn  = 0;
        BrUn    = 0;
        Bsel    = 0;
        Asel    = 0;
        ALUSel  = 4'b0000;
        MemRW   = 0;
        WBSel   = 2'b00;

        case (opcode)

            // ====================================================
            // R-type: ADD, SUB, AND, OR, SLT, SLL, XOR
            // ====================================================
            7'b0110011: begin
                RegWEn = 1;
                Bsel   = 0;
                Asel   = 0;
                WBSel  = 2'b01; // ALU result
                case (funct3)
                    3'b000: ALUSel = (funct7[5]) ? 4'b0001 : 4'b0000; // SUB / ADD
                    3'b111: ALUSel = 4'b1011; // AND
                    3'b110: ALUSel = 4'b1001; // OR
                    3'b100: ALUSel = 4'b0101; // XOR
                    3'b010: ALUSel = 4'b0100; // SLT
                    3'b011: ALUSel = 4'b0110; // SLTU
                    3'b001: ALUSel = 4'b0011; // SLL
                    3'b101: ALUSel = (funct7[5]) ? 4'b1000 : 4'b0111; // SRA/SRL
                    default: ALUSel = 4'b0000;
                endcase
            end

            // ====================================================
            // I-type (Immediate ALU): ADDI, ANDI, ORI, XORI, SLTI
            // ====================================================
            7'b0010011: begin
                RegWEn = 1;
                Bsel   = 1; // use imm
                Asel   = 0;
                WBSel  = 2'b01; // ALU result
                ImmSel = 3'b000; // I-type
                case (funct3)
                    3'b000: ALUSel = 4'b0000; // ADDI
                    3'b010: ALUSel = 4'b0100; // SLTI
                    3'b011: ALUSel = 4'b0110; // SLTIU
                    3'b100: ALUSel = 4'b0101; // XORI
                    3'b110: ALUSel = 4'b1001; // ORI
                    3'b111: ALUSel = 4'b1011; // ANDI
                    3'b001: ALUSel = 4'b0011; // SLLI
                    3'b101: ALUSel = (funct7[5]) ? 4'b1000 : 4'b0111; // SRAI/SRLI
                    default: ALUSel = 4'b0000;
                endcase
            end

            // ====================================================
            // LOAD (LW)
            // ====================================================
            7'b0000011: begin
                RegWEn = 1;
                Bsel   = 1;
                Asel   = 0;
                ALUSel = 4'b0000; // ADD
                ImmSel = 3'b000;  // I-type
                MemRW  = 0;
                WBSel  = 2'b00;  // data from memory
            end

            // ====================================================
            // STORE (SW)
            // ====================================================
            7'b0100011: begin
                RegWEn = 0;
                Bsel   = 1;
                Asel   = 0;
                ALUSel = 4'b0000; // ADD
                ImmSel = 3'b001;  // S-type
                MemRW  = 1;
            end

            // ====================================================
            // BRANCH (BEQ, BNE, BLT, BGE, BLTU, BGEU)
            // ====================================================
            7'b1100011: begin
                RegWEn = 0;
                Asel   = 1;
                Bsel   = 1;
                ALUSel = 4'b0000; // ADD
                ImmSel = 3'b010;  // B-type
                BrUn   = (funct3[1]) ? 1 : 0; // BLTU/BGEU unsigned
                case (funct3)
                    3'b000: PCSel = (BrEq) ? 1 : 0;  // BEQ
                    3'b001: PCSel = (~BrEq) ? 1 : 0; // BNE
                    3'b100: PCSel = (BrLT) ? 1 : 0;  // BLT
                    3'b101: PCSel = (~BrLT) ? 1 : 0; // BGE
                    3'b110: PCSel = (BrLT) ? 1 : 0;  // BLTU
                    3'b111: PCSel = (~BrLT) ? 1 : 0; // BGEU
                    default: PCSel = 0;
                endcase
            end

            // ====================================================
            // JUMP (JAL)
            // ====================================================
            7'b1101111: begin
                RegWEn = 1;
                Asel   = 1; // Pc as base
                Bsel   = 1; // Imm
                ALUSel = 4'b0000; // ADD
                ImmSel = 3'b011; // J-type
                PCSel  = 1; // always jump
                WBSel  = 2'b10; // PC+4
            end

            // ====================================================
            // JUMP (JALR)
            // ====================================================
            7'b1100111: begin
                RegWEn = 1;
                Asel   = 0; // Rs1
                Bsel   = 1; // Imm
                ALUSel = 4'b0000; // ADD
                ImmSel = 3'b000; // I-type
                PCSel  = 1; // always jump
                WBSel  = 2'b10; // PC+4
            end

            // ====================================================
            // LUI (Load Upper Immediate)
            // ====================================================
            7'b0110111: begin
                RegWEn = 1;
                Asel   = 0;
                Bsel   = 1;
                ALUSel = 4'b1111; // pass imm
                ImmSel = 3'b100;  // U-type
                WBSel  = 2'b01;   // imm → reg
            end

            // ====================================================
            // AUIPC
            // ====================================================
            7'b0010111: begin
                RegWEn = 1;
                Asel   = 1; // PC as base
                Bsel   = 1;
                ALUSel = 4'b0000; // ADD
                ImmSel = 3'b100;  // U-type
                WBSel  = 2'b01;   // ALU result = PC + imm
            end

            // ====================================================
            default: begin
                RegWEn = 0;
                PCSel  = 0;
            end
        endcase
    end
endmodule
