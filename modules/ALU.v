`ifndef TEST_H
  `include "../includes/ManBearPig.h"   
`endif    
`ifdef TEST_H   
  `include "../../includes/ManBearPig.h"    
`endif

module ALU (input wire [31:0] src_a,
	        input wire [31:0] src_b,
	        input wire [4:0] sig_alu_control,
	        output reg [31:0] result);

// This module performs the arithmetic operations of the processor.
// It determines what operations to perform on its two inputs based
// on its input control signal. If the result of the operation is 0,
// The alu outputs a high signal on the zerosig output.

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
		default: begin
			$display("BAD ALU OPERATION CODE");
			result = 32'bX;
		end
		endcase
end

endmodule
