
// Reference: https://github.com/LaiCharlie/NYCU-Computer-Organization/blob/main/lab3/HW3_110652034.zip

// 每個檔案對應一個硬體組件
`include "Program_Counter.v"
`include "Adder.v"
`include "Instr_Memory.v"
`include "Mux2to1.v"
`include "Mux3to1.v"
`include "Reg_File.v"
`include "Decoder.v"
`include "ALU_Ctrl.v"
`include "Sign_Extend.v"
`include "Zero_Filled.v"
`include "ALU.v"
`include "Shifter.v"
`include "Data_Memory.v"

module Simple_Single_CPU (
    clk_i,  // clock i: 時脈訊號
    rst_n   // reset n: 重置信號
);

    //I/O port
    input clk_i;
    input rst_n;

    wire [31:0] Jr_pc;
    wire [31:0] pc_instr_out;
    wire [31:0] plus4_pc;
    wire [31:0] add_pc;
    wire [31:0] branch_pc;
    wire [31:0] instr;
    wire [31:0] ex_instr;
    wire [31:0] zero_Fout;

    wire ZeroOut;    
    wire RegWrite_o;
    wire [2:0] ALUOp_o;
    wire ALUSrc_o;
    wire RegDst_o;
    wire Jump_o;
    wire Branch_o;
    wire BranchType_o;
    wire MemRead_o;
    wire MemWrite_o;
    wire MemtoReg_o;

    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] write_data;

    wire [31:0] shift_in;
    wire [31:0] shift_out;

    wire [3:0] ALU_operation_o;
    wire [1:0] FURslt_o;
    wire leftRight_o;

    wire [4:0] write_Reg;

    wire [31:0] result;
    wire zero;
    wire overflow;

    

    wire [31:0] Mux3to1out;

    wire [31:0] DM_out;

  //modules
  Program_Counter PC (
      .clk_i(clk_i),
      .rst_n(rst_n),
      .pc_in_i(Jr_pc),     // 表示目前PC位置
      .pc_out_o(pc_instr_out)
  );

  Adder Adder1 (    // 上面的add
      .src1_i(pc_instr_out),
      .src2_i(32'd4),     // PC + 4 的部分
      .sum_o (plus4_pc)
  );

  Adder Adder2 (
      .src1_i(plus4_pc),
      .src2_i(ex_instr << 2),   // ex階段的instr 然後進行左移
      .sum_o (add_pc)
  );

  Mux2to1 #(    // 做Mux_branch的前置條件
      .size(1)
  ) Mux_Zero (  
      .data0_i (zero),
      .data1_i (~zero),
      .select_i(BranchType_o),
      .data_o  (ZeroOut)
  );

  Mux2to1 #(
      .size(32)
  ) Mux_branch (    // 表示這是branch signal的mux
      .data0_i (plus4_pc),
      .data1_i (add_pc),
      .select_i(Branch_o & ZeroOut),  // branch signal
      .data_o  (branch_pc)  
  );

  Mux2to1 #(
      .size(32)
  ) Mux_jump (
      .data0_i (branch_pc),
      // instr[27:0]: 從instr信號中取出最低28位, 左移2位是因為address是以word對齊的
      .data1_i ({plus4_pc[31:28], instr[27:0] << 2}), // 將兩個不同來源的數據拼接成一個 32 位的數據
      .select_i(Jump_o),
      .data_o  (Jr_pc)
  );

  Instr_Memory IM (
      .pc_addr_i(pc_instr_out),
      .instr_o  (instr)
  );

  Mux2to1 #(
      .size(5)
  ) Mux_Write_Reg ( // RegDst
      .data0_i (instr[20:16]),
      .data1_i (instr[15:11]),
      .select_i(RegDst_o),    // 將brach signal和 ZeroOut做 and 運算
      .data_o  (write_Reg)
  );

  Reg_File RF (
      .clk_i(clk_i),
      .rst_n(rst_n),
      .RSaddr_i(instr[25:21]),  // for R-type instrction
      .RTaddr_i(instr[20:16]),
      .RDaddr_i(write_Reg), // RegDst的輸出
      .RDdata_i(write_data),
      .RegWrite_i(RegWrite_o),
      .RSdata_o(read_data1),
      .RTdata_o(read_data2)
  );

  Decoder Decoder (
      .instr_op_i(instr[31:26]),
      .RegWrite_o(RegWrite_o),
      .ALUOp_o(ALUOp_o),
      .ALUSrc_o(ALUSrc_o),
      .RegDst_o(RegDst_o),
      .Jump_o(Jump_o),
      .Branch_o(Branch_o),
      .BranchType_o(BranchType_o),
      .MemRead_o(MemRead_o),
      .MemWrite_o(MemWrite_o),
      .MemtoReg_o(MemtoReg_o)
  );

  ALU_Ctrl AC (
      .funct_i(instr[5:0]),
      .ALUOp_i(ALUOp_o),
      .ALU_operation_o(ALU_operation_o),
      .FURslt_o(FURslt_o),
      .leftRight_o(leftRight_o)
  );

  Sign_Extend SE (
      .data_i(instr[15:0]),
      .data_o(ex_instr)
  );

  Zero_Filled ZF (
      .data_i(instr[15:0]),
      .data_o(zero_Fout)
  );

  Mux2to1 #(
      .size(32)
  ) ALU_src2Src (
      .data0_i (read_data2),
      .data1_i (ex_instr),
      .select_i(ALUSrc_o),
      .data_o  (shift_in)
  );

  ALU ALU (
      .aluSrc1(read_data1),
      .aluSrc2(shift_in),   // 因為到時也會拿來做shifter的input 
      .ALU_operation_i(ALU_operation_o),
      .result(result),
      .zero(zero),
      .overflow(overflow)
  );

  Shifter shifter (
      .result(shift_out),
      .leftRight(leftRight_o),
      .shamt(instr[10:6]),
      .sftSrc(shift_in)
  );

  Mux3to1 #(
      .size(32)
  ) RDdata_Source (
      .data0_i (result),
      .data1_i (shift_out),
      .data2_i (zero_Fout),
      .select_i(FURslt_o),
      .data_o  (Mux3to1out)
  );

  Data_Memory DM (
      .clk_i(clk_i),
      .addr_i(Mux3to1out),
      .data_i(read_data2),
      .MemRead_i(MemRead_o),
      .MemWrite_i(MemWrite_o),
      .data_o(DM_out)
  );

  // set MemtoReg Mux
  Mux2to1 #(    
      .size(32)
  ) Mux_Write (
      .data0_i(Mux3to1out),
      .data1_i(DM_out),
      .select_i(MemtoReg_o),
      .data_o(write_data)
  );

endmodule 