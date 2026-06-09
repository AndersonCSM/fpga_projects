`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2024 01:27:39 PM
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory(
    input [31:0] address,
    input reset,
    output [31:0] instruction
    );
    
    reg [31:0] Memory [1023:0];
    assign instruction = (reset == 1'b0) ? 32'h00000000 : Memory[address[31:2]];
   
endmodule




















