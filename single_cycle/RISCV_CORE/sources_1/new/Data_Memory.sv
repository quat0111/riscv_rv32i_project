module Data_Memory(
    input logic clk, rst,
    input logic [31:0] addr, 
    input logic [31:0] dataW,
    input logic MemRW,
    output logic [31:0] dataR
//	 output logic [17:0] Led_out
); 
    logic [31:0] mem [1023:0];

    always @ (posedge clk or posedge rst) begin
       if (rst) begin
          for(int i=0; i<4096; i++) begin
             mem[i] <= 32'h00000000;
          end
       end else if (MemRW && addr < 4096) begin
            mem[addr >> 2] <= dataW;
        end
    end

    always_comb begin
        if (MemRW ==0 && addr < 4096) begin
            dataR = mem[addr >> 2];
        end else begin
            dataR = 32'h00000000; // or some other default value or error signal
        end
    end
	 
//	 assign Led_out = mem[0][17:0];

endmodule
 
