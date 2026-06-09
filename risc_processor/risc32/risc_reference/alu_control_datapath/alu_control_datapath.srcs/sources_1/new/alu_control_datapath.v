`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 06:57:16 PM
// Design Name: 
// Module Name: alu_control_datapath
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


module alu_control_datapath(
 
     input   [1:0] ALUop,
     input   [5:0] func, // funct field (instr_addr[5:0])
     
     output  reg [2:0] ALUoperation
);

    always @(*) begin 
     
         casex (ALUop)
          
          2'b00 : begin 
                ALUoperation = 3'b010; // add
          end
          
          2'b01 : begin /* i change it*/
                ALUoperation = 3'b110; // subtract
          end
          
          2'b10 : begin
           
               case (func)
               
                6'b100000 : begin
                    ALUoperation = 3'b010; // add
                end  
                
                6'b100010 : begin
                    ALUoperation = 3'b110; // subtract
                end  
                
                6'b100100 : begin
                    ALUoperation = 3'b000; // and
                end  
                
                6'b100101 : begin
                    ALUoperation = 3'b001; // or
                end  
                
                6'b101010 : begin
                    ALUoperation = 3'b111; // set less than (SLT)
                end 
                
                default : ALUoperation = 3'bxxx;
               endcase
          end
         
          default : ALUoperation = 3'bxxx;
         endcase
    end
endmodule
