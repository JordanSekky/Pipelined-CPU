/**
 * This testbench will test the FD register module to check that values
 * are properly storing and clearing on the clk posedge
 *
 * Notes:
 *  - Values should only change on posedge
 */
 module testbench();
 
  reg   [31:0]  instr_f;
  reg   [31:0]  pc_plus_4_f;
  reg           sig_clr;
  reg           stall_d;
  reg           clk;
  

  // Wires
  wire   [31:0] instr_d;
  wire   [31:0] pc_plus_4_d;

  // Modules
  PIPELINE_FD pipeline_fd(
    .instr_f(instr_f),
    .pc_plus_4_f(pc_plus_4_f),
    .sig_clr(sig_clr),
    .haz_enable(~stall_d),
    .clk(clk),
    .instr_d(instr_d),
    .pc_plus_4_d(pc_plus_4_d));

  initial begin
    instr_f = 32'h11111111;
    pc_plus_4_f = 32'h99999999;
    
    sig_clr = 1'b0;
    stall_d = 1'b0;
    clk = 1'b0;
    #5;
    $display("============ 0 ============");
    $display("instr_d = %h", instr_d); // 00000000
    $display("pc_plus_4_d = %h", pc_plus_4_d); // 00000000
    clk = 1'b1;
    #5;
    $display("============ 0 ============");
    $display("instr_d = %h", instr_d); // 11111111
    $display("pc_plus_4_d = %h", pc_plus_4_d); // 99999999


    instr_f = 32'h22222222;
    pc_plus_4_f = 32'h88888888;
    sig_clr = 1'b0;
    stall_d = 1'b1;
    clk = 1'b0;
    #5;
    $display("============ 1 ============");
    $display("instr_d = %h", instr_d); // 11111111
    $display("pc_plus_4_d = %h", pc_plus_4_d); // 99999999
    clk = 1'b1;
    #5;
    $display("============ 1 ============");
    $display("instr_d = %h", instr_d); // 11111111
    $display("pc_plus_4_d = %h", pc_plus_4_d); // 99999999

    sig_clr = 1'b1;
    stall_d = 1'b1;
    clk = 1'b0;
    #5;
    $display("============ 2 ============");
    $display("instr_d = %h", instr_d); // 11111111
    $display("pc_plus_4_d = %h", pc_plus_4_d); // 99999999
    clk = 1'b1;
    #5;
    $display("============ 2 ============");
    $display("instr_d = %h", instr_d); // 00000000
    $display("pc_plus_4_d = %h", pc_plus_4_d); // 00000000

    $finish;
  end
 endmodule
