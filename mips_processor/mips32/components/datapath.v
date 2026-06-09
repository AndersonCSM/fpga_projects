module datapath(
        input clk, reset, RegDst, RegWrite, ALUsrc, memRead, memWrite, MemToReg,branch, jump,
        input [2:0] ALUoperation,

        output [5:0] opcode,func        
    );
    
    wire zero;
    wire [4:0] write_register;
    wire [31:0] instruction, read_data_1, read_data_2, ALU_operand2, ALU_to_Mem, operand_32, Mem_or_ALU, AluData, MemData;
        
    // instantiate instruction fetch
    instruction_fetch instruction_fetch(
        .reset(reset),
        .clk(clk),
        .zero(zero),
        .branch(branch),
        .jump(jump),
        .offset(operand_32),
        .instruction(instruction)
    );
        
    assign opcode = instruction[31:26];
    assign func = instruction[5:0];
    
    // Reg Dst
    assign write_register = (~RegDst)? instruction[20:16] : instruction[15:11];
        
    // instantiate register file
    register_file register_file(
        .register_read_1(instruction[25:21]), 
        .register_read_2(instruction[20:16]), 
        .write_register(write_register), 
        .write_data(Mem_or_ALU), 
        .reg_write(RegWrite),  
        .reg_clk(clk), 
        .reset(reset),
        .read_data_1(read_data_1),  // register-1
        .read_data_2(read_data_2)   // register-2
    );
    
    // instantiate sign extension
    sign_extension sign_extension(
        .input_16(instruction[15:0]),
        .output_32(operand_32)
    );

    // ALU mux
    assign ALU_operand2 = (~ALUsrc)? read_data_2 : operand_32;
    
    // instantiate ALU
    alu_unit alu_unit(
        .A(read_data_1),
        .B(ALU_operand2),
        .ALU_operation(ALUoperation), 
        .zero(zero), // unused
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
     
endmodule