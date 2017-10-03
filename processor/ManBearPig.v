/**
 * This testbench will test the DATA_MEMORY module.
 *
 * Notes:
 *  - DATA_MEMORY store memory in an array of registers in the range
 *    [32'h7FFFFFFF:32'h7FF00000].
 *  - Should store data only when sig_mem_write is high
 *  - Should always return 32'hXXXXXXXX and not write if the address
 *    is out of the above range.
 */
module testbench();

  // =================================================
  // ===                   Wires                   ===
  // =================================================

  // ===================== Fetch =====================
  wire [31:0] pc;
  wire [31:0] pcF;
  wire [31:0] InstF;
  wire [31:0] PCPlus4F;
  wire [31:0] JumpMuxOutD;

  wire        StallF;

  // ==================== Decode =====================
  wire [1:0]  JumpD;
  wire        UpperD;
  wire        RegWriteD;
  wire        MemToRegD;
  wire        MemWriteD;
  wire [4:0]  ALUControlD;
  wire        ALUSrcD;
  wire        RegDstD;
  wire        BranchD;
  wire [3:0]  BCUControlD;
  wire       PCSrcD;
  wire        BCUOut;
  wire        JALD;

  wire [31:0] JumpExtendD;
  wire [31:0] PCBranchD;
  wire [31:0] InstD;
  wire [31:0] PCPlus4D;
  wire [31:0] SignImmD;
  wire [31:0] RD1D;
  wire [31:0] RD2D;
  wire [31:0] RD1MuxOut;
  wire [31:0] RD2MuxOut;
  wire [31:0] WriteDataD;

  wire        ForwardAD;
  wire        ForwardBD;
  wire        StallD;

  // ==================== Execute ====================
  wire        RegWriteE;
  wire        MemToRegE;
  wire        MemWriteE;
  wire [4:0]  ALUControlE;
  wire        ALUSrcE;
  wire        RegDstE;
  wire        UpperE;

  wire [31:0] RD1E;
  wire [31:0] RD2E;
  wire [4:0]  rsE;
  wire [4:0]  rtE;
  wire [4:0]  rdE;
  wire [4:0]  WriteRegE;
  wire [31:0] SignImmE;
  wire [31:0] SrcAE;
  wire [31:0] ForwardBEMuxOut;
  wire [31:0] SrcBE;
  wire [31:0] WriteDataE;
  wire [31:0] ALUOutE;

  wire [1:0]  ForwardAE;
  wire [1:0]  ForwardBE;
  wire        FlushE;

  // ================== Data Memory ==================
  wire        RegWriteM;
  wire        MemToRegM;
  wire        MemWriteM;
  wire        UpperM;

  wire [31:0] ALUOutM;
  wire [31:0] WriteDataM;
  wire [4:0]  WriteRegM;
  wire [31:0] ReadDataM;

  // =================== Writeback ===================
  wire        RegWriteW;
  wire        MemToRegW;
  wire        UpperW;

  wire [31:0] ReadDataW;
  wire [31:0] ALUOutW;
  wire [4:0] WriteRegW;
  wire [31:0] Result16W;
  wire [31:0] Result32W;


  // =================================================
  // ===                 Registers                 ===
  // =================================================
  reg         clk;

  // =================================================
  // ===                  Modules                  ===
  // =================================================

  // ===================== Fetch =====================
  PC program_counter(
    .pc(pc),
    .haz_enable(~StallF), // <-- use ~ to negate StallF
    .clk(clk),
    .pcf(pcF)
    );
  INST_MEM inst_mem(
    .pc(pcF),
    .instr(InstF)
    );
  ADDER pc_adder(
    .input_a(pcF),
    .input_b(4),
    .result(PCPlus4F)
    );
  THREE_MUX #(32) jump_mux(
    .sig_control(JumpD),
    .input_a(PCPlus4F),
    .input_b(JumpExtendD),
    .input_c(RD1D),
    .result(JumpMuxOutD)
    );
  TWO_MUX #(32) branch_mux(
    .sig_control(PCSrcD),
    .input_lo(JumpMuxOutD),
    .input_hi(PCBranchD),
    .result(pc)
    );

  // ==================== Decode =====================
  PIPELINE_FD pipeline_fd(
    .instr_f(InstF),
    .pc_plus_4_f(PCPlus4F),
    .sig_clr(PCSrcD),
    .haz_enable(~StallD),     // <-- Negate that jawn
    .clk(clk),
    .instr_d(InstD),
    .pc_plus_4_d(PCPlus4D)
    );
  REGISTERS registers(
    .rs(InstD[25:21]),
    .rt(InstD[20:16]),
    .rd(WriteRegW),
    .write_data(WriteDataD),
    .sig_jal(JALD),
    .sig_reg_write(RegWriteW),
    .clk(clk),
    .instr(InstD),
    .read_data_1(RD1D),
    .read_data_2(RD2D)
    );
  CONTROL_UNIT control_unit(
    .op_code(InstD[31:26]),
    .funct_code(InstD[5:0]),
    .load_upper(UpperD),
    .jump(JumpD),
    .jal(JALD),
    .reg_write(RegWriteD),
    .mem_to_reg(MemToRegD),
    .mem_write(MemWriteD),
    .alu_control(ALUControlD),
    .alu_src(ALUSrcD),
    .reg_dst(RegDstD),
    .branch(BranchD),
    .bcu_control(BCUControlD)
    );
  SIGN_EXTEND sign_extend(
    .sign_in(InstD[15:0]),
    .sign_out(SignImmD)
    );
  JUMP_SHIFT_TWO jump_shift_two(
    .upper_pc_plus_four(PCPlus4F[31:28]),
    .jump_imm(InstD[25:0]),
    .jump_addr(JumpExtendD)
    );
  ADDER branch_adder(
    .input_a({SignImmD[29:0], 2'b00}), // <-- Left Shift 2
    .input_b(PCPlus4D),
    .result(PCBranchD)
    );
  TWO_MUX #(32) rd1_mux(
    .sig_control(ForwardAD),
    .input_hi(ALUOutM),
    .input_lo(RD1D),
    .result(RD1MuxOut)
    );
  TWO_MUX #(32) rd2_mux(
    .sig_control(ForwardBD),
    .input_hi(ALUOutM),
    .input_lo(RD2D),
    .result(RD2MuxOut)
    );
  BCU bcu(
    .sig_bcu_control(BCUControlD),
    .rd1(RD1MuxOut),
    .rd2(RD2MuxOut),
    .branch(BCUOut)
    );
  TWO_MUX write_data_mux(
    .sig_control(JALD),
    .input_hi(PCPlus4D),
    .input_lo(Result32W),
    .result(WriteDataD)
    );
  assign PCSrcD = BranchD & BCUOut;

  // ==================== Execute ====================
  PIPELINE_DE pipeline_de(
    .reg_write_d(RegWriteD),
    .mem_to_reg_d(MemToRegD),
    .mem_write_d(MemWriteD),
    .alu_control_d(ALUControlD),
    .alu_src_d(ALUSrcD),
    .reg_dst_d(RegDstD),
    .read_data_1_d(RD1D),
    .read_data_2_d(RD2D),
    .rs_d(InstD[25:21]),
    .rt_d(InstD[20:16]),
    .rd_d(InstD[15:11]),
    .sign_imm_d(SignImmD),
    .upper_d(UpperD),
    .clk(clk),
    .sig_clr(FlushE),
    .reg_write_e(RegWriteE),
    .mem_to_reg_e(MemToRegE),
    .mem_write_e(MemWriteE),
    .alu_control_e(ALUControlE),
    .alu_src_e(ALUSrcE),
    .reg_dst_e(RegDstE),
    .read_data_1_e(RD1E),
    .read_data_2_e(RD2E),
    .rs_e(rsE),
    .rt_e(rtE),
    .rd_e(rdE),
    .sign_imm_e(SignImmE),
    .upper_e(UpperE)
    );
  TWO_MUX #(5) reg_write_mux_e(
    .sig_control(RegDstE),
    .input_lo(rtE),
    .input_hi(rdE),
    .result(WriteRegE)
    );
  THREE_MUX #(32) rd1_mux_e(
    .sig_control(ForwardAE),
    .input_a(RD1E),
    .input_b(Result16W),
    .input_c(ALUOutM),
    .result(SrcAE)
    );
  THREE_MUX #(32) rd2_mux_e(
    .sig_control(ForwardBE),
    .input_a(RD2E),
    .input_b(Result16W),
    .input_c(ALUOutM),
    .result(ForwardBEMuxOut)
    );
  TWO_MUX #(32) src_b_mux(
    .sig_control(ALUSrcE),
    .input_lo(ForwardBEMuxOut),
    .input_hi(SignImmE),
    .result(SrcBE)
    );
  ALU alu(
    .src_a(SrcAE),
    .src_b(SrcBE),
    .sig_alu_control(ALUControlE),
    .result(ALUOutE)
    );

  // ================== Data Memory ==================
  PIPELINE_EM pipeline_em(
    .reg_write_e(RegWriteE),
    .mem_to_reg_e(MemToRegE),
    .mem_write_e(MemWriteE),
    .alu_result_e(ALUOutE),
    .write_data_e(WriteDataE),
    .write_reg_e(WriteRegE),
    .upper_e(UpperE),
    .clk(clk),
    .reg_write_m(RegWriteM),
    .mem_to_reg_m(MemToRegM),
    .mem_write_m(MemWriteM),
    .alu_result_m(ALUOutM),
    .write_data_m(WriteDataM),
    .write_reg_m(WriteRegM),
    .upper_m(UpperM)
    );

  DATA_MEMORY data_memory(
    .sig_mem_write(MemWriteM),
    .addr(ALUOutM),
    .write_data(WriteDataM),
    .read_data(ReadDataM)
    );

  // =================== Writeback ===================
  PIPELINE_MW pipeline_mw(
    .reg_write_m(RegWriteM),
    .mem_to_reg_m(MemToRegM),
    .upper_m(UpperM),
    .alu_result_m(ALUOutM),
    .read_data_m(ReadDataM),
    .write_reg_m(WriteRegM),
    .clk(clk),
    .reg_write_w(RegWriteW),
    .mem_to_reg_w(MemToRegW),
    .upper_w(UpperW),
    .alu_result_w(ALUOutW),
    .read_data_w(ReadDataW),
    .write_reg_w(WriteRegW)
    );
  TWO_MUX #(32) mem_to_reg_mux(
    .sig_control(MemToRegW),
    .input_hi(ReadDataW),
    .input_lo(ALUOutW),
    .result(Result16W)
    );
  TWO_MUX #(32) result_hi_lo_mux(
    .sig_control(UpperW),
    .input_lo(Result16W),               // <-- No need to shift
    .input_hi({Result16W[15:0],16'b0}), // <-- Necessary for lui
    .result(Result32W)
    );

  // ================== Hazard Unit ==================
  HAZARD_UNIT hazard_unit(
    .sig_jump_d(JumpD),
    .sig_branch_d(BranchD),
    .rs_d(InstD[25:21]),
    .rt_d(InstD[20:16]),
    .rs_e(rsE),
    .rt_e(rtE),
    .write_reg_e(WriteRegE),
    .write_reg_m(WriteRegM),
    .write_reg_w(WriteRegW),
    .sig_reg_write_e(RegWriteE),
    .sig_mem_to_reg_e(MemToRegE),
    .sig_reg_write_m(RegWriteM),
    .sig_mem_to_reg_m(MemToRegM),
    .sig_reg_write_w(RegWriteW),
    .stall_f(StallF),
    .stall_d(StallD),
    .forward_a_d(ForwardAD),
    .forward_b_d(ForwardBD),
    .flush_e(FlushE),
    .forward_a_e(ForwardAE),
    .forward_b_e(ForwardBE)
    );

  // ==================================================
  // ===                 Statements                 ===
  // ==================================================

  integer LineNumber;

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,testbench);
    LineNumber = 0;
    clk <= 0;
    #1000;
    $finish;
  end

  always begin
    #5; clk = ~clk;
  end

  always @(posedge clk)
  begin
    $display("===========(%2d)===========", LineNumber);
    $display("%x: %x", pcF, InstF);
    // $display("PCPlus4F:    %x", PCPlus4F);
    // $display("JumpMuxOutD: %x", JumpMuxOutD);
    // $display("BranchD:     %x", BranchD);
    // $display("pc:          %x", pc);
    LineNumber = LineNumber + 1;
  end

endmodule
