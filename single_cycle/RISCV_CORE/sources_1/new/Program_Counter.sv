module Program_Counter(
    input logic clk, rst,
    input logic [31:0] PC_Next,
    output logic [31:0] PC
);

always @(posedge clk or posedge rst) begin
    if (rst) 
        PC <= 32'b0;     
    else
        PC <= PC_Next;  
end

endmodule
