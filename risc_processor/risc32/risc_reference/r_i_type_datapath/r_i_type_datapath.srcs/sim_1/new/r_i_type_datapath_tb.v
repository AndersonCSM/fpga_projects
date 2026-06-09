`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2024 02:23:54 PM
// Design Name: 
// Module Name: r_i_type_datapath_tb
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


module r_i_type_datapath_tb;
    
    reg clk, reset, RegDst, RegWrite, ALUsrc, memRead, memWrite, MemToReg;
    reg [2:0] ALUoperation;
    
    // initialize uut
    r_i_type_datapath uut(
           .clk(clk), 
           .reset(reset), 
           .RegDst(RegDst), 
           .RegWrite(RegWrite), 
           .ALUsrc(ALUsrc), 
           .memRead(memRead), 
           .memWrite(memWrite), 
           .MemToReg(MemToReg), 
           .ALUoperation(ALUoperation)
        );
    
    
    
    initial begin
        clk <= 0;
            reset <= 0;
            # 50
            reset <= 1;
            // clock cycle 1
                clk <= 1;
                // signals for addi
                    RegDst <= 1; 
                    RegWrite <= 1; 
                    ALUsrc <= 0;
                    ALUoperation <= 3'b010;
                    memRead <= 0;
                    memWrite <= 0;
                    MemToReg <= 0;
                # 50
                clk <= 0;
                # 50
//            clk <= 1;
//            # 50
        // clock cycle 2
            clk <= 1;
            # 5
            // signals for sw
                RegDst <= 1'bx; 
                RegWrite <= 0; 
                ALUsrc <= 0;
                ALUoperation <= 3'b010;
                memRead <= 0;
                memWrite <= 1;
                MemToReg <= 1'bx;
            # 50
            clk <= 0;
            # 50
        // clock cycle 3
            clk <= 1;
            # 5
            // signals for lw
                RegDst <= 1; 
                RegWrite <= 1; 
                ALUsrc <= 0;
                ALUoperation <= 3'b010;
                memRead <= 1;
                memWrite <= 0;
                MemToReg <= 1;
            # 50
            clk <= 0;
            # 50
        // clock cycle 4
            clk <= 1;
            # 5
            // signals for add
                RegDst <= 0; 
                RegWrite <= 1; 
                ALUsrc <= 1;
                ALUoperation <= 3'b010;
                memRead <= 0;
                memWrite <= 0;
                MemToReg <= 0;
            # 50
            clk <= 0;
            # 50
        $finish;
    end
    
endmodule

