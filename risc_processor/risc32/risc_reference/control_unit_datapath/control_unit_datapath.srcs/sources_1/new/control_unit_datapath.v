`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 06:36:15 PM
// Design Name: 
// Module Name: control_unit_datapath
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


module control_unit_datapath(

     input    [5:0] opcode,   // (instr_addr[31:26])
      
     output  reg    RegWrite,  
     output  reg    MemToReg, 
     output  reg    RegDst,
     output  reg    ALUsrc,  
     output  reg    branch,   
     output  reg    jump, 
     output  reg    memWrite,  
     output  reg    memRead,
     output reg  [1:0] ALUop

);

    always @(*) begin 
    
         case (opcode)
          
              6'b000000 : begin // R_Type instruction
            
                   RegWrite = 1;  
                   MemToReg = 0; 
                   RegDst = 1; 
                   ALUsrc = 0;  
                   branch = 0;    
                   memWrite = 0;  
                   ALUop = 2'b10;  
                   memRead = 0;  
                   jump = 0;
            
              end 
              
              6'b100011 : begin  // load (lw) instruction
            
                   RegWrite = 1;  
                   MemToReg = 1; 
                   RegDst = 0; 
                   ALUsrc = 1;  
                   branch = 0;    
                   memWrite = 0;  
                   ALUop = 2'b00;  
                   memRead = 1;  
                   jump = 0;
                
              end 
              
              6'b101011 : begin  // store (sw) instruction
            
                   RegWrite = 0;  
                   MemToReg = 1'bx; 
                   RegDst = 1'bx; 
                   ALUsrc = 1;  
                   branch = 0;    
                   memWrite = 1;  
                   ALUop = 2'b00;  
                   memRead = 0;  
                   jump = 0;
            
              end 
              
              6'b000100 : begin  // beq instruction
            
                   RegWrite = 0;  
                   MemToReg = 1'bx; 
                   RegDst = 1'bx; 
                   ALUsrc = 0;  
                   branch = 1;    
                   memWrite = 0;  
                   ALUop = 2'b01;  
                   memRead = 0;  
                   jump = 0;
            
              end 
              
              6'b001000 : begin  // addi instruction
            
                   RegWrite = 1;  
                   MemToReg = 0; 
                   RegDst = 0; 
                   ALUsrc = 1;  
                   branch = 0;    
                   memWrite = 0;  
                   ALUop = 2'b00;  
                   memRead = 0;  
                   jump = 0;
            
              end 
            
              6'b000010 : begin  // jump instruction
            
                   RegWrite = 0;  
                   MemToReg = 1'bx; 
                   RegDst = 1'bx; 
                   ALUsrc = 1'bx;  
                   branch = 0;    
                   memWrite = 0;  
                   ALUop = 2'bxx;  
                   memRead = 0;  
                   jump = 1;
                   
              end 
            
              default : begin
            
                   RegWrite = 0;  
                   MemToReg = 1'bx; 
                   RegDst = 1'bx; 
                   ALUsrc = 1'bx;  
                   branch = 0;    
                   memWrite = 0;  
                   ALUop = 2'bxx;  
                   memRead = 0;  
                   jump = 0;
                   
              end
         endcase
    end
endmodule