module Instruction_Memory(
    input logic rst,
    input logic [31:0] addr,
    output logic [31:0] instr
);
    logic [31:0] mem[1023:0];

    assign instr = (rst) ? 32'h00000013 : mem[addr[31:2]];

    initial begin
        $readmemh("/home/lovecs/Do_an/single_cycle/memfile1.hex", mem);
    end
endmodule
