`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2024 08:05:50 PM
// Design Name: 
// Module Name: data_memory
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


module data_memory(
    input [31:0] address,
    input [31:0] write_data,
    input mem_read, clk,
    input mem_write,
    output [31:0] read_data
    );
    reg [31:0] Memory [1023:0];
    assign read_data = (mem_read)? Memory[address[31:2]] : 32'h00000000;
    always @(posedge clk) begin
        if (mem_write) begin
            Memory[address[31:2]] <= write_data;
        end
    end
    
endmodule
