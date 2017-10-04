`include "../includes/ManBearPig.h"

module INST_MEM (input wire [31:0] pc, output reg [31:0] instr);
  reg [31:0] mem [`instr_mem_lo:`instr_mem_hi]; // Memory block.

  initial begin
    $readmemh("../mips/test_add.mips", mem);
  end

  reg [31:0] wordAddress;

  always @(pc) begin
    wordAddress = pc >> 2;
    instr = mem[wordAddress];
  end
endmodule
