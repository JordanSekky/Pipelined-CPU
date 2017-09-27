/*
 * A 3-way multiplexor with a 2-bit control signal that gives the following
 * control-output mapping:
 * -----------------------
 * 00 -> input_a
 * 01 -> input_b
 * 11 -> input_c
 */
module THREE_MUX (
  input  wire [1:0]      sig_control,
  input  wire [size-1:0] input_a,
  input  wire [size-1:0] input_b,
  input  wire [size-1:0] input_c,
  output wire [size-1:0] result
  );

  parameter size = 32;

  assign result = sig_control[1] ? input_c : (sig_control[0] ? input_a : input_b);

endmodule
