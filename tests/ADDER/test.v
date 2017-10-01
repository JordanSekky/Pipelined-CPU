/**
 * This testbench will test the adder module to check that the computations
 * are properly adding outputs in proper timing.
 *
 * Notes:
 *  - Addition should work up to 2^32.
 *  - Addition does not support negative numbers.
 *  - Addition should overflow over 2^32.
 */
module testbench();

  // Registers
  reg   [31:0]  a;
  reg   [31:0]  b;

  // Wires
  wire  [31:0]  result;

  // Modules
  ADDER adder(a, b, result);

  initial begin
    a = 0;    b = 0;    #10;
    $display("Output = %d", result); // result = 0

    a = 5;    b = 10;   #10;
    $display("Output = %d", result); // result = 15

    a = 10;
    b = 5;
    #5;
    $display("Output = %d", result); // result = 15

    a = 10;
    b = 10;
    #5;
    $display("Output = %d", result); // result = 20

    a = 32'hffffffff;
    b = 32'h00000002;
    #5;
    $display("Output = %d", result); // result = 1

    $finish;
  end




endmodule
