`include "../../includes/ManBearPig.h"

module testbench();

    // Registers
    reg     [31:0]  inst;
    reg             clk;

    // Modules
    BINARY_TO_MIPS b2m(inst, clk);

    // Test Statements
    initial begin
        clk = 0; inst = 32'h00084080; #5; clk = 1; #5; // sll t0 t0 0x02
        clk = 0; inst = 32'h00084082; #5; clk = 1; #5; // srl t0 t0 0x02
        clk = 0; inst = 32'h00095083; #5; clk = 1; #5; // sra t2 t1 0x02
        clk = 0; inst = 32'h00000000; #5; clk = 1; #5; // nop
        clk = 0; inst = 32'h25280005; #5; clk = 1; #5; // addiu t0 t1 0x0005
        clk = 0; inst = 32'h21A80005; #5; clk = 1; #5; // addi to t5 0x0005
        clk = 0; inst = 32'h01404809; #5; clk = 1; #5; // jalr t1 t2
        clk = 0; inst = 32'h03E00008; #5; clk = 1; #5; // jr ra

    end

endmodule
