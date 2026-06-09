module MIPS(
    input clk,
    input reset
);
    
    wire RegDst, RegWrite, ALUsrc, memRead, memWrite, MemToReg,branch, jump;
    wire [5:0] opcode, func;
    wire [2:0] ALUoperation;
    wire [1:0] ALUop;
    
    parameter teste = 1'd0;
    
    initial begin
        if (teste == 1) begin // Teste R
            dp.instruction_fetch.instruction_memory.Memory[0] = 32'b000000_00000_00001_00010_00000_000010; // add r2 = r0 + r1 = 1 + 1 = 2
            dp.instruction_fetch.instruction_memory.Memory[1] = 32'b000000_00010_00001_00011_00000_000110; // sub r3 = r2 - r1 = 2 - 1 = 1
            dp.instruction_fetch.instruction_memory.Memory[2] = 32'b000000_00010_00011_00100_00000_000001; // or  r4 = r2 | r3 = 2 | 1 = 3
            dp.instruction_fetch.instruction_memory.Memory[3] = 32'b000000_00011_00100_00101_00000_000000; // and r5 = r3 & r4 = 1 & 3 = 1
        end
        else if (teste == 2) begin // Teste R e I
            dp.instruction_fetch.instruction_memory.Memory[1] = 32'b000000_00000_00000_0000000000000100; // addi: r0 = r0 + 4 = 0 + 4 = 4
            dp.instruction_fetch.instruction_memory.Memory[2] = 32'b000000_00001_00000_0000000000000000; // sw: Memory[r1+0] = r0; Memory[0] = 4
            dp.instruction_fetch.instruction_memory.Memory[3] = 32'b000000_00001_00001_0000000000000000; // lw: r1 = Memory[r1+0] = Memory[0] = 4
            dp.instruction_fetch.instruction_memory.Memory[4] = 32'b000000_00000_00001_00010_00000_000000; // add: r2 = r0 + r1 = 4 + 4 = 8
        end
        else if (teste == 3) begin // Teste J
            dp.register_file.Registers[0] = 0;
            dp.register_file.Registers[1] = 0;
            
            dp.instruction_fetch.instruction_memory.Memory[0] = 32'b000000_00000000000000000000010110; // jump: to address 22*4
            dp.instruction_fetch.instruction_memory.Memory[22] = 32'b000000_00000_00001_0000000000000011; // beq: r0 == r1? jump to +3
        end
        else if (teste == 4) begin // Teste Fibonacci
            dp.instruction_fetch.instruction_memory.Memory[0] = 32'b000000_00000_00000_00000_00000_000000; // NOP
            dp.instruction_fetch.instruction_memory.Memory[1] = 32'b001000_00000_00000_0000000000000000; // addi r0, r0, 0        (initialize 0)
            dp.instruction_fetch.instruction_memory.Memory[2] = 32'b001000_00001_00001_0000000000000001; // addi r1, r1, 1        (initialize 1)
            dp.instruction_fetch.instruction_memory.Memory[3] = 32'b001000_11111_11111_0000000000000000; // addi r31, r31, 0      (address = 0)
            dp.instruction_fetch.instruction_memory.Memory[4] = 32'b101011_11111_00000_0000000000000000; // sw r0, r31(0)         (A[0] = 0)
            dp.instruction_fetch.instruction_memory.Memory[5] = 32'b001000_11111_11111_0000000000000100; // addi r31, r31, 4      (next base address)
            dp.instruction_fetch.instruction_memory.Memory[6] = 32'b101011_11111_00001_0000000000000000; // sw r1, r31(0)         (A[1] = 1)
            dp.instruction_fetch.instruction_memory.Memory[7] = 32'b001000_00011_00011_0000000000000000; // addi r3, r3, 0        (i = 0)
            dp.instruction_fetch.instruction_memory.Memory[8] = 32'b001000_00100_00100_0000000000011111; // addi r4, r4, 31       (since we don't have slti)
            dp.instruction_fetch.instruction_memory.Memory[9] = 32'b000100_00011_00100_0000000000000111; // for: beq r3, r4, end_loop (loop while i < 31)
            dp.instruction_fetch.instruction_memory.Memory[10] = 32'b000000_00000_00001_00101_00000_100000; // add r5, r0, r1        (r5 = A[i-1] + A[i-2])
            dp.instruction_fetch.instruction_memory.Memory[11] = 32'b001000_11111_11111_0000000000000100; // addi r31, r31, 4      (next base address)
            dp.instruction_fetch.instruction_memory.Memory[12] = 32'b101011_11111_00101_0000000000000000; // sw r5, r31(0)         (A[i] = r5)
            dp.instruction_fetch.instruction_memory.Memory[13] = 32'b001000_00001_00000_0000000000000000; // addi r0, r1, 0        (r0 = r1)
            dp.instruction_fetch.instruction_memory.Memory[14] = 32'b001000_00101_00001_0000000000000000; // addi r1, r5, 0        (r1 = r5)
            dp.instruction_fetch.instruction_memory.Memory[15] = 32'b001000_00011_00011_0000000000000001; // addi r3, r3, 1        (i += 1)
            dp.instruction_fetch.instruction_memory.Memory[16] = 32'b000010_00000000000000000000001001; // j for                 (next iteration)
        end
    end


    // instantiate Main Control Unit
    control_unit controle(
        .opcode(opcode),
        .RegWrite(RegWrite),  
        .MemToReg(MemToReg), 
        .RegDst(RegDst),
        .ALUsrc(ALUsrc),  
        .branch(branch),   
        .jump(jump), 
        .memWrite(memWrite),  
        .memRead(memRead),
        .ALUop(ALUop)
    );
    
    // instantiate ALU Control Unit
    alu_control alu_controle(
        .ALUop(ALUop),
        .func(func), 
        .ALUoperation(ALUoperation)
    );
    
    // instantiate RISC-v dp
    datapath dp(
        .clk(clk), 
        .reset(reset), 
        .RegDst(RegDst), 
        .RegWrite(RegWrite), 
        .ALUsrc(ALUsrc), 
        .memRead(memRead), 
        .memWrite(memWrite), 
        .MemToReg(MemToReg),
        .branch(branch), 
        .jump(jump),
        .ALUoperation(ALUoperation),
        .opcode(opcode),
        .func(func)
    );

endmodule