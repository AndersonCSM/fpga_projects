`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2024 05:37:23 PM
// Design Name: 
// Module Name: register_file
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


module register_file(
    input [4:0] register_read_1,
    input [4:0] register_read_2,
    input [4:0] write_register,
    input [31:0] write_data,
    input reg_write, clk, reset,
    output [31:0] read_data_1,
    output [31:0] read_data_2
    );
    
    reg [31:0] Registers [31:0];
        
    assign read_data_1 = (!reset)? 32'h00000000  : Registers[register_read_1];
    assign read_data_2 = (!reset)? 32'h00000000  : Registers[register_read_2];
    
    always @(posedge clk)
    begin
        $display("Writing to register %d: %d, %d", write_register, write_data,reg_write);
        if( reg_write == 1'b1 )
        begin
            Registers[write_register] <= write_data;
        end
    end
endmodule





