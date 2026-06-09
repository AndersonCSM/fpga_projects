`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 03:21:25 PM
// Design Name: 
// Module Name: control_transfer_datapath_tb
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


module control_transfer_datapath_tb;
    reg branch, jump, clk, reset;
    reg [2:0] ALUoperation;
    
    control_transfer_datapath uut(
        .clk(clk),
        .reset(reset),
        .branch(branch),
        .jump(jump),
        .ALUoperation(ALUoperation)
    );
    
    initial begin
        reset <= 0;
        clk <= 0;
        # 50
        // clock cycle 1
            clk <= 1;
            # 1
            reset <= 1;
                // Control signals for jump
                jump = 1'b1; 
                branch = 1'b0; 
                ALUoperation = 3'bxxx;
            # 49
            clk <= 0;
            # 50
        // clock cycle 2
            clk <= 1;
            # 1
                // Control signals for beq
                jump = 1'b0; 
                branch = 1'b1; 
                ALUoperation = 3'b110;
            # 49
            clk <= 0;
            # 50
        $finish;
    end
endmodule
