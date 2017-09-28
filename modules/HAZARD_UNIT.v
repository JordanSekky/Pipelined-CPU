module HAZARD_UNIT (
	input sig_jump_d,
	input sig_branch_d,
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
	input sig_reg_write_w,
	output reg stall_f,
	output reg stall_d,
	output reg forward_a_d,
	output reg forward_b_d,
	output reg flush_e,
	output reg [1:0] forward_a_e,
	output reg [1:0] forward_b_e);

reg lwstall;
reg branchstall;

always @(*) begin
	if ((rs_e != 0) && (rs_e == write_reg_m) && sig_reg_write_m) 
		forward_a_e <= 2'b10;
	else if ((rs_e != 0) && (rs_e == write_reg_w) && sig_reg_write_w) 
		forward_a_e <= 2'b01;
	else forward_a_e <= 2'b00;

	if ((rt_e != 0) && (rt_e == write_reg_m) && sig_reg_write_m) 
		forward_b_e <= 2'b10;
	else if ((rt_e != 0) && (rt_e == write_reg_w) && sig_reg_write_w) 
		forward_b_e <= 2'b01;
	else forward_b_e <= 2'b00;

	lwstall <= ((rs_d == rt_e) || (rt_d == rt_e)) && sig_mem_to_reg_e;

	forward_a_d <= (rs_d != 0) && (rs_d == write_reg_m) && sig_reg_write_m;
	forward_b_d <= (rt_d != 0) && (rt_d == write_reg_m) && sig_reg_write_m;


	branchstall <= sig_branch_d && sig_reg_write_e && (write_reg_e == rs_d || write_reg_e == rt_d) || 
	              sig_branch_d && sig_mem_to_reg_m && (write_reg_m == rs_d || write_reg_m == rt_d);

	stall_f = lwstall || branchstall;
	stall_d = lwstall || branchstall;
	flush_e = lwstall || branchstall;
end

endmodule