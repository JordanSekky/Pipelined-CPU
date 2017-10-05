module syscall_handler(
	input sig_syscall,
	input [31:0] v0,
	input [31:0] a0,
	input clk,
	output sig_print_string);
// This module keeps an eye on the current instruction and performs syscalls
// as necessary. It currently supports displaying an integer and exiting.

always @(posedge clk) begin
	if (sig_syscall) begin
		if (v0 == 1) begin
			$display("%d", a0);
		end
		if (v0 == 11) begin
			$write("%c", a0);
		end
		if (v0 == 4) begin
			sig_print_string <= 1;
		end
		if (v0 == 10) begin
			$finish;
		end
	end
	else begin
		sig_print_string <= 0;
	end
end

endmodule