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
  wire [31:0] pc;
  wire        clk;

  // ===================== Fetch =====================
  wire [31:0] pcF;
  wire [31:0] instF;
  wire [31:0] PCPlus4F;
  wire        stallF;


  // ==================== Decode =====================
  wire        JumpD;
  wire [31:0] jumpExtendD;
  wire [31:0] jumpMuxOutD;

  // ==================== Execute ====================

  // ================== Data Memory ==================

  // =================== Writeback ===================


  // =================================================
  // ===                 Registers                 ===
  // =================================================

  // ===================== Fetch =====================

  // ==================== Decode =====================

  // ==================== Execute ====================

  // ================== Data Memory ==================

  // =================== Writeback ===================


  // =================================================
  // ===                  Modules                  ===
  // =================================================

  // ===================== Fetch =====================
  PC program_counter(
    .pc(pc),
    .haz_enable(~stallF), // <-- use ~ to negate stallF
    .clk(clk),
    .pcf(stallF)
    );
  INST_MEM inst_mem(
    .pc(pcF),
    .instr(instF)
    );
  ADDER adder(
    .input_a(pcF),
    .input_b(4),
    .result(PCPlus4F)
    );
  TWO_MUX #(32) branch_mux(
    .sig_control(JumpD),
    .input_hi()
    );

  // ==================== Decode =====================

  // ==================== Execute ====================

  // ================== Data Memory ==================

  // =================== Writeback ===================

endmodule
