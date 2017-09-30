module INST_MEM (input wire [31:0] pc, output reg [31:0] instr);
  reg [31:0] mem [32'h100000:32'h101000]; // Memory block.
  
  initial begin
    $readmemh("hello_world.v", mem);
  end
  
  reg [31:0] wordAddress;
  always @(readAddress)
  begin
    wordAddress = readAddress >> 2;
    instr = mem[wordAddress];
  end
endmodule
