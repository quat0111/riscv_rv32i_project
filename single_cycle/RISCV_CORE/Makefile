
# Makefile cho QuestaSim / ModelSim với waveform

# Thư mục chứa RTL và TB
RTL_DIR = sources_1/new
TB_DIR  = sim_1/new

# Thư viện work
LIB = work

# Công cụ (đổi lại nếu bạn dùng vsim khác)
VLOG = vlog
VSIM = vsim

# Tất cả testbenches
TB_LIST = $(basename $(notdir $(wildcard $(TB_DIR)/tb_*.sv))) RISCV_Top_tb

# Mặc định chạy RISCV_Top_tb
TB ?= RISCV_Top_tb

.PHONY: all run gui clean help list

all: compile run

compile:
	@echo ">> Tạo thư viện work..."
	vlib $(LIB) || true
	@echo ">> Compile RTL..."
	$(VLOG) +acc $(RTL_DIR)/*.sv
	@echo ">> Compile Testbenches..."
	$(VLOG) +acc $(TB_DIR)/*.sv

run:
	@echo ">> Chạy mô phỏng testbench: $(TB)"
	$(VSIM) -c $(TB) -do "run -all; quit"

# Chạy với GUI và waveform
gui:
	@echo ">> Chạy GUI waveform cho testbench: $(TB)"
	$(VSIM) $(TB) -do "add wave -r *; run -all"

list:
	@echo "Danh sách testbench có thể chạy:"
	@echo $(TB_LIST)

clean:
	@rm -rf transcript vsim.wlf $(LIB)
	@echo ">> Dọn sạch thư mục build."

help:
	@echo "Sử dụng:"
	@echo "  make              # compile + chạy RISCV_Top_tb (console)"
	@echo "  make TB=tb_ALU    # chạy testbench ALU (console)"
	@echo "  make gui          # chạy GUI waveform cho RISCV_Top_tb"
	@echo "  make gui TB=tb_ALU # chạy GUI waveform cho ALU"
	@echo "  make list         # liệt kê tất cả testbenches"
	@echo "  make clean        # xóa build files"
