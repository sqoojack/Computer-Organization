module Instr_Memory (
    pc_addr_i,
    instr_o
);

  //I/O ports
  input [31:0] pc_addr_i;
  output [31:0] instr_o;

  //Internal Signals
  reg [31:0] instr_o; // 宣告32bit的暫存器
  integer  i; // integer variable used to for loop

  
  reg [31:0] Instr_Mem[0:31]; // reg [31:0]: 每個register unit的bit寬度是 32bit

  //Parameter


  always @(pc_addr_i) begin
    instr_o = Instr_Mem[pc_addr_i/4]; // 根據PC的位置讀取instruction memory 中的指令
  end

  //Initial Memory Contents
  initial begin
    for (i = 0; i < 32; i = i + 1) 
      Instr_Mem[i] = 32'b0; // 初始化記憶體為0
  end
endmodule
