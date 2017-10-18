/**
 * This testbench will test the JUMP_SHIFT_TWO module.
 *
 * Notes:
 *  - JUMP_SHIFT_TWO should concatenate the bits of the two inputs
      in the following order {upper_pc_plus_four, jump_imm, 2'b00}.
 */
module testbench();

  // Registers
  reg   [3:0]   upper_pc_plus_four;
  reg   [25:0]  jump_imm;

  // Wires
  wire  [31:0]  result;

  // Modules
  JUMP_SHIFT_TWO jst(
    upper_pc_plus_four,
    jump_imm,
    result);

  initial begin
    upper_pc_plus_four = 4'h0;
    jump_imm  =   26'b0;
    #10;
    $display("Output = %h", result); // 00000000
    upper_pc_plus_four = 4'hf;
    #10;
    $display("Output = %h", result); // f0000000
    jump_imm  =   26'h0000004;
    #10;
    $display("Output = %h", result); // f0000010
    upper_pc_plus_four = 4'h0;
    jump_imm  =   26'h2000000;
    #10;
    $display("Output = %h", result); // 08000000
    upper_pc_plus_four = 4'hd;
    jump_imm  =   26'h2aaaaaa;
    #10;
    $display("Output = %h", result); // daaaaaa8

    $finish;
  end




endmodule
