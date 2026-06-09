`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 05:16:31 PM
// Design Name: 
// Module Name: r_type_datapath
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


module r_type_datapath(
        input clk,
        input reset
    );
    
    wire [31:0] read_data_1, read_data_2, ALU_to_reg, instruction;
    
        
    // instantiate instruction fetch
    instruction_fetch instruction_fetch(
        .reset(reset),
        .clk(clk),
        .instruction(instruction)
    );
    
    // instantiate register file
    register_file register_file(
        .register_read_1(instruction[25:21]), // rs
        .register_read_2(instruction[20:16]), // rt
        .write_register(instruction[15:11]),  // rd
        .write_data(ALU_to_reg), 
        .reg_write(instruction[31]),  // for now control signal is 1 to ever write 
        .clk(clk), 
        .reset(reset),
        .read_data_1(read_data_1),  // ALU operand 1
        .read_data_2(read_data_2)   // ALU operand 2
    );
    
    // instantiate ALU
    alu_unit alu_unit(
        .A(read_data_1),
        .B(read_data_2),
        .ALU_operation(instruction[2:0]), // for now operation will be select from func bits
        .zero(), // unused
        .result(ALU_to_reg)
    );
    
    integer i;
    initial begin
        // initialize registers with 1
        for (i = 0; i < 32; i = i + 1) begin
            register_file.Registers[i] = 1;
        end
        // initialize memory and PC counter
        instruction_fetch.instruction_memory.Memory[1] = 32'b10000000000000010001000000000010;  // add r2 = r0 + r1 = 1 + 1 = 2
        instruction_fetch.instruction_memory.Memory[2] = 32'b10000000010000010001100000000110;  // sub r3 = r2 - r1 = 2 - 1 = 1
        instruction_fetch.instruction_memory.Memory[3] = 32'b10000000010000110010000000000001;  // or  r4 = r2 | r3 = 2 | 1 = 3
        instruction_fetch.instruction_memory.Memory[4] = 32'b10000000011001000010100000000000;  // and r5 = r3 & r4 = 1 & 3 = 1
        instruction_fetch.program_counter.PC = 0;
    end
    
endmodule
