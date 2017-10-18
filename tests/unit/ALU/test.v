`include "../../../includes/ManBearPig.h"

/**
 * This testbench will test the adder module to check that the computations
 * are properly computing on the outputs in proper timing.
 *
 * Notes:
 *  - ALU operations should properly work with positive and negative
 *    numbers.
 *  - ALU operations should only work when the proper sig_alu_control is
 *    provided for that operation.
 *  - If a sig_alu_control is provided that isn't handled, the output
 *    should be X
 */
module testbench();

  // Registers
  reg   signed  [31:0]  src_a;
  reg   signed  [31:0]  src_b;
  reg           [4:0]   sig_alu_control;

  // Wires
  wire  signed  [31:0]  result;
  wire  signed  [31:0]  hi;
  wire  signed  [31:0]  lo;

  // Modules
  ALU alu(
    src_a,
    src_b,
    sig_alu_control,
    result,
    hi,
    lo
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
    
    src_a = 1;
    src_b = 2;
    sig_alu_control = `ALU_sll; #10;
    $display("a(%2d) [SLL] b(%2d) = %2d", src_a, src_b, result); // result = 4
    
    src_a = -8;
    src_b = 2;
    sig_alu_control = `ALU_sra; #10;
    $display("a(%2d) [SRA] b(%2d) = %2d", src_a, src_b, result); // result = -2

    src_a = 2000000000;
    src_b = 3;
    sig_alu_control = `ALU_mult; #10;
    $display("a(%8h) [MULT] b(%8h): hi = %8h, lo = %8h", src_a, src_b, hi, lo); 
    // hi = 32'h00000001 
    // lo = 32'h65a0bc00
    
    src_a = 11;
    src_b = 3;
    sig_alu_control = `ALU_div; #10;
    $display("a(%2d) [DIV] b(%2d): hi = %2d, lo = %2d", src_a, src_b, hi, lo); 
    // hi = 2 This is 11 % 3
    // lo = 3 This is 11 / 3

    $finish;
  end




endmodule
