
`timescale 1ns/1ps

module tb_RISCV_Top;

  // ==============================
  // 1. Khai báo tín hiệu testbench
  // ==============================
  logic CLOCK_50;
  logic KEY;
  logic [17:0] led;

  // ==============================
  // 2. Instantiate DUT (Design Under Test)
  // ==============================
  RISCV_Top uut (
    .CLOCK_50 (CLOCK_50),
    .KEY      (KEY),
    .led      (led)
  );

  // ==============================
  // 3. Tạo clock 50 MHz  (chu kỳ 20 ns)
  // ==============================
  initial begin
    CLOCK_50 = 0;
    forever #1 CLOCK_50 = ~CLOCK_50;
  end

  // ==============================
  // 4. Reset sequence
  // ==============================
  initial begin
    KEY = 0;                 // giữ reset active low
    #20;                    // chờ 100 ns
    KEY = 1;                 // nhả reset
  end

  // ==============================
  // 5. Quan sát LED
  // ==============================
  initial begin
    $display("=== Start simulation ===");
    $dumpfile("wave.vcd");    // để xem waveform nếu dùng GTKWave
    $dumpvars(0, tb_RISCV_Top);

    // chạy mô phỏng một khoảng thời gian nhất định
    #5000000;                  // 0.5 ms (tùy bạn chỉnh)
    $display("=== End simulation ===");
    $finish;
  end

endmodule
