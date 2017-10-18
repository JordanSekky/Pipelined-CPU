/**
 * This testbench will test the MW register module to check that the values
 * are properly storing and clearing on clk posedge
 *
 * Notes:
 *  - Values should only change on posedge
 */
module testbench();

  // Registers
  reg           reg_write_m;
  reg           mem_to_reg_m;
  reg   [31:0]  alu_result_m;
  reg   [31:0]  read_data_m;
  reg   [4:0]   write_reg_m;
  reg           clk;

  // Wires
  wire          reg_write_w;
  wire          mem_to_reg_w;
  wire   [31:0] alu_result_w;
  wire   [31:0] read_data_w;
  wire   [4:0]  write_reg_w;

  // Modules
  PIPELINE_MW pipeline_em(
    .reg_write_m(reg_write_m),
    .mem_to_reg_m(mem_to_reg_m),
    .alu_result_m(alu_result_m),
    .read_data_m(read_data_m),
    .write_reg_m(write_reg_m),
    .clk(clk),
    .reg_write_w(reg_write_w),
    .mem_to_reg_w(mem_to_reg_w),
    .alu_result_w(alu_result_w),
    .read_data_w(read_data_w),
    .write_reg_w(write_reg_w)
    );

  initial begin
    reg_write_m = 1;
    mem_to_reg_m = 1;
    alu_result_m = 32'h11111111;
    read_data_m = 32'h99999999;
    write_reg_m = 5'b00110;
    clk = 1'b0;
    #5;
    $display("============ 0 ============");
    $display("reg_write_w = %h", reg_write_w); // 0
    $display("mem_to_reg_w = %h", mem_to_reg_w); // 0
    $display("alu_result_w = %h", alu_result_w); // 0
    $display("read_data_w = %h", read_data_w); // 0
    $display("write_reg_w = %h", write_reg_w); // 0
    clk = 1'b1;
    #5;
    $display("============ 0 ============");
    $display("reg_write_w = %h", reg_write_w); // 1
    $display("mem_to_reg_w = %h", mem_to_reg_w); // 1
    $display("alu_result_w = %h", alu_result_w); // 11111111
    $display("read_data_w = %h", read_data_w); // 99999999
    $display("write_reg_w = %h", write_reg_w); // 6

    reg_write_m = 0;
    mem_to_reg_m = 0;
    alu_result_m = 32'h22222222;
    read_data_m = 32'h88888888;
    write_reg_m = 5'b00001;
    clk = 1'b0;
    #5;
    $display("============ 1 ============");
    $display("reg_write_w = %h", reg_write_w); // 1
    $display("mem_to_reg_w = %h", mem_to_reg_w); // 1
    $display("alu_result_w = %h", alu_result_w); // 11111111
    $display("read_data_w = %h", read_data_w); // 99999999
    $display("write_reg_w = %h", write_reg_w); // 6
    clk = 1'b1;
    #5;
    $display("============ 1 ============");
    $display("reg_write_w = %h", reg_write_w); // 0
    $display("mem_to_reg_w = %h", mem_to_reg_w); // 0
    $display("alu_result_w = %h", alu_result_w); // 22222222
    $display("read_data_w = %h", read_data_w); // 88888888
    $display("write_reg_w = %h", write_reg_w); // 1
    $finish;
  end
endmodule
