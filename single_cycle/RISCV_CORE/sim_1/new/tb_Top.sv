
`timescale 1ns/1ps

module tb_Top;

    // ====== Clock & Reset ======
    logic clk;
    logic rst;
//    wire [17:0] LED_out;
    // ====== Instantiate DUT ======
    CPU CPU (
        .clk(clk),
        .rst(rst)
//        .LED_out(LED_out)
    );

    // ====== Clock generation (10ns period → 100 MHz) ======
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ====== Reset sequence ======
    initial begin
        rst = 1;
        #20 rst = 0;       // giữ reset 20ns
    end

    // ====== Simulation runtime ======
    initial begin
        #1000;             // chạy 1000ns (hoặc lâu hơn tùy bạn)
        $finish;
    end

    // ====== Dump waveform for QuestaSim / GTKWave ======
    initial begin
        $dumpfile("tb_Top.vcd");
        $dumpvars(0, tb_Top);
    end

endmodule
