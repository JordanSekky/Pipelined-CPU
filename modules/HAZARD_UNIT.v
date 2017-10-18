`include "../includes/ManBearPig.h"

module HAZARD_UNIT (
	input [1:0] sig_jump_d,
	input sig_jal_d,
	input sig_jal_e,
	input sig_branch_d,
	input sig_syscall_d,
	input [4:0] rs_d,
	input [4:0] rt_d,
	input [4:0] rs_e,
	input [4:0] rt_e,
	input [4:0] write_reg_e,
	input [4:0] write_reg_m,
	input [4:0] write_reg_w,
	input sig_reg_write_e,
	input sig_mem_to_reg_e,
	input sig_reg_write_m,
	input sig_mem_to_reg_m,
	input sig_mem_to_reg_w,
	input sig_reg_write_w,
	input sig_mem_write_m,
	output reg stall_f,
	output reg stall_d,
	output reg forward_a_d,
	output reg forward_b_d,
	output reg flush_e,
	output reg [1:0] forward_a_e,
	output reg [1:0] forward_b_e,
	output reg forward_m);

reg lwstall;
reg syscallstall;
reg branchstall;
reg stallcounter;

always @(*) begin
	if ((rs_e != 0) && (rs_e == write_reg_m) && sig_reg_write_m)
		forward_a_e = 2'b10; // Ex to Ex Forwarding for rs
	else if ((rs_e != 0) && (rs_e == write_reg_w) && sig_reg_write_w)
		forward_a_e = 2'b01; // Mem to Ex Forwarding for rs
	else forward_a_e = 2'b00; // No forward for rs

	if ((rt_e != 0) && (rt_e == write_reg_m) && sig_reg_write_m)
		forward_b_e = 2'b10; // Ex to Ex Forwarding for rs
	else if ((rt_e != 0) && (rt_e == write_reg_w) && sig_reg_write_w)
		forward_b_e = 2'b01; // Mem to Ex Forwarding for rs
	else forward_b_e = 2'b00; // No forward for rs

	if ((write_reg_m == write_reg_w) && (sig_mem_to_reg_w && sig_mem_write_m))
		forward_m = 1;
	else forward_m = 0;

	lwstall = ((rs_d == rs_e) || (rt_d == rt_e)) && sig_mem_to_reg_e;
	syscallstall = (((`v0 == write_reg_e) || (`v0 == write_reg_m) || (`v0 == write_reg_w)) ||
					((`a0 == write_reg_e) || (`a0 == write_reg_m) || (`a0 == write_reg_w))) && sig_syscall_d;

	forward_a_d = (rs_d != 0) && (rs_d == write_reg_m) && sig_reg_write_m;
	forward_b_d = (rt_d != 0) && (rt_d == write_reg_m) && sig_reg_write_m;


	branchstall = (sig_branch_d && sig_reg_write_e && (write_reg_e == rs_d || write_reg_e == rt_d)) ||
	              (sig_branch_d && sig_mem_to_reg_m && (write_reg_m == rs_d || write_reg_m == rt_d));
end

always @(*) begin
	stall_f <= lwstall || branchstall || (sig_jal_d && !sig_jal_e);
	stall_d <= lwstall || branchstall || (sig_jal_d && !sig_jal_e);
	flush_e <= lwstall || branchstall || sig_jal_e;
end

endmodule
