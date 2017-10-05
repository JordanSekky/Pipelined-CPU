module PIPELINE_EM (
    input wire reg_write_e,
    input wire mem_to_reg_e,
    input wire mem_write_e,
    input wire [31:0] alu_result_e,
    input wire [31:0] write_data_e,
    input wire [4:0] write_reg_e,
    input wire upper_e,
    input wire [31:0] read_data_1_e,
    input wire [31:0] read_data_2_e,
    input wire syscall_e,
    input wire clk,
    output reg reg_write_m,
    output reg mem_to_reg_m,
    output reg mem_write_m,
    output reg [31:0] alu_result_m,
    output reg [31:0] write_data_m,
    output reg [4:0] write_reg_m,
    output reg upper_m,
    output reg [31:0] read_data_1_m,
    output reg [31:0] read_data_2_m,
    output reg syscall_m);

  initial begin
    reg_write_m <= 0;
    mem_to_reg_m <= 0;
    mem_write_m <= 0;
    alu_result_m <= 0;
    write_data_m <= 0;
    write_reg_m <= 0;
    upper_m <= 0;
    syscall_m <= 0;
  end

  always @(posedge clk) begin
    reg_write_m <= reg_write_e;
    mem_to_reg_m <= mem_to_reg_e;
    mem_write_m <= mem_write_e;
    alu_result_m <= alu_result_e;
    write_data_m <= write_data_e;
    write_reg_m <= write_reg_e;
    upper_m <= upper_e;
    read_data_1_m <= read_data_1_e;
    read_data_2_m <= read_data_2_e;
    syscall_m <= syscall_e;
  end
endmodule
