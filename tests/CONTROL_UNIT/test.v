`include "../../includes/ManBearPig.h"
/**
 * This testbench will test the DATA_MEMORY module.
 *
 * Notes:
 *  - DATA_MEMORY store memory in an array of registers in the range
 *    [32'h7FFFFFFF:32'h7FF00000].
 *  - Should store data only when sig_mem_write is high
 *  - Should always return 32'hXXXXXXXX and not write if the address
 *    is out of the above range.
 */
module testbench();

/*
  input  wire [5:0] op_code,
  input  wire [5:0] funct_code,
  output reg        load_upper,
  output reg  [1:0] jump,
  output reg        jal,
  output reg        reg_write,
  output reg        mem_to_reg,
  output reg        mem_write,
  output reg  [4:0] alu_control,
  output reg        alu_src,
  output reg        reg_dst,
  output reg        branch,
  output reg  [3:0] bcu_control
*/

  // Registers
  reg   [5:0]  op_code = 6'b0;
  reg   [5:0]  funct_code = 6'b0;

  // Wires
  wire       load_upper;
  wire [1:0] jump;
  wire       jal;
  wire       reg_write;
  wire       mem_to_reg;
  wire       mem_write;
  wire [4:0] alu_control;
  wire       alu_src;
  wire       reg_dst;
  wire       branch;
  wire [3:0] bcu_control;

  // Modules
  CONTROL_UNIT data_memory(
    op_code,
    funct_code,
    load_upper,
    jump,
    jal,
    reg_write,
    mem_to_reg,
    mem_write,
    alu_control,
    alu_src,
    reg_dst,
    branch,
    bcu_control);

  initial begin
    $display("op_code funct_code load_upper jump jal reg_write mem_to_reg mem_write alu_control alu_src reg_dst branch bcu_ctrl\n------- ---------- ---------- ---- --- --------- ---------- --------- ----------- ------- ------- ------ --------");
    $monitor(" %b     %b          %b   %b   %b         %b          %b         %b       %b       %b       %b      %b     %b",
      op_code,
      funct_code,
      load_upper,
      jump,
      jal,
      reg_write,
      mem_to_reg,
      mem_write,
      alu_control,
      alu_src,
      reg_dst,
      branch,
      bcu_control);

      // addiu
      op_code <= 6'b001001;
      funct_code <= 6'b000100;
      #10;
      // jal
      op_code <= 6'b000011;
      funct_code <= 6'b000100;
      #10;
      // jr
      op_code <= 6'b000000;
      funct_code <= 6'b001000;
      #10;
      // lui
      op_code <= 6'b001111;
      funct_code <= 6'b000100;
      #10;
      // lw
      op_code <= 6'b100011;
      funct_code <= 6'b000100;
      #10;
      // ori
      op_code <= 6'b001101;
      funct_code <= 6'b000100;
      #10;
      // sw
      op_code <= 6'b101011;
      funct_code <= 6'b000100;
      #10;
      // addu
      op_code <= 6'b000000;
      funct_code <= 6'b100001;
      #10;
      // beq
      op_code <= 6'b000100;
      funct_code <= 6'b000100;
      #10;
      // bne
      op_code <= 6'b000101;
      funct_code <= 6'b000100;
      #10;
    

    $finish;
  end


endmodule
