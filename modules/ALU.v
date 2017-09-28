`include "ManBearPig.h"
module alu (input [31:0] src_a,
	        input [31:0] src_b,
	        input [4:0] sig_alu_control,
	        output reg [31:0] result);
// This module performs the arithmetic operations of the processor.
// It determines what operations to perform on its two inputs based
// on its input control signal. If the result of the operation is 0,
// The alu outputs a high signal on the zerosig output.

always @(*)
begin
	case (control)
		`ALU_AND: begin
			out = in1 & in2;
		end 
		`ALU_OR: begin
			out = in1 | in2;
		end
		`ALU_add: begin
			out = in1 + in2;
		end
		`ALU_sub: begin
			out = in1 - in2;
		end
		default: $display("BAD ALU OPERATION CODE");
		endcase
end

endmodule