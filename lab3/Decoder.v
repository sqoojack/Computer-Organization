
module Decoder (
    instr_op_i,
    RegWrite_o,
    ALUOp_o,
    ALUSrc_o,
    RegDst_o,
    Jump_o,
    Branch_o,
    BranchType_o,
    MemRead_o,
    MemWrite_o,
    MemtoReg_o
);

  // I/O ports
  input [5:0] instr_op_i;
  
  output reg RegWrite_o;
  output reg [2:0] ALUOp_o;
  output reg ALUSrc_o;
  output reg RegDst_o;
  output reg Jump_o;
  output reg Branch_o;
  output reg BranchType_o;
  output reg MemRead_o;
  output reg MemWrite_o;
  output reg MemtoReg_o;

  // 處理control signal
  // sllv, slrv, jr is in Rtype 
  parameter RType = 6'b000000;
  parameter addi = 6'b010011;
  parameter lw = 6'b011000;
  parameter sw = 6'b101000;
  parameter beq = 6'b011001;
  parameter bne = 6'b011010;
  parameter jump = 6'b001100;
  parameter jal = 6'b001111;
  parameter blt = 6'b011100;
  parameter bnez = 6'b011101;
  parameter bgez = 6'b011110;

  always @(*) begin
    // Set RegWrite signal
    if (instr_op_i == RType || instr_op_i == addi || instr_op_i == lw || instr_op_i == jal)
      RegWrite_o = 1'b1;
    else
      RegWrite_o = 1'b0;

    // Set ALUOp signal
    case (instr_op_i)
      RType:  ALUOp_o = 3'b010;  // Rtype時的
      addi:   ALUOp_o = 3'b011; 
      lw:     ALUOp_o = 3'b000; 
      sw:     ALUOp_o = 3'b000;     
      beq:    ALUOp_o = 3'b001;  
      bne:    ALUOp_o = 3'b110; 
      bnez:   ALUOp_o = 3'b110; 
      blt:    ALUOp_o = 3'b100; 
      bgez:   ALUOp_o = 3'b101; 
      default: ALUOp_o = 3'b000; // 默認值
    endcase

    // Set ALUSrc signal
    if (instr_op_i == addi || instr_op_i == lw || instr_op_i == sw)
      ALUSrc_o = 1'b1;   // 只有當指令是addi, lw, sw時 ALUSrc = 1
    else
      ALUSrc_o = 1'b0;

    // Set RegDst signal
    if (instr_op_i == RType)
      RegDst_o = 1'b1;
    else
      RegDst_o = 1'b0;

    // Set Jump signal
    if (instr_op_i == jump || instr_op_i == jal)
      Jump_o = 1'b1;
    else
      Jump_o = 1'b0;

    // Set BranchType signal
    if (instr_op_i == bne || instr_op_i == blt || instr_op_i == bgez)
      BranchType_o = 1'b1;
    else
      BranchType_o = 1'b0;

    // Set Branch signal
    if (instr_op_i == beq || instr_op_i == bne || instr_op_i == blt || instr_op_i == bgez || instr_op_i == bnez)
      Branch_o = 1'b1;
    else
      Branch_o = 1'b0;

    // Set MemRead signal
    if (instr_op_i == lw)
      MemRead_o = 1'b1;
    else
      MemRead_o = 1'b0;

    // Set MemWrite signal
    if (instr_op_i == sw)
      MemWrite_o = 1'b1;
    else
      MemWrite_o = 1'b0;

    // Set MemtoReg signal
    if (instr_op_i == lw)
      MemtoReg_o = 1'b1;
    else
      MemtoReg_o = 1'b0;
  end

endmodule