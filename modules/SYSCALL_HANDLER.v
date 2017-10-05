module SYSCALL_HANDLER(
	input sig_syscall,
	input [31:0] v0,
	input [31:0] a0,
	input clk,
	output reg [31:0] sig_print_string);
// This module keeps an eye on the current instruction and performs syscalls
// as necessary. It currently supports displaying an integer and exiting.

always @(posedge clk) begin
	if (sig_syscall) begin
		if (v0 == 1) begin
			$display("\n\n\n\n\n\n%d\n\n\n\n\n\n\n", a0);
		end
		if (v0 == 11) begin
			$write("%c", a0);
		end
		if (v0 == 4) begin
			sig_print_string <= a0;
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
