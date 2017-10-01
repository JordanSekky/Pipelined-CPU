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
  output wire [31:0] read_data
  );

  // Memory
  reg [31:0] mem [`data_mem_hi:`data_mem_lo];

  // Will be undefined if writing in the same cycle
  assign read_data = mem[addr];

  always @(addr, write_data, posedge sig_mem_write) begin
    if (sig_mem_write) mem[addr] <= write_data;
  end

endmodule
