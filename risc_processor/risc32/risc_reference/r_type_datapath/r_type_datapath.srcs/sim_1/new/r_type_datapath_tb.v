`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 07:56:05 PM
// Design Name: 
// Module Name: r_type_datapath_tb
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


module r_type_datapath_tb;
    reg clk, reset;
    
    // instantiate unit under test
    r_type_datapath uut(
        .clk(clk),
        .reset(reset)
    );
    
    initial begin
        // start execution
        clk <= 0;
        reset <= 0;
        # 50
        reset = 1;
        # 400
        // stop execution
        reset = 0; 
        $finish;
    end
    
    always # 50 clk <= ~clk;
endmodule
