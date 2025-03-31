module Full_adder (
    carryIn,
    input1,
    input2,
    sum,
    carryOut
);

  //I/O ports
  input carryIn;
  input input1;
  input input2;

  output sum;
  output carryOut;

  //Internal Signals
  wire sum;
  wire carryOut;
  wire w1, w2, w3;

  //Main function
  xor x1 (w1, input1, input2);  // sum = input1 xor input2 xor carryIn  
  xor x2 (sum, w1, carryIn);  
  and a1 (w2, input1, input2);  // carryOut = (input1 and input2) or ((input1 xor input2) and carryIn)
  and a2 (w3, w1, carryIn);     // Cout = ab + aCin + bCin
  or o1 (carryOut, w2, w3);

endmodule
