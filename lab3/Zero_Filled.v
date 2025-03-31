module Zero_Filled (
    data_i,
    data_o
);

  //I/O ports
  input [15:0] data_i;
  output [31:0] data_o;

  //Internal Signals
  wire [31:0] data_o;

  // 用零來填滿擴展的部分
  assign data_o[31:0] = {16'b0, data_i[15:0]};

endmodule
