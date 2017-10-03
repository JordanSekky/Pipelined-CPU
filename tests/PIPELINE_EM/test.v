/**
 * This testbench will test the EM register module to check that the values
 * are properly storing and clearing on clk posedge
 *
 * Notes:
 *  - Values should only change on posedge
 */
module testbench();

  // Registers
  reg           reg_write_e;
  reg           mem_to_reg_e;
  reg           mem_write_e;
  reg   [31:0]  alu_result_e;
  reg   [31:0]  write_data_e;
  reg   [4:0]   write_reg_e;
  reg           clk;

  // Wires
  wire          reg_write_m;
  wire          mem_to_reg_m;
  wire          mem_write_m;
  wire   [31:0] alu_result_m;
  wire   [31:0] write_data_m;
  wire   [4:0]  write_reg_m;

  // Modules
  PIPELINE_EM pipeline_em(
    .reg_write_e(reg_write_e),
    .mem_to_reg_e(mem_to_reg_e),
    .mem_write_e(mem_write_e),
    .alu_result_e(alu_result_e),
    .write_data_e(write_data_e),
    .write_reg_e(write_reg_e),
    .clk(clk),
    .reg_write_m(reg_write_m),
    .mem_to_reg_m(mem_to_reg_m),
    .mem_write_m(mem_write_m),
    .alu_result_m(alu_result_m),
    .write_data_m(write_data_m),
    .write_reg_m(write_reg_m)
    );

  initial begin
    reg_write_e = 1;
    mem_to_reg_e = 1;
    mem_write_e = 1;
    alu_result_e = 32'h11111111;
    write_data_e = 32'h99999999;
    write_reg_e = 5'b00110;
    clk = 1'b0;
    #5;
    $display("============ 0 ============");
    $display("reg_write_m = %h", reg_write_m); // 0
    $display("mem_to_reg_m = %h", mem_to_reg_m); // 0
    $display("mem_write_m = %h", mem_write_m); // 0
    $display("alu_result_m = %h", alu_result_m); // 0
    $display("write_data_m = %h", write_data_m); // 0
    $display("write_reg_m = %h", write_reg_m); // 0
    clk = 1'b1;
    #5;
    $display("============ 0 ============");
    $display("reg_write_m = %h", reg_write_m); // 1
    $display("mem_to_reg_m = %h", mem_to_reg_m); // 1
    $display("mem_write_m = %h", mem_write_m); // 1
    $display("alu_result_m = %h", alu_result_m); // 11111111
    $display("write_data_m = %h", write_data_m); // 99999999
    $display("write_reg_m = %h", write_reg_m); // 6

    reg_write_e = 0;
    mem_to_reg_e = 0;
    mem_write_e = 0;
    alu_result_e = 32'h22222222;
    write_data_e = 32'h88888888;
    write_reg_e = 5'b00001;
    clk = 1'b0;
    #5;
    $display("============ 1 ============");
    $display("reg_write_m = %h", reg_write_m); // 1
    $display("mem_to_reg_m = %h", mem_to_reg_m); // 1
    $display("mem_write_m = %h", mem_write_m); // 1
    $display("alu_result_m = %h", alu_result_m); // 11111111
    $display("write_data_m = %h", write_data_m); // 99999999
    $display("write_reg_m = %h", write_reg_m); // 6
    clk = 1'b1;
    #5;
    $display("============ 1 ============");
    $display("reg_write_m = %h", reg_write_m); // 0
    $display("mem_to_reg_m = %h", mem_to_reg_m); // 0
    $display("mem_write_m = %h", mem_write_m); // 0
    $display("alu_result_m = %h", alu_result_m); // 22222222
    $display("write_data_m = %h", write_data_m); // 88888888
    $display("write_reg_m = %h", write_reg_m); // 1
    $finish;
  end
endmodule
