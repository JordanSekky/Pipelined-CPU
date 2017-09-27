/*
 * Turns a 26-bit jump immediate value into the 32-bit address to jump to.
 * This is done by shifting the immediate value left 2 bits and prepending the
 * leading 4 bits from the PC+4 value
 */
module JUMP_SHIFT_TWO (upper_pc_plus_four, jump_imm, jump_addr);

  input wire [3:0] upper_pc_plus_four;
  input wire [25:0] jump_imm;
  output wire [31:0] jump_addr;

  assign jump_addr = {upper_pc_plus_four, jump_imm, 2'b0};

endmodule
