/**
 * This testbench will test the PC register module to check that values
 * are properly storing and clearing on the clk posedge
 *
 * Notes:
 *  - Values should only change on posedge
 */
 module testbench();
 
  reg   [31:0]  pc;
  reg           stall_f;
  reg           clk;
  

  // Wires
  wire   [31:0] pcf;

  // Modules
  PC pc_module(
    .pc(pc),
    .haz_enable(~stall_f),
    .clk(clk),
    .pcf(pcf));

  initial begin
    pc = 32'h11111111;
    stall_f = 1'b0;
    clk = 1'b0;
    #5;
    $display("============ 0 ============");
    $display("pcf = %h", pcf); // 000400020
    clk = 1'b1;
    #5;
    $display("============ 0 ============");
    $display("pcf = %h", pcf); // 11111111

    pc = 32'h22222222;
    stall_f = 1'b1;
    clk = 1'b0;
    #5;
    $display("============ 1 ============");
    $display("pcf = %h", pcf); // 11111111
    clk = 1'b1;
    #5;
    $display("============ 1 ============");
    $display("pcf = %h", pcf); // 11111111

    stall_f = 1'b0;
    clk = 1'b0;
    #5;
    $display("============ 2 ============");
    $display("pcf = %h", pcf); // 11111111
    clk = 1'b1;
    #5;
    $display("============ 2 ============");
    $display("pcf = %h", pcf); // 22222222

    $finish;
  end
 
 endmodule
