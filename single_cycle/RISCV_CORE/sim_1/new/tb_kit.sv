
`timescale 1ns/1ps

module tb_kit;

    // ====== Clock & Reset ======
    reg clk;
    reg rst;
    wire [17:0] led_out;

    // ====== DUT (Device Under Test) ======
    RISCV_Top_DE2115 RISCV_Top_DE2115 (
        .CLOCK_50(clk),
        .KEY(rst),
        .LEDR(led_out)
    );

    // ====== Clock generation ======
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 10ns period = 100MHz
    end

    // ====== Reset sequence ======
    initial begin
        rst = 0;
        #20;
        rst = 1;
        #20000000;

        $finish;  // hoặc $finish

    end

    // ====== Simulation control ======
    initial begin
        // waveform dump
        $dumpfile("tb_kit.vcd");   // dùng cho GTKWave hoặc ModelSim VCD
        $dumpvars(0, tb_kit);

           end

endmodule
