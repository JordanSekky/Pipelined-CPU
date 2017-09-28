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
  reg   [1:0]   input_a_2;
  reg   [1:0]   input_b_2;
  reg   [1:0]   input_c_2;
  reg   [1:0]   signal_2;
  reg   [31:0]  input_a_32;
  reg   [31:0]  input_b_32;
  reg   [31:0]  input_c_32;
  reg   [1:0]   signal_32;

  // Wires
  wire  [1:0]   result_2;
  wire  [31:0]  result_32;

  // Modules
  THREE_MUX #(2) mux2(
    signal_2,
    input_a_2,
    input_b_2,
    input_c_2,
    result_2);
  THREE_MUX #(32) mux32(
    signal_32,
    input_a_32,
    input_b_32,
    input_c_32,
    result_32);

  initial begin
    input_a_2  =   2'b00;
    input_b_2  =   2'b01;
    input_c_2  =   2'b10;
    signal_2 = 2'b00;
    #10;
    $display("Output = %b", result_2); // 00
    signal_2 = 2'b01;
    #10;
    $display("Output = %b", result_2); // 01
    signal_2 = 2'b10;
    #10;
    $display("Output = %b", result_2); // 10
    signal_2 = 2'b11;
    #10;
    $display("Output = %b", result_2); // xx

    input_a_32  =   32'h00000000;
    input_b_32  =   32'h55555555;
    input_c_32  =   32'hffffffff;
    signal_32 = 2'b00;
    #10;
    $display("Output = %b", result_32); // 00000000
    signal_32 = 2'b01;
    #10;
    $display("Output = %b", result_32); // 55555555
    signal_32 = 2'b10;
    #10;
    $display("Output = %b", result_32); // ffffffff
    signal_32 = 2'b11;
    #10;
    $display("Output = %b", result_32); // xxxxxxxx

    $finish;
  end




endmodule
