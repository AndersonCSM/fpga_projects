`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 07:44:26 PM
// Design Name: 
// Module Name: RISC_v_datapath
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


module RISC_v_datapath(
    input clk,
    input reset
    );
    
    wire RegDst, RegWrite, ALUsrc, memRead, memWrite, MemToReg,branch, jump;
    wire [5:0] opcode, func;
    wire [2:0] ALUoperation;
    wire [1:0] ALUop;
    
    // instantiate Main Control Unit
    control_unit_datapath control_unit(
         .opcode(opcode),
         .RegWrite(RegWrite),  
         .MemToReg(MemToReg), 
         .RegDst(RegDst),
         .ALUsrc(ALUsrc),  
         .branch(branch),   
         .jump(jump), 
         .memWrite(memWrite),  
         .memRead(memRead),
         .ALUop(ALUop)
    );
    
    // instantiate ALU Control Unit
    alu_control_datapath alu_control(
         .ALUop(ALUop),
         .func(func), 
         .ALUoperation(ALUoperation)
    );
    
    // instantiate RISC-v SCDP
    SCDP_without_control_unit SCDP(
        .clk(clk), 
        .reset(reset), 
        .RegDst(RegDst), 
        .RegWrite(RegWrite), 
        .ALUsrc(ALUsrc), 
        .memRead(memRead), 
        .memWrite(memWrite), 
        .MemToReg(MemToReg),
        .branch(branch), 
        .jump(jump),
        .ALUoperation(ALUoperation),
        .opcode(opcode),
        .func(func)
    );
    
endmodule
