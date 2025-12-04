

module CPU (
    input  logic clk,
    input  logic rst
//    output logic [17:0] LED_out
);
	 

    // ====== Wires ======
    logic [31:0] pc, pc_next, instr;
    logic [31:0] dataR1, dataR2, alu_out, dataR, dataW;
    logic [31:0] imm;
    logic BrEq, BrLT;

    // Control signals
    logic PCSel, RegWEn, BrUn, BSel, ASel, MemRW;
    logic [2:0] ImmSel;
    logic [3:0] ALUSel;
    logic [1:0] WBSel;

    // ====== PC & IMEM ======
    Program_Counter pc_reg (.clk(clk), .rst(rst), .PC_Next(pc_next), .PC(pc));
    Instruction_Memory imem (.rst(rst), .addr(pc), .instr(instr));

    // ====== Control Unit ======
    Control_Logic ctrl (
        .instr(instr),
        .PCSel(PCSel),
        .BrEq(BrEq),
        .BrLT(BrLT),
        .RegWEn(RegWEn),
        .BrUn(BrUn),
        .Bsel(BSel),
        .Asel(ASel),
        .MemRW(MemRW),
        .ImmSel(ImmSel),
        .ALUSel(ALUSel),
        .WBSel(WBSel)
    );

    // ====== Register File ======
    Register_File regfile (
        .clk(clk),
        .rst(rst),
        .rsR1(instr[19:15]),
        .rsR2(instr[24:20]),
        .rsW(instr[11:7]),
        .dataW(dataW),
        .RegWEn(RegWEn),
        .dataR1(dataR1),
        .dataR2(dataR2)
    );

    // ====== Immediate Generator ======
    Immediate_Generator imm_gen (
        .Instr(instr),
        .ImmSel(ImmSel),
        .Imm(imm)
    );

    // ====== Branch Comparator ======
    Branch branch (
        .dataR1(dataR1),
        .dataR2(dataR2),
        .BrUn(BrUn),
        .BrEq(BrEq),
        .BrLT(BrLT)
    );

    // ====== ALU ======
    logic [31:0] aluA;     
    logic [31:0] aluB;

    always_comb begin
        case(ASel)
            0: aluA = dataR1;
            1: aluA = pc;
        endcase
    end

    always_comb begin
        case(BSel)
            0: aluB = dataR2;
            1: aluB = imm;
        endcase
    end

    ALU alu (
        .src1(aluA),
        .src2(aluB),
        .alu_control(ALUSel),
        .alu_result(alu_out)
    );

    // ====== Data Memory ======
    Data_Memory dmem (
        .clk(clk),
        .rst(rst),
        .addr(alu_out),
        .dataW(dataR2),
        .dataR(dataR),
        .MemRW(MemRW)
//        .Led_out(LED_out)
    );

    // ====== Write-back Mux ======
    always_comb begin
        case (WBSel)
            2'b00: dataW = dataR;   // Memory_read
            2'b01: dataW = alu_out;     // alu_result
            2'b10: dataW = pc + 4;    // PC+4 (for JAL)
            default: dataW = 32'b0;
        endcase
    end

    always_comb begin
        case (PCSel)
            0: pc_next = pc + 4;
            1: pc_next = alu_out;
            default: pc_next = pc + 4;
        endcase
    end

//assign LED_out = dmem.mem[0];   // dữ liệu tại địa chỉ 0 của Data Memory

endmodule
