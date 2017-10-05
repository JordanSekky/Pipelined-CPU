`ifndef TEST_H
  `include "../includes/ManBearPig.h"   
`endif    
`ifdef TEST_H   
  `include "../../includes/ManBearPig.h"    
`endif

/*
 * A data memory module. If sig_mem_write is true, write_data will be written to
 * mem[addr]. If sig_mem_write is false, read_data will output the values at
 * mem[addr], and nothing will be written.
 */
module DATA_MEMORY(
  input  wire        sig_mem_write,
  input  wire [31:0] addr,
  input  wire [31:0] write_data,
  input  wire [31:0] print_string_m,
  output wire [31:0] read_data
  );

  // Memory
  reg [31:0] mem [`data_mem_hi:`data_mem_lo];


  reg [1:0] byte_offset = 0;
  reg [31:0] word_offset = 0;

  reg [7:0] char;
  wire [31:0] word;
  assign word = mem[print_string_m + word_offset];

  // Will be undefined if writing in the same cycle
  assign read_data = mem[addr];

  always @(addr, write_data, posedge sig_mem_write) begin
    if (sig_mem_write) mem[addr] <= write_data;
  end
  
  integer i;

  always @(print_string_m) begin
    if (print_string_m > 0) begin
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
