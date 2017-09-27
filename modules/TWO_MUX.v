/*
 * A 2-way multiplexor with a 1-bit control signal that gives the following
 * control-output mapping:
 * -----------------------
 * 1 -> input_hi
 * 0 -> input_lo
 */
module TWO_MUX (
  input  wire            sig_control,
  input  wire [size-1:0] input_hi,
  input  wire [size-1:0] input_lo,
  output wire [size-1:0] result
  );
  
  parameter size = 32;

  assign result = sig_control ? input_hi : input_lo;

endmodule
