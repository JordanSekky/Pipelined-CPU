`ifndef TEST_H
  `include "../includes/ManBearPig.h"
`endif
`ifdef TEST_H
  `include "../../includes/ManBearPig.h"
`endif

module ALU (input wire signed [31:0] src_a,
	        input wire signed [31:0] src_b,
	        input wire [4:0] sig_alu_control,
	        output reg signed [31:0] result,
	        output reg signed [31:0] hi,
	        output reg signed [31:0] lo);

// This module performs the arithmetic operations of the processor.
// It determines what operations to perform on its two inputs based
// on its input control signal. If the result of the operation is 0,
// The alu outputs a high signal on the zerosig output.

reg [63:0] mult_result;

always @(*)
begin
	case (sig_alu_control)
		`ALU_AND: begin
			result = src_a & src_b;
		end
		`ALU_OR: begin
			result = src_a | src_b;
		end
		`ALU_add: begin
			result = src_a + src_b;
		end
		`ALU_sub: begin
			result = src_a - src_b;
		end
		`ALU_sll: begin
		  result = src_a << src_b;
		end
		`ALU_sra: begin
		  result = src_a >>> src_b;
		end
		`ALU_mult: begin
		  mult_result = src_a * src_b;
		  hi = mult_result[63:32];
		  lo = mult_result[31:0];
		end
		`ALU_div: begin
		  hi = src_a % src_b;
		  lo = src_a / src_b;
		end
		`ALU_lui: begin
			result = src_b << 16;
		end
		default: begin
      `ifdef TEST_H
			   $display("BAD ALU OPERATION CODE");
      `endif
			result = 32'bX;
		end
		endcase
end

endmodule
