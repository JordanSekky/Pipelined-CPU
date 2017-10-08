`ifndef TEST_H
  `include "../includes/ManBearPig.h"
`endif
`ifdef TEST_H
  `include "../../includes/ManBearPig.h"
`endif

module BINARY_TO_MIPS (input wire [31:0] inst, input wire clk);

  reg [4:0]  OpCode;
  wire [23:0] rs;
  wire [23:0] rt;
  wire [23:0] rd;
  reg [4:0] Shamt;
  reg [15:0] SignImm;
  reg [25:0] JumpImm;
  reg [5:0]  FunctCode;

  BINARY_TO_REGISTERS btr_rs(inst[25:21], rs);
  BINARY_TO_REGISTERS btr_rt(inst[20:16], rt);
  BINARY_TO_REGISTERS btr_rd(inst[15:11], rd);

  always @(posedge clk) begin
    #1;
    
    OpCode = inst[31:26];
    Shamt = inst[10:6];
    SignImm = inst[15:0];
    JumpImm = inst[25:0];
    FunctCode = inst[5:0];

    if (inst == 32'h0) $display("nop");
    else begin
      case (OpCode)
        `SPECIAL:   begin
          case (FunctCode)
            `SLL:     $display("sll %s %s 0x%h", rd, rt, Shamt);
            `SRL:     $display("srl %s %s 0x%h", rd, rt, Shamt);
            `SRA:     $display("sra %s %s 0x%h", rd, rt, Shamt);
            `SLLV:    $display("sllv %s %s %s", rd, rt, rs);
            `SRLV:    $display("srlv %s %s %s", rd, rt, rs);
            `SRAV:    $display("srav %s %s %s", rd, rt, rs);

            `JR:      $display("jr %s", rs);
            `JALR:    $display("jalr %s %s", rd, rs);

            `SYSCALL: $display("syscall");
            `BREAK:   $display("break");

            `MFHI:    $display("mfhi");
            `MTHI:    $display("mthi");
            `MFLO:    $display("mflo");
            `MTLO:    $display("mtlo");

            `MULT:    $display("mult %s %s %s", rd, rt, rs);
            `MULTU:   $display("multu %s %s %s", rd, rt, rs);
            `DIV:     $display("div %s %s %s", rd, rt, rs);
            `DIVU:    $display("divu %s %s %s", rd, rt, rs);

            `ADD:     $display("add %s %s %s", rd, rt, rs);
            `ADDU:    $display("addu %s %s %s", rd, rt, rs);
            `SUB:     $display("sub %s %s %s", rd, rt, rs);
            `SUBU:    $display("subu %s %s %s", rd, rt, rs);
            `AND:     $display("and %s %s %s", rd, rt, rs);
            `OR:      $display("or %s %s %s", rd, rt, rs);
            `XOR:     $display("xor %s %s %s", rd, rt, rs);
            `NOR:     $display("nor %s %s %s", rd, rt, rs);

            `SLT:     $display("slt");
            `SLTU:    $display("sltu");

            `TGE:     $display("tge");
            `TGEU:    $display("tgeu");
            `TLT:     $display("tlt");
            `TLTU:    $display("tltu");
            `TEQ:     $display("teq");

            `TNE:     $display("tne");

            default:  $display("FunctCode %b is Unknown for OpCode SPECIAL", FunctCode);
          endcase
        end
        `REGIMM: begin
          case (FunctCode)
            `BLTZ:    $display("bltz");
            `BGEZ:    $display("bgez");
            `BLTZL:   $display("bltzl");
            `BGEZL:   $display("bgezl");

            `TGEI:    $display("tgei");
            `TGEIU:   $display("tgeiu");
            `TLTI:    $display("tlti");
            `TLTIU:   $display("tltiu");
            `TEQI:    $display("teqi");

            `TNEI:    $display("tnei");

            `BLTZAL:  $display("bltzal");
            `BGEZAL:  $display("bgezal");
            `BLTZALL: $display("bltzall");
            `BGEZALL: $display("bgezall");

            default:  $display("FunctCode %b is Unknown for OpCode REGIMM", FunctCode);
          endcase
        end
        `J:         $display("j 0x%h", JumpImm);
        `JAL:       $display("jal 0x%h", JumpImm);
        `BEQ:       $display("beq %s %s 0x%h", rs, rt, SignImm);
        `BNE:       $display("bne %s %s 0x%h", rs, rt, SignImm);
        `BLEZ:      $display("blez");
        `BGTZ:      $display("bgtz");

        `ADDI:      $display("addi %s %s 0x%h", rt, rs, SignImm);
        `ADDIU:     $display("addiu %s %s 0x%h", rt, rs, SignImm);
        `SLTI:      $display("slti %s %s 0x%h", rt, rs, SignImm);
        `SLTIU:     $display("sltiu %s %s 0x%h", rt, rs, SignImm);
        `ANDI:      $display("andi %s %s 0x%h", rt, rs, SignImm);
        `ORI:       $display("ori %s %s 0x%h", rt, rs, SignImm);
        `XORI:      $display("xori %s %s 0x%h", rt, rs, SignImm);
        `LUI:       $display("lui %s 0x'h", rt, SignImm);

        `COP0:      $display("cop0");
        `COP1:      $display("cop1");
        `COP2:      $display("cop2");
        `COP3:      $display("cop3");
        `BEQL:      $display("beql");
        `BNEL:      $display("bnel");
        `BLEZL:     $display("blezl");
        `BGTZL:     $display("bgtzl");

        `LB:        $display("lb %s 0x%h", rt, SignImm);
        `LH:        $display("lh %s 0x%h", rt, SignImm);
        `LWL:       $display("lwl %s 0x%h", rt, SignImm);
        `LW:        $display("lw %s 0x%h", rt, SignImm);
        `LBU:       $display("lbu %s 0x%h", rt, SignImm);
        `LHU:       $display("lhu %s 0x%h", rt, SignImm);
        `LWR:       $display("lwr %s 0x%h", rt, SignImm);

        `SB:        $display("sb %s 0x%h", rt, SignImm);
        `SH:        $display("sh %s 0x%h", rt, SignImm);
        `SWL:       $display("swl %s 0x%h", rt, SignImm);
        `SW:        $display("sw %s 0x%h", rt, SignImm);

        `SWR:       $display("SWR");
        `CACHE:     $display("CACHE");

        `LL:        $display("LL");
        `LWC1:      $display("LWC1");
        `LWC2:      $display("LWC2");
        `LWC3:      $display("LWC3");

        `LDC1:      $display("LDC1");
        `LDC2:      $display("LDC2");
        `LDC3:      $display("LDC3");

        `SC:        $display("SC");
        `SWC1:      $display("SWC1");
        `SWC2:      $display("SWC2");
        `SWC3:      $display("SWC3");

        `SDC1:      $display("SDC1");
        `SDC2:      $display("SDC2");
        `SDC3:      $display("SDC3");

        default:      $display("OpCode %b unknown", OpCode);

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
