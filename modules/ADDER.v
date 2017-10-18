/*
 * Adds input_a and input_b, returning the values in result
 */
module ADDER (input [31:0] input_a, input [31:0] input_b, output [31:0] result);
  assign result = input_a + input_b;
endmodule
