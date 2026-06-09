`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2024 07:45:46 PM
// Design Name: 
// Module Name: control_transfer_datapath
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


module control_transfer_datapath(
        input clk, reset, branch, jump,
        input [2:0] ALUoperation
    );
 
    wire zero;
    wire [31:0] instruction, read_data_1, read_data_2, operand_32;
        
    // instantiate instruction fetch
    instruction_fetch_with_control_transfer instruction_fetch_with_control_transfer(
        .reset(reset),
        .clk(clk),
        .zero(zero),
        .branch(branch),
        .jump(jump),
        .offset(operand_32),
        .instruction(instruction)
    );
            
    // instantiate register file
    register_file register_file(
        .register_read_1(instruction[25:21]), 
        .register_read_2(instruction[20:16]), 
        .write_register(),  // unused
        .write_data(),  // unused
        .reg_write(1'b0),  
        .clk(clk), 
        .reset(reset),
        .read_data_1(read_data_1),  // register-1
        .read_data_2(read_data_2)   // register-2
    );
    
    // instantiate sign extension
    sign_extension sign_extension(
            .input_16(instruction[15:0]),
            .output_32(operand_32)
    );
    
    // instantiate ALU
    alu_unit alu_unit(
        .A(read_data_1),
        .B(read_data_2),
        .ALU_operation(ALUoperation), 
        .zero(zero),
        .result()  // unused
    );
    
      
     // value initialization
     initial begin
        // register initialization
        register_file.Registers[0] = 0;
        register_file.Registers[1] = 0;
        // instruction initialization
        
        // jump: to address 22*4
        // jump = 1'b1; branch = 1'b0; ALUoperation = 3'bxxx
        instruction_fetch_with_control_transfer.instruction_memory.Memory[0] = 32'b000000_00000000000000000000010110; 
        
        // beq: r0 == r1? jump to +3
        // jump = 1'b0; branch = 1'b1; ALUoperation = 3'b110
        instruction_fetch_with_control_transfer.instruction_memory.Memory[22] = 32'b000000_00000_00001_0000000000000011; 
        
        // PC counter 
        instruction_fetch_with_control_transfer.program_counter.PC = 0;
     end
             
endmodule
