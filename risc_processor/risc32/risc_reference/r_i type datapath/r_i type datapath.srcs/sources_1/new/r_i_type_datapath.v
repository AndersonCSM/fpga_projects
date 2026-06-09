`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2024 07:42:09 PM
// Design Name: 
// Module Name: r_i_type_datapath
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


module r_i_type_datapath(
        input clk, reset, RegDst, RegWrite, ALUsrc, memRead, memWrite, MemToReg,
        input [2:0] ALUoperation
    );
    
    wire [4:0] write_register;
    wire [31:0] instruction, read_data_1, read_data_2, ALU_operand2, ALU_to_Mem, operand_2, Mem_or_ALU, AluData, MemData;
        
    // instantiate instruction fetch
    instruction_fetch instruction_fetch(
        .reset(reset),
        .clk(clk),
        .instruction(instruction)
    );
    
    // Reg Dst
    assign write_register = RegDst? instruction[20:16] : instruction[15:11];
        
    // instantiate register file
    register_file register_file(
        .register_read_1(instruction[25:21]), 
        .register_read_2(instruction[20:16]), 
        .write_register(write_register), 
        .write_data(Mem_or_ALU), 
        .reg_write(RegWrite),  
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
    // ALU mux
    assign ALU_operand2 = ALUsrc? read_data_2 : operand_2;
    
    // instantiate ALU
    alu_unit alu_unit(
        .A(read_data_1),
        .B(ALU_operand2),
        .ALU_operation(ALUoperation), 
        .zero(), // unused
        .result(AluData)
    );
    
    data_memory data_memory(
        .address(AluData),
        .write_data(read_data_2),
        .mem_read(memRead),
        .clk(clk),
        .mem_write(memWrite),
        .read_data(MemData)
     );
     
     // register write mux
     assign Mem_or_ALU = MemToReg?  MemData: AluData;
     
     // value initialization
     integer i;
     initial begin
        // register initialization
        for (i = 0; i < 32; i = i + 1) begin
            register_file.Registers[i] = 0;
        end
        // instruction initialization
        // addi: r0 = r0 + 4 = 0 + 4 = 4
        // RegDst = 1, RegWrite = 1, ALUsrc = 0, ALUoperation = 010, memRead = 0, memWrite = 0, MemToReg = 0
        instruction_fetch.instruction_memory.Memory[1] = 32'b000000_00000_00000_0000000000000100; 
                                                        //   ------_  r0 _  r0 _       4
        // sw: Memory[r1+0] = r0; Memory[0] = 4
        // RegDst = x, RegWrite = 0, ALUsrc = 0, ALUoperation = 010, memRead = 0, memWrite = 1, MemToReg = x
        instruction_fetch.instruction_memory.Memory[2] = 32'b000000_00001_00000_0000000000000000;
                                                        //   ------_  r1 _  r0 _       0
        // lw: r1 = Memory[r1+0] = Memory[0] = 4
        // RegDst = 1, RegWrite = 1, ALUsrc = 0, ALUoperation = 010, memRead = 1, memWrite = 0, MemToReg = 1
        instruction_fetch.instruction_memory.Memory[3] = 32'b000000_00001_00001_0000000000000000;
                                                        //   ------_  r1 _  r1 _       0
        // add: r2 = r0 + r1 = 4 + 4 = 8
        // RegDst = 0, RegWrite = 1, ALUsrc = 1, ALUoperation = 010, memRead = 0, memWrite = 0, MemToReg = 0
        instruction_fetch.instruction_memory.Memory[4] = 32'b000000_00000_00001_00010_00000_000000;
                                                        //   ------_  r0 _  r1 _  r2 _ -----------
  
        // PC counter 
        instruction_fetch.program_counter.PC = 0;
     end
             
endmodule
