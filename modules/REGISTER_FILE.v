`include "../includes/ManBearPig.h"
module syscall_handler(
	input [31:0] instr,
	input [31:0] v0,
	input [31:0] a0);
// This module keeps an eye on the current instruction and performs syscalls
// as necessary. It currently supports displaying an integer and exiting.

always @(instr) begin
	if (instr == 32'h0000000C) begin
		if (v0 == 1) begin
			$display ("%d", a0);
		end
		if (v0 == 11) begin
			$write("%c", a0);
		end
		if (v0 == 10) begin
			$finish;
		end
	end
end

endmodule

module REGISTERS (input [4:0] rs,
				  input [4:0] rt,
				  input [4:0] rd,
				  input [31:0] write_data,
				  input sig_jal,
				  input sig_reg_write,
				  input clk,
				  input [31:0] instr,
				  output reg [31:0] read_data_1,
				  output reg [31:0] read_data_2);
// This module stores the contents of all of the registers on the mips processors.
// It stores them as an array of 32 32-bit registers. r_1 and r_2 are the values
// of the two registers to be read. w_r is the register to be written to. w_d is
// the data to write into w_r. r_d_1 and r_d_2 are the data read from r_1 and r_2
// respectively. v0_out is always the value of v0 to facilitate syscalls. a0 is like
// v0_out, but with a0. regwrite is a control signal indicating that w_r is being written
// to this cycle.

///////////////////////// internal memory storage //////////////////////////////
reg [31:0] regs [31:0];
reg [5:0] k;
syscall_handler sh(instr, regs[`v0], regs[`a0]);

initial begin
	for (k = 0; k < 32; k = k + 1) begin
		regs[k] = 32'b0;
	end
end

always @(posedge clk) begin
	read_data_1 = regs[rs];
	read_data_2 = regs[rt];
end

always @(negedge clk) begin
	if (sig_reg_write)
	begin
		if (sig_jal)
			regs[`ra] = write_data;
		else if (rd > 0)
			regs[rd] = write_data;
	end
end


endmodule
