/**
 * This testbench will test the de register module to check that the values
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
  reg   [4:0]   alu_result_e;
  reg   [31:0]  write_data_e;
  reg   [4:0]   write_reg_e;
  reg           clk;

  // Wires
  wire          reg_write_m;
  wire          mem_to_reg_m;
  wire          mem_write_m;
  wire   [4:0]  alu_result_m;
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
    reg_write_e;
    mem_to_reg_e;
    mem_write_e;
    alu_result_e = 5'h0;
    write_data_e = 32'h0;
    write_reg_e = 5'h0;
    #5;
    $display("============ 0 ============");
    $display("reg_write_m = %h", reg_write_m);
    $display("mem_to_reg_m = %h", mem_to_reg_m);
    $display("mem_write_m = %h", mem_write_m);
    $display("alu_result_m = %h", alu_result_m);
    $display("write_data_m = %h", write_data_m);
    $display("write_reg_m = %h", write_reg_m);
    clk = 1'b1;
    sig_clr = 1'b0;
    #5;
    $display("============ 0 ============");
    $display("reg_write_m = %h", reg_write_m);
    $display("mem_to_reg_m = %h", mem_to_reg_m);
    $display("mem_write_m = %h", mem_write_m);
    $display("alu_result_m = %h", alu_result_m);
    $display("write_data_m = %h", write_data_m);
    $display("write_reg_m = %h", write_reg_m);

    reg_write_e;
    mem_to_reg_e;
    mem_write_e;
    alu_result_e = 5'h0;
    write_data_e = 32'h0;
    write_reg_e = 5'h0;
    #5;
    $display("============ 0 ============");
    $display("reg_write_m = %h", reg_write_m);
    $display("mem_to_reg_m = %h", mem_to_reg_m);
    $display("mem_write_m = %h", mem_write_m);
    $display("alu_result_m = %h", alu_result_m);
    $display("write_data_m = %h", write_data_m);
    $display("write_reg_m = %h", write_reg_m);
    clk = 1'b1;
    sig_clr = 1'b0;
    #5;
    $display("============ 0 ============");
    $display("reg_write_m = %h", reg_write_m);
    $display("mem_to_reg_m = %h", mem_to_reg_m);
    $display("mem_write_m = %h", mem_write_m);
    $display("alu_result_m = %h", alu_result_m);
    $display("write_data_m = %h", write_data_m);
    $display("write_reg_m = %h", write_reg_m);

    reg_write_e;
    mem_to_reg_e;
    mem_write_e;
    alu_result_e = 5'h0;
    write_data_e = 32'h0;
    write_reg_e = 5'h0;
    #5;
    $display("============ 0 ============");
    $display("reg_write_m = %h", reg_write_m);
    $display("mem_to_reg_m = %h", mem_to_reg_m);
    $display("mem_write_m = %h", mem_write_m);
    $display("alu_result_m = %h", alu_result_m);
    $display("write_data_m = %h", write_data_m);
    $display("write_reg_m = %h", write_reg_m);
    clk = 1'b1;
    sig_clr = 1'b0;
    #5;
    $display("============ 0 ============");
    $display("reg_write_m = %h", reg_write_m);
    $display("mem_to_reg_m = %h", mem_to_reg_m);
    $display("mem_write_m = %h", mem_write_m);
    $display("alu_result_m = %h", alu_result_m);
    $display("write_data_m = %h", write_data_m);
    $display("write_reg_m = %h", write_reg_m);

    $finish;
  end




endmodule
