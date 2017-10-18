`include "../../../includes/ManBearPig.h"

/**
 * This testbench will test the BCU module.
 *
 * Notes:
 *  - Branch control signals are defined as follows:
 *    BCU_EQ  -> 5'b0000
 *    BCU_NE  -> 5'b0001
 *    BCU_GT  -> 5'b0010
 *    BCU_LT  -> 5'b0011
 *    BCU_GE  -> 5'b0100
 *    BCU_LE  -> 5'b0101
 *    BCU_EQZ -> 5'b0110
 *    BCU_NEZ -> 5'b0111
 *    BCU_GTZ -> 5'b1001
 *    BCU_LTZ -> 5'b1010
 *    BCU_GEZ -> 5'b1011
 *    BCU_LEZ -> 5'b1100
 * - The signals ending with a 'Z' compare rd1 against 0 (rd2 is ignored)
 */
module testbench();

  // Registers
  reg [3:0]  sig_bcu_control = `BCU_NE;
  reg signed [4:0] rd1 = 0;
  reg signed [4:0] rd2 = 0;

  // Wires
  wire branch;

  // Modules
  BCU bcu (
    sig_bcu_control, 
    {rd1, 27'b0 }, 
    {rd2, 27'b0 },
    branch);

  initial begin
    $monitor(" %d, %d = %b", rd1, rd2, branch);

    $display("EQ:");
    sig_bcu_control <= `BCU_EQ;
    rd1 <= 1;
    rd2 <= 1;
    #10;      // 1
    rd1 <= 0;
    rd2 <= 1;
    #10;      // 0

    $display("NE:");
    sig_bcu_control = `BCU_NE;
    rd1 <= 1;
    rd2 <= 1;
    #10;      // 0
    rd1 <= 0;
    rd2 <= 1;
    #10;      // 1

    $display("GT:");
    #10;
    sig_bcu_control = `BCU_GT;
    rd1 <= 1;
    rd2 <= 1;
    #10;      // 0
    rd1 <= 0;
    rd2 <= 1;
    #10;      // 0
    rd1 <= 1;
    rd2 <= 0;
    #10;      // 1

    $display("LT:");
    sig_bcu_control = `BCU_LT;
    rd1 <= 1;
    rd2 <= 1;
    #10;      // 0
    rd1 <= 0;
    rd2 <= 1;
    #10;      // 1
    rd1 <= 1;
    rd2 <= 0;
    #10;      // 0

    $display("GE:");
    sig_bcu_control = `BCU_GE;
    rd1 <= 1;
    rd2 <= 1;
    #10;      // 1
    rd1 <= 0;
    rd2 <= 1;
    #10;      // 0
    rd1 <= 1;
    rd2 <= 0;
    #10;      // 1

    $display("LE:");
    sig_bcu_control = `BCU_LE;
    rd1 <= 1;
    rd2 <= 1;
    #10;      // 1
    rd1 <= 0;
    rd2 <= 1;
    #10;      // 1
    rd1 <= 1;
    rd2 <= 0;
    #10;      // 0

    $display("EQZ:");
    sig_bcu_control <= `BCU_EQZ;
    rd1 <= 1;
    #10;      // 0
    rd1 <= 0;
    #10;      // 1

    $display("NEZ:");
    sig_bcu_control = `BCU_NEZ;
    rd1 <= 1;
    #10;      // 1
    rd1 <= 0;
    #10;      // 0

    $display("GTZ:");
    sig_bcu_control = `BCU_GTZ;
    rd1 <= 1;
    #10;      // 1
    rd1 <= 0;
    #10;      // 0
    rd1 <= -1;
    #10;      // 0

    $display("LTZ:");
    sig_bcu_control = `BCU_LTZ;
    rd1 <= 1;
    #10;      // 0
    rd1 <= 0;
    #10;      // 0
    rd1 <= -1;
    #10;      // 1

    $display("GEZ:");
    sig_bcu_control = `BCU_GEZ;
    rd1 <= 1;
    #10;      // 1
    rd1 <= 0;
    #10;      // 1
    rd1 <= -1;
    #10;      // 0

    $display("LEZ:");
    sig_bcu_control = `BCU_LEZ;
    rd1 <= 1;
    #10;      // 0
    rd1 <= 0;
    #10;      // 1
    rd1 <= -1;
    #10;      // 1

    $finish;
  end

endmodule
