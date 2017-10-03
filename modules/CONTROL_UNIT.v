`ifndef TEST_H
  `include "../includes/ManBearPig.h"
`endif
`ifdef TEST_H
  `include "../../includes/ManBearPig.h"
`endif

module CONTROL_UNIT (
  input  wire [5:0] op_code,
  input  wire [5:0] funct_code,
  output reg        load_upper,
  output reg  [1:0] jump,
  output reg        jal,
  output reg        reg_write,
  output reg        mem_to_reg,
  output reg        mem_write,
  output reg  [4:0] alu_control,
  output reg        alu_src,
  output reg        reg_dst,
  output reg        branch,
  output reg  [3:0] bcu_control
  );

  initial begin
    load_upper <= 0;
    jump <= 0;
    jal <= 0;
    reg_write <= 0;
    mem_to_reg <= 0;
    mem_write <= 0;
    alu_control <= 0;
    alu_src <= 0;
    reg_dst <= 0;
    branch <= 0;
    bcu_control <= 0;
  end

  always @(op_code or funct_code) begin

    // load_upper
    case (op_code)
      `LUI: load_upper <= 1'b1;
      default: load_upper <= 1'b0;
    endcase

    // jump
    case (op_code)
      `J, `JAL: jump <= 2'b01;
      `SPECIAL: begin
        if (funct_code == `JR) jump <= 2'b10;
      end
      default: jump <= 2'b00;
    endcase

    // jal
    case (op_code)
      `JAL: jal <= 1'b1;
      default: jal <= 1'b0;
    endcase

    // reg_write
    case (op_code)
      `SPECIAL, `ADDIU, `ADDI, `ADDU, `ORI, `LW, `LUI: reg_write <= 1'b1;
      default: reg_write <= 1'b0;
    endcase

    // mem_to_reg
    case (op_code)
      `LW: mem_to_reg <= 1'b1;
      default: mem_to_reg <= 1'b0;
    endcase

    // mem_write
    case (op_code)
        `SW: mem_write <= 1'b1;
      default: mem_write <= 1'b0;
    endcase

    // alu_control
    case(op_code)
      `ADDIU, `ADDI, `ADDU, `LW, `SW, `LUI: alu_control <= `ALU_add;
      `ORI: alu_control <= `ALU_OR;
      `BEQ, `BNE: alu_control <= `ALU_sub;

      // R-type instructions
      `SPECIAL: case(funct_code)
          `SLT: alu_control <= `ALU_slt;
          `ADD: alu_control <= `ALU_add;
          `SUB: alu_control <= `ALU_sub;
          `AND: alu_control <= `ALU_AND;
          `OR:  alu_control <= `ALU_OR;
          default: begin
            $display("Unsupported function code: %x", funct_code);
            alu_control <= `ALU_undef;
          end
        endcase
      default: alu_control <= `ALU_undef;
    endcase

    // alu_src
    case (op_code)
      `ADDIU, `ADDI, `ADDU, `ORI, `LW, `SW, `LUI: alu_src <= 1'b1;
      default: alu_src <= 1'b0;
    endcase

    // reg_dst
    case (op_code)
      `SPECIAL: begin
          reg_dst <= 1'b1;
        end
      default: reg_dst <= 1'b0;
    endcase

    // branch
    case (op_code)
      `BEQ, `BNE, `BLEZ, `BGEZ, `BLTZ, `BGTZ: branch <= 1'b1;
      default: branch <= 1'b0;
    endcase

    // branch_control
    case (op_code)
      `BEQ: bcu_control <= `BCU_EQ;
      `BNE: bcu_control <= `BCU_NE;
      `BLEZ: bcu_control <= `BCU_LEZ;
      `BGEZ: bcu_control <= `BCU_GEZ;
      `BLTZ: bcu_control <= `BCU_LTZ;
      `BGTZ: bcu_control <= `BCU_GTZ;
      default: bcu_control <= 4'bx;
    endcase

  end
endmodule
