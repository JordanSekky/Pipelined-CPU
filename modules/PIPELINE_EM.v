module PIPELINE_EM (
    input reg_write_e,
    input mem_to_reg_e,
    input mem_write_e,
    input [31:0] alu_result_e,
    input [31:0] write_data_e,
    input [4:0] write_reg_e,
    input clk,
    output reg reg_write_m,
    output reg mem_to_reg_m,
    output reg mem_write_m,
    output reg [31:0] alu_result_m,
    output reg [31:0] write_data_m,
    output reg [4:0] write_reg_m);
    
  initial begin
    reg_write_m <= 0;
    mem_to_reg_m <= 0;
    mem_write_m <= 0;
    alu_result_m <= 0;
    write_data_m <= 0;
    write_reg_m <= 0;
  end
  
  always @(posedge clk) begin
    reg_write_m <= reg_write_e;
    mem_to_reg_m <= mem_to_reg_e;
    mem_write_m <= mem_write_e;
    alu_result_m <= alu_result_e;
    write_data_m <= write_data_e;
    write_reg_m <= write_reg_e;
  end
endmodule
