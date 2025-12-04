`timescale 1ns / 1ps

module tb_Branch;
   logic [31:0]  dataR1, dataR2;
   logic BrUn, BrEq, BrLT;

Branch Branch(
   .dataR1(dataR1),
   .dataR2(dataR2),
   .BrUn(BrUn),
   .BrEq(BrEq),
   .BrLT(BrLT)
   );

initial begin
   dataR1 = 32'd15;
   dataR2 = 32'd20;
   BrUn = 0;

   #20;
   dataR1 = 32'd15;
   dataR2 = -32'd20;

   #20;
   BrUn = 1;

   #20;
   dataR1 = 32'd15;
   dataR2 = 32'd20;

   #20;
   dataR1 = 32'd20;

   #20;
   $finish;
end

endmodule


