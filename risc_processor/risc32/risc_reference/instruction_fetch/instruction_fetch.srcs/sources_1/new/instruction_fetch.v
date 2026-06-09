`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 09:34:42 AM
// Design Name: 
// Module Name: instruction_fetch
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


module instruction_fetch(
    input reset,clk,
    output [31:0] instruction
    );
    
    wire [31:0] PC_address, PC_plus_4;
    
    // instantiate PC
    program_counter program_counter(
        .PC_next(PC_plus_4),
        .clk(clk),
        .reset(reset),
        .PC(PC_address)
    );
    
    // instantiate counter 
    pc_counter pc_counter(
        .PC_address(PC_address),
        .PC_plus_4(PC_plus_4)
        );
        
    // instantiate memory
    instruction_memory instruction_memory(
        .address(PC_address),
        .reset(reset),
        .instruction(instruction)
    );
    

    
endmodule
