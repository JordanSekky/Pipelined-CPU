`ifndef TEST_H
  `include "../includes/ManBearPig.h" 
`endif    
`ifdef TEST_H   
  `include "../../includes/ManBearPig.h"    
`endif

module MEMORY (
  input  wire [31:0] instr_pc,
  input  wire        data_sig_mem_write,
  input  wire [31:0] data_addr,
  input  wire [31:0] data_write_data,
  input  wire [31:0] data_print_addr,
  output wire [31:0] instr_out,
  output wire [31:0] data_read_data
  );

  reg [31:0] memory [`mem_size_lo:`mem_size_hi]; // Memory block.

  initial begin
    `ifndef TEST_H
      $readmemh("../mips/test_add.mips", memory);
    `endif
  end


  // =================================================
  // ===            Instruction Memory             ===
  // =================================================


  assign instr_out = memory[instr_pc >> 2];


  // =================================================
  // ===               Data Memory                 ===
  // =================================================


  wire [31:0] data_addr_shifted;
  assign data_addr_shifted = data_addr >> 2;

  assign data_read_data = memory[data_addr_shifted];

  always @(data_addr_shifted, data_write_data, posedge data_sig_mem_write) begin
    if (data_sig_mem_write) memory[data_addr_shifted] <= data_write_data;
  end

  // Print strings from data memory

  reg [1:0] byte_offset = 0;
  reg [31:0] word_offset = 0;
  reg [7:0] char;
  wire [31:0] word;

  assign data_print_addr_shifted = data_print_addr_shifted >> 2;
  assign word = memory[data_print_addr_shifted + word_offset];

  integer i;
  always @(data_print_addr_shifted) begin
    if (data_print_addr_shifted > 0) begin
      word_offset = 0;
      char = word[31:24];
      while (char != 8'h00) begin
        case (byte_offset)
          0: char = word[31:24];
          1: char = word[23:16];
          2: char = word[15:8];
          3: char = word[7:0];
        endcase
        if (char != 8'h00) $write("%c", char);
        if (byte_offset == 3) word_offset += 1;
        byte_offset += 1;
      end
      $display();
    end
  end

endmodule
