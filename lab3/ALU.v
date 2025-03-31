
module ALU (
    aluSrc1,
    aluSrc2,
    ALU_operation_i,
    result,
    zero,
    overflow
);

  // I/O ports
  input [31:0] aluSrc1;
  input [31:0] aluSrc2;
  input [3:0] ALU_operation_i;

  output reg [31:0] result;
  output reg zero;
  output reg overflow;

  always @(*) begin
    // Default values
    zero = 0;
    overflow = 0;

    // ALU operations
    case (ALU_operation_i)
      4'b0000: result = aluSrc1 & aluSrc2;  // AND
      4'b0001: result = aluSrc1 | aluSrc2;  // OR
      4'b0010: result = aluSrc1 + aluSrc2;  // ADD
      4'b0110: result = aluSrc1 - aluSrc2;  // SUB
      4'b0111: result = ($signed(aluSrc1) < $signed(aluSrc2)) ? 32'd1 : 32'd0;  // SLT
      4'b1000: result = ($signed(aluSrc1) < $signed(aluSrc2)) ? 32'd0 : 32'd1;  // SLT Reverse
      4'b1001: result = aluSrc1 << aluSrc2; // SLL
      4'b1010: result = aluSrc1 >> aluSrc2; // SRL
      4'b1100: result = ~(aluSrc1 | aluSrc2); // NOR
      default: result = 32'd0;
    endcase

    // Set zero flag
    zero = (result == 32'd0);

    // Set overflow flag for ADD operation
    if (ALU_operation_i == 4'b0010) begin
      if ((aluSrc1[31] == 0 && aluSrc2[31] == 0 && result[31] == 1) || 
          (aluSrc1[31] == 1 && aluSrc2[31] == 1 && result[31] == 0)) begin
        overflow = 1'b1;
      end else begin
        overflow = 1'b0;
      end
    end else begin
      overflow = 1'b0;
    end
  end
endmodule