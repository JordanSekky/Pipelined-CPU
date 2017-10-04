`include "../includes/ManBearPig.h"

module REGISTERS (input [4:0] rs,
				  input [4:0] rt,
				  input [4:0] rd,
				  input [31:0] write_data,
				  input sig_jal,
				  input sig_reg_write,
				  input clk,
				  input [31:0] pc_plus_4,
				  input [31:0] instr,
				  input sig_syscall,
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

initial begin
	for (k = 0; k < 32; k = k + 1) begin
		regs[k] = 32'b0;
	end
  read_data_1 = 0;
  read_data_2 = 0;
end

always @(posedge clk) begin
	if (sig_jal) begin
		read_data_1 = regs[`v0];
		read_data_2 = regs[`a0];
	end 
	else begin
		if (sig_syscall) begin
			read_data_1 = pc_plus_4;
			read_data_2 = regs[`zero];
		end else begin
			read_data_1 = regs[rs];
			read_data_2 = regs[rt];
		end
	end
end

always @(negedge clk) begin
	if (sig_reg_write)
	begin
		if (sig_jal)
    begin
			regs[`ra] <= write_data;
		end
    else if (rd > 0)
    begin
		regs[rd] = write_data;
    end
	end
end


endmodule
