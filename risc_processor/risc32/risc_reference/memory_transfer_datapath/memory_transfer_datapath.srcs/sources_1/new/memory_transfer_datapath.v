`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2024 12:40:19 PM
// Design Name: 
// Module Name: memory_transfer_datapath
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


module memory_transfer_datapath(
    input clk,
    input reset
    );
    
    wire [31:0] instruction, read_data_1, read_data_2, ALU_to_Mem, operand_2, Mem_to_ALU;
    
    // instantiate instruction fetch
        instruction_fetch instruction_fetch(
            .reset(reset),
            .clk(clk),
            .instruction(instruction)
        );
        
        // instantiate register file
        register_file register_file(
            .register_read_1(instruction[25:21]), // rs base address
            .register_read_2(instruction[20:16]), // rt for se
            .write_register(instruction[20:16]),  // rd for lw
            .write_data(Mem_to_ALU), 
            .reg_write(instruction[31]),  // for now control signal is 1 to ever write 
            .clk(clk), 
            .reset(reset),
            .read_data_1(read_data_1),  // register-1
            .read_data_2(read_data_2)   // register-2
        );
        
        // instantiate sign extension
        sign_extension sign_extension(
                .input_16(instruction[15:0]),
                .output_32(operand_2)
        );
        
        // instantiate ALU
        alu_unit alu_unit(
            .A(read_data_1),
            .B(operand_2),
            .ALU_operation(instruction[28:26]), 
            .zero(), // unused
            .result(ALU_to_Mem)
        );
        
        data_memory data_memory(
            .address(ALU_to_Mem),
            .write_data(read_data_2),
            .mem_read(instruction[30]),
            .clk(clk),
            .mem_write(instruction[29]),
            .read_data(Mem_to_ALU)
         );
         
         // value initialization
         integer i;
         initial begin
            // register initialization
            register_file.Registers[0] = 32'd0;
            register_file.Registers[2] = 32'd22;
            // instruction initialization
            // Memory[r0+0] = r2; Memory[0] = 22
            instruction_fetch.instruction_memory.Memory[1] = 32'b00101000000000100000000000000000;    
            // r31 = Memory[r0+0]; r31 = 22
            instruction_fetch.instruction_memory.Memory[2] = 32'b11001000000111110000000000000000;    
            // PC counter 
            instruction_fetch.program_counter.PC = 0;
         end
    
endmodule
