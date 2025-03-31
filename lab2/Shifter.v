
module Shifter(
    sftSrc, // 32bit input data
    shamt,  // 位移量, 5bit
    leftRight,  // control signal
    result  // 32bit output data (位移完之後的結果)
);

    input [31:0] sftSrc;
    input [4:0] shamt;
    input leftRight;

    output reg [31:0] result;


    always @(*) begin
        if (leftRight == 1'b0) begin   // leftRight == 0 時 -> 向右移
            result = sftSrc >> shamt;
        end
        else begin
            result = sftSrc << shamt;
        end
    end
endmodule
