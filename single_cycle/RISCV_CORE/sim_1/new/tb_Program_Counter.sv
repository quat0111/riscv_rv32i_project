`timescale 1ns / 1ps

module tb_Program_Counter();

    logic clk, rst;
    logic [31:0] PC_Next;
    logic [31:0] PC;

    Program_Counter dut (
        .clk(clk),
        .rst(rst),
        .PC_Next(PC_Next),
        .PC(PC)
    );

    // Clock 20ns period
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Stimulus
    initial begin
        rst = 1;
        PC_Next = 32'd0;

        @(posedge clk);   
        rst = 0;

         PC_Next = 32'h00000004;
        @(posedge clk);  PC_Next = 32'h00000008;
        @(posedge clk);  PC_Next = 32'h0000000C;
        @(posedge clk);  PC_Next = 32'h00000010;
        @(posedge clk);  PC_Next = 32'h00000014;
        @(posedge clk);  PC_Next = 32'h00000018;
        @(posedge clk);  PC_Next = 32'h0000001C;
        @(posedge clk);  PC_Next = 32'h00000020;

        #20 $finish;
    end

endmodule

