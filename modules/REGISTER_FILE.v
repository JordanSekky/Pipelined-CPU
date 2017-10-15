`include "../includes/ManBearPig.h"

module REGISTERS (input unsigned [4:0] rs,
				  input unsigned [4:0] rt,
				  input unsigned [4:0] rd,
				  input [31:0] write_data,
					input [31:0] hi_reg,
					input [31:0] lo_reg,
				  input sig_jal,
				  input sig_reg_write,
				  input clk,
				  input [31:0] pc_plus_4,
				  input [31:0] instr,
				  input sig_syscall,
				  output reg [31:0] read_data_1,
				  output reg [31:0] read_data_2,
				  output wire [31:0] a0,
				  output wire [31:0] v0);
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
	reg [3:0] i;

	initial begin
		for (k = 0; k < 32; k = k + 1) begin
			regs[k] = 32'b0;
		end
	  read_data_1 = 0;
	  read_data_2 = 0;
		regs[`sp] = `stack_size_hi - 4;
	end

	assign a0 = regs[`a0];
	assign v0 = regs[`v0];

	// always @(posedge clk) begin
	// 	for (i=0; i<8; i=i+1)
	// 		$display("%d: %d  %d: %d  %d: %d  %d: %d",
	// 			4*i,
	// 			regs[4*i], 4*i+1, regs[4*i+1], 4*i+2,
	// 			regs[4*i+2], 4*i+3, regs[4*i+3]);
	// end

	always @(posedge clk, rs, rt) begin
		if (sig_syscall) begin
			read_data_1 <= regs[`v0];
			read_data_2 <= regs[`a0];
		end
		else if (sig_jal) begin
			read_data_1 <= pc_plus_4;
			read_data_2 <= regs[`zero];
		end
		else begin
			// $display("regs[%0d] = %x", rs, regs[rs]);
			read_data_1 <= regs[rs];
			// $display("regs[%0d] = %x", rt, regs[rt]);
			read_data_2 <= regs[rt];
		end
	end

	always @(negedge clk, write_data, pc_plus_4) begin
		if (!clk && sig_reg_write && rd > 0) begin
			regs[rd] = write_data;
		end

		if (!clk && sig_jal) begin
			regs[`ra] <= pc_plus_4;
		end
	end

endmodule
