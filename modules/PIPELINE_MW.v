module PIPELINE_MW (
    input reg_write_m,
    input mem_to_reg_m,
    input [31:0] alu_result_m,
    input [31:0] write_data_m,
    input [4:0] write_reg_m,
    input clk,
    output reg reg_write_w,
    output reg mem_to_reg_w,
    output reg [31:0] alu_result_w,
    output reg [31:0] write_data_w,
    output reg [4:0] write_reg_w);
    
  initial begin
    reg_write_w <= 0;
    mem_to_reg_w <= 0;
    alu_result_w <= 0;
    write_data_w <= 0;
    write_reg_w <= 0;
  end
  
  always @(posedge clk) begin
    reg_write_w <= reg_write_m;
    mem_to_reg_w <= mem_to_reg_m;
    alu_result_w <= alu_result_m;
    write_data_w <= write_data_m;
    write_reg_w <= write_reg_m;
  end
endmodule
