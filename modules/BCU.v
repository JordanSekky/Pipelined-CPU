`ifndef TEST_H
  `include "../includes/ManBearPig.h"
`endif
`ifdef TEST_H
  `include "../../includes/ManBearPig.h"
`endif

module BCU (
    input [3:0] sig_bcu_control, 
    input [31:0] rd1, 
    input [31:0] rd2,
    output reg branch);

  always @(*) begin
    case (sig_bcu_control)
    `BCU_EQ: begin
      branch = rd1 == rd2;
    end 
    `BCU_NE: begin
      branch = rd1 != rd2;
    end
    `BCU_GT: begin
      branch = rd1 > rd2;
    end
    `BCU_LT: begin
      branch = rd1 < rd2;
    end
    `BCU_GE: begin
      branch = rd1 >= rd2;
    end
    `BCU_LE: begin
      branch = rd1 <= rd2;
    end
    `BCU_EQZ: begin
      branch = rd1 == 0; 
    end
    `BCU_NEZ: begin
      branch = rd1 != 0;
    end
    `BCU_GTZ: begin
      branch = rd1 > 0;
    end
    `BCU_LTZ: begin
      branch = rd1 < 0;
    end
    `BCU_GEZ: begin
      branch = rd1 >= 0;
    end
    `BCU_LEZ: begin
      branch = rd1 <= 0;
    end
    default: $display("BAD BCU CONTROL SIGNAL");
    endcase
  end
endmodule
