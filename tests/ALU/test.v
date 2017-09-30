`include "../../includes/ManBearPig.h"

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
  reg   signed  [31:0]  src_a;
  reg   signed  [31:0]  src_b;
  reg           [4:0]   sig_alu_control;

  // Wires
  wire  signed  [31:0]  result;

  // Modules
  ALU alu(
    src_a,
    src_b,
    sig_alu_control,
    result
    );

  initial begin
    src_a = 0;
    src_b = 0;
    sig_alu_control = 10; #10;
    $display("a(%h) [undef] b(%h) = %h", src_a, src_b, result); // result = X

    src_a = 32'h0;
    src_b = 32'h0;
    sig_alu_control = `ALU_AND; #10;
    $display("a(%h) [AND] b(%h) = %h", src_a, src_b, result); // result = 00000000

    src_a = 32'h0000FFFF;
    src_b = 32'hAAAAAAAA;
    sig_alu_control = `ALU_AND; #10;
    $display("a(%h) [AND] b(%h) = %h", src_a, src_b, result); // result = 0000AAAA

    src_a = 32'h0000FFFF;
    src_b = 32'hAAAAAAAA;
    sig_alu_control = `ALU_OR; #10;
    $display("a(%h) [OR] b(%h) = %h", src_a, src_b, result); // result = AAAAFFFF

    src_a = 32'hAAAAAAAA;
    src_b = 32'h0000FFFF;
    sig_alu_control = `ALU_OR; #10;
    $display("a(%h) [OR] b(%h) = %h", src_a, src_b, result); // result = AAAAFFFF

    src_a = 20;
    src_b = 4;
    sig_alu_control = `ALU_add; #10;
    $display("a(%2d) [ADD] b(%2d) = %2d", src_a, src_b, result); // result = 24

    src_a = 20;
    src_b = -4;
    sig_alu_control = `ALU_add; #10;
    $display("a(%2d) [ADD] b(%2d) = %2d", src_a, src_b, result); // result = 16

    src_a = 20;
    src_b = 4;
    sig_alu_control = `ALU_sub; #10;
    $display("a(%2d) [SUB] b(%2d) = %2d", src_a, src_b, result); // result = 24

    src_a = 20;
    src_b = -4;
    sig_alu_control = `ALU_sub; #10;
    $display("a(%2d) [SUB] b(%2d) = %2d", src_a, src_b, result); // result = 16

    $finish;
  end




endmodule
