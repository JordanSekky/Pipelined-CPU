/*
 * PC register - the location of the current instruction in memory
 */
module PC (input [31:0] pc, input haz_enable, input clk, output reg [31:0] pcf);

initial begin
  pcf <= 32'h00400020;
end

always @(posedge clk) begin
  if (haz_enable == 1) begin
    pcf <= pc;
  end
end

endmodule
