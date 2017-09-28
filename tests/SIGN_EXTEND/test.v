/**
 * This testbench will test the SIGN_EXTEND module.
 *
 * Notes:
 *  - SIGN_EXTEND changes the signed 16 bit input to a signed 32 bit input.
 *  - Positive numbers must stay positive and negative numbers must stay
 *    negative.  (16'b-2 --> 32'b-2)
 *  - Numbers values must stay the same. (16'b2 --> 32'b2)
 */
module testbench();

  // Registers
  reg   [15:0]  sign_in;

  // Wires
  wire  [31:0]  sign_out;

  // Modules
  SIGN_EXTEND sign_extend(
    sign_in,
    sign_out);

  initial begin
    sign_in = 16'h0;
    #10;
    $display("Output = %h", sign_out); // 00000000
    sign_in = 16'h000a;
    #10;
    $display("Output = %h", sign_out); // 0000000a
    sign_in = -4;
    #10;
    $display("Output = %h", sign_out); // fffffffc    

    $finish;
  end




endmodule
