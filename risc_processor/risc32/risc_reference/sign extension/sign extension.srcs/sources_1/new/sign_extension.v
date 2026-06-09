`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2024 12:14:59 PM
// Design Name: 
// Module Name: sign_extension
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


module sign_extension(
    input [15:0] input_16,
    output [31:0] output_32
    );
    
    assign output_32 = (input_16[15] == 1'b1)? {{16{1'b1}},input_16} :{{16{1'b0}},input_16};
     
endmodule


