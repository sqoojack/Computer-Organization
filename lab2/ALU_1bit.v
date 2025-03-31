
`include "Full_adder.v"

module ALU_1bit(
    input a,
    input b,
    input Ainvert,
    input Binvert,
    input CarryIn,
    input Less,
    input [1:0] operation,

    output reg CarryOut,
    output reg Result
);

    wire a_inverted, b_inverted;
    wire sum, carry;
    wire or_op, and_op;

    // 根據Ainvert和Binvert信號對a和b進行反轉
    assign a_inverted = Ainvert ? ~a : a;
    assign b_inverted = Binvert ? ~b : b;

    // AND和OR操作
    assign and_op = a_inverted & b_inverted;
    assign or_op = a_inverted | b_inverted;



    // Full_adder計算加法結果
    Full_adder FA(
        .input1(a_inverted),
        .input2(b_inverted),
        .carryIn(CarryIn),
        .sum(sum),
        .carryOut(carry)
    );

    // 根據操作碼選擇相應的結果
    always @(*) begin
        case (operation)
            2'b00: begin  // and 操作
                Result = and_op;
                CarryOut = 0;
            end
            2'b01: begin  // less 操作
                Result = Less;
                CarryOut = 0;
            end
            2'b10: begin  // or 操作
                Result = or_op;
                CarryOut = 0;
            end
            2'b11: begin
                Result = sum; // add 操作
                CarryOut = carry;
            end

            default: begin
                Result = 0;
                CarryOut = 0;    
            end
        endcase
    end 
endmodule
