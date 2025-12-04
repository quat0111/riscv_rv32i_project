`timescale 1ns / 1ps

module tb_ALU();
    // Inputs
    logic [31:0] A, B;
    logic [3:0] ALUSel;
    // Outputs
    logic [31:0] alu_result;
    
    ALU dut (
        .src1(A), 
        .src2(B), 
        .alu_control(ALUSel), 
        .alu_result(alu_result)
        );


initial begin
    ALUSel = 4'b0000;//add
        A = 32'd150;B = 32'd50;#10;//A+B
    
    ALUSel = 4'b0001;//sub
        A = 32'd50;B = 32'd150;#10;//A-B

    ALUSel = 4'b0110;//sltu
        A = 32'd150;B = 32'd50;#10;//A>B
        A = 32'd50; B = 32'd150;#10;//A<B     
    
    ALUSel = 4'b0100;//slt
        A = 32'd150;B = 32'd50;#10;//A>B
        A = -32'd150;B = 32'd50;#10;//A<B

    ALUSel = 4'b1111;//lui
        A = 32'd100; B= 32'd200; #10;

    ALUSel = 4'b0011;//sll
        A = 32'd255;B = 32'd3;#10;
  
    ALUSel = 4'b0101;//xor
        A = 32'd15;B = 32'd5;#10;//AxorB #0
        A = 32'd15;B = 32'd15;#10;//AxorB =0 
       
    ALUSel = 4'b0111;//srl
        A = 32'd255;B = 32'd3;#10;
    
    ALUSel = 4'b1000;//sra
        A = -32'd255 ;B = 32'd3;#10;
    
    ALUSel = 4'b1001;//or
        A = 32'd15;B = 32'd5;#10; 
   
    ALUSel = 4'b1011;//and
        A = 32'd15;B = 32'd5;#10;         

        
        $stop;
 end 

endmodule
