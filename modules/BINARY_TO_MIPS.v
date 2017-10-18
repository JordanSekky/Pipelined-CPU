`ifndef TEST_H
  `include "../includes/ManBearPig.h"
`endif
`ifdef TEST_H
  `include "../../../includes/ManBearPig.h"
`endif

/*
 * Converts binary back into mips. 
 */
module BINARY_TO_MIPS (
    input wire [31:0] inst,
    output reg [255:0] mips);

  reg [5:0]  OpCode;
  wire [23:0] rs;
  wire [23:0] rt;
  wire [23:0] rd;
  reg [4:0] Shamt;
  reg [15:0] SignImm;
  reg [25:0] JumpImm;
  reg [5:0]  FunctCode;
  reg [25:0] CopFunc;

  BINARY_TO_REGISTERS btr_rs(inst[25:21], rs);
  BINARY_TO_REGISTERS btr_rt(inst[20:16], rt);
  BINARY_TO_REGISTERS btr_rd(inst[15:11], rd);

  always @(*) begin
    OpCode = inst[31:26];
    Shamt = inst[10:6];
    SignImm = inst[15:0];
    JumpImm = inst[25:0];
    FunctCode = inst[5:0];
    CopFunc = inst[25:0];

    if (inst == 32'h0) $sformat(mips, "nop");
    else begin
      case (OpCode)
        `SPECIAL:   begin
          case (FunctCode)
            `SLL:     $sformat(mips, "sll %s %s 0x%h", rd, rt, Shamt);
            `SRL:     $sformat(mips, "srl %s %s 0x%h", rd, rt, Shamt);
            `SRA:     $sformat(mips, "sra %s %s 0x%h", rd, rt, Shamt);
            `SLLV:    $sformat(mips, "sllv %s %s %s", rd, rt, rs);
            `SRLV:    $sformat(mips, "srlv %s %s %s", rd, rt, rs);
            `SRAV:    $sformat(mips, "srav %s %s %s", rd, rt, rs);

            `JR:      $sformat(mips, "jr %s", rs);
            `JALR:    $sformat(mips, "jalr %s %s", rd, rs);

            `SYSCALL: $sformat(mips, "syscall");
            `BREAK:   $sformat(mips, "break");

            `MFHI:    $sformat(mips, "mfhi %s", rd);
            `MTHI:    $sformat(mips, "mthi %s", rs);
            `MFLO:    $sformat(mips, "mflo %s", rd);
            `MTLO:    $sformat(mips, "mtlo %s", rs);

            `MULT:    $sformat(mips, "mult %s %s", rs, rt);
            `MULTU:   $sformat(mips, "multu %s %s", rs, rt);
            `DIV:     $sformat(mips, "div %s %s", rd, rt);
            `DIVU:    $sformat(mips, "divu %s %s", rs, rt);

            `ADD:     $sformat(mips, "add %s %s %s", rd, rs, rt);
            `ADDU:    $sformat(mips, "addu %s %s %s", rd, rs, rt);
            `SUB:     $sformat(mips, "sub %s %s %s", rd, rs, rt);
            `SUBU:    $sformat(mips, "subu %s %s %s", rd, rs, rt);
            `AND:     $sformat(mips, "and %s %s %s", rd, rs, rt);
            `OR:      $sformat(mips, "or %s %s %s", rd, rs, rt);
            `XOR:     $sformat(mips, "xor %s %s %s", rd, rs, rt);
            `NOR:     $sformat(mips, "nor %s %s %s", rd, rs, rt);

            `SLT:     $sformat(mips, "slt %s %s %s", rd, rs, rt);
            `SLTU:    $sformat(mips, "sltu %s %s %s", rd, rs, rt);

            `TGE:     $sformat(mips, "tge %s %s", rs, rt);
            `TGEU:    $sformat(mips, "tgeu %s %s", rs, rt);
            `TLT:     $sformat(mips, "tlt %s %s", rs, rt);
            `TLTU:    $sformat(mips, "tltu %s %s", rs, rt);
            `TEQ:     $sformat(mips, "teq %s %s", rs, rt);

            `TNE:     $sformat(mips, "tne %s %s", rs, rt);

            default:  $sformat(mips, "0x%h is Unknown for SPECIAL", FunctCode);
          endcase
        end
        `REGIMM: begin
          case (inst[20:16])
            `BLTZ:    $sformat(mips, "bltz %s 0x%h", rs, SignImm);
            `BGEZ:    $sformat(mips, "bgez %s 0x%h", rs, SignImm);
            `BLTZL:   $sformat(mips, "bltzl %s 0x%h", rs, SignImm);
            `BGEZL:   $sformat(mips, "bgezl %s 0x%h", rs, SignImm);

            `TGEI:    $sformat(mips, "tgei %s 0x%h", rs, SignImm);
            `TGEIU:   $sformat(mips, "tgeiu %s 0x%h", rs, SignImm);
            `TLTI:    $sformat(mips, "tlti %s 0x%h", rs, SignImm);
            `TLTIU:   $sformat(mips, "tltiu %s 0x%h", rs, SignImm);
            `TEQI:    $sformat(mips, "teqi %s 0x%h", rs, SignImm);

            `TNEI:    $sformat(mips, "tnei %s 0x%h", rs, SignImm);

            `BLTZAL:  $sformat(mips, "bltzal %s 0x%h", rs, SignImm);
            `BGEZAL:  $sformat(mips, "bgezal %s 0x%h", rs, SignImm);
            `BLTZALL: $sformat(mips, "bltzall %s 0x%h", rs, SignImm);
            `BGEZALL: $sformat(mips, "bgezall %s 0x%h", rs, SignImm);

            default:  $sformat(mips, "0x%h is Unknown for REGIMM", inst[20:16]);
          endcase
        end
        `J:         $sformat(mips, "j 0x%h", JumpImm);
        `JAL:       $sformat(mips, "jal 0x%h", JumpImm);
        `BEQ:       $sformat(mips, "beq %s %s 0x%h", rs, rt, SignImm);
        `BNE:       $sformat(mips, "bne %s %s 0x%h", rs, rt, SignImm);
        `BLEZ:      $sformat(mips, "blez %s %s 0x%h", rs, rt, SignImm);
        `BGTZ:      $sformat(mips, "bgtz %s %s 0x%h", rs, rt, SignImm);

        `ADDI:      $sformat(mips, "addi %s %s 0x%h", rt, rs, SignImm);
        `ADDIU:     $sformat(mips, "addiu %s %s 0x%h", rt, rs, SignImm);
        `SLTI:      $sformat(mips, "slti %s %s 0x%h", rt, rs, SignImm);
        `SLTIU:     $sformat(mips, "sltiu %s %s 0x%h", rt, rs, SignImm);
        `ANDI:      $sformat(mips, "andi %s %s 0x%h", rt, rs, SignImm);
        `ORI:       $sformat(mips, "ori %s %s 0x%h", rt, rs, SignImm);
        `XORI:      $sformat(mips, "xori %s %s 0x%h", rt, rs, SignImm);
        `LUI:       $sformat(mips, "lui %s 0x%h", rt, SignImm);

        `COP0:      $sformat(mips, "cop0 0x%h", CopFunc);
        `COP1:      $sformat(mips, "cop1 0x%h", CopFunc);
        `COP2:      $sformat(mips, "cop2 0x%h", CopFunc);
        `COP3:      $sformat(mips, "cop3 0x%h", CopFunc);
        `BEQL:      $sformat(mips, "beql %s %s 0x%h", rs, rt, SignImm);
        `BNEL:      $sformat(mips, "bnel %s %s 0x%h", rs, rs, SignImm);
        `BLEZL:     $sformat(mips, "blezl %s 0x%h", rs, SignImm);
        `BGTZL:     $sformat(mips, "bgtzl %s 0x%h", rs, SignImm);

        `LB:        $sformat(mips, "lb %s %0d(%s)", rt, SignImm, rs);
        `LH:        $sformat(mips, "lh %s %0d(%s)", rt, SignImm, rs);
        `LWL:       $sformat(mips, "lwl %s %0d(%s)", rt, SignImm, rs);
        `LW:        $sformat(mips, "lw %s %0d(%s)", rt, SignImm, rs);
        `LBU:       $sformat(mips, "lbu %s %0d(%s)", rt, SignImm, rs);
        `LHU:       $sformat(mips, "lhu %s %0d(%s)", rt, SignImm, rs);
        `LWR:       $sformat(mips, "lwr %s %0d(%s)", rt, SignImm, rs);

        `SB:        $sformat(mips, "sb %s %0d(%s)", rt, SignImm, rs);
        `SH:        $sformat(mips, "sh %s %0d(%s)", rt, SignImm, rs);
        `SWL:       $sformat(mips, "swl %s %0d(%s)", rt, SignImm, rs);
        `SW:        $sformat(mips, "sw %s %0d(%s)", rt, SignImm, rs);

        `SWR:       $sformat(mips, "swr %s %0d(%s)", rt, SignImm, rs);
        `CACHE:     $sformat(mips, "cache %s %0d(%s)", rt, SignImm, rs);

        `LL:        $sformat(mips, "ll %s %0d(%s)", rt, SignImm, rs);
        `LWC1:      $sformat(mips, "lwc1 %s %0d(%s)", rt, SignImm, rs);
        `LWC2:      $sformat(mips, "lwc2 %s %0d(%s)", rt, SignImm, rs);
        `LWC3:      $sformat(mips, "lwc3 %s %0d(%s)", rt, SignImm, rs);

        `LDC1:      $sformat(mips, "ldc1 %s 0x%h(%s)", rt, SignImm, rs);
        `LDC2:      $sformat(mips, "ldc2 %s 0x%h(%s)", rt, SignImm, rs);
        `LDC3:      $sformat(mips, "ldc3 %s 0x%h(%s)", rt, SignImm, rs);

        `SC:        $sformat(mips, "sc %s %0d(%s)", rt, SignImm, rs);
        `SWC1:      $sformat(mips, "swc1 %s %0d(%s)", rt, SignImm, rs);
        `SWC2:      $sformat(mips, "swc2 %s %0d(%s)", rt, SignImm, rs);
        `SWC3:      $sformat(mips, "swc3 %s %0d(%s)", rt, SignImm, rs);

        `SDC1:      $sformat(mips, "sdc1 %s %0d(%s)", rt, SignImm, rs);
        `SDC2:      $sformat(mips, "sdc2 %s %0d(%s)", rt, SignImm, rs);
        `SDC3:      $sformat(mips, "sdc3 %s %0d(%s)", rt, SignImm, rs);

        default:      $sformat(mips, "OpCode 0x%h unknown", OpCode);

      endcase
    end
  end

endmodule

module BINARY_TO_REGISTERS(
  input wire [4:0] register,
  output reg [23:0] regName);

  always @(register) begin
    case (register)
      0:                          regName = "$z0";
      1:                          regName = "$at";
      2,3:                        $sformat(regName, "$v%1d", register-2);
      4,5,6,7:                    $sformat(regName, "$a%1d", register-4);
      8,9,10,11,12,13,14,15:      $sformat(regName, "$t%1d", register-8);
      16,17,18,19,20,21,22,23:    $sformat(regName, "$s%1d", register-16);
      24,25:                      $sformat(regName, "$t%1d", register-16);
      26,27:                      $sformat(regName, "$k%1d", register-26);
      28:                         regName = "$gp";
      29:                         regName = "$sp";
      30:                         regName = "$fp";
      31:                         regName = "$ra";
      default:                    regName = "$??";
    endcase
  end

endmodule
