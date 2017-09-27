/*
 * Sign-extends a value from 16 bits to 32 bits, such that all of the leading
 * bits that are prepended match the leftmost bit of the input value
 */
module SIGN_EXTEND (
  input wire [15:0] sign_in,
  input wire [31:0] sign_out
  );

  // Prepends the leftmost bit of sign_in 16x
  assign sign_out = {{16{sign_in[15]}}, sign_in};

endmodule
