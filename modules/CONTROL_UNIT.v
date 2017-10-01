`include "../includes/ManBearPig.h"

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

  always @(op_code or funct_code) begin

    // jal
    jal <= op_code == `JAL ? 1'b1 : 1'b0;

    // reg_dst
    case (op_code)
      `SPECIAL: begin
          reg_dst <= 1'b1;
        end
      default: reg_dst <= 1'b0;
    endcase

    // jump
    case (op_code)
      `J, `JAL: jump <= 2'b01;
      `JR: jump <= 2'b10;
      default: jump <= 2'b00;
    endcase

    // branch
    case (op_code)
      `BEQ, `BNE: branch <= 1'b1;
      default: branch <= 1'b0;
    endcase

    // mem_to_reg
    case (op_code)
      `LW: mem_to_reg <= 1'b1;
      default: mem_to_reg <= 1'b0;
    endcase

    // reg_write
    case (op_code)
      `SPECIAL, `ADDIU, `ADDI, `ADDU, `ORI, `LW, `LUI: reg_write <= 1'b1;
      default: reg_write <= 1'b0;
    endcase

    // alu_src
    case (op_code)
      `ADDIU, `ADDI, `ADDU, `ORI, `LW, `SW, `LUI: alu_src <= 1'b1;
      default: alu_src <= 1'b0;
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

      // R-type
      `SPECIAL: case(funct_code)
          `SLT: alu_control <= `ALU_slt;
          `ADD: alu_control <= `ALU_add;
          `SUB: alu_control <= `ALU_sub;
          `AND: alu_control <= `ALU_AND;
          `OR:  alu_control <= `ALU_OR;
          default: begin
            $display("Unsupported function code: %x", alu_control);
            alu_control <= `ALU_undef;
          end
        endcase
      default: alu_control <= `ALU_undef;
    endcase

  end

endmodule
