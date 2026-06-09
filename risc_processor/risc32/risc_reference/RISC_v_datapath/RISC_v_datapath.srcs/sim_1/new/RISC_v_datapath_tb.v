`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 08:17:20 PM
// Design Name: 
// Module Name: RISC_v_datapath_tb
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


module RISC_v_datapath_tb;
    reg clk, reset;
    
    RISC_v_datapath uut(
        .clk(clk),
        .reset(reset)
    );
    
    initial begin
        clk <= 0;
        reset <= 0;
        # 1
        reset <= 1;

    end
    
    always #1 clk = ~clk;
    
    // value initialization
    initial begin : value_initialization
        // initialize registers
        integer i;
        for (i = 0; i < 32; i = i + 1) begin
            uut.SCDP.register_file.Registers[i] = 0;
        end 
        
        // initialize instructions
        // addi r0, r0, 0        // initialize 0
        uut.SCDP.instruction_fetch.instruction_memory.Memory[1] = 32'b001000_00000_00000_0000000000000000; 
        // addi r1, r1, 1        // initialize 1
        uut.SCDP.instruction_fetch.instruction_memory.Memory[2] = 32'b001000_00001_00001_0000000000000001;
        // addi r31, r31, 0      // address = 0
        uut.SCDP.instruction_fetch.instruction_memory.Memory[3] = 32'b001000_11111_11111_0000000000000000;
        // sw r0, r31(0)         // A[0] = 0
        uut.SCDP.instruction_fetch.instruction_memory.Memory[4] = 32'b101011_11111_00000_0000000000000000;
        // addi r31, r31, 4      // next base address
        uut.SCDP.instruction_fetch.instruction_memory.Memory[5] = 32'b001000_11111_11111_0000000000000100;
        // sw r1, r31(0)         // A[1] = 1
        uut.SCDP.instruction_fetch.instruction_memory.Memory[6] = 32'b101011_11111_00001_0000000000000000;
        // addi r4, r4, 9        // since we don't have slti
        uut.SCDP.instruction_fetch.instruction_memory.Memory[8] = 32'b001000_00100_00100_0000000000011111;
        // addi r3, r3, 0        // i = 0
        uut.SCDP.instruction_fetch.instruction_memory.Memory[7] = 32'b001000_00011_00011_0000000000000000;
        // for:
        //     beq r3, r4, end_loop  // loop while i < 31
        uut.SCDP.instruction_fetch.instruction_memory.Memory[9] = 32'b000100_00011_00100_0000000000000111; 
        //     add r5, r0, r1        // r5 = A[i-1] + A[i-2]
        uut.SCDP.instruction_fetch.instruction_memory.Memory[10] = 32'b000000_00000_00001_00101_00000_100000;
        //     addi r31, r31, 4      // next base address
        uut.SCDP.instruction_fetch.instruction_memory.Memory[11] = 32'b001000_11111_11111_0000000000000100;
        //     sw r5, r31(0)         // A[i] = r5
        uut.SCDP.instruction_fetch.instruction_memory.Memory[12] = 32'b101011_11111_00101_0000000000000000;
        //     addi r0, r1, 0        // r0 = r1
        uut.SCDP.instruction_fetch.instruction_memory.Memory[13] = 32'b001000_00001_00000_0000000000000000;
        //     addi r1, r5, 0        // r1 = r5
        uut.SCDP.instruction_fetch.instruction_memory.Memory[14] = 32'b001000_00101_00001_0000000000000000;
        //     addi r3, r3, 1        // i += 1
        uut.SCDP.instruction_fetch.instruction_memory.Memory[15] = 32'b001000_00011_00011_0000000000000001;
        //     j for                 // next interation
        uut.SCDP.instruction_fetch.instruction_memory.Memory[16] = 32'b000010_00000000000000000000001001;
        // end_loop
        
        // initialize PC
        uut.SCDP.instruction_fetch.program_counter.PC = 0;
    end
endmodule

//module RISC_v_datapath_tb;
//    reg clk, reset;
    
//    RISC_v_datapath uut(
//        .clk(clk),
//        .reset(reset)
//    );
    
//    initial begin
//        clk <= 0;
//        reset <= 0;
//        # 10
//        reset <= 1;
//        # 850
//        reset <= 0;
//        $finish;
//    end
    
//    always #50 clk = ~clk;
    
//    // value initialization
//    initial begin : value_initialization
//        // initialize registers
//        integer i;
//        for (i = 0; i < 32; i = i + 1) begin
//            uut.SCDP.register_file.Registers[i] = 0;
//        end 
        
//        // initialize instructions
//        // addi: r1 = r1 + 10 = 0 + 10 = 10
//        uut.SCDP.instruction_fetch.instruction_memory.Memory[1] = 32'b001000_00001_00001_0000000000001010; 
//        // addi: r2 = r2 + 10 = 0 + 10 = 10
//        uut.SCDP.instruction_fetch.instruction_memory.Memory[2] = 32'b001000_00010_00010_0000000000001010; 
//        // add: r3 = r1 + r2; 10 + 10 = 20
//        uut.SCDP.instruction_fetch.instruction_memory.Memory[3] = 32'b000000_00001_00010_00011_00000_100000; 
//        // sw: Memory[r0+0] = r3; Memory[0] = 20
//        uut.SCDP.instruction_fetch.instruction_memory.Memory[4] = 32'b101011_00000_00011_0000000000000000; 
//        // beq: r1 == r2? jump to +3
//        uut.SCDP.instruction_fetch.instruction_memory.Memory[5] = 32'b000100_00001_00010_0000000000000011; 
//        // j: jump to 100x4
//        uut.SCDP.instruction_fetch.instruction_memory.Memory[9] = 32'b000010_00000000000000000001100100; 
//        // lw: r4 = Memory[r0+0] = Memory[0] = 20
//        uut.SCDP.instruction_fetch.instruction_memory.Memory[100] = 32'b100011_00000_00100_0000000000000000; 
//        // and: r5 = r3 & r4 = 20 & 20 = 20
//        uut.SCDP.instruction_fetch.instruction_memory.Memory[101] = 32'b000000_00011_00100_00101_00000_100100;
        
//        // initialize PC
//        uut.SCDP.instruction_fetch.program_counter.PC = 0;
//    end
//endmodule
