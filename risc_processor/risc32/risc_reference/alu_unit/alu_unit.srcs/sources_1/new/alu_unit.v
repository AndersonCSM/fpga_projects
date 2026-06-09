`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 04:09:44 PM
// Design Name: 
// Module Name: alu_unit
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


module alu_unit(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALU_operation,
    output reg zero,
    output reg [31:0] result
    );
    // If any input change
    always @(*) begin
        // MUX based on ALU_operation
        case (ALU_operation)
            // and operation
            3'b000: begin
                result = A & B;
            end
            // or operation
            3'b001: begin
                result = A | B;
            end
            // addition operation
            3'b010 : begin 
                result = A + B;
            end
            // subtraction operation
            3'b110 : begin
                result = A - B;
            end
            // less than operation
            3'b111 : begin
                result = (A < B) ? 32'd1 : 32'd0;
            end
            // no operation
            default: begin
                result = 0;
            end
        endcase
        
        // zero flag for bne and beq
        if (result == 0) begin
            zero = 1;
        end
        else begin
            zero = 0;
        end
    end
    
endmodule









