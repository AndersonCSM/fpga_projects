`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 10:05:07 AM
// Design Name: 
// Module Name: instruction_fetch_tb
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


module instruction_fetch_tb;
    reg clk, reset;
    wire [31:0] instruction;
    
    // instantiate instruction fetch unit
    instruction_fetch uut(
        .reset(reset),
        .clk(clk),
        .instruction(instruction)
        );
        
    initial begin
        clk <= 0;
        reset <= 0;
        #10
        reset <= 1;        
    end
    always #50 clk = ~clk;
endmodule
