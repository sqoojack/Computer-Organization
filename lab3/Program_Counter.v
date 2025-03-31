module Program_Counter (
    clk_i,
    rst_n,
    pc_in_i,
    pc_out_o
);

  //I/O ports
  input clk_i;    // clock i: 時脈訊號
  input rst_n;    // reset n: 重置信號
  input [31:0] pc_in_i;   
  output [31:0] pc_out_o; 

  //Internal Signals
  reg [31:0] pc_out_o;

  //Main function
  always @(posedge clk_i) begin
    if (~rst_n) 
        pc_out_o <= 0;
    else 
        pc_out_o <= pc_in_i;
  end

endmodule
