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

  reg [31:0] memory [(`memory_size_lo >> 2):(`memory_size_hi >> 2)]; // Memory block.

  integer j = 0;
  integer OtherWord;
  `ifndef TEST_H
    initial begin
        $readmemh("../mips/merge_test/merge_test.bin", memory);
        // while (j < 3) begin
        //   OtherWord = memory[(32'h00410040>>2)+j];
        //   //OtherWord = memory[(32'h004102c4>>2)+j];
        //   //OtherWord = memory[(32'h004102f8>>2)+j];
        //
        //   $display("Memory[%x][0] = %s", (32'h004102f8>>2)+j, OtherWord[31:24]);
        //   $display("Memory[%x][1] = %s", (32'h004102f8>>2)+j, OtherWord[23:16]);
        //   $display("Memory[%x][2] = %s", (32'h004102f8>>2)+j, OtherWord[15:8]);
        //   $display("Memory[%x][3] = %s", (32'h004102f8>>2)+j, OtherWord[7:0]);
        //   j = j + 1;
        // end
    end
  `endif
  `ifdef TEST_H
    always @(data_addr or instr_pc or data_print_addr) begin
      if (((data_addr) < `memory_size_lo) || ((data_addr) > `memory_size_hi))
        $display("memory address %x out of bounds.", (data_addr));
    end
  `endif

  // =================================================
  // ===            Instruction Memory             ===
  // =================================================


  assign instr_out = memory[instr_pc >> 2];


  // =================================================
  // ===               Data Memory                 ===
  // =================================================


  wire [31:0] data_addr_shifted;
  wire [1:0]  data_byte_offset;
  assign data_addr_shifted = data_addr >> 2;
  assign data_byte_offset = data_addr[1:0];

  assign data_read_data = memory[data_addr_shifted];

  always @(data_addr_shifted, data_write_data, posedge data_sig_mem_write) begin
    if (data_sig_mem_write) begin
      memory[data_addr_shifted] <= data_write_data;
    end
  end

  // Print strings from data memory
  reg  [31:0] print_char_addr = 0;
  reg  [7:0]  char;
  reg  [31:0] word;

  always @(data_print_addr) begin
    print_char_addr = data_print_addr;
    if (print_char_addr > 0) begin
      word = memory[print_char_addr >> 2];
      case (print_char_addr[1:0])
        3: char = word[31:24];
        2: char = word[23:16];
        1: char = word[15:8];
        0: char = word[7:0];
      endcase
      while (char != 8'h0) begin
        $write("%c", char);
        print_char_addr += 32'h00000001;
        word = memory[print_char_addr >> 2];
        case (print_char_addr[1:0])
          3: char = word[31:24];
          2: char = word[23:16];
          1: char = word[15:8];
          0: char = word[7:0];
        endcase
      end
    end
  end

endmodule
