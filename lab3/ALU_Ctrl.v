
// ALU Control
module ALU_Ctrl (
    funct_i,
    ALUOp_i,
    ALU_operation_o,
    FURslt_o,
    leftRight_o
);

  //I/O ports
  input [5:0] funct_i;
  input [2:0] ALUOp_i;

  output reg [3:0] ALU_operation_o;
  output reg [1:0] FURslt_o;
  output reg leftRight_o;
 
  parameter and_f = 4'b0000; 
	parameter or_f = 4'b0001; 
  parameter add_f = 4'b0010; 
	parameter sub_f = 4'b0110;
  parameter mlt_f = 4'b1010;
	parameter slt_f = 4'b0111; 
	parameter nor_f = 4'b1100; 

  parameter addi = 3'b011;
  parameter lwsw = 3'b000;
  parameter beq  = 3'b001;
  parameter bne  = 3'b110; // bnez, bne
  parameter blt  = 3'b100;
  parameter bgez = 3'b101;


  always @(*) begin
    ALU_operation_o = ({ALUOp_i,funct_i} == 9'b010100011 || ALUOp_i == 3'b011 || ALUOp_i == 3'b000) ? add_f 
    : ({ALUOp_i,funct_i} == 9'b010010011 || ALUOp_i == 3'b001 || ALUOp_i == 3'b110) ? sub_f
    : ({ALUOp_i,funct_i} == 9'b010010100 || ALUOp_i == 3'b100) ? slt_f
    : (ALUOp_i == 3'b101) ? 4'b1000
    : ({ALUOp_i,funct_i} == 9'b010010000) ? nor_f
    : ({ALUOp_i,funct_i} == 9'b010011111) ? and_f
    : ({ALUOp_i,funct_i} == 9'b010010010) ? and_f
    : ({ALUOp_i,funct_i} == 9'b010101111) ? or_f
    : ({ALUOp_i,funct_i} == 9'b010100010) ? or_f
    : ({ALUOp_i,funct_i} == 9'b010011000) ? 4'b1001
    : ({ALUOp_i,funct_i} == 9'b010101000) ? mlt_f : and_f;

    // assign FURslt_o = ({ALUOp_i,funct_i} == 9'b010100010 || {ALUOp_i,funct_i} == 9'b010101000 || {ALUOp_i,funct_i} == 9'b010011000 || {ALUOp_i,funct_i} == 9'b010010010) ? 2'b01 : 2'b00;
    FURslt_o =  	(ALUOp_i == lwsw || ALUOp_i == beq || ALUOp_i == bne || ALUOp_i == blt || ALUOp_i == bgez) ? 2'b00 
    : ({ALUOp_i,funct_i} == 9'b010100011 || ALUOp_i == addi) ? 2'b00 
    : ({ALUOp_i,funct_i} == 9'b010010011) ? 2'b00 
    : ({ALUOp_i,funct_i} == 9'b010011111) ? 2'b00 
    : ({ALUOp_i,funct_i} == 9'b010101111) ? 2'b00 
    : ({ALUOp_i,funct_i} == 9'b010010000) ? 2'b00 
    : ({ALUOp_i,funct_i} == 9'b010010100) ? 2'b00 
    : ({ALUOp_i,funct_i} == 9'b010010010) ? 2'b01 
    : ({ALUOp_i,funct_i} == 9'b010100010) ? 2'b01 
    : ({ALUOp_i,funct_i} == 9'b010011000) ? 2'b01 
    : ({ALUOp_i,funct_i} == 9'b010101000) ? 2'b01 : 2'b00;  

    // lr = 1 -> shift right >>
    // lr = 0 -> shift left  <<
    if ({ALUOp_i,funct_i} == 9'b010100010 || {ALUOp_i,funct_i} == 9'b010101000)
      leftRight_o = 1'b1;
    else leftRight_o = 1'b0;
  end
  

endmodule
