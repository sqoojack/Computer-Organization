module Mux2to1 (
    data0_i,
    data1_i,
    select_i,
    data_o
);

  parameter size = 0; // 因為輸入的bit會不固定, 故用size來變動

  //I/O ports
  input [size-1:0] data0_i;
  input [size-1:0] data1_i;
  input select_i;

  output reg [size-1:0] data_o;

  always @(*) begin
    if (select_i == 1)
      data_o = data1_i;   // mux位於1的話, output 會是data1
    else
      data_o = data0_i;
  end
  
endmodule
