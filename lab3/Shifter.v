module Shifter (
    result,
    leftRight,
    shamt,
    sftSrc
);

  //I/O ports
  output reg [31:0] result;

  input leftRight;
  input [4:0] shamt;
  input [31:0] sftSrc;

  // lr = 1 -> shift right
  always @(*) begin
    if (leftRight == 1)
      result = sftSrc >> shamt;
    else
      result = sftSrc << shamt;
  end

endmodule
