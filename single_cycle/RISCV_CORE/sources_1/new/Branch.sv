module Branch(
    input logic [31:0] dataR1,     // R[rs1]
    input logic [31:0] dataR2,     // R[rs2]
    input logic    BrUn,  // 0 = signed compare, 1 = unsigned compare

    output logic   BrEq,
    output logic   BrLT   
);

    // Equality check 
    assign BrEq = (dataR1 == dataR2);

    // Less-than check 
    assign BrLT = (BrUn) ? (dataR1 < dataR2) : ($signed(dataR1) < $signed(dataR2));

endmodule
