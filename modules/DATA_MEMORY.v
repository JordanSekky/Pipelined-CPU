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
  reg [31:0] mem [32'h7FFFFFFF:32'h7FF00000];

  // Will be undefined if writing in the same cycle
  assign read_data = mem[addr];

  always @(addr) begin
    if (sig_mem_write) mem[addr] <= write_data;
  end

endmodule
