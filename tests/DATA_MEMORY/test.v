/**
 * This testbench will test the DATA_MEMORY module.
 *
 * Notes:
 *  - DATA_MEMORY store memory in an array of registers in the range
 *    [32'h7FFFFFFF:32'h7FF00000].
 *  - Should store data only when sig_mem_write is high
 *  - Should always return 32'hXXXXXXXX and not write if the address
 *    is out of the above range.
 */
module testbench();

  // Registers
  reg           sig_mem_write;
  reg   [31:0]  addr;
  reg   [31:0]  write_data;

  // Wires
  wire  [31:0]  read_data;

  // Modules
  DATA_MEMORY data_memory(
    sig_mem_write,
    addr,
    write_data,
    read_data);

  initial begin
    $monitor(
      "Write(%b) %h\nmem[%h] = %h\n",
      sig_mem_write,
      write_data, addr,
      read_data);

    write_data = 32'h00000000;
    sig_mem_write = 1'b0;
    addr = 32'h7fffffff;
    #10; // 00000000

    write_data = 32'hdeadbeef;
    addr = addr-1;
    sig_mem_write = 1'b1;
    #10; // 00000000

    write_data = 32'h12345678;
    addr = addr+1;
    sig_mem_write = 1'b1;
    #10; // 00000000

    write_data = 32'h0000dead;
    addr = addr-1;
    sig_mem_write = 1'b0;
    #10; // 00000000

    write_data = 32'hbeef0000;
    addr = addr+1;
    sig_mem_write = 1'b0;
    #10; // 00000000

    $finish;
  end




endmodule
