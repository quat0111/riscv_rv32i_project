module Register_File(
    input logic clk, rst, RegWEn,
    input logic [4:0] rsR1, rsR2, rsW,
    input logic [31:0] dataW,
    output logic [31:0] dataR1, dataR2
);
logic [31:0] Register [31:0];

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        for (int i = 0; i < 32; i++) begin
            Register[i] <= 32'h00000000;
        end
    end else if (RegWEn & (rsW != 5'h00)) begin
        Register[rsW] <= dataW;
    end
end

assign dataR1 = Register[rsR1];
assign dataR2 = Register[rsR2];

endmodule
