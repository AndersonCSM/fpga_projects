`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2024 08:00:03 PM
// Design Name: 
// Module Name: instruction_fetch_with_control_transfer
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


module instruction_fetch_with_control_transfer(
    input reset,clk,zero,branch,jump,
    input [31:0] offset,
    output [31:0] instruction
    );
    
    wire [31:0] JTA, BTA, PC_plus_4;
    wire [31:0] PC_address, Actual_PC_Address, Branch_Address;
    
    // instantiate PC
    program_counter program_counter(
        .PC_next(Actual_PC_Address),
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
    
    // Calculate BTA
    assign BTA = PC_plus_4 + (offset << 2);
    
    // Calculate JTA
    assign JTA = {PC_plus_4[31:28], {instruction[25:0], 2'b00}};
    
    // Branch MUX
    assign Branch_Address = (zero & branch)? BTA : PC_plus_4;
    
    // Jump MUX
    assign Actual_PC_Address = jump? JTA : Branch_Address;
   
endmodule
