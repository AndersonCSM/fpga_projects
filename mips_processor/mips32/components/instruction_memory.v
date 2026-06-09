module instruction_memory(
    input [31:0] address,
    input reset,
    
    output [31:0] instruction
    );

    reg [31:0] Memory [1023:0];  // 1024 * 32 = 32768 Bits = 4.096 KB

    // If reset is 0 then the output would be 0 otherwise instruction 
    // at the location. I will explain reason behind using 
    // address[31:2] later.
    assign instruction = (reset == 1'b0) ? 32'h00000000 : Memory[address[31:2]];

endmodule