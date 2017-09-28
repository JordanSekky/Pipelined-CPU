/**
 * This testbench will test the TWO_MUX module.
 *
 * Notes:
 *  - TWO_MUX should work on a variety of input sizes from 1 to 32 bits
 *  - Output will equal input_hi on signal high
 *  - Output will equal input_lo on signal low
 */
module testbench();

  // Registers
  reg   [1:0]   input_hi_2;
  reg   [1:0]   input_lo_2;
  reg           signal_2;
  reg   [7:0]   input_hi_8;
  reg   [7:0]   input_lo_8;
  reg           signal_8;
  reg   [31:0]  input_hi_32;
  reg   [31:0]  input_lo_32;
  reg           signal_32;

  // Wires
  wire  [1:0]   result_2;
  wire  [7:0]   result_8;
  wire  [31:0]  result_32;

  // Modules
  TWO_MUX #(2) mux2(
    signal_2,
    input_hi_2,
    input_lo_2,
    result_2);
  TWO_MUX #(8) mux8(
    signal_8,
    input_hi_8,
    input_lo_8,
    result_8);
  TWO_MUX #(32) mux32(
    signal_32,
    input_hi_32,
    input_lo_32,
    result_32);

  initial begin
    input_hi_2  =   2'b11;
    input_lo_2  =   2'b00;
    signal_2 = 1'b1;
    #10;
    $display("Output = %b", result_2); // 11
    signal_2 = 1'b0;
    #10;
    $display("Output = %b", result_2); // 00

    input_hi_8  =   8'hff;
    input_lo_8  =   8'h00;
    signal_8 = 8'b1;
    #10;
    $display("Output = %b", result_8); // 11111111
    signal_8 = 8'b0;
    #10;
    $display("Output = %b", result_8); // 00000000

    input_hi_32  =   32'hffffffff;
    input_lo_32  =   32'h00000000;
    signal_32 = 32'b1;
    #10;
    $display("Output = %b", result_32); // 11111111111111111111111111111111
    signal_32 = 32'b0;
    #10;
    $display("Output = %b", result_32); // 00000000000000000000000000000000

    $finish;
  end




endmodule
