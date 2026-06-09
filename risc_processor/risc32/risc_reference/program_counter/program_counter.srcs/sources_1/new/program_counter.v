`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2024 05:08:19 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter(
    input [31:0] PC_next,
    input clk,reset,
    output reg [31:0] PC
    );
    
    
    always @(posedge clk)
    begin
        if (reset == 1'b0) PC <= 32'h00000000;
        else PC <= PC_next;
    end
    
endmodule
