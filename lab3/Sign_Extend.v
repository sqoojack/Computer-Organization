module Sign_Extend (
    data_i,
    data_o
);

  //I/O ports
  input [15:0] data_i;

  output reg [31:0] data_o;

  // 要用 0 還是用 1 來填充
  always @(*) begin
    if (data_i[15] == 1)
      data_o[31:0] = {16'b1111111111111111, data_i[15:0]};
    else
      data_o[31:0] = {16'b0, data_i[15:0]};
  end

endmodule
