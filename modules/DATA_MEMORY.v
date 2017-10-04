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
  
  initial begin
    print_string_m <= 32'h00000000;
  end

  // Memory
  reg [31:0] mem [`data_mem_hi:`data_mem_lo];
  reg [31:0] print_string_address;
  string print_string;
  string temp_string;
  reg [7:0] char;

  // Will be undefined if writing in the same cycle
  assign read_data = mem[addr];

  always @(addr, write_data, posedge sig_mem_write) begin
    if (sig_mem_write) mem[addr] <= write_data;
  end
  
  always @(print_string_m) begin
    if (print_string_m > 0) begin
      print_string_address = print_string_m;
      print_string = "";
      char = mem[print_string_address : print_string_address - 8];
      while (char != 8'h00) begin
        temp_string = "";
        print_string = {print_string, temp_string.hextoa(char)};
        print_string_address = print_string_address - 8;
        char = mem[print_string_address : print_string_address - 8];
      end
      $display("%s", print_string);
      print_string_m = 0;
    end
  end
  
  always 

endmodule
