module PIPELINE_FD (
    input [31:0] instr_f,
    input pc_plus_4_f,
    input sig_clr,
    input haz_enable,
    input clk,
    output reg [31:0] instr_d,
    output reg pc_plus_4_d);
    
  initial begin
    intstr_d <= 0;
    pc_plus_4_d <= 0;
  end
  
  always @(posedge clk) begin
    if (sig_clr == 1) begin
      intstr_d <= 0;
      pc_plus_4_d <= 0;
    end
    else if (haz_enable == 1) begin
      instr_d <= instr_f;
      pc_plus_4_d <= pc_plus_4_f;
    end
  end
endmodule
