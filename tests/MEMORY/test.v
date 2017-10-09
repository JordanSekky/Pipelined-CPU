`include "../../includes/ManBearPig.h"

module testbench();

  reg  [31:0] instr_pc = `mem_size_lo << 2;
  reg         data_sig_mem_write = 1'b0;
  reg  [31:0] data_addr = `mem_size_hi << 2;
  reg  [31:0] data_write_data = 32'b0;
  reg  [31:0] data_print_addr = 32'b0;
  wire [31:0] instr_out;
  wire [31:0] data_read_data;

  MEMORY memory(
    instr_pc,
    data_sig_mem_write,
    data_addr,
    data_write_data,
    data_print_addr,
    instr_out,
    data_read_data);

  initial begin
    $monitor(
      "Write(%b) %h\nmem[%h] = %h\n",
      data_sig_mem_write,
      data_write_data, data_addr,
      data_read_data);

    data_write_data = 32'hdeadbeef;
    data_addr = data_addr-4;
    data_sig_mem_write = 1'b1;
    #10;

    data_write_data = 32'h12345678;
    data_addr = data_addr+4;
    data_sig_mem_write = 1'b1;
    #10;

    data_write_data = 32'h0000dead;
    data_addr = data_addr-4;
    data_sig_mem_write = 1'b0;
    #10;

    data_write_data = 32'hbeef0000;
    data_addr = data_addr+4;
    data_sig_mem_write = 1'b0;
    #10;

    data_write_data = 32'h0000dead;
    data_addr = data_addr-4;
    data_sig_mem_write = 1'b0;
    #10;

    data_write_data = 32'hbeef0000;
    data_addr = data_addr+4;
    data_sig_mem_write = 1'b1;
    #10;
    
    // Test printing strings. 
    data_addr <= data_addr - 40;
    data_write_data <= 32'h68656c6c; // "hell"
    data_sig_mem_write <= 1'b1;
    #5;
    data_addr <= data_addr + 4;
    data_write_data <= 32'h6f20776f; // "o wo"
    #5;
    data_addr <= data_addr + 4;
    data_write_data <= 32'h726c6400; // "rld";
    #5;
    data_print_addr <= data_addr-8; // Print
    #10;

    // Test instruction memory reading from same module
    instr_pc <= data_addr;
    #10; $display("%h => %h\n", instr_pc, instr_out);
    instr_pc <= data_addr-4;
    #10; $display("%h => %h\n", instr_pc, instr_out);
    instr_pc <= data_addr-8;
    #10; $display("%h => %h\n", instr_pc, instr_out);

    $finish();
  end

endmodule