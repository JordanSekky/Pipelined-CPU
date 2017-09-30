/**
 * This testbench will test the de register module to check that the values
 * are properly storing and clearing on clk posedge
 *
 * Notes:
 *  - Vlues should only change on posedge
 *  - Values will update to 0 if sig_clr.
 */
module testbench();

  // Registers
  reg           reg_write_d;
  reg           mem_to_reg_d;
  reg           mem_write_d;
  reg   [4:0]   alu_control_d;
  reg           alu_src_d;
  reg           reg_dst_d;
  reg   [31:0]  read_data_1_d;
  reg   [31:0]  read_data_2_d;
  reg   [4:0]   rs_d;
  reg   [4:0]   rt_d;
  reg   [4:0]   rd_d;
  reg   [31:0]  sign_imm_d;
  reg           clk;
  reg           sig_clr;

  // Wires
  wire          reg_write_e;
  wire          mem_to_reg_e;
  wire          mem_write_e;
  wire  [4:0]   alu_control_e;
  wire          alu_src_e;
  wire          reg_dst_e;
  wire  [31:0]  read_data_1_e;
  wire  [31:0]  read_data_2_e;
  wire  [4:0]   rs_e;
  wire  [4:0]   rt_e;
  wire  [4:0]   rd_e;
  wire  [31:0]  sign_imm_e;

  // Modules
  PIPELINE_DE pipeline_de(
    .reg_write_d(reg_write_d),
    .mem_to_reg_d(mem_to_reg_d),
    .mem_write_d(mem_write_d),
    .alu_control_d(alu_control_d),
    .alu_src_d(alu_src_d),
    .reg_dst_d(reg_dst_d),
    .read_data_1_d(read_data_1_d),
    .read_data_2_d(read_data_2_d),
    .rs_d(rs_d),
    .rt_d(rt_d),
    .rd_d(rd_d),
    .sign_imm_d(sign_imm_d),
    .clk(clk),
    .sig_clr(sig_clr),
    .reg_write_e(reg_write_e),
    .mem_to_reg_e(mem_to_reg_e),
    .mem_write_e(mem_write_e),
    .alu_control_e(alu_control_e),
    .alu_src_e(alu_src_e),
    .reg_dst_e(reg_dst_e),
    .read_data_1_e(read_data_1_e),
    .read_data_2_e(read_data_2_e),
    .rs_e(rs_e),
    .rt_e(rt_e),
    .rd_e(rd_e),
    .sign_imm_e(sign_imm_e)
    );

  initial begin
    reg_write_d = 1'b0;
    mem_to_reg_d = 1'b0;
    mem_write_d = 1'b0;
    alu_control_d = 5'h0;
    alu_src_d = 1'b0;
    reg_dst_d = 1'b0;
    read_data_1_d = 32'h0;
    read_data_2_d = 32'h0;
    rs_d = 5'h0;
    rt_d = 5'h0;
    rd_d = 5'h0;
    sign_imm_d = 32'h0;
    clk = 1'b0;
    sig_clr = 1'b0;
    #5;
    $display("============ 0 ============");
    $display("reg_write_e = %h", reg_write_e);
    $display("mem_to_reg_e = %h", mem_to_reg_e);
    $display("mem_write_e = %h", mem_write_e);
    $display("alu_control_e = %h", alu_control_e);
    $display("alu_src_e = %h", alu_src_e);
    $display("reg_dst_e = %h", reg_dst_e);
    $display("read_data_1_e = %h", read_data_1_e);
    $display("read_data_2_e = %h", read_data_2_e);
    $display("rs_e = %h", rs_e);
    $display("rt_e = %h", rt_e);
    $display("rd_e = %h", rd_e);
    $display("sign_imm_e = %h", sign_imm_e);
    clk = 1'b1;
    sig_clr = 1'b0;
    #5;
    $display("============ 0 ============");
    $display("reg_write_e = %h", reg_write_e);
    $display("mem_to_reg_e = %h", mem_to_reg_e);
    $display("mem_write_e = %h", mem_write_e);
    $display("alu_control_e = %h", alu_control_e);
    $display("alu_src_e = %h", alu_src_e);
    $display("reg_dst_e = %h", reg_dst_e);
    $display("read_data_1_e = %h", read_data_1_e);
    $display("read_data_2_e = %h", read_data_2_e);
    $display("rs_e = %h", rs_e);
    $display("rt_e = %h", rt_e);
    $display("rd_e = %h", rd_e);
    $display("sign_imm_e = %h", sign_imm_e);

    reg_write_d = 1'b1;
    mem_to_reg_d = 1'b1;
    mem_write_d = 1'b1;
    alu_control_d = 5'h5;
    alu_src_d = 1'b1;
    reg_dst_d = 1'b1;
    read_data_1_d = 32'h32;
    read_data_2_d = 32'h32;
    rs_d = 5'h1;
    rt_d = 5'h1;
    rd_d = 5'h1;
    sign_imm_d = 32'h32;
    clk = 1'b0;
    sig_clr = 1'b0;
    #5;
    $display("============ 1 ============");
    $display("reg_write_e = %h", reg_write_e);
    $display("mem_to_reg_e = %h", mem_to_reg_e);
    $display("mem_write_e = %h", mem_write_e);
    $display("alu_control_e = %h", alu_control_e);
    $display("alu_src_e = %h", alu_src_e);
    $display("reg_dst_e = %h", reg_dst_e);
    $display("read_data_1_e = %h", read_data_1_e);
    $display("read_data_2_e = %h", read_data_2_e);
    $display("rs_e = %h", rs_e);
    $display("rt_e = %h", rt_e);
    $display("rd_e = %h", rd_e);
    $display("sign_imm_e = %h", sign_imm_e);
    clk = 1'b1;
    sig_clr = 1'b0;
    #5;
    $display("============ 1 ============");
    $display("reg_write_e = %h", reg_write_e);
    $display("mem_to_reg_e = %h", mem_to_reg_e);
    $display("mem_write_e = %h", mem_write_e);
    $display("alu_control_e = %h", alu_control_e);
    $display("alu_src_e = %h", alu_src_e);
    $display("reg_dst_e = %h", reg_dst_e);
    $display("read_data_1_e = %h", read_data_1_e);
    $display("read_data_2_e = %h", read_data_2_e);
    $display("rs_e = %h", rs_e);
    $display("rt_e = %h", rt_e);
    $display("rd_e = %h", rd_e);
    $display("sign_imm_e = %h", sign_imm_e);

    clk = 1'b0;
    sig_clr = 1'b0;
    #5;
    $display("============ 2 ============");
    $display("reg_write_e = %h", reg_write_e);
    $display("mem_to_reg_e = %h", mem_to_reg_e);
    $display("mem_write_e = %h", mem_write_e);
    $display("alu_control_e = %h", alu_control_e);
    $display("alu_src_e = %h", alu_src_e);
    $display("reg_dst_e = %h", reg_dst_e);
    $display("read_data_1_e = %h", read_data_1_e);
    $display("read_data_2_e = %h", read_data_2_e);
    $display("rs_e = %h", rs_e);
    $display("rt_e = %h", rt_e);
    $display("rd_e = %h", rd_e);
    $display("sign_imm_e = %h", sign_imm_e);
    clk = 1'b1;
    sig_clr = 1'b1;
    #5;
    $display("============ 2 ============");
    $display("reg_write_e = %h", reg_write_e);
    $display("mem_to_reg_e = %h", mem_to_reg_e);
    $display("mem_write_e = %h", mem_write_e);
    $display("alu_control_e = %h", alu_control_e);
    $display("alu_src_e = %h", alu_src_e);
    $display("reg_dst_e = %h", reg_dst_e);
    $display("read_data_1_e = %h", read_data_1_e);
    $display("read_data_2_e = %h", read_data_2_e);
    $display("rs_e = %h", rs_e);
    $display("rt_e = %h", rt_e);
    $display("rd_e = %h", rd_e);
    $display("sign_imm_e = %h", sign_imm_e);

    $finish;
  end




endmodule
