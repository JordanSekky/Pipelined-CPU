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

  wire [255:0]  MipsF;

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
  wire        SyscallD;

  wire [255:0] MipsD;

  wire [31:0] JumpExtendD;
  wire [31:0] PCBranchD;
  wire [31:0] InstD;
  wire [31:0] PCPlus4D;
  wire [31:0] SignImmD;
  wire [31:0] RD1D;
  wire [31:0] RD2D;
  wire [31:0] RD1MuxOut;
  wire [31:0] RD2MuxOut;
  // wire [31:0] WriteDataD;

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
  wire        JALE;
  wire        SyscallE;

  wire  [255:0] MipsE;

  wire [31:0] InstE;
  wire [31:0] RD1E;
  wire [31:0] RD2E;
  wire [4:0]  rsE;
  wire [4:0]  rtE;
  wire [4:0]  rdE;
  wire [4:0]  WriteRegE;
  wire [4:0]  WriteRegMuxMuxE;
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
  wire        SyscallM;

  reg [255:0] MipsM;

  wire [31:0] PrintStringM;

  wire [31:0] ALUOutM;
  wire [31:0] WriteDataM;
  wire [4:0]  WriteRegM;
  wire [31:0] ReadDataM;

  wire [31:0] a0M;
  wire [31:0] v0M;

  // =================== Writeback ===================
  wire        RegWriteW;
  wire        MemToRegW;
  wire        UpperW;
  wire        SyscallW;

  reg  [255:0] MipsW;

  wire [31:0] ReadDataW;
  wire [31:0] ALUOutW;
  wire [4:0] WriteRegW;
  wire [31:0] Result16W;
  wire [31:0] Result32W;
  
  // ============== Mult and Div support =============
  wire [31:0] hi;
  wire [31:0] lo;

  // =================================================
  // ===                 Registers                 ===
  // =================================================
  reg         clk;
  reg  [4:0]  RegRA = 5'b11111;

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
  BINARY_TO_MIPS b2m_F(
      InstF,
      MipsF);


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
    .write_data(Result32W),
    .sig_jal(JALD),
    .sig_reg_write(RegWriteW),
    .clk(~clk),
    .instr(InstD),
    .hi_reg(hi),
    .lo_reg(lo),
    .sig_syscall(SyscallD),
    .read_data_1(RD1D),
    .read_data_2(RD2D),
    .pc_plus_4(PCPlus4D),
    .a0(a0M),
    .v0(v0M)
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
    .bcu_control(BCUControlD),
    .syscall(SyscallD)
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
  BINARY_TO_MIPS b2m_D(
      InstD,
      MipsD);
  assign PCSrcD = BranchD && BCUOut;

  // ==================== Execute ====================
  PIPELINE_DE pipeline_de(
    .inst_d(InstD),
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
    .jal_d(JALD),
    .syscall_d(SyscallD),
    .clk(clk),
    .sig_clr(FlushE),
    .inst_e(InstE),
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
    .upper_e(UpperE),
    .jal_e(JALE),
    .syscall_e(SyscallE)
    );
  TWO_MUX #(5) reg_write_mux_e(
    .sig_control(RegDstE),
    .input_lo(rtE),
    .input_hi(rdE),
    .result(WriteRegMuxMuxE)
    );
  TWO_MUX #(5) reg_write_mux_jal_e(
    .sig_control(JALE),
    .input_lo(WriteRegMuxMuxE),
    .input_hi(RegRA),
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
    .result(ALUOutE),
    .hi(hi),
    .lo(lo)
    );
  BINARY_TO_MIPS b2m_E(
      InstE,
      MipsE);

  // ================== Data Memory ==================
  PIPELINE_EM pipeline_em(
    .reg_write_e(RegWriteE),
    .mem_to_reg_e(MemToRegE),
    .mem_write_e(MemWriteE),
    .alu_result_e(ALUOutE),
    .write_data_e(ForwardBEMuxOut),
    .write_reg_e(WriteRegE),
    .upper_e(UpperE),
    .syscall_e(SyscallE),
    .clk(clk),
    .reg_write_m(RegWriteM),
    .mem_to_reg_m(MemToRegM),
    .mem_write_m(MemWriteM),
    .alu_result_m(ALUOutM),
    .write_data_m(WriteDataM),
    .write_reg_m(WriteRegM),
    .upper_m(UpperM),
    .syscall_m(SyscallM)
    );
  SYSCALL_HANDLER syscall_unit(
    .sig_syscall(SyscallM),
    .v0(v0M),
    .a0(a0M),
    .clk(clk),
    .sig_print_string(PrintStringM)
    );

  // =================== Writeback ===================
  PIPELINE_MW pipeline_mw(
    .reg_write_m(RegWriteM),
    .mem_to_reg_m(MemToRegM),
    .upper_m(UpperM),
    .alu_result_m(ALUOutM),
    .read_data_m(ReadDataM),
    .write_reg_m(WriteRegM),
    .syscall_m(SyscallM),
    .clk(clk),
    .reg_write_w(RegWriteW),
    .mem_to_reg_w(MemToRegW),
    .upper_w(UpperW),
    .alu_result_w(ALUOutW),
    .read_data_w(ReadDataW),
    .write_reg_w(WriteRegW),
    .syscall_w(SyscallW)
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

  // ================== Non-staged ==================
  HAZARD_UNIT hazard_unit(
    .sig_jump_d(JumpD),
    .sig_jal_d(JALD),
    .sig_jal_e(JALE),
    .sig_branch_d(BranchD),
    .sig_syscall_d(SyscallD),
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
  MEMORY mem(
    .instr_pc(pcF),
    .instr_out(InstF),
    .data_sig_mem_write(MemWriteM),
    .data_addr(ALUOutM),
    .data_write_data(WriteDataM),
    .data_print_addr(PrintStringM),
    .data_read_data(ReadDataM)
    );

  // ==================================================
  // ===                 Statements                 ===
  // ==================================================

  integer LineNumber;

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,testbench);
    LineNumber = 0;
    clk <= 1;
    #10000;
    $finish;
  end

  always begin
    #5; clk = ~clk;
  end
  always @(posedge clk) begin
    MipsW = MipsM;
    MipsM = MipsE;
  end

  always @(negedge clk)
  begin
    $display("===========(%2d)===========", LineNumber);
    $display("Fetch:      %-s", MipsF);
    $display("Decode:     %-s", MipsD);
    $display("Execute:    %-s", MipsE);
    $display("Memory:     %-s", MipsM);
    $display("Writeback:  %-s", MipsW);
    $display("");
    // $display("Fetch:");
    // $display("pc:         %x", pc);
    // $display("pcF:        %x", pcF);
    // $display("StallF:     %b", StallF);
    // $display("");
    // $display("Decode:");
    $display("StallD:     %x", StallD);
    $display("PCSrcD:     %x", PCSrcD);
    // $display("StallD:     %b", StallD);
    // $display("JumpD:      %x", JumpD);
    // $display("RD1D:       %x", RD1D);
    // $display("RD2D:       %x", RD2D);
    // $display("JALD:       %x", JALD);
    // $display("");
    // $display("Execute:");
    $display("FlushE:     %x", FlushE);
    // $display("ForwardAE:  %x", ForwardAE);
    // $display("ForwardBE:  %x", ForwardBE);
    // $display("SrcAE:      %x", SrcAE);
    // $display("SrcBE:      %x", SrcBE);
    // $display("ALUSrcE:    %x", ALUSrcE);
    // $display("SignImmE:   %x", SignImmE);
    // $display("ALUOutE:    %x", ALUOutE);
    // $display("JALE:       %x", JALE);
    // $display("SyscallM:   %x", SyscallM);
    // $display("WriteDataE: %x", WriteDataE);
    $display("RegWriteE:  %x", RegWriteE);
    // $display("");
    // $display("Memory:");
    $display("MemToRegM:  %x", MemToRegM);
    // $display("ALUOutM:    %x", ALUOutM);
    // $display("ReadDataM:  %x", ReadDataM);
    // $display("WriteDataM: %x", WriteDataM);
    // $display("Writeback:");
    // $display("Result16W:  %x", Result16W);
    // $display("SyscallW:   %x", SyscallW);
    // $display("");
    LineNumber = LineNumber + 1;
  end

endmodule
