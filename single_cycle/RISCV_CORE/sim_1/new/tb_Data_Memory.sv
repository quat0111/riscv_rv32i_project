`timescale 1ns / 1ps

module tb_Data_Memory();
    // Inputs
    logic clk, rst, MemRW;
    logic [31:0] addr, dataW ;
    // Outputs
    logic [31:0] dataR;
    // Instantiate the Unit Under Test (UUT)
    Data_Memory dut (.clk(clk), 
                     .rst(rst), 
                     .MemRW(MemRW), 
                     .addr(addr), 
                     .dataW(dataW), 
                     .dataR(dataR));

    always begin
    clk = 1;
    forever #5 clk = ~clk;
    end
    
    initial begin
    rst = 1;
    #10;
    rst = 0;
    addr = 32'h00000005;
    dataW = 32'hcacacaca;
    MemRW = 0;
    #10;
    MemRW = 1;
    #10;
    addr = 32'h0000001F;
    dataW = 32'hfefefefe;
    #10;
    MemRW = 0;
    #10;
    addr = 32'h00000005;
    #10;

        $finish;
    end
      
endmodule
