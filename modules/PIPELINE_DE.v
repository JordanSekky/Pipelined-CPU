module PIPELINE_DE (
    input wire reg_write_d,
    input wire mem_to_reg_d,
    input wire mem_write_d,
    input wire [4:0] alu_control_d,
    input wire alu_src_d,
    input wire reg_dst_d,
    input wire [31:0] read_data_1_d,
    input wire [31:0] read_data_2_d,
    input wire [4:0] rs_d,
    input wire [4:0] rt_d,
    input wire [4:0] rd_d,
    input wire [31:0] sign_imm_d,
    input wire upper_d,
    input wire jal_d,
    input wire syscall_d,
    input wire clk,
    input wire sig_clr,
    output reg reg_write_e,
    output reg mem_to_reg_e,
    output reg mem_write_e,
    output reg [4:0] alu_control_e,
    output reg alu_src_e,
    output reg reg_dst_e,
    output reg [31:0] read_data_1_e,
    output reg [31:0] read_data_2_e,
    output reg [4:0] rs_e,
    output reg [4:0] rt_e,
    output reg [4:0] rd_e,
    output reg [31:0] sign_imm_e,
    output reg upper_e,
    output reg jal_e,
    output reg syscall_e);

  initial begin
    reg_write_e <= 0;
    mem_to_reg_e <= 0;
    mem_write_e <= 0;
    alu_control_e <= 0;
    alu_src_e <= 0;
    reg_dst_e <= 0;
    read_data_1_e <= 0;
    read_data_2_e <= 0;
    rs_e <= 0;
    rt_e <= 0;
    rd_e <= 0;
    sign_imm_e <= 0;
    upper_e <= 0;
    syscall_e <= 0;
  end

  always @(posedge clk) begin
    if (sig_clr == 1) begin
      reg_write_e <= 0;
      mem_to_reg_e <= 0;
      mem_write_e <= 0;
      alu_control_e <= 0;
      alu_src_e <= 0;
      reg_dst_e <= 0;
      read_data_1_e <= 0;
      read_data_2_e <= 0;
      rs_e <= 0;
      rt_e <= 0;
      rd_e <= 0;
      sign_imm_e <= 0;
      upper_e <= 0;
      jal_e <= 0;
      syscall_e <= 0;
    end
    else begin
      reg_write_e <= reg_write_d;
      mem_to_reg_e <= mem_to_reg_d;
      mem_write_e <= mem_write_d;
      alu_control_e <= alu_control_d;
      alu_src_e <= alu_src_d;
      reg_dst_e <= reg_dst_d;
      read_data_1_e <= read_data_1_d;
      read_data_2_e <= read_data_2_d;
      rs_e <= rs_d;
      rt_e <= rt_d;
      rd_e <= rd_d;
      sign_imm_e <= sign_imm_d;
      upper_e <= upper_d;
      jal_e <= syscall_d;
      syscall_e <= syscall_d;
    end
  end
endmodule
