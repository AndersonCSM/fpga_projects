`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2024 02:37:47 PM
// Design Name: 
// Module Name: instruction_memory_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module instruction_memory_tb;

    reg [31:0] address;
    reg reset;
    wire [31:0] instruction;

    instruction_memory uut (
        .address(address),
        .reset(reset),
        .instruction(instruction)
    );

    integer i;

    initial begin
        // Initialize inputs
        reset = 0;
        address = 0;

        // Initialize memory with test data
        for (i = 0; i < 1024; i = i + 1) begin
            uut.Memory[i] = i * 4; // Example initialization
        end

        // Wait for the initial reset state
        #10;
        
        
        // Test reset behavior
        #10 reset = 0; address = 32'h00000004; #10;
        #10 reset = 0; address = 32'h00000008; #10;

        // Test active state behavior
        reset = 1; #10;
        address = 32'h00000000; #10;
        address = 32'h00000004; #10;
        address = 32'h00000008; #10;

        // Finish simulation
        $finish;
    end

endmodule
