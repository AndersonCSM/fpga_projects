module RISC(
    input clk,
    input reset
);
    
    wire RegWrite, ALUsrc, memRead, memWrite, MemToReg, branch, jump;
    wire [1:0] ImmSrc;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [2:0] ALUoperation;
    wire [1:0] ALUop;
    
    parameter teste = 1'd0;
    
    initial begin
        if (teste == 1) begin // Teste R
            // RISC-V R-Type: funct7(7) | rs2(5) | rs1(5) | funct3(3) | rd(5) | opcode(7)
            dp.instruction_fetch.instruction_memory.Memory[0] = 32'b0000000_00001_00000_000_00010_0110011; // add r2 = r0 + r1 = 1 + 1 = 2
            dp.instruction_fetch.instruction_memory.Memory[1] = 32'b0100000_00001_00010_000_00011_0110011; // sub r3 = r2 - r1 = 2 - 1 = 1
            dp.instruction_fetch.instruction_memory.Memory[2] = 32'b0000000_00011_00010_110_00100_0110011; // or  r4 = r2 | r3 = 2 | 1 = 3
            dp.instruction_fetch.instruction_memory.Memory[3] = 32'b0000000_00100_00011_111_00101_0110011; // and r5 = r3 & r4 = 1 & 3 = 1
        end
        else if (teste == 2) begin // Teste R e I
            // RISC-V I-Type: imm(12) | rs1(5) | funct3(3) | rd(5) | opcode(7)
            // RISC-V S-Type: imm(7) | rs2(5) | rs1(5) | funct3(3) | imm(5) | opcode(7)
            dp.instruction_fetch.instruction_memory.Memory[1] = 32'b000000000100_00000_000_00000_0010011; // addi: r0 = r0 + 4 = 0 + 4 = 4
            dp.instruction_fetch.instruction_memory.Memory[2] = 32'b0000000_00000_00001_000_00000_0100011; // sw: Memory[r1+0] = r0; Memory[0] = 4
            dp.instruction_fetch.instruction_memory.Memory[3] = 32'b000000000000_00001_000_00001_0000011; // lw: r1 = Memory[r1+0] = Memory[0] = 4
            dp.instruction_fetch.instruction_memory.Memory[4] = 32'b0000000_00001_00000_000_00010_0110011; // add: r2 = r0 + r1 = 4 + 4 = 8
        end
        else if (teste == 3) begin // Teste J
            dp.register_file.Registers[0] = 0;
            dp.register_file.Registers[1] = 0;
            
            // J-Type custom: imm(20) | rd(5) | opcode(7)
            // B-Type custom: imm(7) | rs2(5) | rs1(5) | funct3(3) | imm(5) | opcode(7)
            dp.instruction_fetch.instruction_memory.Memory[0] = 32'b00000000000000010101_00000_1101111; // jal: jump to address 22 (+21 words from PC+4)
            dp.instruction_fetch.instruction_memory.Memory[22] = 32'b0000000_00001_00000_000_00011_1100011; // beq: r0 == r1? jump to +3
        end
        else if (teste == 4) begin // Teste Fibonacci
            dp.instruction_fetch.instruction_memory.Memory[0] =  32'b000000000000_00000_000_00000_0010011; // NOP (addi r0, r0, 0)
            dp.instruction_fetch.instruction_memory.Memory[1] =  32'b000000000000_00000_000_00000_0010011; // addi r0, r0, 0        (initialize 0)
            dp.instruction_fetch.instruction_memory.Memory[2] =  32'b000000000001_00001_000_00001_0010011; // addi r1, r1, 1        (initialize 1)
            dp.instruction_fetch.instruction_memory.Memory[3] =  32'b000000000000_11111_000_11111_0010011; // addi r31, r31, 0      (address = 0)
            dp.instruction_fetch.instruction_memory.Memory[4] =  32'b0000000_00000_11111_000_00000_0100011; // sw r0, r31(0)         (A[0] = 0)
            dp.instruction_fetch.instruction_memory.Memory[5] =  32'b000000000100_11111_000_11111_0010011; // addi r31, r31, 4      (next base address)
            dp.instruction_fetch.instruction_memory.Memory[6] =  32'b0000000_00001_11111_000_00000_0100011; // sw r1, r31(0)         (A[1] = 1)
            dp.instruction_fetch.instruction_memory.Memory[7] =  32'b000000000000_00011_000_00011_0010011; // addi r3, r3, 0        (i = 0)
            dp.instruction_fetch.instruction_memory.Memory[8] =  32'b000000011111_00100_000_00100_0010011; // addi r4, r4, 31       (loop limit)
            dp.instruction_fetch.instruction_memory.Memory[9] =  32'b0000000_00100_00011_000_00111_1100011; // for: beq r3, r4, end (jump +7 words)
            dp.instruction_fetch.instruction_memory.Memory[10] = 32'b0000000_00001_00000_000_00101_0110011; // add r5, r0, r1        (r5 = A[i-1] + A[i-2])
            dp.instruction_fetch.instruction_memory.Memory[11] = 32'b000000000100_11111_000_11111_0010011; // addi r31, r31, 4      (next base address)
            dp.instruction_fetch.instruction_memory.Memory[12] = 32'b0000000_00101_11111_000_00000_0100011; // sw r5, r31(0)         (A[i] = r5)
            dp.instruction_fetch.instruction_memory.Memory[13] = 32'b000000000000_00001_000_00000_0010011; // addi r0, r1, 0        (r0 = r1)
            dp.instruction_fetch.instruction_memory.Memory[14] = 32'b000000000000_00101_000_00001_0010011; // addi r1, r5, 0        (r1 = r5)
            dp.instruction_fetch.instruction_memory.Memory[15] = 32'b000000000001_00011_000_00011_0010011; // addi r3, r3, 1        (i += 1)
            dp.instruction_fetch.instruction_memory.Memory[16] = 32'b11111111111111111000_00000_1101111; // j for                 (jump -8 words)
        end
    end


    // instantiate Main Control Unit
    control_unit controle(
        .opcode(opcode),
        .RegWrite(RegWrite),  
        .MemToReg(MemToReg), 
        .ImmSrc(ImmSrc),
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
        .funct3(funct3), 
        .funct7(funct7),
        .ALUoperation(ALUoperation)
    );
    
    // instantiate RISC-v dp
    datapath dp(
        .clk(clk), 
        .reset(reset), 
        .RegWrite(RegWrite), 
        .ALUsrc(ALUsrc), 
        .memRead(memRead), 
        .memWrite(memWrite), 
        .MemToReg(MemToReg),
        .branch(branch), 
        .jump(jump),
        .ImmSrc(ImmSrc),
        .ALUoperation(ALUoperation),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7)
    );

endmodule